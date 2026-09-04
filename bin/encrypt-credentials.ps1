# One-time setup (rerun to change the account or password).
#
# Asks for the RotS account email and password and writes them, gpg
# symmetric-encrypted (AES256, ASCII-armoured), to credentials.asc - two
# lines: account, then password. Nothing is written to disk unencrypted.
# gpg pops up a window asking for a passphrase: that is what wintin.ps1 asks
# for at launch, and what you give to anyone who should be able to log in.

$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

if (-not (Get-Command gpg -ErrorAction SilentlyContinue)) {
    Write-Error 'gpg not found on PATH. Install Gpg4win (https://gpg4win.org) - see README.md.'
    exit 1
}

$account  = Read-Host 'RotS account email'
$password = Read-Host 'RotS password' -AsSecureString
$plain    = [System.Net.NetworkCredential]::new('', $password).Password

if ($plain -match '[{}$"]') {
    Write-Error 'Passwords containing { } $ or " cannot be passed to tintin safely; change the password first.'
    exit 1
}

$credFile = Join-Path $PSScriptRoot 'credentials.asc'
if (Test-Path $credFile) { Remove-Item $credFile }

"$account`n$plain" | & gpg --symmetric --armor --cipher-algo AES256 --output $credFile
if ($LASTEXITCODE -ne 0) {
    Write-Error 'gpg failed; credentials.asc was not written.'
    exit 1
}

Write-Host "Wrote $credFile - commit it. Test with .\wintin.ps1"
