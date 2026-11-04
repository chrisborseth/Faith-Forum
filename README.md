# Faith Forum / Common Thread

An email-style Bible discussion forum for a small men's group. No individual accounts.

## Features
- Any member can create a thread or reply to one
- Each message has a required FROM name
- Anyone with the shared passcode can delete any message or thread
- Conversations are stored centrally in Cloudflare D1
- Responsive desktop email-style sidebar and mobile thread list

## Setup

### 1. Publish GitHub Pages
In this repository, open **Settings → Pages**. Choose **Deploy from a branch**, branch **main**, folder **/docs**, then **Save**.

The website address will be:
https://chrisborseth.github.io/Faith-Forum/

The UI will display, but the passcode and discussions will not function until the backend is configured.

### 2. Deploy the Cloudflare Worker backend
Create a free Cloudflare account and install Node.js on a computer. Download this repository as a ZIP (Code → Download ZIP) and extract it. In a terminal inside the **worker** folder run:

```bash
npx wrangler login
npx wrangler d1 create faith-forum
```

Copy the generated database UUID and replace `REPLACE_WITH_D1_DATABASE_UUID` in `worker/wrangler.toml`.

Then run:

```bash
npx wrangler d1 migrations apply faith-forum --remote
npx wrangler deploy
npx wrangler secret put PASSCODE
npx wrangler secret put SESSION_SECRET
```

Choose a shared passphrase for PASSCODE and a completely different, long random string (at least 32 characters) for SESSION_SECRET. Never put either value in GitHub.

### 3. Link the frontend
Copy the worker URL printed by deployment, such as `https://faith-forum-api.YOUR-NAME.workers.dev`.

Edit **docs/config.js** on GitHub and replace the placeholder URL. GitHub Pages will update after committing.

### 4. Test
Unlock the site with the passcode, create a thread, send a reply on a different browser/device, and test message deletion.

## Security notes
This is a **shared-secret** community, not identity-verified or fully private. Anyone who learns the passcode can read, post under any name, and delete all content. Public GitHub source files must not contain secrets. Password checking and database operations happen only in the Cloudflare Worker.

A hard-to-guess link or an origin check is not a security boundary. The server verifies the passcode/session for all content operations.

Authentication requests have a basic in-memory throttle only; for internet exposure, add Cloudflare rate limiting to the auth endpoint. The forum is best for ordinary discussion, not sensitive confessions or highly confidential information. Export or back up D1 periodically; deletes are permanent at the application level.

Rotating PASSCODE does not revoke existing sessions. Rotate SESSION_SECRET as well to invalidate sessions.

## Development
Frontend: `docs/index.html` and `docs/config.js`.
Backend: `worker/index.js`, `worker/wrangler.toml`, and `worker/migrations/0001_initial.sql`.
