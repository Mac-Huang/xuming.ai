export const MAX_VIDEO_BYTES=50*1024*1024;
export function videoType(file) {
  if(/\.mov$/i.test(file.name)||file.type==='video/quicktime')return {extension:'mov',mime:'video/quicktime'};
  if(/\.mp4$/i.test(file.name)||file.type==='video/mp4')return {extension:'mp4',mime:'video/mp4'};
  return null;
}
export function fileDataURL(file,type) {
  return new Promise((resolve,reject)=>{
    const reader=new FileReader();reader.onload=()=>resolve(reader.result);reader.onerror=()=>reject(new Error('Could not read this media file. Please select it again.'));
    reader.readAsDataURL(new Blob([file],{type}));
  });
}
export function videoMarkup(name,url) {
  const label=name.replace(/[<>"'&\r\n]/g,'');
  return `<video src="${url}" controls width="640" playsinline></video>\n\n[Open / download ${label.replace(/[\[\]\\]/g,'')}](${url})`;
}
export function validMediaData(value) {return typeof value==='string' && /^data:(?:image\/(?:png|jpeg|webp|gif)|video\/(?:mp4|quicktime));base64,[a-zA-Z0-9+/=]+$/.test(value);}
const previews=new Map();
export function videoPreview(path,data) {
  const cached=previews.get(path);if(cached?.data===data)return cached.url;
  if(cached)URL.revokeObjectURL(cached.url);
  const [header,base64]=data.split(',');const type=header.slice(5,header.indexOf(';'));
  const bytes=Uint8Array.from(atob(base64),c=>c.charCodeAt(0));
  const url=URL.createObjectURL(new Blob([bytes],{type}));previews.set(path,{data,url});return url;
}
export function releaseUnusedPreviews(pending) {for(const [path,value] of previews)if(!pending[path]){URL.revokeObjectURL(value.url);previews.delete(path);}}
