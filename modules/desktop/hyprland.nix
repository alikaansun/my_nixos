{
  pkgs,
  inputs,
  osConfig,
  ...
}:
let
  hostname = osConfig.networking.hostName;

  monitorConfigs = {
    desktop = [
      "DP-1,2560x1440@144,0x0,1.25"
      "HDMI-A-1,1920x1080@60,2560x0,1"
    ];
    laptop = [
      "eDP-1,1920x1080,0x0,1"
    ];
    default = [
      ",preferred,auto,1"
    ];
  };

  envConfigs = {
    laptop = [
      "GDK_SCALE,1"
      "QT_AUTO_SCREEN_SCALE_FACTOR,1"
      "QT_SCALE_FACTOR,1"
      "XCURSOR_SIZE,24"
      "HYPRCURSOR_SIZE,24"
    ];
    desktop = [
      "GDK_SCALE,1"
      "QT_AUTO_SCREEN_SCALE_FACTOR,1"
      "QT_SCALE_FACTOR,1"
      "XCURSOR_SIZE,24"
      "HYPRCURSOR_SIZE,24"
    ];
  };
in
{

  home.packages = with pkgs; [
    swww
    grim
    slurp
    kdePackages.dolphin
    # hyprpanel
    waybar
    wl-clipboard
    rofi-wayland
    hyprpolkitagent
    hyprshot
    # Additional packages for waybar modules
    # pavucontrol      # Volume control GUI
    # blueman          # Bluetooth manager
    # networkmanager
    # htop             # System monitor
    # powertop         # Power management
    # hyprland-qtutils  # needed for banners and ANR messages
  ];

  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
  };

  home.sessionVariables = {
    # HiDPI scaling
    NIXOS_OZONE_WL = "1"; # Enables native Wayland support

    # Wayland-specific
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  # Configure Qt scaling
  qt = {
    enable = true;
    # platformTheme.name = "adwaita";
    # style.name = "adwaita-dark";
  };

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      # Essential keybindings
      "$mod" = "SUPER";

      # Monitor configuration with hostname-dependent logic
      monitor = monitorConfigs.${hostname} or monitorConfigs.default;

      # You can also make environment variables hostname-dependent
      env = envConfigs.${hostname} or envConfigs.desktop;

      bind = [
        "$mod, Return, exec, kitty"
        "$mod, R, exec, rofi -show drun"
        "$mod, Q, killactive"
        "$mod SHIFT, E, exit"
        "$mod, T, togglefloating" # Terminal (alternative)
        "$mod, F, fullscreen"
        # Add workspace switching
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"

        # App launching shortcuts (using mod key instead of ctrl+alt)
        "$mod, SPACE, exec, zen" # Zen browser
        "$mod, V, exec, code" # VSCode
        "$mod, E, exec, dolphin" # VSCode
        "$mod, D, exec, vesktop" # Discord/Vesktop
        "$mod, O, exec, obsidian" # Obsidian
        "$mod, K, exec, keepassxc" # KeePassXC
        "$mod, S, exec, steam" # Steam
        "$mod, M, exec, thunderbird" # Thunderbird
        ", PRINT, exec, hyprshot"

        # Screenshot shortcuts
        ", Print, exec, grim -g \"$(slurp)\" ~/Pictures/Screenshots/$(date +'%Y%m%d_%H%M%S').png"
        "$mod SHIFT, S, exec, grim -g \"$(slurp)\" ~/Pictures/Screenshots/$(date +'%Y%m%d_%H%M%S').png"

        # Move active window to different workspace and follow
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"

        # Move window to workspace and does not follow it
        "$mod CTRL, 1, movetoworkspacesilent, 1"
        "$mod CTRL, 2, movetoworkspacesilent, 2"
        "$mod CTRL, 3, movetoworkspacesilent, 3"
        "$mod CTRL, 4, movetoworkspacesilent, 4"
        "$mod CTRL, 5, movetoworkspacesilent, 5"

        # Move windows around in current workspace
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, L, movewindow, r"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, J, movewindow, d"

        # Create new workspace and move window there
        "$mod SHIFT, N, movetoworkspace, special"
        "$mod, N, togglespecialworkspace"
      ];

      # Mouse binds for dragging and resizing windows
      bindm = [
        "$mod, mouse:272, movewindow" # Super + Left click to drag/move window
        "$mod, mouse:273, resizewindow" # Super + Right click to resize window
      ];

      # Optional: Mouse click binds (click without drag)
      bindc = [
        "$mod, mouse:273, togglefloating" # Super + Right click to toggle floating
      ];

      # Configure drag threshold for distinguishing clicks from drags
      binds = {
        drag_threshold = 10; # pixels to distinguish between click and drag
      };

      # Auto-start essential services
      exec-once = [
        "hyprpanel"
        "swww-daemon"
        "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent"
      ];

      # Basic appearance
      general = {
        gaps_in = 2;
        gaps_out = 4;
        border_size = 1;
        layout = "dwindle";
        resize_on_border = "true";
      };

      decoration = {
        inactive_opacity = 0.8;
        rounding = 4;
        rounding_power = 4;
      };

      # touchpad gestures
      gestures = {
        workspace_swipe = true;
        workspace_swipe_forever = true;
      };

      animation = [
        "border, 1, 2, default"
        "fade, 1, 4, default"
        "windows, 1, 3, default, popin 80%"
        "workspaces, 1, 2, default, slide"
      ];

    };

    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    systemd = {
      enable = true;
      enableXdgAutostart = true;
      variables = [ "--all" ];
    };
    xwayland = {
      enable = true;
    };

    # plugins = [
    #     inputs.hyprland-plugins.packages."${pkgs.stdenv.hostPlatform.system}".hy
    # ];

  };

}
# programs.hyprpanel = {
#   # package=pkgs.hyprpanel;
#   # Configure and theme almost all options from the GUI.
#   # See 'https://hyprpanel.com/configuration/settings.html'.
#   settings = {

#     # Configure bar layouts for monitors.
#     # See 'https://hyprpanel.com/configuration/panel.html'.
#     layout = {
#       bar.layouts = {
#         "0" = {
#           left = [ "dashboard" "workspaces" ];
#           middle = [ "media" ];
#           right = [ "volume" "systray" "notifications"  "power"];
#         };
#       };
#     };

#     bar.launcher.autoDetectIcon = true;
#     bar.workspaces.show_icons = true;

#     menus.clock = {
#       time = {
#         military = true;
#         hideSeconds = true;
#       };
#       weather.unit = "metric";
#     };

#     menus.dashboard.directories.enabled = false;
#     # menus.dashboard.stats.enable_gpu = true;

#     theme.bar.transparent = true;
#     theme.font = {
#       name = "Fira Code Mono Nerd Font";
#       size = "14px";
#     };
#   };
# };
