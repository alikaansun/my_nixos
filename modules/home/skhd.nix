{
  flake.homeModules.skhd =
    {
      pkgs,
      config,
      ...
    }:
    {
      services.skhd = {
        enable = true;

        skhdConfig = ''
          # Application launcher shortcuts (matching plasma config)
          cmd - return : open -a "kitty"
          cmd - space : open -a "brave"
          ctrl + alt - v : open -a "Visual Studio Code"
          ctrl + alt - d : open -a "Discord"
          ctrl + alt - o : open -a "Obsidian"
          ctrl + alt - k : open -a "KeePassXC"

          # Screenshots
          cmd + shift - s : screencapture -i -c
          cmd + shift - 3 : screencapture -c
          cmd + shift - 4 : screencapture -i ~/Desktop/screenshot_$(date +%Y%m%d_%H%M%S).png

          # Lock screen
          cmd - l : pmset displaysleepnow

          # Mission Control and desktop switching
          ctrl - left : osascript -e 'tell application "System Events" to key code 123 using control down'
          ctrl - right : osascript -e 'tell application "System Events" to key code 124 using control down'
          ctrl - up : osascript -e 'tell application "System Events" to key code 126 using control down'

          # Show desktop
          fn - f11 : osascript -e 'tell application "System Events" to key code 103'

          # Quit application
          cmd - q : osascript -e 'tell application "System Events" to keystroke "q" using command down'
        '';
      };
    };
}
