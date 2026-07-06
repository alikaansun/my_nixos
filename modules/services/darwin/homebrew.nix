{
  inputs,
  ...
}:
{
  flake.darwinModules.homebrew =
    {
      config,
      ...
    }:
    {
      imports = [
        inputs.nix-homebrew.darwinModules.nix-homebrew
      ];

      # nix-homebrew configuration
      nix-homebrew = {
        enable = true;
        enableRosetta = true;
        user = "alik";

        taps = {
          "homebrew/homebrew-core" = inputs.homebrew-core;
          "homebrew/homebrew-cask" = inputs.homebrew-cask;
        };

        mutableTaps = false;
      };

      homebrew = {
        enable = true;
        taps = builtins.attrNames config.nix-homebrew.taps;
        brews = [
          "clippy"
        ];
        casks = [
          "microsoft-outlook"
          "microsoft-powerpoint"
          "microsoft-excel"
          "microsoft-word"
          "onedrive"
          "nextcloud"
          "whatsapp"
          "claude"
          # "obsidian"
          "zotero"
          "rustdesk"
          "keepassxc"
          "anydesk"
          "steam"
          "blender"
          "vlc"
          "spotify"
          "font-fira-code-nerd-font"
          #mac spesific stuff
          "betterdisplay" # external display
          # "rectangle" # window snap
          "keka" # winrar
          "linearmouse"
          "keyclu"
          "karabiner-elements" # Required for kanata
        ];
        onActivation = {
          cleanup = "uninstall";
          upgrade = true;
          autoUpdate = true;
          extraFlags = [
            "|| true" # ignores failed package updates instead of aborting the whole activation
          ];
        };
        masApps = {
          # "pdfgear" = 6469021132;
          # "eduvpn" = 1317704208;
          # "Xcode"  = 497799835;
        };
      };
    };
}
