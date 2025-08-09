{ pkgs,inputs, ... }:
{
 
  home.packages = with pkgs; [
    swww
    grim
    slurp
    waybar
    wl-clipboard
    rofi-wayland
    hyprpolkitagent
    # hyprland-qtutils  # needed for banners and ANR messages
  ];

  
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      # Essential keybindings
      "$mod" = "SUPER";
      
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