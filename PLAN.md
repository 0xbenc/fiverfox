# Firefox SOCKS Toggle Extension (MV3) — Spec / Plan

## Goal

Provide a Firefox extension with a toolbar icon that opens a small popup panel to quickly switch Firefox proxy settings between:

- **Off**: **No proxy** (equivalent to selecting “No proxy” in Connection Settings).
- **On**: **Manual proxy configuration** using **SOCKS v5** at `localhost:<port>`.

The popup also includes a **DNS** toggle that maps to Firefox’s “Proxy DNS when using SOCKS v5”.

## Target & Constraints

- **Firefox WebExtension**, **Manifest V3 only**.
- Uses the WebExtension proxy API (`browser.proxy.settings.*`), not UI automation of `about:preferences`.
- Always **overwrites** whatever proxy configuration the user currently has when toggling On/Off (no “restore previous settings” behavior).

## Popup UI (when clicking the extension icon)

Controls:

1. **On/Off toggle** (label: `On/Off`)
2. **Port textbox** (numeric)
   - Default: `1080`
   - Valid range: `1–65535`
   - Changes apply **immediately** when On (with a small typing debounce).
3. **DNS toggle** (label: `DNS`)
   - Applies **immediately** when On.

UI feedback:

- If the port is invalid, show an inline error message and do not apply proxy changes.
- If applying proxy settings fails (API error / not controllable), show an inline error message.

## Stored State

Persisted via `browser.storage.local`:

```json
{
  "enabled": false,
  "port": 1080,
  "dns": false
}
```

Initialization behavior:

- On popup open, load stored state.
- Also read `browser.proxy.settings.get({})` and, when the current proxy config is clearly one of:
  - `direct` (no proxy), or
  - the extension’s expected manual SOCKS config (localhost + SOCKS v5),
  the popup may sync its UI to reflect the actual current config (port + DNS).
  Otherwise, the popup uses stored state.

## Proxy Mapping (what the toggles do)

### Off

Set Firefox proxy to **No proxy**:

- `proxyType: "none"`

### On

Set Firefox proxy to **Manual proxy configuration** using **SOCKS v5**:

- `proxyType: "manual"`
- `socks: "localhost"`
- `socksPort: <port>`
- `socksVersion: 5`
- `proxyDNS: <dns>`

To match Firefox’s default Connection Settings behavior, also set:

- `passthrough: "localhost, 127.0.0.1, ::1"`

## Apply Rules (immediate)

- Toggle `On/Off`:
  - `Off` applies `direct` immediately.
  - `On` applies manual SOCKS settings immediately (using the current port + DNS toggle values).
- Port input:
  - Stored when valid.
  - If `enabled === true`, applies immediately (debounced) using the new port.
- DNS toggle:
  - Stored immediately.
  - If `enabled === true`, applies immediately using the new DNS value.

## Permissions

`manifest.json` permissions:

- `proxy`
- `storage`

Popup:

- `action.default_popup` points to the popup HTML.

## Expected File Layout (implementation)

- `manifest.json`
- `popup/popup.html`
- `popup/popup.css`
- `popup/popup.js`
- `icons/` (toolbar icon assets, e.g. `48.png`, `96.png`)

## Manual Verification Checklist

- Open Firefox → Settings → Network Settings → Connection Settings.
- With the extension popup:
  - Toggle **Off** and confirm “No proxy” is selected.
  - Toggle **On** and confirm “Manual proxy configuration” is selected, SOCKS Host `localhost`, SOCKS v5, Port matches the popup port.
  - Toggle **DNS** and confirm the “Proxy DNS when using SOCKS v5” checkbox tracks it.
  - Change the port while On and confirm the SOCKS port updates immediately.

## Non-goals / Out of Scope

- Restoring previous proxy settings when turning Off.
- Supporting HTTP/HTTPS proxy fields, PAC URL, system proxy, or auto-detect modes.
- Per-container/per-site proxy rules.
- Any networking beyond setting Firefox proxy preferences.
