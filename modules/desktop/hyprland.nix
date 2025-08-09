{ pkgs,inputs,config, ... }:
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
      
      # Monitor configuration with proper scaling
      monitor = [
        # Adjust these values based on your display
        # Format: name,resolution,position,scale
        # "eDP-1,preferred,auto,1.25"  # 1.25x scaling for most laptops
        # Or for specific monitor:
        "eDP-1,1920x1080,0x0,1.25"
      ];

      # Environment variables for proper scaling
      env = [
        "GDK_SCALE,1.25"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_SCALE_FACTOR,1.25"
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];
      
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
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
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