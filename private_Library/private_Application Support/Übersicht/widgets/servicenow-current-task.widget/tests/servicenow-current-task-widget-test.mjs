import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

import {
  formatTaskText,
  formatUrlText,
  getSafeUrl,
  parseState,
} from '../ServiceNowCurrentTask.helpers.mjs';

const widgetSource = readFileSync(new URL('../index.jsx', import.meta.url), 'utf8');
assert.equal(widgetSource.includes('Application Support/Übersicht/servicenow-current-task.json'), true);
assert.equal(widgetSource.includes('bottom: 0;'), true);
assert.equal(widgetSource.includes("paddingBottom: hasDetailsLine ? '0' : '12px'"), true);

assert.deepEqual(parseState(''), { taskText: '', url: '' });

assert.deepEqual(parseState('{"taskText":"INC0292497 Missing subfolder in Member Services UDrive","url":"https://example.service-now.com/incident.do?sys_id=123"}'), {
  taskText: 'INC0292497 Missing subfolder in Member Services UDrive',
  url: 'https://example.service-now.com/incident.do?sys_id=123',
});

assert.equal(
  formatTaskText('INC0292497 Missing subfolder in Member Services UDrive'),
  'INC0292497 - Missing subfolder in Member Services UDrive',
);

assert.equal(
  formatTaskText(`INC0292497 ${'A'.repeat(130)}`),
  `INC0292497 - ${'A'.repeat(80)}...`,
);

assert.equal(
  formatTaskText('General Work and Meetings'),
  'General Work and Meetings',
);

assert.equal(getSafeUrl('javascript:alert(1)'), '');
assert.equal(getSafeUrl('https://example.service-now.com/incident.do?sys_id=123'), 'https://example.service-now.com/incident.do?sys_id=123');

assert.equal(
  formatUrlText('https://example.service-now.com/incident.do?sys_id=123'),
  'example.service-now.com/incident.do?sys_id=123',
);

const shortenedUrl = formatUrlText('https://example.service-now.com/' + 'a'.repeat(120));
assert.equal(shortenedUrl.length, 80);
assert.equal(shortenedUrl.startsWith('example.service-now.com/'), true);
assert.equal(shortenedUrl.endsWith('...'), true);

console.log('PASS');
