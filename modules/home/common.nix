{ pkgs, inputs, ... }:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ./zed.nix
    ./git.nix
    ./terminal.nix

  ];
  home.username = "alik";
  home.homeDirectory = "/home/alik";
  nixpkgs.config.allowUnfree = true;
  home.enableNixpkgsReleaseCheck = false;
  # Add SOPS configuration for home-manager
  sops.defaultSopsFile = ../../modules/secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/alik/.config/sops/age/keys.txt";

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
  };

  programs.ssh = {
    enable = true;
    # addKeysToAgent = "yes";
    extraConfig = ''
      IdentitiesOnly no
    '';
  };

  home.packages = with pkgs; [
    keepassxc
    thunderbird
    vscode
    github-copilot-cli
    obsidian
    fastfetch
    # inputs.anifetch.packages.${pkgs.system}.default
    vesktop
    spotify
    vlc
    parted
    nextcloud-client
    ffmpeg
    zotero
    tor-browser
    rustdesk
    onlyoffice-desktopeditors
    obs-studio
    foliate # ebook
    klayout
    rsshub
    alarm-clock-applet
  ];

}
