export const REPO = 'Mac-Huang/xuming.ai';
export const BRANCH = 'journal-data';
export const API = `https://api.github.com/repos/${REPO}`;
export const RAW = `https://raw.githubusercontent.com/${REPO}/${BRANCH}/`;
export function validDate(date) {
  return /^\d{4}-\d{2}-\d{2}$/.test(date) && !Number.isNaN(Date.parse(`${date}T12:00:00Z`)) && new Date(`${date}T12:00:00Z`).toISOString().slice(0, 10) === date;
}
export function entryPath(date) {
  if (!validDate(date)) throw new Error('Choose a valid date.');
  return `journal/entries/${date.slice(0,4)}/${date.slice(5,7)}/${date.slice(8)}.json`;
}
export function encode(text) {
  const bytes = new TextEncoder().encode(text);
  return bytesToBase64(bytes);
}
export function bytesToBase64(bytes) {
  let binary = '';
  for (let i = 0; i < bytes.length; i += 8192) binary += String.fromCharCode(...bytes.subarray(i, i + 8192));
  return btoa(binary);
}
export function decode(content) {
  return new TextDecoder().decode(Uint8Array.from(atob(content.replace(/\s/g, '')), c => c.charCodeAt(0)));
}
export class GitHubError extends Error {
  constructor(status) {
    super(status === 409 || status === 422 ? 'GitHub changed since this draft was opened. Refresh to compare versions.' : status === 401 ? 'Your GitHub token expired or is invalid. Reconnect to save.' : status === 403 ? 'GitHub denied this request. Check token permissions or try again after the API limit resets.' : `GitHub request failed (${status}). Your draft is still on this device.`);
    this.status = status;
  }
}
export class GitHub {
  constructor(fetcher = (url, options) => fetch(url, options)) { this.fetcher = fetcher; this.token = ''; }
  async request(path, options = {}) {
    const headers = { Accept: 'application/vnd.github+json', 'X-GitHub-Api-Version': '2026-03-10', ...options.headers };
    if (this.token) headers.Authorization = `Bearer ${this.token}`;
    let result;
    try { result = await this.fetcher(`${API}${path}`, { ...options, headers, cache: 'no-store', signal: AbortSignal.timeout(30000) }); }
    catch { throw new Error('Cannot reach GitHub. Your draft stays on this device; use Save now to retry.'); }
    if (result.status === 404 && options.allowMissing) return null;
    if (!result.ok) throw new GitHubError(result.status);
    return result.json();
  }
  async connect(token) {
    this.token = token;
    try {
      const repo = await this.request('');
      if (!repo.permissions?.push) throw new Error('This token does not have write access to Mac-Huang/xuming.ai.');
    } catch (error) { this.token = ''; throw error; }
  }
  async get(date) {
    const file = await this.request(`/contents/${entryPath(date)}?ref=${BRANCH}`, { allowMissing: true });
    if (!file) return { sha: null, entry: null };
    const entry = JSON.parse(decode(file.content));
    if (entry.date !== date || typeof entry.html !== 'string' || typeof entry.title !== 'string') throw new Error('The saved entry has an invalid format. It has not been overwritten.');
    return { sha: file.sha, entry };
  }
  async month(month) {
    if (!/^\d{4}-\d{2}$/.test(month)) throw new Error('Invalid month.');
    const files = await this.request(`/contents/journal/entries/${month.replace('-', '/')}?ref=${BRANCH}`, { allowMissing: true });
    return (files || []).filter(f => f.type === 'file' && /^\d{2}\.json$/.test(f.name)).map(f => `${month}-${f.name.slice(0,2)}`);
  }
  async put(path, content, sha, message) {
    if (!this.token) throw new Error('Connect GitHub to sync this draft.');
    if (!/^journal\/(entries|media)\/[\w/.-]+$/.test(path) || path.includes('..')) throw new Error('Invalid journal path.');
    const body = { message, content, branch: BRANCH };
    if (sha) body.sha = sha;
    return this.request(`/contents/${path}`, { method: 'PUT', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(body) });
  }
  async save(entry, sha) {
    return this.put(entryPath(entry.date), encode(JSON.stringify(entry, null, 2) + '\n'), sha, `Journal: ${entry.date}`);
  }
}
// No entry HTML is trusted, including local drafts and GitHub content.
export function cleanHTML(html, doc = document) {
  const template = doc.createElement('template');
  template.innerHTML = html;
  const allowed = new Set(['P','DIV','BR','B','STRONG','I','EM','U','S','H2','H3','UL','OL','LI','BLOCKQUOTE','PRE','CODE','IMG']);
  const remove = new Set(['SCRIPT','STYLE','IFRAME','OBJECT','SVG','MATH','FORM','INPUT','BUTTON','TEMPLATE','LINK','META']);
  for (const node of [...template.content.querySelectorAll('*')]) {
    if (remove.has(node.tagName)) { node.remove(); continue; }
    if (!allowed.has(node.tagName)) { node.replaceWith(...node.childNodes); continue; }
    const src = node.getAttribute('src') || '';
    const alt = node.getAttribute('alt') || '';
    for (const attr of [...node.attributes]) node.removeAttribute(attr.name);
    if (node.tagName === 'IMG') {
      if (!/^data:image\/(png|jpeg|webp|gif);base64,[a-zA-Z0-9+/=]+$/.test(src) && !src.startsWith(`${RAW}journal/media/`)) { node.remove(); continue; }
      node.setAttribute('src', src); node.setAttribute('alt', alt); node.setAttribute('loading','lazy');
    }
  }
  return template.innerHTML;
}
