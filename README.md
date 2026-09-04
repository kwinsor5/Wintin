# WinTin++ for Return of the Shadow

TinTin++ configuration for [Return of the Shadow](https://rotsmud.org) (`rotsmud.org:3791`),
run on Windows through WinTin++ (TinTin++ + mintty + cygwin).

The repo holds only the scripts. The WinTin++ binaries and the login
credentials are ignored by git and have to be put in place once per machine.

## Layout

    bin/
      main.tin                 entry point: reads global.tin, opens the session
      global.tin               everything shared: layout, HUD, colours, aliases, events
      map.tin, skills.tin, ... feature scripts read by global.tin
      classes/*.tin            class profiles (mage, mystic, ...)
      characters/*.tin         per-character profiles, loaded after login
      rots.map                 the #map database
      mintty.con               terminal settings
      wintin.cmd / wintin.ps1  launcher
      encrypt-credentials.ps1  one-time credential setup

## Setup on Windows from a fresh clone

### 1. Clone

    git clone <repo-url> C:\Repositories\Wintin

Any folder works; the launcher uses its own location. The rest of this file
assumes `C:\Repositories\Wintin`.

### 2. WinTin++ binaries

`.gitignore` excludes `*.exe`, `*.dll` and `*.ico`, so a fresh clone has no
`tt++.exe`. Install WinTin++ and copy its files in:

1. Download the WinTin++ installer (`wintin-<version>.msi`) from
   https://tintin.mudhalla.net/download.php (mirrored on
   [SourceForge](https://sourceforge.net/projects/tintin/files/WinTin++%20Windows%20Installer/)).
   This repo was built against tt++ 2.02.x.
2. Run it. The default install folder is `C:\Program Files (x86)\Wintin`.
3. Copy these from `C:\Program Files (x86)\Wintin\bin` into the repo's `bin\`:

       tt++.exe
       mintty.exe
       cygwin1.dll
       cygwin-console-helper.exe
       tt++.ico

   Do **not** copy the installer's `mintty.con` or any `.tin` files; the repo's
   versions replace them.

The installed copy in Program Files can be uninstalled afterwards; nothing
refers to it.

### 3. gpg (Gpg4win)

The login is stored gpg-encrypted and decrypted at launch, so `gpg` has to be
on the PATH.

1. Download the installer from https://gpg4win.org/download.html (the donation
   page can be skipped with $0).
2. Run it. Only **GnuPG** is required; **Kleopatra** is optional and the rest
   can be unticked. Keep the default install folder.
3. Open a new PowerShell window (PATH is refreshed on open) and check:

       gpg --version

   If it is not found, add `C:\Program Files (x86)\GnuPG\bin` to your PATH
   (Settings > System > About > Advanced system settings > Environment
   Variables) and open a new window.

### 4. Credentials

No account or password lives in any `.tin` file. They are kept in
`bin/credentials.asc`, gpg symmetric-encrypted, which is also gitignored, so
every clone creates its own:

    cd C:\Repositories\Wintin\bin
    .\encrypt-credentials.ps1      # asks for account and password; gpg then asks for a passphrase

The passphrase is what you will type at every launch (gpg-agent caches it for
a while). Passwords containing `{ } $ "` are rejected because they cannot be
passed to tintin safely; change the password first.

Rerun the script to change the account or password.

### 5. Shortcut

Create a shortcut (right-click the desktop > New > Shortcut) with:

- Target: `C:\Repositories\Wintin\bin\wintin.cmd`
- Start in: `C:\Repositories\Wintin\bin`
- Icon: `C:\Repositories\Wintin\bin\tt++.ico`

`wintin.cmd` runs `wintin.ps1` with `-ExecutionPolicy Bypass`, so no
execution-policy change is needed. Double-clicking `wintin.cmd` directly also
works.

### 6. First run

Launch the shortcut. A gpg passphrase window appears, then mintty opens
maximised and tt++ connects and logs in. If the window closes immediately,
run `bin\wintin.cmd` from a PowerShell window to see the error; the launcher
reports a missing `gpg`, a missing `credentials.asc`, or a wrong passphrase.

## How the launcher works

`bin/wintin.ps1` runs `gpg --decrypt` on `credentials.asc`, puts the two lines
in the `ROTS_ACCOUNT` / `ROTS_PASSWORD` environment variables, and starts
tt++ with `-e "#variable {rots_account} ..."` and
`-e "#variable {rots_password} ..."` before `-r main.tin`, so `global.tin`'s
SESSION CONNECTED event can `#send` them. tintin cannot read environment
variables itself and this cygwin install has no `/bin/sh` for `#script`, which
is why the values go in through `-e`.

If `ROTS_ACCOUNT` and `ROTS_PASSWORD` are already set in the environment,
decryption is skipped.

Sharing the repo: the other person follows the steps above and creates their
own `credentials.asc`. Nothing in the repo lets anyone log in.
