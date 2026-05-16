{
  flake = {
    homeModules.terminal =
      {
        pkgs,
        self,
        ...
      }:
      {
        imports = [ self.homeModules.yazi ];
        home.packages =
          with pkgs;
          [
            btop
            github-copilot-cli
            fastfetch
            ffmpeg
            wget
            nvd
            nix-output-monitor
            tldr
            unrar
            xclip
            xsel
          ]
          ++ (pkgs.lib.optionals pkgs.stdenv.isLinux [
            parted
            lm_sensors
            pciutils
            exfatprogs
            impala
            nvtopPackages.full
            wl-clipboard
          ])
          ++ (pkgs.lib.optionals pkgs.stdenv.isDarwin [
            macmon
          ]);

        programs = {
          bluetuith.enable = if pkgs.stdenv.isLinux then true else false;

          oh-my-posh = {
            enable = true;
            useTheme = "emodipt-extend";
            enableBashIntegration = false;
            enableZshIntegration = true;
          };

          zsh = {
            enable = true;
            enableCompletion = true;
            autosuggestion.enable = true;
            syntaxHighlighting.enable = true;

            oh-my-zsh = {
              enable = true;
              theme = ""; # Disable oh-my-zsh theme so oh-my-posh can handle the prompt
              plugins = [
                "git" # Git aliases (gst, gco, gp, etc.)
                "python"
                "sudo" # Press ESC twice to add sudo
                "history" # History search shortcuts
                "dirhistory" # Alt+Left/Right to navigate dirs
              ];
            };

            initContent = ''
              # Enable fzf keybindings
              [ -f ${pkgs.fzf}/share/fzf/key-bindings.zsh ] && source ${pkgs.fzf}/share/fzf/key-bindings.zsh
              [ -f ${pkgs.fzf}/share/fzf/completion.zsh ] && source ${pkgs.fzf}/share/fzf/completion.zsh

              # Git commit and push function
              gitacp() {
                git add --all
                git commit -m "$1"
                git push
              }

              gitac() {
                git add --all
                git commit -m "$1"
              }

              gita() {
                git add --all
              }

              nixdev() {
                nix develop ~/Documents/Repos/my_nix_flakes/$1
              }

              # Auto-add all SSH keys
              if [ -z "$SSH_AUTH_SOCK" ]; then
                eval $(ssh-agent -s) > /dev/null 2>&1
              fi

              for key in ~/.ssh/id_*; do
                if [[ -f "$key" && ! "$key" =~ \.pub$ ]]; then
                  ssh-add "$key" 2>/dev/null
                fi
              done

              e() {
                local target="''${1:-$HOME/input}"
                ${pkgs.yazi}/bin/yazi "$target"
              }
            '';

            shellAliases = {
              nrs = "sudo nixos-rebuild switch --flake ~/.dotfiles#$(hostname)";
              drs = "ulimit -n 10240 && sudo darwin-rebuild switch --flake ~/.dotfiles#$(hostname)";
              ngc = "sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +10 && sudo nix-collect-garbage";
              nixupp = "ulimit -n 10240 && nix flake update --flake $HOME/.dotfiles";
              # `e` implemented as a shell function in `zsh.initContent` above
              freecad-x11 = "QT_QPA_PLATFORM=xcb freecad";
              rc2nix = "nix run github:nix-community/plasma-manager > ~/.dotfiles/modules/home/plasma.txt";
            };
          };

          bat = {
            enable = true;
            themes = {
              dracula = {
                src = pkgs.fetchFromGitHub {
                  owner = "dracula";
                  repo = "sublime"; # Bat uses sublime syntax for its themes
                  rev = "26c57ec282abcaa76e57e055f38432bd827ac34e";
                  sha256 = "019hfl4zbn4vm4154hh3bwk6hm7bdxbr1hdww83nabxwjn99ndhv";
                };
                file = "Dracula.tmTheme";
              };
            };
          };

          zoxide = {
            enable = true;
            enableBashIntegration = false;
            enableZshIntegration = true;
          };

          fzf = {
            enable = true;
            enableBashIntegration = false;
            enableZshIntegration = true;
          };

          ghostty = {
            enable = true;
            package = if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
            enableZshIntegration = true;
            settings = {
              # Window
              background-opacity = 0.8;
              window-padding-x = 10;
              window-padding-y = 10;
              # title = "Ghostty";

              # Font
              font-family = "FiraCode Nerd Font Mono";
              font-size = if pkgs.stdenv.isDarwin then 13 else 10;

              # Cursor
              cursor-style = "bar";

              # Colors (Gruvbox Material Dark)
              background = "32302f";
              foreground = "d4be98";

              palette = [
                # Normal
                "0=282828" # black
                "1=ea6962" # red
                "2=a9b665" # green
                "3=d8a657" # yellow
                "4=7daea3" # blue
                "5=d3869b" # magenta
                "6=89b482" # cyan
                "7=d4be98" # white
                # Bright
                "8=7c6f64" # bright black
                "9=ea6962" # bright red
                "10=a9b665" # bright green
                "11=d8a657" # bright yellow
                "12=7daea3" # bright blue
                "13=d3869b" # bright magenta
                "14=89b482" # bright cyan
                "15=d4be98" # bright white
              ];

              cursor-color = "d4be98";
              cursor-text = "32302f";
              selection-background = "d4be98";
              selection-foreground = "32302f";

            };
          };
        };
      };
  };
}
