{ pkgs,inputs,osConfig, ... }:
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
    # waybar
    wl-clipboard
    rofi-wayland
    hyprpolkitagent
    # Additional packages for waybar modules
    pavucontrol      # Volume control GUI
    blueman          # Bluetooth manager
    networkmanager   # Network management
    htop             # System monitor
    powertop         # Power management
    # hyprland-qtutils  # needed for banners and ANR messages
  ];

  # programs.waybar = {
  #   enable = true; 
  #   package = pkgs.waybar;
  #   # settings = {
      
  #   # };
  # };

  home.sessionVariables = {
    # HiDPI scaling
    NIXOS_OZONE_WL = "1";  # Enables native Wayland support
    
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
        "$mod, D, exec, rofi -show drun"
        "$mod, Q, killactive"
        "$mod SHIFT, E, exit"
        "$mod, V, togglefloating"
        "$mod, F, fullscreen"
        # Add workspace switching
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        
        # App launching shortcuts (using mod key instead of ctrl+alt)
        "$mod, T, exec, kitty"                        # Terminal (alternative)
        "$mod, SPACE, exec, zen"                      # Zen browser  
        "$mod, V, exec, code"                         # VSCode
        "$mod, D, exec, vesktop"                      # Discord/Vesktop
        "$mod, O, exec, obsidian"                     # Obsidian
        "$mod, K, exec, keepassxc"                    # KeePassXC
        "$mod, S, exec, steam"                        # Steam
        "$mod, M, exec, thunderbird"                  # Thunderbird
        
        # Screenshot shortcuts
        ", Print, exec, grim -g \"$(slurp)\" ~/Pictures/Screenshots/$(date +'%Y%m%d_%H%M%S').png"
        "$mod SHIFT, S, exec, grim -g \"$(slurp)\" ~/Pictures/Screenshots/$(date +'%Y%m%d_%H%M%S').png"
      ];
      
      # Auto-start essential services
      exec-once = [
        "waybar"
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

      plugin.hyprbars = {
        bar_height = 20;
        # bar_precedence_over_border = true;
        icon_on_hover = true;
      };


    };


    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    systemd = {
      enable = true;
      enableXdgAutostart = true;
      variables = ["--all"];
    };
    xwayland = {
      enable = true;
    };
    
    plugins = [
        inputs.hyprland-plugins.packages."${pkgs.stdenv.hostPlatform.system}".hyprbars
    ];

  };

}