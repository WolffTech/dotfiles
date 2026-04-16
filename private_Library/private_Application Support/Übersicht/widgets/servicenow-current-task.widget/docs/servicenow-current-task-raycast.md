# ServiceNow Current Task Raycast Setup

## Files

- Widget: `servicenow-current-task.widget/index.jsx`
- Capture script: `scripts/capture-servicenow-current-task.sh`
- Clear script: `scripts/clear-servicenow-current-task.sh`
- State file: `~/Library/Application Support/Übersicht/servicenow-current-task.json`

## Raycast Script Command

Before expecting updates, make sure `servicenow-current-task.widget` is enabled in Übersicht.

Create a Raycast Script Command that runs:

```bash
/Users/nicholas.wolff/Library/Application\ Support/Übersicht/widgets/servicenow-current-task.widget/scripts/capture-servicenow-current-task.sh
```

That absolute path must match the local checkout location of the `widgets` directory on this machine.

Suggested metadata:

- Title: `Capture ServiceNow Current Task`
- Mode: `Compact`
- Package Name: `Local`

Create a second Raycast Script Command to clear the widget back to the default state:

```bash
/Users/nicholas.wolff/Library/Application\ Support/Übersicht/widgets/servicenow-current-task.widget/scripts/clear-servicenow-current-task.sh
```

Suggested metadata:

- Title: `Clear ServiceNow Current Task`
- Mode: `Compact`
- Package Name: `Local`

## Expected Behavior

1. Open a ServiceNow ticket in Safari.
2. Run the Raycast command.
3. A macOS notification confirms success or failure.
4. The widget refreshes and shows the latest captured task.
5. Running the clear command resets the widget to `Current Task: General Work and Meetings` with no second line.

## Permissions

- On first run, macOS may prompt Raycast for notification permission so the script can surface success and failure messages.
- macOS may also prompt to allow Raycast or `osascript` to control Safari. Approve that automation request or the capture step will fail before it can read the current tab.
- In Safari, enable `Allow JavaScript from Apple Events` in `Settings > Advanced > Show features for web developers`, then `Developer`, or Safari will reject the DOM capture step.

## Failure Cases

- If Safari is not showing a recognized ServiceNow ticket, the script exits non-zero and leaves the current state file unchanged.
- If the widget file is enabled but the state file is missing, the widget renders nothing.

## Future Hotkey

The hotkey path is intentionally disabled for now. When needed later, point the hotkey runner at the same capture script so the widget and state format stay unchanged.
