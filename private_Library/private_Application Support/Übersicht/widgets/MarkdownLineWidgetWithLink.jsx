{/*
Copyright (c) 2024, Nick Wolff <nick@wolff.tech>

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/}

// Übersicht Widget for displaying a line starting with "- [~]" from a Markdown document.
// Links inside of () at the end of the line will be displayed on the widget as a second line.

// Specify the path to your Markdown document
const markdownFilePath = "~/Documents/worklog.md";

export const command = `cat ${markdownFilePath}`;

// Set the refresh frequency for updating the widget
export const refreshFrequency = 5000; // ms

const parseMarkdown = (output) => {
  const lines = output.split('\n');
  const taskLine = lines.find(line => line.startsWith('- [~]'));

  if (taskLine) {
    const taskMatch = taskLine.match(/- \[~\] ([^(]+)(?:\(([^)]+)\))?/);

    if (taskMatch) {
      const taskText = taskMatch[1].trim();
      const detailsText = taskMatch[2] ? taskMatch[2].trim() : '';
      return { taskText, detailsText };
    }
  }

  return { taskText: '', detailsText: '' };
};

// Render function to display the widget
export const render = ({ output }) => {
  const { taskText, detailsText } = parseMarkdown(output);

  return (
    <div style={{ textAlign: 'center' }}>
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
          margin-top: 2px;
          text-shadow:
            0 1px 2px rgba(0, 0, 0, 0.9),
            0 0 6px rgba(0, 0, 0, 0.55);
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

      {detailsText ? (
        <p style={{ margin: '2px 2px'}}>
          <span className="current-task">Current Task: </span>
          <span className="task-details">{taskText}</span>
        </p>
      ) : (
        <p>
          <span className="current-task">Current Task: </span>
          <span className="task-details">{taskText}</span>
        </p>
      )}

      {detailsText && (
        <p className="task-small">{detailsText}</p>
      )}
    </div>
  );
};

// Styling for the overall widget presentation
export const className = `
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
  color: #fff;
  font-family: 'Realtime';
  font-size: 15px;
`;
