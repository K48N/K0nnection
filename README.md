# K0nnection

An invisible Windows utility that switches your keyboard language layout automatically when an external keyboard is connected or disconnected.

## What it is

A PowerShell script, launched through a VBScript wrapper, that polls connected PnP devices every 5 seconds for a specific keyboard's hardware VID/PID. When that keyboard is present, the system's primary input language switches to `en-US`; when it is gone, it reverts to `de-DE`. No tray icon, no installer, no compiled binary.

## Please Note

This is a personal fix for a narrow annoyance: switching between a laptop's built-in layout and an external keyboard with a different layout, every time either one gets connected. Input-switching utilities that do more already exist, but they come with tray icons, settings screens, and background services for a problem that a short polling loop already solves.

## How it works

- `K0nnection.vbs` launches `KeyboardSync.ps1` in a hidden window so no console ever flashes on screen
- The script polls `Get-PnpDevice` every 5 seconds for a hardware ID matching `VID_xxxx&PID_xxxx`
- If that device is present with status `OK`, `Set-WinUserLanguageList` sets the language order to `en-US, de-DE`
- If the device is absent, the order reverts to `de-DE, en-US`

## Why it's built this way

- `Get-PnpDevice` and `Set-WinUserLanguageList` are both built into Windows, so there is nothing here that needs a third-party dependency or a compiled executable
- The VBScript wrapper exists purely to hide the PowerShell console window; the actual logic all lives in one script
- Polling every 5 seconds is deliberately simple: no event hooks, no driver-level hardware notifications, just a loop cheap enough to run indefinitely in the background

## Shortcomings

- Polling on a 5-second interval means the layout switch is not instant
- The hardware ID is hardcoded per machine; a new keyboard means re-extracting and updating `$targetId`
- No packaging or installer; running at login requires manually adding a Task Scheduler entry or a Startup folder shortcut

## Usage

Set your keyboard's hardware ID in `KeyboardSync.ps1`:

```powershell
$targetId = "VID_03F0&PID_038F"
```

Find it with:

```powershell
Get-PnpDevice | Where-Object { $_.InstanceId -match 'VID_.*&PID_' } | Select-Object FriendlyName, InstanceId, Status
```

Then launch:

```cmd
wscript K0nnection.vbs
```

Add a shortcut to `K0nnection.vbs` in `shell:startup`, or create a Task Scheduler entry at user logon, to run it automatically.

## License

MIT
