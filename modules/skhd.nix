{
  flake.darwinModules.skhd = { pkgs, ... }: {
    
    services.skhd = {
      enable = true;
      skhdConfig = ''
        # # --- Window focus (like kwin Switch Window ...)
        # cmd + alt - left  : yabai -m window --focus west
        # cmd + alt - right : yabai -m window --focus east
        # cmd + alt - up    : yabai -m window --focus north
        # cmd + alt - down  : yabai -m window --focus south

        # # --- Desktop switching (like kwin Switch One Desktop ...)
        # cmd + ctrl - left  : yabai -m space --focus prev
        # cmd + ctrl - right : yabai -m space --focus next
        # cmd + ctrl - up    : yabai -m space --focus prev
        # cmd + ctrl - down  : yabai -m space --focus next

        # # --- Move window to desktop (like kwin Window One Desktop ...)
        # cmd + ctrl + shift - left  : yabai -m window --space prev; yabai -m space --focus prev
        # cmd + ctrl + shift - right : yabai -m window --space next; yabai -m space --focus next
        # cmd + ctrl + shift - up    : yabai -m window --space prev; yabai -m space --focus prev
        # cmd + ctrl + shift - down  : yabai -m window --space next; yabai -m space --focus next

        # # --- Switch to Desktop N (like kwin Switch to Desktop N)
        # ctrl - f1 : yabai -m space --focus 1
        # ctrl - f2 : yabai -m space --focus 2
        # # Add more if you have more spaces

        # --- Application launchers (matching your plasma config)
        cmd - return : open -a "Kitty"
        cmd - space  : open -a "Brave Browser"
        ctrl + alt - v : open -a "Visual Studio Code"
        ctrl + alt - d : open -a "Discord"
        ctrl + alt - o : open -a "Obsidian"
        ctrl + alt - k : open -a "KeePassXC"

        # --- Lock screen
        # cmd - l : pmset displaysleepnow
      '';
    };
  };
}
