{ config,lib, pkgs,inputs, ... }:



let
    startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
      ${pkgs.waybar}/bin/waybar &
      ${pkgs.swww}/bin/swww init &
  
      sleep 1
  
      ${pkgs.swww}/bin/swww img ${./wallpaper.png} &
    '';
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    # package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    plugins = [
      # inputs.hyprland-plugins.packages."${pkgs.system}".borders-plus-plus
    ];

    settings = {
      # "plugin:borders-plus-plus" = {
      #   add_borders = 1; # 0 - 9

      #   # you can add up to 9 borders
      #   "col.border_1" = "rgb(ffffff)";
      #   "col.border_2" = "rgb(2222ff)";

      #   # -1 means "default" as in the one defined in general:border_size
      #   border_size_1 = 10;
      #   border_size_2 = -1;

      #   # makes outer edges match rounding of the parent. Turn on / off to better understand. Default = on.
      #   natural_rounding = "yes";
      # };
      # exec-once = "${startupScript}/bin/start";
      # hyprland config
      # hyprland_config = ''
      #   # Hyprland config goes here
      #   # Example:
      #   monitor=HDMI-A-1,1920x1080@60,0,0,1
      #   monitor=DP-1,1920x1080@60,1920,0,1
      #   monitor=DP-2,1920x1080@60,3840,0,1
      # '';
    };
  };

}