{inputs,  pkgs,  ... }:

{

  imports =
    [
      # ./modules/desktop/hyprland.nix
      ../../modules/home/common.nix
      ../../modules/home/terminal.nix
      ../../modules/home/git.nix
      ../../modules/home/plasma.nix
      ../../modules/creative.nix

    ];

  home.stateVersion = "24.11"; # Please read the comment before changing.
  
  home.packages = with pkgs; [
    keepassxc
    trezor-suite
    thunderbird
    vscode
    obsidian
    fastfetch
    klayout
    vesktop
    vlc
    parted
    nextcloud-client
    tor-browser
    libreoffice-qt6
    ffmpeg
    zotero
    obs-studio
    spotify 
    spicetify-cli
    foliate #ebook
    rustdesk

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

  # programs.ssh = {
  #   enable = true;
  #   matchBlocks = {
  #     "github.com" = {
  #       hostname = "github.com";
  #       user = "git";
  #       identityFile = "~/.ssh/id_ed25519";
  #       identitiesOnly = true;
  #     };
  #   };
  # };
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
