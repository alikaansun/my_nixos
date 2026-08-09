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
        home.sessionVariables = {
          EDITOR = "nvim";
          VISUAL = "nvim";
        };
        home.packages =
          with pkgs;
          [
            btop
            github-cli
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
                local target="''${1:-.}"
                ${if pkgs.stdenv.isDarwin then "open" else "xdg-open"} "$target"
              }
            '';

            shellAliases = {
              nrs = "sudo nixos-rebuild switch --flake ~/.dotfiles#$(hostname)";
              drs = "ulimit -n 10240 && sudo darwin-rebuild switch --flake ~/.dotfiles#$(hostname)";
              ngc = "sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +3 && sudo nix-collect-garbage";
              nixupp = "ulimit -n 10240 && nix flake update --flake $HOME/.dotfiles";
              # `e` opens Finder (darwin) or xdg-open/Dolphin (linux) — defined as a shell function in zsh.initContent above
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
              background-opacity = 0.9;
              window-padding-x = 10;
              window-padding-y = 10;
              # title = "Ghostty";

              # Font
             font-family = if pkgs.stdenv.isDarwin then "Menlo" else "MesloLGM Nerd Font Mono";
              font-size = if pkgs.stdenv.isDarwin then 13 else 10;

              # Cursor
              cursor-style = "bar";
              cursor-style-blink = true;

              # Colors (Kanagawa Wave)
              background = "1f1f28";
              foreground = "dcd7ba";

              palette = [
                # Normal
                "0=090618" # black
                "1=c34043" # red
                "2=76946a" # green
                "3=c0a36e" # yellow
                "4=7e9cd8" # blue
                "5=957fb8" # magenta
                "6=6a9589" # cyan
                "7=c8c093" # white
                # Bright
                "8=727169" # bright black
                "9=e82424" # bright red
                "10=98bb6c" # bright green
                "11=e6c384" # bright yellow
                "12=7fb4ca" # bright blue
                "13=938aa9" # bright magenta
                "14=7aa89f" # bright cyan
                "15=dcd7ba" # bright white
              ];

              cursor-color = "c8c093";
              cursor-text = "1f1f28";
              adjust-cursor-thickness = 1;
              selection-background = "2d4f67";
              selection-foreground = "dcd7ba";

              keybind = [
                "ctrl+g=text:lazygit\\n"
              ];

            };
          };
        };
      };
  };
}
