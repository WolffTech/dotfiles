#!/bin/zsh
# Claude Code status line (two rows).
#   Row 1: model | context% | project path | git branch | +added/-removed
#   Row 2: session cost | token usage | rate-limit windows
# Both rows are left-aligned, so nothing reaches the contested right edge.
set -euo pipefail

input="$(cat)"

# JSON is passed via env (the heredoc is python's stdin).
STATUSLINE_INPUT="$input" python3 <<'PY'
import json, os, subprocess, tempfile

RESET = "\033[0m"
def c(code, s):                       # wrap text in an ANSI SGR code
    return f"\033[{code}m{s}{RESET}"

try:
    data = json.loads(os.environ.get("STATUSLINE_INPUT", ""))
except Exception:
    raise SystemExit(0)

def g(d, *path, default=None):        # safe nested get
    for k in path:
        if not isinstance(d, dict):
            return default
        d = d.get(k)
        if d is None:
            return default
    return d

# ---- values --------------------------------------------------------------
model = g(data, "model", "display_name", default="?")
cwd   = g(data, "workspace", "current_dir", default=g(data, "cwd", default=""))
proj  = g(data, "workspace", "project_dir", default=cwd)
home  = os.path.expanduser("~")
proj_disp = proj.replace(home, "~", 1) if proj else ""

ctx_pct = int(g(data, "context_window", "used_percentage", default=0) or 0)
ctx_tok = int(g(data, "context_window", "total_input_tokens", default=0) or 0)

# Per-MTok (input, output) rates by model-id substring, checked in order.
# Cache rates derive from the input rate: read = 0.1x, write = 1.25x (5-min
# TTL) / 2x (1-hour TTL). The 1M context runs at standard pricing (no
# long-context premium). Update when Anthropic's pricing changes.
PRICES = [
    ("fable",  (10.0, 50.0)),
    ("mythos", (10.0, 50.0)),
    ("opus",   (5.0, 25.0)),
    ("sonnet", (3.0, 15.0)),
    ("haiku",  (1.0, 5.0)),
]
DEFAULT_RATE = (5.0, 25.0)                # unknown model: assume Opus-tier

def rates(model_id):
    for frag, r in PRICES:
        if frag in (model_id or ""):
            return r
    return DEFAULT_RATE

# Cumulative session token usage, cost, and lines changed. The status-line
# JSON only carries the last API call's counts (current_usage), a volatile
# cost estimate, and per-message line counts, so derive all three from the
# transcript instead. Assistant rows are duplicated in the transcript, so
# dedupe on (msg id, requestId); tool results dedupe on tool_use_id. Cost is
# priced per message by that message's own model (with the 5m/1h cache-write
# split), so it stays correct across model switches and stays monotonic.
# Lines come from Edit/Write structuredPatch hunks (new-file writes count
# their content as added). Cache the result keyed by transcript size so we
# only re-parse when the file has actually grown.
def token_totals(path, sid):
    zero = (0, 0, 0, 0, 0.0, 0, 0)
    if not path or not os.path.exists(path):
        return zero
    try:
        size = os.path.getsize(path)
    except OSError:
        return zero
    cache = os.path.join(tempfile.gettempdir(), f"claude-statusline-tok-{sid or 'x'}")
    try:
        with open(cache) as cf:
            csize, ci, co, ccr, ccw, ccost, cadd, crem = cf.read().split()
            if int(csize) == size:
                return (int(ci), int(co), int(ccr), int(ccw), float(ccost),
                        int(cadd), int(crem))
    except Exception:
        pass
    tin = tout = cr = cw = add = rem = 0
    cost = 0.0
    seen_msgs, seen_tools = set(), set()
    try:
        with open(path) as tf:
            for line in tf:
                line = line.strip()
                if not line:
                    continue
                try:
                    d = json.loads(line)
                except Exception:
                    continue
                msg = d.get("message") if isinstance(d.get("message"), dict) else {}

                # --- lines changed (Edit/Write tool results) ---
                tr = d.get("toolUseResult")
                if isinstance(tr, dict) and "structuredPatch" in tr:
                    c = msg.get("content")
                    tuid = None
                    if isinstance(c, list) and c and isinstance(c[0], dict):
                        tuid = c[0].get("tool_use_id")
                    tuid = tuid or d.get("uuid")
                    if tuid not in seen_tools:
                        seen_tools.add(tuid)
                        sp = tr.get("structuredPatch")
                        if isinstance(sp, list) and sp:
                            for hunk in sp:
                                for ln in hunk.get("lines", []) if isinstance(hunk, dict) else []:
                                    if ln.startswith("+"):
                                        add += 1
                                    elif ln.startswith("-"):
                                        rem += 1
                        elif tr.get("type") == "create" and isinstance(tr.get("content"), str):
                            add += tr["content"].count("\n") + 1

                # --- tokens + cost (assistant usage rows) ---
                u = msg.get("usage")
                if not isinstance(u, dict):
                    continue
                key = (msg.get("id"), d.get("requestId"))
                if key in seen_msgs:
                    continue
                seen_msgs.add(key)
                m_in  = int(u.get("input_tokens", 0) or 0)
                m_out = int(u.get("output_tokens", 0) or 0)
                m_cr  = int(u.get("cache_read_input_tokens", 0) or 0)
                m_cw  = int(u.get("cache_creation_input_tokens", 0) or 0)
                # Split cache creation by TTL; if absent, treat as 5-minute.
                split = u.get("cache_creation")
                if isinstance(split, dict):
                    m_cw5  = int(split.get("ephemeral_5m_input_tokens", 0) or 0)
                    m_cw1h = int(split.get("ephemeral_1h_input_tokens", 0) or 0)
                else:
                    m_cw5, m_cw1h = m_cw, 0
                tin += m_in; tout += m_out; cr += m_cr; cw += m_cw
                r_in, r_out = rates(msg.get("model"))
                cost += (
                    m_in  * r_in
                    + m_out * r_out
                    + m_cr  * r_in * 0.1
                    + m_cw5 * r_in * 1.25
                    + m_cw1h * r_in * 2.0
                ) / 1_000_000
    except OSError:
        return zero

    try:
        tmp = f"{cache}.{os.getpid()}"
        with open(tmp, "w") as cf:
            cf.write(f"{size} {tin} {tout} {cr} {cw} {cost:.6f} {add} {rem}")
        os.replace(tmp, cache)
    except Exception:
        pass
    return (tin, tout, cr, cw, cost, add, rem)

tin, tout, cr, cw, cost, added, removed = token_totals(
    g(data, "transcript_path", default="") or "",
    g(data, "session_id", default="") or "",
)

branch = ""
try:
    branch = subprocess.run(
        ["git", "-C", cwd or ".", "branch", "--show-current"],
        capture_output=True, text=True, timeout=1,
    ).stdout.strip()
except Exception:
    branch = ""

rl   = g(data, "rate_limits", default={}) or {}
five = g(rl, "five_hour", "used_percentage")     # present only on Pro/Max
week = g(rl, "seven_day", "used_percentage")

# ---- helpers -------------------------------------------------------------
def hnum(n):
    if n >= 1_000_000:
        return f"{n/1_000_000:.1f}M".replace(".0M", "M")
    if n >= 1_000:
        return f"{n/1_000:.1f}k".replace(".0k", "k")
    return str(n)

def pct_color(p):                     # green < 70, yellow 70-89, red >= 90
    return "31" if p >= 90 else "33" if p >= 70 else "32"

SEP = c("90", " │ ")                  # dim separator (│ is width-1)

# ---- left group ----------------------------------------------------------
left = [c("1;36", model), c(pct_color(ctx_pct), f"{hnum(ctx_tok)} ({ctx_pct}%) ctx")]
if proj_disp:
    left.append(c("90", proj_disp))
if branch:
    left.append(c("32", f"⎇ {branch}"))
left.append(c("32", f"+{added}") + "/" + c("31", f"-{removed}"))
left = SEP.join(left)

# ---- second row ----------------------------------------------------------
second = [
    c("33", f"${cost:.2f}"),
    c("90", f"in {hnum(tin)} out {hnum(tout)} cr {hnum(cr)} cw {hnum(cw)}"),
]
usage = []
if five is not None:
    usage.append(c(pct_color(int(five)), f"5h {int(round(five))}%"))
if week is not None:
    usage.append(c(pct_color(int(week)), f"7d {int(round(week))}%"))
if usage:
    second.append(" ".join(usage))
second = SEP.join(second)

# Two left-aligned rows: nothing reaches the contested right edge, so nothing
# is ever truncated. Each print() renders as its own status-line row.
print(left)
print(second)
PY
