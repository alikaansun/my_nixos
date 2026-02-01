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
            drs = "sudo darwin-rebuild switch --flake ~/.dotfiles#$(hostname)";
            ngc = "sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +10 && sudo nix-collect-garbage";
            nixupp = "sudo nix flake update --flake ~/.dotfiles";
            e = if pkgs.stdenv.isDarwin then "open $1" else "nohup dolphin --new-window $1 > /dev/null 2>&1 &";
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

        yazi = {
          enable = true;
          enableBashIntegration = false;
          enableZshIntegration = true;
          extraPackages = with pkgs; [
            glow
            ouch
            fzf
            zoxide
          ];
        };

        kitty = {
          enable = true;
          shellIntegration.enableZshIntegration = true;
          shellIntegration.enableBashIntegration = false;
          font.name = "FiraCode Nerd Font Mono";
          font.package = pkgs.nerd-fonts.fira-code;
          themeFile = "GruvboxMaterialDarkSoft";
          settings = {
            background_opacity = 0.8;
          };
        };

      };

    };
}