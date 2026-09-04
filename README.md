# WinTin++ for Return of the Shadow

## Credentials

No account or password lives in any `.tin` file. They are kept in
`bin/credentials.asc`, gpg symmetric-encrypted, and decrypted at launch.

### Installing gpg (Gpg4win)

1. Download the installer from https://gpg4win.org/download.html (the donation
   page can be skipped with $0).
2. Run it. Only **GnuPG** is required; **Kleopatra** is optional and the rest
   can be unticked. Keep the default install folder.
3. Open a new PowerShell window (PATH is refreshed on open) and check:

       gpg --version

   If it is not found, add `C:\Program Files (x86)\GnuPG\bin` to your PATH
   (Settings > System > About > Advanced system settings > Environment
   Variables) and open a new window.

### Setting up the login

    cd C:\Repositories\Wintin\bin
    .\encrypt-credentials.ps1      # asks for account and password; gpg then asks for a passphrase

Commit `bin/credentials.asc`.

### Running

Point the WinTin++ shortcut at `bin\wintin.cmd`. The launcher (`bin/wintin.ps1`)
runs `gpg --decrypt` (a passphrase window appears; gpg-agent caches it), puts
the two lines in the `ROTS_ACCOUNT` / `ROTS_PASSWORD` environment variables,
and starts tt++ with `-e "#variable {rots_account} ..."` and
`-e "#variable {rots_password} ..."` before `main.tin`, so `global.tin`'s
SESSION CONNECTED event can `#send` them. If those two environment variables
are already set, decryption is skipped.

Sharing the repo: give the other person the passphrase out of band. Anyone
without it gets a clone that starts but cannot log in.
