# fiversox

A tiny Firefox (MV3) extension that toggles Firefox’s proxy between:

- **Off**: no proxy
- **On**: manual **SOCKS v5** proxy at `localhost:<port>` (default `1080`)

Includes an optional **DNS** toggle (“Proxy DNS when using SOCKS v5”).

## What it changes

This extension **directly sets Firefox’s global proxy configuration** via `browser.proxy.settings`.

- Turning **On** overwrites whatever proxy settings you had.
- Turning **Off** sets “No proxy” (it does not restore previous settings).

## Install for development

[Developer notes](docs/dx.md)

## Usage

- Click the extension icon to open the popup.
- Toggle **On/Off**:
  - **Off** → “No proxy”
  - **On** → SOCKS v5 `localhost:<port>`
- Change **Port** then press ✅ to apply (while On).
- Toggle **DNS** (applies immediately while On).
  
## Contributors

- 0xbenc
- basedvik
