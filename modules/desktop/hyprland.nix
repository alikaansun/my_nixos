{ pkgs,inputs,osConfig, ... }:
let
  hostname = osConfig.networking.hostName;
  
  monitorConfigs = {
    desktop = [
      "DP-1,2560x1440@144,0x0,1"
      "HDMI-A-1,1920x1080@60,2560x0,1"
    ];
    laptop = [
      "eDP-1,1920x1080,0x0,1.25"
    ];
    default = [
      ",preferred,auto,1"
    ];
  };

  envConfigs = {
    laptop = [
      "GDK_SCALE,1.25"
      "QT_AUTO_SCREEN_SCALE_FACTOR,1"
      "QT_SCALE_FACTOR,1.25"
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
    waybar
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

  programs.waybar = {
    enable = true; 
    package = pkgs.waybar;
    # settings = {
      
    # };
  };

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
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
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
      };
      
      decoration = {
        rounding = 10;
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
    
    # plugins = [
    #     inputs.hyprland-plugins.packages."${pkgs.system}".hyprbars
    # ];

  };

}