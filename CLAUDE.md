# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal NixOS / nix-darwin dotfiles using a flake-parts + import-tree architecture. All `.nix` files under `modules/` are automatically discovered and merged via `import-tree` — no manual registration is needed when adding new modules.

## Key Commands

Apply configuration on NixOS:
```bash
sudo nixos-rebuild switch --flake ~/.dotfiles#$(hostname)
# or via alias:
nrs
```

Apply configuration on macOS (leona):
```bash
ulimit -n 10240 && sudo darwin-rebuild switch --flake ~/.dotfiles#$(hostname)
# or via alias:
drs
```

Update all flake inputs:
```bash
ulimit -n 10240 && nix flake update --flake $HOME/.dotfiles
# or via alias:
nixupp
```

Format Nix files:
```bash
nix fmt
```

Garbage collect (keep last 10 generations):
```bash
sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +10 && sudo nix-collect-garbage
# or via alias:
ngc
```

Capture current KDE Plasma settings as Nix:
```bash
nix run github:nix-community/plasma-manager > ~/.dotfiles/modules/home/plasma.txt
# or via alias:
rc2nix
```

## Architecture

### Module Auto-Discovery

`flake.nix` passes `import-tree ./modules` to flake-parts. Every `.nix` file under `modules/` is automatically imported and merged. Modules export their configuration under `flake.nixosModules.<name>`, `flake.homeModules.<name>`, or `flake.darwinModules.<name>`.

### Hosts

| Host | Platform | Role |
|------|----------|------|
| `arondil` | NixOS x86_64, AMD GPU | Desktop (KDE Plasma) |
| `eldunari` | NixOS x86_64, WSL2 | Windows Subsystem for Linux |
| `leona` | macOS aarch64 (nix-darwin) | MacBook |

Each host lives in `modules/hosts/<name>/configuration.nix` and imports the modules it needs explicitly. Home Manager config lives in `modules/hosts/<name>/_files/home.nix`.

### Module Layout

- `modules/common.nix` — shared NixOS base (sops, pipewire, user `alik`, locale)
- `modules/home/` — Home Manager modules (terminal, nvim, git, KDE plasma, hyprland, zed, yazi)
- `modules/services/` — opt-in service modules (caddy, nextcloud, miniflux, audiobookshelf, paperless, tailscale, hermes-agent, kanata, rustdeskServer)
- `modules/services/darwin/` — macOS-only services (aerospace, homebrew, sketchy)
- `modules/vars.nix` — shared variables (hostnames, IPs, ports) exported as `flake.vars` and passed via `specialArgs`
- `modules/stylix.nix` — system-wide theming (Gruvbox Dark, Fira Code)
- `modules/gc.nix` — automatic weekly garbage collection
- `modules/_files/pythonEnv.nix` — reusable Python environment exposed as a flake package

### Secrets (sops-nix)

Secrets are encrypted in `modules/secrets/secrets.yaml` using age keys for three hosts (desktop/laptop/leona). Key file on each machine: `~/.config/sops/age/keys.txt`. The `.sops.yaml` at the repo root defines which age keys can decrypt which paths.

### Shared Variables Pattern

Service modules receive `vars` via `specialArgs` (set in each host's configuration):
```nix
specialArgs = { inherit inputs self; vars = self.vars; };
```
Use `vars.serviceName.port`, `vars.serviceName.hostName`, etc. rather than hardcoding values.

### Cross-Platform Conditionals

Home Manager modules use `pkgs.stdenv.isLinux` / `pkgs.stdenv.isDarwin` for platform-specific packages and settings. See `modules/home/terminal.nix` for examples.
