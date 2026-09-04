# WinTin++ launcher.
#
# Decrypts credentials.asc with gpg into the ROTS_ACCOUNT / ROTS_PASSWORD
# environment variables, then starts mintty/tt++ exactly as the old shortcut
# did, handing the two values to tintin as $rots_account / $rots_password.
# global.tin's SESSION CONNECTED event sends them at the login prompts.
#
# tintin cannot read environment variables itself and this install has no
# /bin/sh for #script, so the values go in through tt++'s -e option, which
# runs before -r main.tin.
#
# If ROTS_ACCOUNT and ROTS_PASSWORD are already set in the environment the
# decryption is skipped. Create or change credentials.asc with
# encrypt-credentials.ps1.

$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

if (-not ($env:ROTS_ACCOUNT -and $env:ROTS_PASSWORD)) {
    $credFile = Join-Path $PSScriptRoot 'credentials.asc'

    if (-not (Get-Command gpg -ErrorAction SilentlyContinue)) {
        Write-Error 'gpg not found on PATH. Install Gpg4win (https://gpg4win.org) - see README.md.'
        exit 1
    }
    if (-not (Test-Path $credFile)) {
        Write-Error "$credFile not found. Run encrypt-credentials.ps1 first."
        exit 1
    }

    # gpg asks for the passphrase through pinentry; gpg-agent caches it.
    $lines = @(& gpg --quiet --decrypt $credFile)
    if ($LASTEXITCODE -ne 0 -or $lines.Count -lt 2) {
        Write-Error 'Could not decrypt credentials.asc (wrong passphrase, or the file does not hold two lines).'
        exit 1
    }

    $env:ROTS_ACCOUNT  = $lines[0].Trim()
    $env:ROTS_PASSWORD = $lines[1].Trim()
}

& .\mintty.exe -c mintty.con --configdir $PSScriptRoot -i tt++.ico -t 'WinTin++' `
    -e ././tt++.exe `
        -e "#variable {rots_account} {$env:ROTS_ACCOUNT}" `
        -e "#variable {rots_password} {$env:ROTS_PASSWORD}" `
        -r main.tin
