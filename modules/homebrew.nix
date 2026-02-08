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
        casks = [
          "microsoft-teams"
          "microsoft-outlook"
          "microsoft-onenote"
          "microsoft-powerpoint"
          "microsoft-excel"
          "microsoft-word"
          "onedrive"
          "nextcloud"
          "whatsapp"
          "obsidian"
          "rustdesk"
          "keepassxc"
          "docker-desktop"
          "trezor-suite"
          "steam"
          "font-fira-code-nerd-font"
          #mac spesific stuff
          # "aldente"
          "betterdisplay" # external display
          "rectangle" # window snap
          "keka" # winrar
          "linearmouse"
          "keyclu" # command to see shortcuts
          "vanilla" # hide menubar icons
          "yoink"
          "karabiner-elements" # Required for kanata
        ];
        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        masApps = {
          # "eduvpn" = 1317704208;
          # "Xcode"  = 497799835;
        };
      };
    };
}
