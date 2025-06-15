{ pkgs,inputs, ... }:
{
  imports = [
  inputs.plasma-manager.homeManagerModules.plasma-manager
  ];
  programs.plasma= { 

    workspace = {  
      theme="breeze-dark";
      wallpaper="/home/alik/.dotfiles/modules/desktop/fav.jpg";
      clickItemTo="select";
      iconTheme="breeze-dark";
      cursor.theme="breeze-light";
    };

    panels = [
      { 
      location= "top";
      alignment="center";
      widgets=[
        "org.kde.plasma.plasma-panel-colorizer"
        "org.kde.plasma.global-menu"
        {
          name="org.kde.plasma.kickoff";
          config= {
            General={
              icon = "nix-snowflake";
            };
          };
        }
        "org.kde.plasma.pager"
        "org.kde.plasma.icontasks"
        "org.kde.plasma.pager"
        "org.kde.plasma.system-tray"
        "org.kde.plasma.digital-clock"

      ];

      }
    ];
  };



}