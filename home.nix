{ config, pkgs, 
lib , 
programs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "alik";
  home.homeDirectory = "/home/alik";
  nixpkgs.config.allowUnfree = true;
  home.enableNixpkgsReleaseCheck=false;
  
  imports =
    [
      # ./modules/desktop/hyprland.nix
      ./modules/terminal.nix
      ./modules/git.nix
    ];
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.
  
  home.packages = with pkgs; [
    keepassxc
    trezor-suite
    thunderbird
    vscode
    obsidian
    fastfetch
    klayout
    discord
    vlc
    parted
    nextcloud-client
    tor-browser
    libreoffice-qt6
    ffmpeg
    zotero
    obs-studio
    spotify
    gimp 
    foliate #ebook
    blender
    ardour #sound recording
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
  # Add more as needed
    
    
    
    # Add more as needed
    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    # recursive=true;
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
