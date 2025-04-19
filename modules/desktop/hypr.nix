{ config,lib, pkgs,inputs, ... }:

{
#Enabling hyprlnd on NixOS
programs.hyprland = {
  enable = true;
  # nvidiaPatches = true;
  xwayland.enable = true;
  withUWSM = true;
  package = inputs.hyprland.packages."${pkgs.system}".hyprland;
};



# xdg.portal.enable = true;
# xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];


# environment.sessionVariables = {
#   #If your cursor becomes invisible
#   WLR_NO_HARDWARE_CURSORS = "1";
#   # Hint electron apps to use wayland
#   NIXOS_OZONE_WL = "1";
# };

environment.systemPackages = with pkgs; [ 
  waybar
  mako
  alacritty
  rofi-wayland
  #(pkgs.waybar.overrideAttrs (oldAttrs: {
  #  mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
  #})
  #)

];  

hardware = {
    #Graphics (used to be opengl)
    graphics.enable = true;

    #Most wayland compositors need this
    # nvidia.modesetting.enable = true;
};

}