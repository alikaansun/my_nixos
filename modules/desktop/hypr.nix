{ config,lib, pkgs,inputs, ... }:

{
  
  
  services.xserver.displayManager.gdm.enable = true;
  # services.xserver.xkb = {
  #   layout = "us,ir,tr";
  #   variant = "";
  #   # options = "grp:alt_shift_toggle";
  # };
  #Enabling hyprlnd on NixOS
  programs.hyprland = {
  enable = true;
  withUWSM = true;
  # set the flake package
  package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  # make sure to also set the portal package, so that they are in sync
  portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  
  };  

  # xdg.portal = {
  # enable = true;
  # extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  # };

}