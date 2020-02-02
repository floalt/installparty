﻿<#

    Konfigurations-Script für ein neues Benutzerprofil
    wird bei PCs angewandt, die nicht in einer Domäne verwaltet werden

    author: flo.alt@fa-netz.de
    version: 0.6


    Vorlage für neuen Registry-Block:

    $title = ""
    $action = ""
    $key = "HKCU:\"
    $name = ""
    $type = "DWORD"
    $value = 0
    set-registry

#>


# ---------------- Hier werden alle Funktionen definiert ---------------------

# Funktion: Script-Verzeichnis auslesen

    function Get-ScriptDirectory {
        Split-Path -parent $PSCommandPath
    }
    $scriptpath = Get-ScriptDirectory


# Funktion: legt einen Registry Key fest

    function set-registrykey {
        if (!(Test-Path $key)) {
            $yeah = "OK: Registry Key $key erfolgreich angelegt"
            $shit = "FEHLER: Registry Key $key konnte nicht angelegt werden"
            New-Item $key -Force | Out-Null
            errorcheck}
        }


# Funktion: legt einen Registry Wert fest

    function set-registryvalue {
        set-registrykey
        $yeah = "OK: $title wurde erfolgreich $action"
        $shit = "Fehler: $title konnte nicht $action werden"
        Set-ItemProperty -Type $type -Path $key -Name $name -Value $value
        errorcheck
    }


# Funktion: Desktop-Verknüpfung löschen
    
    function del-desktoplink {
        $yeah ="OK: $unwantedlink wurde vom Desktop gelöscht"
        $shit ="FEHLER: $title konnte nicht vom Desktop gelöscht werden"
        if (Test-Path $env:USERPROFILE\Desktop\$unwantedlink.lnk) {
            del $env:USERPROFILE\Desktop\$unwantedlink.lnk
            errorcheck
        }
    }


# Funktion: Fehlercheck

    function errorcheck {
        if ($?) {
            write-host $yeah -F Green
        } else {
            write-host $shit -F Red
            $script:errorcount = $script:errorcount + 1
        }
    }

# ------------------- ENDE Definition der Funktionen --------------------

# ------------------- Hier beginnt der Befehlsablauf --------------------

# Begrüßung

Write-Host "
    ;-) Install-Party ;-) `n
    Konfiguration für neue Benutzerprofile
    " -F Yellow

Write-Host "
    >>>>> Party on, Wayne
            >>>>> Party on, Garth `n
    " -F Green

Start-Sleep 1

$script:errorcount = 0


# Onedrive deinstallieren

    & $env:SystemRoot\SysWOW64\OneDriveSetup.exe /uninstall
    Write-Host "INFO: OneDrive Deinstallation wurde gestartet
        Admin-Rechte bitte im nachfolgendem Fenster bestätigen
        " -F Yellow


# Cortana / Bing Search deaktivieren
    
    $title = "Bing Search"
    $action = "deaktiviert"
    $key = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search"
    $name = "BingSearchEnabled"
    $type = "DWORD"
    $value = 0
    set-registryvalue

    $title = "Cortanta Consent"
    $action = "deaktiviert"
    $key = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search"
    $name = "CortanaConsent"
    $type = "DWORD"
    $value = 0
    set-registryvalue

# Schaltet die Suchleiste in der Taskbar aus:

    $title = "Suchleiste in der Taskbar"
    $action = "deaktiviert"
    $key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
    $name = "SearchboxTaskbarMode"
    $type = "DWORD"
    $value = 0
    set-registryvalue

# Blendet den Arbeitsplatz auf dem Desktop ein:

    $title = "Arbeitsplatz auf dem Desktop"
    $action = "eingeblendet"
    $key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
    $name = "{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
    $type = "DWORD"
    $value = 0
    set-registryvalue

# Desktop-Verknüpfungen löschen

    $unwantedlink = "Microsoft Edge"
    del-desktoplink

# Appdata Defaults

    $7zpath = "C:\Program Files\7-Zip"
    $7zfile = "appdata.7z"
    $appdtadir = $env:APPDATA
    $yeah = "OK: Appdata Default wurden erfolgreich erstellt"
    $shit = "FEHLER: Appdata Defaults konnten nicht erstell werden"

    mkdir C:\tempdir7z | Out-Null
    & $7zpath\7z.exe x  -o"c:\tempdir7z" -y $scriptpath\$7zfile | Out-Null
    Copy-Item C:\tempdir7z\* $appdtadir -Force -Recurse
    errorcheck
    Remove-Item C:\tempdir7z -Recurse -Force


# Script Ende

if ($errorcount -lt 1) {
    write-host "
        Alles erfolgreich abgeschlossen.
          > > Yippie ya yeah Schweinebacke!
        " -F Green
} else {
    write-host "
        Es sind $script:errorcount Fehler aufgetreten...
        ...but it's better to burn out then to fade away
        " -F Red
}