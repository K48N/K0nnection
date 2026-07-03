Dim fso, scriptDir, psPath
Set fso = CreateObject("Scripting.FileSystemObject")
scriptDir = fso.GetParentFolderName(WScript.ScriptFullName)
psPath = scriptDir & "\KeyboardSync.ps1"
Set fso = Nothing

Set WshShell = CreateObject("WScript.Shell")
' Startet das PowerShell-Skript komplett im Hintergrund
WshShell.Run "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File """ & psPath & """", 0
Set WshShell = Nothing