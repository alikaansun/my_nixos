{ pkgs,inputs, ... }:
{
 
  # home.packages = with pkgs; [
  #   # swww
  #   # grim
  #   # slurp
  #   # waybar
  #   # wl-clipboard
  #   # rofi-wayland
  #   # hyprpolkitagent
  #   # hyprland-qtutils  # needed for banners and ANR messages
  # ];

  
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    systemd = {
      enable = true;
      # uenableXdgAutostart = true;
      # variables = ["--all"];
    };
    xwayland = {
      enable = true;
    };
    
    
    # plugins = [
    #     inputs.hyprland-plugins.packages."${pkgs.system}".hyprbars
    # ];


  };

}