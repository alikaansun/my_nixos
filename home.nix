{ config, pkgs, 
lib , 
programs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "alik";
  home.homeDirectory = "/home/alik";


  # imports =
  #   [
  #     ./modules/desktop/hypr_home.nix
  #   ];
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.
  
  programs.oh-my-posh.enable = true;
  programs.oh-my-posh.useTheme = "emodipt-extend";
  programs.oh-my-posh.enableBashIntegration = true;

  programs.bash = {
    enable = true;
    initExtra = ''
      eval "$(ssh-agent -s)" > /dev/null
      ssh-add -q ~/.ssh/id_ed25519g > /dev/null
    '';
    shellAliases = {
      cdrepos = "cd ~/Documents/Repos";
      nrs = "sudo nixos-rebuild switch --flake ~/.dotfiles";
      eduvpn = "nohup eduvpn-gui &";
      ngc = "sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +10  
      sudo nix-collect-garbage";
      # You can add more aliases here
    };
  };

  programs.git = {
  enable= true;
  userName= "alik";
  userEmail = "asunnetcoglu@gmail.com";
  extraConfig = {
    init.defaultBranch = "main";
    pull.rebase = "true";
    # safe.directory="/etc/nixos";
    };
  };

  programs.alacritty = { 
    enable= true;
    settings= { 
      window = {
      opacity = 0.8;
      padding = {
        x = 10;
        y = 10;
      };
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
      # blinking = "On";
    };
    };
  };
  # home.programs = {
  #   oh-my-posh.enable = true;
  #   oh-my-posh.useTheme = "emodipt-extend";

  #   # # This enables the 'hello' program. You can run it with 'hello'.
  #   # hello.enable = true;

  #   # # This enables the 'git' program. You can run it with 'git'.
  #   # git.enable = true;

  #   # # This enables the 'emacs' program. You can run it with 'emacs'.
  #   # emacs.enable = true;
  # };



  # The home.packages option allows you to install Nix packages into your
  # environment.

  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    plasma-panel-colorizer

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
  #virt-manager with wayland requires a gdk cursor to be set
  #In order to run on Wayland, virt-manager must be ran under XWayland with `$ GDK_BACKEND=x11 virt-manager` or a gdk cursor must be set. 
  #An example of setting a gdk cursor with home-manager is as follows: 
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
  };
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/alik/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
