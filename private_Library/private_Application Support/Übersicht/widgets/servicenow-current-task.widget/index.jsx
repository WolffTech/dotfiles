import {
  formatTaskText,
  formatUrlText,
  getSafeUrl,
  parseState,
} from './ServiceNowCurrentTask.helpers.mjs';

const stateFilePath = "$HOME/Library/Application Support/Übersicht/servicenow-current-task.json";

export const command = `if [ -f "${stateFilePath}" ]; then cat "${stateFilePath}"; fi`;

export const refreshFrequency = 5000;

const openUrl = (url) => {
  const safeUrl = getSafeUrl(url);

  if (!safeUrl) {
    return;
  }

  window.open(safeUrl, '_blank', 'noopener,noreferrer');
};

export const render = ({ output }) => {
  const { taskText, url } = parseState(output);
  const safeUrl = getSafeUrl(url);
  const displayTaskText = formatTaskText(taskText);
  const displayUrlText = formatUrlText(safeUrl);
  const hasDetailsLine = Boolean(safeUrl && displayUrlText);

  if (!displayTaskText) {
    return null;
  }

  return (
    <div style={{ textAlign: 'center', paddingBottom: hasDetailsLine ? '0' : '12px' }}>
      <style>{`
        .current-task {
          font-family: 'Realtime Semibold', sans-serif;
          font-size: 18px;
          color: #fff;
          font-weight: bold;
          text-align: center;
          text-shadow:
            0 1px 2px rgba(0, 0, 0, 0.9),
            0 0 6px rgba(0, 0, 0, 0.55);
        }

        .task-details {
          font-family: 'Realtime Light', sans-serif;
          font-size: 18px;
          color: #fff;
          text-align: center;
          text-shadow:
            0 1px 2px rgba(0, 0, 0, 0.9),
            0 0 6px rgba(0, 0, 0, 0.55);
        }

        .task-link {
          cursor: pointer;
          user-select: none;
        }

        .task-small {
          font-family: 'Realtime Light', sans-serif;
          font-size: 11px;
          color: #fff;
          text-align: center;
          margin-top: 2px;
          text-shadow:
            0 1px 2px rgba(0, 0, 0, 0.9),
            0 0 6px rgba(0, 0, 0, 0.55);
        }
      `}</style>

      <p style={{ margin: '2px 2px' }}>
        <span className="current-task">Current Task: </span>
        <span className="task-details">{displayTaskText}</span>
      </p>

      {hasDetailsLine && (
        <p className="task-small task-link" onClick={() => openUrl(safeUrl)}>
          {displayUrlText}
        </p>
      )}
    </div>
  );
};

export const className = `
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
  color: #fff;
  font-family: 'Realtime';
  font-size: 15px;
`;
