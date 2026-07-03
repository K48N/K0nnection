# Hardware-ID Ihrer Tastatur
$targetId = "VID_03F0&PID_038F"

while($true) {
    # Prüft den Status des Composite Device
    $keyboard = Get-PnpDevice | Where-Object { $_.InstanceId -like "*$targetId*" -and $_.Status -eq "OK" }

    # Aktuelle Sprachliste abrufen
    $currentLanguage = (Get-WinUserLanguageList)[0].LanguageTag

    if ($keyboard) {
        # Wenn Tastatur da und nicht auf US: Wechsel zu US
        if ($currentLanguage -ne "en-US") {
            Set-WinUserLanguageList -LanguageList "en-US", "de-DE" -Force
        }
    } else {
        # Wenn Tastatur weg und nicht auf DE: Wechsel zu DE
        if ($currentLanguage -ne "de-DE") {
            Set-WinUserLanguageList -LanguageList "de-DE", "en-US" -Force
        }
    }
    
    # Intervall von 5 Sekunden zur Schonung der CPU
    Start-Sleep -Seconds 5
}