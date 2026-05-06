export const parseState = (output) => {
  if (!output || !output.trim()) {
    return { taskText: '', url: '' };
  }

  try {
    const state = JSON.parse(output);
    return {
      taskText: typeof state.taskText === 'string' ? state.taskText.trim() : '',
      url: typeof state.url === 'string' ? state.url.trim() : '',
    };
  } catch {
    return { taskText: '', url: '' };
  }
};

export const getSafeUrl = (url) => {
  if (!url) {
    return '';
  }

  try {
    const parsedUrl = new URL(url);
    return parsedUrl.protocol === 'https:' || parsedUrl.protocol === 'http:' ? parsedUrl.href : '';
  } catch {
    return '';
  }
};

const truncateText = (text, maxLength, includeEllipsisInLimit = false) => {
  if (text.length <= maxLength) {
    return text;
  }

  if (includeEllipsisInLimit && maxLength > 3) {
    return `${text.slice(0, maxLength - 3)}...`;
  }

  return `${text.slice(0, maxLength)}...`;
};

export const formatTaskText = (taskText, maxDescriptionLength = 80) => {
  const match = taskText.match(/^(\S+)\s+(.+)$/);
  const ticketPattern = /^(?:INC|RITM|REQ|CHG|PRB|SCTASK|TASK)\d+$/i;

  if (!match) {
    return truncateText(taskText, maxDescriptionLength);
  }

  const [, ticketNumber, description] = match;

  if (!ticketPattern.test(ticketNumber)) {
    return truncateText(taskText, maxDescriptionLength);
  }

  return `${ticketNumber} - ${truncateText(description, maxDescriptionLength)}`;
};

export const formatUrlText = (url, maxLength = 80) => {
  const safeUrl = getSafeUrl(url);

  if (!safeUrl) {
    return '';
  }

  const parsedUrl = new URL(safeUrl);
  const displayUrl = `${parsedUrl.host}${parsedUrl.pathname}${parsedUrl.search}`;
  return truncateText(displayUrl, maxLength, true);
};
