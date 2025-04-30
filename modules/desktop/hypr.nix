{ config,lib, pkgs,inputs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;
 #Enabling hyprlnd on NixOS
  programs.hyprland = {
  enable = true;
  # set the flake package
  package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  # make sure to also set the portal package, so that they are in sync
  portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
};

}