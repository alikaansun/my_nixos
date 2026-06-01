{
  flake.homeModules.common =
    {
      pkgs,
      inputs,
      ...
    }:
    {
      imports = [
        inputs.sops-nix.homeManagerModules.sops
      ];

      home.username = "alik";
      home.homeDirectory = "/home/alik";
      home.enableNixpkgsReleaseCheck = false;

      manual.manpages.enable = false;
      manual.html.enable = false;
      manual.json.enable = false;

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
      };

      home.packages = with pkgs; [
        keepassxc
        thunderbird
        vscode
        obsidian
        vesktop
        spotify
        vlc
        nextcloud-client
        zotero
        tor-browser
        # rustdesk
        onlyoffice-desktopeditors
        obs-studio
        foliate
        klayout
        alarm-clock-applet
      ];

    };
}
