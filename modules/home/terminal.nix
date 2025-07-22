{ pkgs,inputs,config, ... }:

{
  imports = [ inputs.nvf.homeManagerModules.default ];
  
  programs = {
    nvf = {
      enable = true;
      settings = {
        ##################
        vim = {
          viAlias = false;
          vimAlias = true;
          theme = {
            enable = true;
            name = "gruvbox";
            style = "dark";
          };
          languages={
            
            enableTreesitter = true;
            nix.enable = true;
            bash.enable = true;
            python.enable = true;

          };
          statusline.lualine.enable = true;
          telescope.enable = true;
        };
        ############
      };

    };
    
    oh-my-posh = {
      enable = true;
      useTheme = "emodipt-extend";
      enableBashIntegration = true;
    };

    bash = {
      enable = true;
      initExtra = ''
        # Enable fzf keybindings
        [ -f ${pkgs.fzf}/share/fzf/key-bindings.bash ] && source ${pkgs.fzf}/share/fzf/key-bindings.bash
        [ -f ${pkgs.fzf}/share/fzf/completion.bash ] && source ${pkgs.fzf}/share/fzf/completion.bash

        # Git commit and push function
        gitcp() {
          git add --all
          git commit -m "$1"
          git push
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
        cdrepos = "cd ~/Documents/Repos";
        cdflakes = "cd ~/Documents/Repos/my_nix_flakes";
        nrs = "sudo nixos-rebuild switch --flake ~/.dotfiles#$(hostname)";
        eduvpn = "nohup eduvpn-gui &";
        ngc = "sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +10  
        sudo nix-collect-garbage";
        nixupp = "sudo nix flake update --flake ~/.dotfiles";
        e = "nohup dolphin --new-window . > /dev/null 2>&1 &";
        freecad-x11 = "QT_QPA_PLATFORM=xcb freecad";
        rc2nix = "nix run github:nix-community/plasma-manager > ~/.dotfiles/modules/home/plasma.txt";
        cd = "z";

      };
    };

    bat.enable = true;

    zoxide={
      enable = true;
      enableBashIntegration = true;
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
    };

    alacritty = { 
      enable = true;
      settings = { 
        window = {
          opacity = 0.8;
          padding = { x = 10; y = 10; };
          decorations = "full";
          dynamic_title = true;
        };
        colors = {
          primary = {
            background = "#282c34";
            foreground = "#abb2bf";
          };
        };
        cursor = {
          style = "Beam";
        };
        font = {
          normal = { family = "FiraCode Nerd Font Mono"; style = "Regular"; };
          bold = { family = "FiraCode Nerd Font Mono"; style = "Bold"; };
          italic = { family = "FiraCode Nerd Font Mono"; style = "Italic"; };
          size = 13;
        };
      };
    };

  };

}