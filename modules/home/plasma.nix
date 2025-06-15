{ pkgs,inputs, ... }:
{
  imports = [
  inputs.plasma-manager.homeManagerModules.plasma-manager
  ];
  programs.plasma= { 

    workspace = {  
      theme="breeze-dark";
      wallpaper="~/.dotfiles/modules/desktop/fav.jpg";
    };

  };
}