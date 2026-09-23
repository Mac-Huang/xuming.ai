// Apply the same external-link behavior to static content and generated rows/citations.
(() => {
  const external = a => {
    const url = new URL(a.getAttribute('href') || '', location.href);
    return /^https?:$/.test(url.protocol) && url.origin !== location.origin && !['xuming.ai', 'www.xuming.ai'].includes(url.hostname);
  };
  const update = root => {
    const links = [...(root.querySelectorAll?.('a[href]') || [])];
    if (root.matches?.('a[href]')) links.push(root);
    for (const a of links) if (external(a)) {
      a.target = '_blank';
      a.rel = [...new Set([...a.relList, 'noopener', 'noreferrer'])].join(' ');
    }
  };
  update(document);
  new MutationObserver(records => records.forEach(r => {
    if (r.type === 'attributes') update(r.target);
    else r.addedNodes.forEach(update);
  })).observe(document.documentElement, {childList:true, subtree:true, attributes:true, attributeFilter:['href']});
})();
