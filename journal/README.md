# Journal

Unlisted personal journal at `/journal/`. The app, entries, and images are public. There is no incoming link from the portfolio navigation, course catalogs, blog, or bot knowledge. `noindex` requests exclusion from search engines; it is not access control.

The page uses the portfolio's shared stylesheet. A calendar opens one entry per day, with a Markdown editor and Write/Preview views, image paste/upload, local drafts, and automatic GitHub synchronization after five seconds of inactivity. Images are resized to 2048 pixels and converted to WebP (animated GIFs become a still image).

## Saving

Click **Connect GitHub**, then supply a GitHub fine-grained personal access token with this repository selected and **Contents: Read and write**. A public visitor can read and keep local drafts, but cannot change the repository without write access. **Remember on this device** is selected by default. It stores the token in this browser's localStorage and reconnects automatically after refresh or reopening. Uncheck it for a connection held only in the current tab. Use this only on a trusted device: scripts on the same website origin can access browser storage. **Disconnect GitHub** removes the stored token and disconnects other open journal tabs. Never put a token into source, a URL, or an entry.

- Entries: `journal/entries/YYYY/MM/DD.json` (title, Markdown source, date, update time; version 2). Older version 1 HTML entries are converted when opened and are only rewritten after an edit/save.
- Images: `journal/media/YYYY/MM/<uuid>.webp`.
- Drafts: IndexedDB in the current browser, removed after confirmed synchronization.
- Saves: GitHub Contents API commits to the public `journal-data` branch in the same repository; no backend is needed and saving does not rebuild the portfolio. Images are committed before their entry. A failed entry save retains its local draft and already-uploaded image references.
- Conflicts: the original file SHA is supplied on update. Changes from another device require explicit comparison/selection; no automatic overwrite.
- History: links to GitHub's per-file commit history. **Export** downloads a `.md` file; synced image URLs remain remote. New pasted/uploaded images insert Markdown image links, with local image previews available before synchronization.

External GitHub requests have a 30-second timeout. Failed saves stay local and can be retried. GitHub permission/rate-limit errors are shown in the page. Empty new entries are not uploaded automatically. Remembered tokens are validated on startup; expired/revoked tokens that return 401 are removed. Transient network errors keep the saved token for a later visit.

Do not add this directory to discovery feeds or bot knowledge. Markdown previews support GitHub-style tables, task lists, fenced code, headings, and links. Preview HTML is sanitized; external links open in another tab. Pinned parser/converter code is served locally from `vendor/`.

No journal content should be extracted into `data/bot-knowledge.json`.
