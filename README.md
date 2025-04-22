# mynixos

This repository contains my personal NixOS configuration files organized in a modular structure. The configuration uses the NixOS module system and home-manager for system and user-level configuration.

## Configuration Structure

```
.
├── configuration.nix          # Main system configuration
├── hardware-configuration.nix # Hardware-specific settings
├── flake.nix                  # Nix flake definition
├── home.nix                   # Home-manager user configuration
│
├── modules/                   # Modular configuration components
│   ├── gaming.nix             # Gaming-related packages and settings
│   ├── localai.nix            # Local AI services (Ollama, OpenWebUI)
│   ├── locale.nix             # Language and timezone settings
│   ├── virtualisation.nix     # VM and virtualization support
│   │
│   └── desktop/               # Desktop environment modules
│       ├── fav.jpg            # Wallpaper/theme image
│       ├── hypr_home.nix      # Hyprland home-manager configs
│       ├── hypr.nix           # Hyprland system configs
│       ├── kde.nix            # KDE Plasma desktop configs
│       └── stylix.nix         # System-wide theming
```

## Features

### Core System
- NVIDIA GPU support with open drivers
- AMD CPU optimization
- Custom filesystem mounts
- Multi-language keyboard layout (US, Persian, Turkish)
- Automatic garbage collection and store optimization

### Desktop Environments
- KDE Plasma 6 (currently active)
- Hyprland Wayland compositor (available but commented out)

### Gaming
- Steam with Proton support
- Lutris and Heroic game launchers
- Wine and Gamemode configuration
- Minecraft (HMCL) and PlayStation 4 emulation (shadps4)

### Development
- VS Code with Nix language support
- Git configuration
- Custom terminal setup with Alacritty and Oh My Posh

### Virtualization
- Libvirt and virt-manager for VM management
- KVM acceleration for AMD CPUs

### Multimedia
- OBS Studio for recording/streaming
- Blender for 3D modeling
- GIMP for image editing
- Video playback with VLC and ffmpeg

## Usage

### Installation

To rebuild and switch to this configuration:

```bash
sudo nixos-rebuild switch --flake ~/.dotfiles
```

Or use the provided alias:

```bash
nrs
```

### System Maintenance

Clean up old generations:

```bash
ngc  # Alias for nix garbage collection
```

## User Configuration

The user environment is configured using Home Manager:

- Shell: Bash with Oh My Posh theme
- Terminal: Alacritty with customized appearance
- Git configuration
- SSH agent auto-start
- Custom aliases for common operations

## Hardware Support

- NVIDIA GPU with proper driver configuration
- AMD CPU with microcode updates
- Multiple storage volumes with custom mount points
- Bluetooth support

## Notes

- System is based on NixOS unstable channel
- State version is set to 24.11
- Most components are modular and can be enabled/disabled by commenting in `configuration.nix`
