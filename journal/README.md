# Journal

Unlisted personal journal at `/journal/`. The app, entries, and images are public. There is no incoming link from the portfolio navigation, course catalogs, blog, or bot knowledge. `noindex` requests exclusion from search engines; it is not access control.

The page uses the portfolio's shared stylesheet. A calendar opens one entry per day, with a rich-text editor, image paste/upload, local drafts, and automatic GitHub synchronization after five seconds of inactivity. Images are resized to 2048 pixels and converted to WebP (animated GIFs become a still image).

## Saving

Click **Connect GitHub**, then supply a GitHub fine-grained personal access token with this repository selected and **Contents: Read and write**. A public visitor can read and keep local drafts, but cannot change the repository without write access. The token remains in JavaScript memory only; refresh, disconnect, or closing the tab clears it. Never put a token into source, a URL, or an entry.

- Entries: `journal/entries/YYYY/MM/DD.json` (title, sanitized HTML, date, update time).
- Images: `journal/media/YYYY/MM/<uuid>.webp`.
- Drafts: IndexedDB in the current browser, removed after confirmed synchronization.
- Saves: GitHub Contents API commits to the public `journal-data` branch in the same repository; no backend is needed and saving does not rebuild the portfolio. Images are committed before their entry. A failed entry save retains its local draft and already-uploaded image references.
- Conflicts: the original file SHA is supplied on update. Changes from another device require explicit comparison/selection; no automatic overwrite.
- History: links to GitHub's per-file commit history. **Export** downloads the current entry as HTML; synced image URLs remain remote.

External GitHub requests have a 30-second timeout. Failed saves stay local and can be retried. GitHub permission/rate-limit errors are shown in the page. Empty new entries are not uploaded automatically. A token is needed again in each new/reloaded tab.

Do not add this directory to discovery feeds or bot knowledge. No journal content should be extracted into `data/bot-knowledge.json`.
