{ config, pkgs, ... }:

{
    # Enable the X11 windowing system.
  services.xserver.enable = true;
  
  services.xserver.desktopManager.xfce.enable = true;
  services.displayManager.defaultSession = "xfce";
  
  services.picom = {
    enable = true;
    fade = true;
    inactiveOpacity = 0.9;
    shadow = true;
    fadeDelta = 4;
  };

}