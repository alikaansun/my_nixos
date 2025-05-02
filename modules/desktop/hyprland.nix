{ config,lib, pkgs,inputs, ... }:
{
 
  home.packages = with pkgs; [
    swww
    grim
    slurp
    waybar
    wl-clipboard
    rofi-wayland
    # hyprpolkitagent
    # hyprland-qtutils  # needed for banners and ANR messages
  ];

  
  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      # enableXdgAutostart = true;
      # variables = ["--all"];
    };
    xwayland = {
      enable = true;
    };
    
    # plugins = [
    #     inputs.hyprland-plugins.packages."${pkgs.system}".hyprbars
    # ];

  # home.file."~/.config/hypr/hyprland.conf".text = ''
  #   decoration {
  #     shadow_offset = 0 5
  #     col.shadow = rgba(00000099)
  #   }

  #   $mod = SUPER

  #   bindm = $mod, mouse:272, movewindow
  #   bindm = $mod, mouse:273, resizewindow
  #   bindm = $mod ALT, mouse:272, resizewindow
  # '';
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    # plugins = [
      # inputs.hyprland-plugins.packages."${pkgs.system}".borders-plus-plus
    # ];

  };

}