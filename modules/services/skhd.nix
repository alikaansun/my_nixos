{
  flake.darwinModules.skhd =
    { pkgs, ... }:
    {

      services.skhd = {
        enable = true;
        skhdConfig = ''
          # --- Application launchers (matching your plasma config)
          cmd - return : open -a "Alacritty"
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
