{ config, pkgs, ... }:

{

  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,ir,tr";
    variant = "";
    # options = "grp:alt_shift_toggle";
  };
  
  programs.kdeconnect.enable = true;

}