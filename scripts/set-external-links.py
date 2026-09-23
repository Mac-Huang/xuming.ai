#!/usr/bin/env python3
"""Set external anchors statically and load the handler for dynamically rendered links."""
from pathlib import Path
from urllib.parse import urlsplit
import html,re,os
ROOT=Path(__file__).resolve().parents[1]
def anchor(m):
 tag=m.group();u=re.search(r'\bhref\s*=\s*([\"\'])(.*?)\1',tag,re.S|re.I)
 if not u:return tag
 url=urlsplit(html.unescape(u[2]))
 if url.scheme not in ('http','https','') or not url.netloc or url.hostname in ('xuming.ai','www.xuming.ai'):return tag
 tag=re.sub(r'\s+target\s*=\s*([\"\']).*?\1','',tag,flags=re.I|re.S)
 rel=re.search(r'\s+rel\s*=\s*([\"\'])(.*?)\1',tag,re.I|re.S)
 values=set((rel[2] if rel else '').split())|{'noopener','noreferrer'}
 if rel:tag=tag[:rel.start()]+tag[rel.end():]
 return tag[:-1]+' target="_blank" rel="'+' '.join(sorted(values))+'">'
for p in ROOT.rglob('*.html'):
 if any(x in p.parts for x in ['node_modules','.git']):continue
 original=p.read_bytes(); crlf=b'\r\n' in original and original.count(b'\r\n')==original.count(b'\n')
 s=re.sub(r'<a\b[^>]*>',anchor,p.read_text(),flags=re.I)
 if 'src="'+os.path.relpath(ROOT/'js/site-links.js',p.parent)+'"' not in s:
  script='<script src="'+os.path.relpath(ROOT/'js/site-links.js',p.parent)+'" defer></script>'
  s=s.replace('</head>',script+'\n</head>',1)
 p.write_bytes(s.replace('\n','\r\n').encode() if crlf else s.encode())
