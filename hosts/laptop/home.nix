{ config, pkgs,
lib ,
programs,inputs, ... }:

{

  imports =
    [
    #  ../../modules/desktop/hyprland.nix
     
      ../../modules/home/common.nix
      ../../modules/home/terminal.nix
      ../../modules/home/git.nix
      # inputs.omarchy-nix.homeManagerModules.default
      # inputs.plasma-manager.homeManagerModules.plasma-manager
      ../../modules/home/plasma.nix
#       ../../modules/creative.nix

    ];

  home.stateVersion = "25.05"; # Please read the comment before changing.
  
  home.packages = with pkgs; [
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
  
  # home.backupFileExtension = "backup";

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".config/kdeglobals".source = ./modules/.config/kdeglobals;
    # ".config/kwinrc".source = ./modules/.config/kwinrc;
    # ".config/kglobalshortcutsrc".source = ./modules/.config/kglobalshortcutsrc;
    # ".config/kwinrulesrc".source = ./modules/.config/kwinrulesrc;
    # ".config/kcminputrc".source = ./modules/.config/kcminputrc;


    # ".config/kcminputrc" = {
    #   source = ./modules/.config/kcminputrc;
    #   force = true;
    # };


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
