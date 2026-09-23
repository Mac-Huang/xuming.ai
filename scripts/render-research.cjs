// Keep research readable without JavaScript; main.js uses the same data in the browser.
const fs = require('node:fs');
const vm = require('node:vm');
const path = require('node:path');
const root = path.resolve(__dirname, '..');
const context = vm.createContext({});
vm.runInContext(fs.readFileSync(path.join(root, 'data/publications.js'), 'utf8') + '\nthis.entries = publications;', context);
const escape = value => String(value).replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '&quot;');
function row(p) {
  const links = [['paper_url','paper_label','paper'],['code_url','code_label','code'],['project_url','project_label','project']]
    .filter(([key]) => p[key]).map(([key,label,fallback]) => `<a href="${escape(p[key])}">${escape(p[label] || fallback)}</a>`).join(' / ');
  return `<tr id="${escape(p.id)}" class="research-row"${p.highlighted ? ' style="background-color:#ffffd0"' : ''}><td style="padding:20px;width:25%;vertical-align:middle"><img src="${escape(p.image)}" alt="${escape(p.title)}" width="160" style="border-style:none;height:auto" loading="lazy"></td><td style="padding:20px;width:75%;vertical-align:middle"><a href="${escape(p.paper_url)}"><papertitle>${escape(p.title)}</papertitle></a><br><div>${p.authors}</div><em>${escape(p.venue)}</em><br><div>${links}</div><p>${escape(p.abstract)}</p></td></tr>`;
}
for (const [file,id,entries] of [['index.html','selected-publications',context.entries.filter(p=>p.selected)],['research.html','publications-table',context.entries]]) {
  const target=path.join(root,file);const content=fs.readFileSync(target,'utf8');
  const pattern=new RegExp(`(<table[^>]*id="${id}"[^>]*>\\s*<tbody>)[\\s\\S]*?(<\\/tbody>)`);
  if(!pattern.test(content)) throw new Error(`Missing table ${id}`);
  fs.writeFileSync(target,content.replace(pattern,(_,start,end)=>start+'\n'+entries.map(row).join('\n')+'\n'+end));
}
