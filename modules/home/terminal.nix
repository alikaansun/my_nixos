{
  flake.homeModules.terminal =
    {
      pkgs,
      inputs,
      config,
      ...
    }:
    {
      imports = [ ];

      programs = {

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
          '';

          shellAliases = {
            nrs = "sudo nixos-rebuild switch --flake ~/.dotfiles#$(hostname)";
            drs = "ulimit -n 10240 && sudo darwin-rebuild switch --flake ~/.dotfiles#$(hostname)";
            ngc = "sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +10 && sudo nix-collect-garbage";
            # dgc = "sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +10 && sudo nix-collect-garbage -d";
            nixupp = "ulimit -n 10240 && nix flake update --flake $HOME/.dotfiles";
            e = if pkgs.stdenv.isDarwin then "open $1" else "nohup dolphin --new-window $1 > /dev/null 2>&1 &";
            freecad-x11 = "QT_QPA_PLATFORM=xcb freecad";
            rc2nix = "nix run github:nix-community/plasma-manager > ~/.dotfiles/modules/home/plasma.txt";
          };
        };

        tmux = {
          enable = true;
          keyMode = "vi";
          shell = "${pkgs.zsh}/bin/zsh";
          historyLimit = 10000;
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
          tmux = {
            enableShellIntegration = true;
            # shellIntegrationOptions = {
            # "ctrl-t"; # Filesystem search
            # "ctrl-r"; # Command history search
            # "ctrl-i"; # Hostname search
            # };

          };
        };

        yazi = {
          enable = true;
          enableBashIntegration = false;
          shellWrapperName = "y";
          enableZshIntegration = true;
          extraPackages = with pkgs; [
            glow
            ouch
            fzf
            zoxide
            _7zz-rar
          ];
          settings = {
            preview = {
              # image_filter = "lanczos3";
              # image_quality = 90;
              tab_size = 1;
              max_width = 600;
              max_height = 900;
              cache_dir = "";
              ueberzug_scale = 1;
              ueberzug_offset = [
                0
                0
                0
                0
              ];
            };
            yazi = {
              ratio = [
                1
                4
                3
              ];
              sort_by = "natural";
              sort_sensitive = true;
              sort_reverse = false;
              sort_dir_first = true;
              linemode = "none";
              show_hidden = true;
              show_symlink = true;
            };
            opener = {
              edit = [
                {
                  run = "nvim $@";
                  block = true;
                }
              ];
            };
          };
        };

        ghostty = {
          enable = true;
          package = pkgs.ghostty-bin;
          enableZshIntegration = true;
          settings = {
            # Window
            background-opacity = 0.8;
            window-padding-x = 10;
            window-padding-y = 10;
            title = "Ghostty";

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
              "8=32302f" # bright black
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
}
