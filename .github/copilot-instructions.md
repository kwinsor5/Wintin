# WinTin++ / Return of the Shadow

This repository represents a local installation of the TinTin++ MUD client for text-based Multi-User Dungeons (MUDs). Its primary target is **Return of the Shadow**, a Lord of the Rings-based MUD.

## Repository Goal

Create and maintain a robust character profile setup, including aliases, triggers, highlights, variables, and scripts.

## Configuration Boundaries

- Keep global aliases, triggers, highlights, variables, and scripts separate from character-specific configuration.
- Global configuration must load for every TinTin++ session.
- Character-specific aliases, triggers, highlights, variables, and scripts must load only after connecting to the game and selecting the active character.
- Prefer reusable global behavior over duplicated per-character definitions.
- Keep character profiles isolated so behavior, state, and automation for one character cannot leak into another.

## Return of the Shadow Connection

TinTin++ should be configured to automatically connect to:

- Server: `rotsmud.org`
- Port: `3791`

Do not store account credentials, passwords, API keys, or other secrets in repository files. Obtain them at runtime from a secure local mechanism or prompt for them when required.

## Maintenance Expectations

- Preserve the global/character-specific loading lifecycle when adding or changing configuration.
- Document the intended character-loading entry point alongside any profile loader changes.
- Keep scripts and configuration readable, modular, and safe to reload during a session where possible.
