{ pkgs, ... }:

{
  programs = {
    oh-my-posh = {
      enable = true;
      useTheme = "emodipt-extend";
      enableBashIntegration = true;
    };

  bash = {
    enable = true;
    initExtra = ''
      eval "$(ssh-agent -s)" > /dev/null
      ssh-add -q ~/.ssh/id_ed25519g > /dev/null
      # Enable fzf keybindings
      [ -f ${pkgs.fzf}/share/fzf/key-bindings.bash ] && source ${pkgs.fzf}/share/fzf/key-bindings.bash
      [ -f ${pkgs.fzf}/share/fzf/completion.bash ] && source ${pkgs.fzf}/share/fzf/completion.bash
    '';
    
    shellAliases = {
      cdrepos = "cd ~/Documents/Repos";
      nrs = "sudo nixos-rebuild switch --flake ~/.dotfiles";
      eduvpn = "nohup eduvpn-gui &";
      ngc = "sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +10  
      sudo nix-collect-garbage";
    };
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