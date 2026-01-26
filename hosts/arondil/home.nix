{ inputs, pkgs, ... }:

{

  imports = [
    # ./modules/desktop/hyprland.nix
    ../../modules/home/common.nix
    ../../modules/home/plasma.nix
    # ../../modules/creative.nix

  ];

  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    # Creative apps
    blender # 3D modeling and animation
    gimp # Image editing
    texliveFull
    onlyoffice-desktopeditors
    tor-browser
    ardour # Audio recording and editing
    # musescore      # Music notation software
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
