{
  pkgs,
  inputs,
  config,
  ...
}:

{
  imports = [ ./nvim.nix ];

  programs = {

    oh-my-posh = {
      enable = true;
      useTheme = "emodipt-extend";
      enableBashIntegration = true;
    };

    bash = {
      enable = true;
      enableCompletion = true;
      initExtra = ''
        # Enable fzf keybindings
        [ -f ${pkgs.fzf}/share/fzf/key-bindings.bash ] && source ${pkgs.fzf}/share/fzf/key-bindings.bash
        [ -f ${pkgs.fzf}/share/fzf/completion.bash ] && source ${pkgs.fzf}/share/fzf/completion.bash

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

        # Add all private keys in ~/.ssh/
        for key in ~/.ssh/id_*; do
          if [[ -f "$key" && ! "$key" =~ \.pub$ ]]; then
            ssh-add "$key" 2>/dev/null
          fi
        done

      '';

      shellAliases = {
        nrs = "sudo nixos-rebuild switch --flake ~/.dotfiles#$(hostname)";
        ngc = "sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +10  
        sudo nix-collect-garbage";
        nixupp = "sudo nix flake update --flake ~/.dotfiles";
        e = "nohup dolphin --new-window . > /dev/null 2>&1 &";
        freecad-x11 = "QT_QPA_PLATFORM=xcb freecad";
        rc2nix = "nix run github:nix-community/plasma-manager > ~/.dotfiles/modules/home/plasma.txt";
        # cd = "z";

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
      enableBashIntegration = true;
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
    };

    yazi = { 
      enable = true; 
      enableBashIntegration = true;
      extraPackages = with pkgs; [
        glow
        ouch
        fzf
        zoxide
    ]

    }; 
    # alacritty = {
    #   enable = true;
    #   settings = {
    #     window = {
    #       opacity = 0.8;
    #       padding = { x = 10; y = 10; };
    #       decorations = "full";
    #       dynamic_title = true;
    #     };
    #     colors = {
    #       primary = {
    #         background = "#282c34";
    #         foreground = "#abb2bf";
    #       };
    #     };
    #     cursor = {
    #       style = "Beam";
    #     };
    #     font = {
    #       normal = { family = "FiraCode Nerd Font Mono"; style = "Regular"; };
    #       bold = { family = "FiraCode Nerd Font Mono"; style = "Bold"; };
    #       italic = { family = "FiraCode Nerd Font Mono"; style = "Italic"; };
    #       size = 13;
    #     };
    #   };
    # };

    kitty = {
      enable = true;
      shellIntegration.enableBashIntegration = true;
      font.name = "FiraCode Nerd Font";
      font.package = pkgs.nerd-fonts.fira-code;
      themeFile = "GruvboxMaterialDarkSoft";
      settings = {
        background_opacity = 0.8;
      };
    };

  };

}
