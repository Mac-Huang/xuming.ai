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
  constructor(status, details = {}) {
    const reason=details.message || '';
    const limited=status===429 || ((status===403) && (details.remaining==='0' || details.retryAfter || /rate limit|abuse/i.test(reason)));
    const conflict=status===409 || (status===422 && /sha|already exists|does not match/i.test(reason));
    const delay=Number(details.retryAfter),reset=Number(details.reset);
    const retryAt=limited ? Math.max(Date.now()+1000, Number.isFinite(delay)&&delay>0 ? Date.now()+delay*1000 : details.remaining==='0' && Number.isFinite(reset)&&reset>0 ? reset*1000+1000 : Date.now()+60000) : 0;
    let message=conflict?'GitHub changed since this draft was opened. Refresh to compare versions.':`GitHub request failed (${status}).`;
    if(limited)message=`GitHub rate limit reached. Sync will retry after ${new Date(retryAt).toLocaleTimeString()}.`;
    else if(status===401)message='Your GitHub token expired or was revoked. Update the connection token.';
    else if(status===403 && /resource not accessible|permission/i.test(reason))message='This token cannot write to the journal. In GitHub token settings, select Mac-Huang/xuming.ai and set Contents to Read and write, then retry. If you created a new token, update the connection.';
    else if(status===403)message='GitHub denied this request.';
    else if(status===413 || /too large|larger than|exceeds.*size/i.test(reason))message='This file is too large for GitHub. Choose a smaller file.';
    else if(status===422 && !conflict)message='GitHub could not accept this upload.';
    else if(status===404 && details.method==='PUT')message='GitHub cannot access this repository or branch with the current token. Check the selected repository and Contents write permission.';
    if(reason && !limited)message+=` GitHub: ${reason.slice(0,350)}`;
    super(message+' Your draft stays on this device.');
    this.status = status;
    this.kind=limited?'rate-limit':conflict?'conflict':status===401?'authentication':status===403?'permission':'request';
    this.retryAt=retryAt;
  }
}
export class GitHub {
  constructor(fetcher = (url, options) => fetch(url, options)) { this.fetcher = fetcher; this.token = ''; }
  async request(path, options = {}) {
    const headers = { Accept: 'application/vnd.github+json', 'X-GitHub-Api-Version': '2026-03-10', ...options.headers };
    if (this.token) headers.Authorization = `Bearer ${this.token}`;
    let result;
    try { result = await this.fetcher(`${API}${path}`, { ...options, headers, cache: 'no-store', signal: AbortSignal.timeout(options.method==='PUT'?180000:30000) }); }
    catch { throw new Error('Cannot reach GitHub. Your draft stays on this device; use Save now to retry.'); }
    if (result.status === 404 && options.allowMissing) return null;
    if (!result.ok) {
      const payload=await result.json().catch(()=>({}));
      const reason=typeof payload.message==='string'?payload.message:'';
      throw new GitHubError(result.status,{message:this.token?reason.replaceAll(this.token,'[redacted]'):reason,remaining:result.headers.get('x-ratelimit-remaining'),reset:result.headers.get('x-ratelimit-reset'),retryAfter:result.headers.get('retry-after'),method:options.method||'GET'});
    }
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
    if (entry.date !== date || (typeof entry.markdown !== 'string' && typeof entry.html !== 'string') || typeof entry.title !== 'string') throw new Error('The saved entry has an invalid format. It has not been overwritten.');
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
  const allowed = new Set(['P','DIV','BR','HR','B','STRONG','I','EM','U','S','DEL','H1','H2','H3','H4','H5','H6','UL','OL','LI','BLOCKQUOTE','PRE','CODE','IMG','VIDEO','SOURCE','A','TABLE','THEAD','TBODY','TR','TH','TD','INPUT']);
  const remove = new Set(['SCRIPT','STYLE','IFRAME','OBJECT','SVG','MATH','FORM','BUTTON','TEMPLATE','LINK','META']);
  for (const node of [...template.content.querySelectorAll('*')]) {
    if (remove.has(node.tagName)) { node.remove(); continue; }
    if (!allowed.has(node.tagName)) { node.replaceWith(...node.childNodes); continue; }
    const src = node.getAttribute('src') || '';
    const alt = node.getAttribute('alt') || '';
    const href = node.getAttribute('href') || '';
    const checkbox = node.getAttribute('type') === 'checkbox';
    const checked = node.hasAttribute('checked');
    const start = node.getAttribute('start');
    // Read only dimension declarations as text: CSP intentionally blocks inline CSS.
    const styles=Object.fromEntries((node.getAttribute('style')||'').split(';').map(part=>part.split(':').map(value=>value.trim().toLowerCase())).filter(part=>part.length===2));
    const width=node.getAttribute('width') || styles.width;
    const height=node.getAttribute('height') || styles.height;
    const type=node.getAttribute('type');
    for (const attr of [...node.attributes]) node.removeAttribute(attr.name);
    if (node.tagName === 'IMG') {
      if (!/^data:image\/(png|jpeg|webp|gif);base64,[a-zA-Z0-9+/=]+$/.test(src) && !/^https:\/\//i.test(src) && !/^\/(?!\/)/.test(src)) { node.remove(); continue; }
      node.setAttribute('src', src); node.setAttribute('alt', alt); node.setAttribute('loading','lazy');
    }
    if(['IMG','VIDEO'].includes(node.tagName)) {
      for(const [name,value] of [['width',width],['height',height]]) {
        if(!value)continue;
        if(/^\d+(?:px)?$/.test(value) && parseInt(value)>0 && parseInt(value)<=4096)node.setAttribute(name,String(parseInt(value)));
        else if(name==='width' && /^\d+(?:\.\d+)?%$/.test(value) && parseFloat(value)>0 && parseFloat(value)<=100)node.setAttribute(name,value);
      }
    }
    if(['VIDEO','SOURCE'].includes(node.tagName)) {
      if(src && /^https:\/\//i.test(src))node.setAttribute('src',src);
      if(type && ['video/mp4','video/quicktime','video/webm'].includes(type))node.setAttribute('type',type);
      if(node.tagName==='VIDEO'){node.setAttribute('controls','');node.setAttribute('playsinline','');node.setAttribute('preload','metadata');}
    }
    if(node.tagName === 'A' && /^(https?:\/\/|mailto:)/i.test(href)) { node.setAttribute('href',href); node.setAttribute('target','_blank'); node.setAttribute('rel','noopener noreferrer'); }
    if(node.tagName === 'INPUT') {
      if(!checkbox) { node.remove(); continue; }
      node.setAttribute('type','checkbox');node.setAttribute('disabled','');if(checked)node.setAttribute('checked','');
    }
    if(node.tagName === 'OL' && /^\d+$/.test(start||''))node.setAttribute('start',start);
  }
  return template.innerHTML;
}
