{ config,lib, pkgs,inputs, ... }:
{
 
  home.packages = with pkgs; [
    swww
    grim
    slurp
    wl-clipboard
    ydotool
    hyprpolkitagent
    hyprland-qtutils  # needed for banners and ANR messages
  ];

  
  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      enableXdgAutostart = true;
      variables = ["--all"];
    };
    xwayland = {
      enable = true;
    };
    # package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    # plugins = [
      # inputs.hyprland-plugins.packages."${pkgs.system}".borders-plus-plus
    # ];

  };

}