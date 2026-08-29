# Wolf_Fr CMS local bridge

This optional integration runs the exact
[`WolfFr1/DarkOrbit-CMS-Wolf_Fr`](https://github.com/WolfFr1/DarkOrbit-CMS-Wolf_Fr)
PHP website on the local Windows machine while keeping Kalaazu as the game and
account source of truth.

## Boundaries

- The PHP CMS is served by Docker at `http://127.0.0.1:8082`.
- Kalaazu remains at `http://127.0.0.1:8081` and the browser game gateway remains on port `8083`.
- Login and registration are sent to Kalaazu's `/external` API.
- The CMS database contains a compatibility shadow record so the original PHP templates can render.
- The original Flash launch page is replaced by a session handoff to Kalaazu's HTML5 client.
- Home and Start are connected first. Legacy Shop, Equipment and Clan mutations still target the compatibility database and must not be treated as live Kalaazu gameplay features yet.

The upstream CMS repository includes game assets whose redistribution rights may
differ from the PHP code's MIT license. The setup script downloads the upstream
repository directly for local use; Kalaazu does not copy those files into this repository.

## First setup

Start Kalaazu normally, then open a second PowerShell window:

```powershell
cd C:\Users\B1tza\Kalaazu
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\windows\setup-wolf-cms.ps1
```

Open `http://127.0.0.1:8082`, register or log in, and use the original **Start**
button. It redirects to the HTML5 client with the authenticated Kalaazu session.

## Later starts

Docker Desktop normally restarts the CMS containers automatically. To start them
explicitly:

```powershell
.\scripts\windows\run-wolf-cms.ps1
```

Kalaazu itself must also be running:

```powershell
.\scripts\windows\run-local.ps1
```
