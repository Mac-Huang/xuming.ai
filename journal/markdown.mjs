import { marked } from './vendor/marked.mjs';
import TurndownService from './vendor/turndown.mjs';
import { RAW, cleanHTML } from './core.mjs?v=20260924-media';
import { videoPreview, releaseUnusedPreviews, validMediaData } from './media.mjs';

const converter = new TurndownService({headingStyle:'atx',codeBlockStyle:'fenced',bulletListMarker:'-',emDelimiter:'*'});
converter.addRule('strikethrough',{filter:['del','s'],replacement:content=>`~~${content}~~`});
converter.addRule('sizedMedia',{filter:node=>node.nodeName==='VIDEO'||node.nodeName==='IMG'&&(node.hasAttribute('width')||node.hasAttribute('height')),replacement:(_content,node)=>'\n\n'+node.outerHTML+'\n\n'});
export function mediaPath(date) { return `journal/media/${date.slice(0,7).replace('-','/')}/${crypto.randomUUID()}.webp`; }
export function markdownImage(name,url) { return `![${name.replace(/[\[\]\\\r\n]/g,'')}](${url})`; }
export function toMarkdownEntry(entry,date) {
  if(!entry)return {date,title:'',markdown:'',pendingImages:{},version:2};
  if(typeof entry.markdown==='string')return {...entry,pendingImages:{...entry.pendingImages},version:2};
  const container=document.createElement('div');container.innerHTML=cleanHTML(entry.html||'');
  const pendingImages={};
  for(const image of container.querySelectorAll('img')) {
    if(image.src.startsWith('data:')) {
      const extension=/data:image\/(\w+);/.exec(image.src)[1];
      const path=mediaPath(date).replace(/\.webp$/,'.'+extension);pendingImages[path]=image.src;image.src=RAW+path;
    }
  }
  return {...entry,markdown:converter.turndown(container),pendingImages,version:2};
}
export function renderMarkdown(markdown,pendingImages={}) {
  const template=document.createElement('template');
  template.innerHTML=cleanHTML(marked.parse(markdown,{gfm:true,breaks:false,async:false}));
  for(const image of template.content.querySelectorAll('img')) {
    const path=image.getAttribute('src').slice(RAW.length);
    if(pendingImages[path] && /^data:image\/(png|jpeg|webp|gif);base64,[a-zA-Z0-9+/=]+$/.test(pendingImages[path]))image.src=pendingImages[path];
  }
  releaseUnusedPreviews(pendingImages);
  for(const video of template.content.querySelectorAll('video,source')) {
    const src=video.getAttribute('src')||'',path=src.slice(RAW.length);
    if(src.startsWith(RAW) && validMediaData(pendingImages[path]) && pendingImages[path].startsWith('data:video/'))video.src=videoPreview(path,pendingImages[path]);
  }
  for(const link of template.content.querySelectorAll('a[href]')) {
    const href=link.getAttribute('href'),path=href.slice(RAW.length);
    if(href.startsWith(RAW) && validMediaData(pendingImages[path]) && pendingImages[path].startsWith('data:video/'))link.href=videoPreview(path,pendingImages[path]);
  }
  return template.innerHTML;
}
