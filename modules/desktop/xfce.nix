{ config, pkgs, ... }:

{
  
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