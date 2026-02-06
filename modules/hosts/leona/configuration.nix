{
  inputs,
  self,
  config,
  ...
}:
{
  # Define the darwinConfiguration for this host
  flake.darwinConfigurations.leona = inputs.nix-darwin.lib.darwinSystem {
    specialArgs = {
      inherit inputs self;
      vars = self.vars;
    };
    modules = [
      self.darwinModules.hostLeona
      self.darwinModules.kanata
      self.darwinModules.skhd
    ];
  };

  # Define the actual configuration module
  flake.darwinModules.hostLeona =
    { pkgs, config, ... }:
    {
      imports = [
        inputs.nix-homebrew.darwinModules.nix-homebrew
        inputs.home-manager.darwinModules.home-manager
        inputs.sops-nix.darwinModules.sops
      ];
      services.mykanata.enable = true;

      security.pam.services.sudo_local.touchIdAuth = true;

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit inputs self;
          hostname = "leona";
        };
        users = {
          alik = import ./_files/home.nix;
        };
        backupFileExtension = "backup";
      };

      # Define the user so home-manager can get homeDirectory
      users.users.alik = {
        name = "alik";
        home = "/Users/alik";
      };
      # networking.computerName = "leona";
      networking.hostName = "leona";
      networking.wakeOnLan.enable = true;

      # System packages
      nixpkgs.hostPlatform = "aarch64-darwin";
      nixpkgs.config.allowUnfree = true;
      environment.systemPackages = with pkgs; [
        vim
        git
        vscode
        keepassxc
        raycast
        brave
        zotero
        spotify
        github-copilot-cli
        nix-output-monitor
        tldr
        nixd # nix language server
        nil
        nixfmt # nix formatter
        nixfmt-tree # treefmt
        nerd-fonts.fira-code
        age
        sops
        macmon
        klayout
        discord
        fastfetch
        docker-client
      ];
      fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        nerd-fonts.fira-code
      ];
      # Nix settings

      # System configuration
      nix.settings.experimental-features = "nix-command flakes";
      nix.enable = false;

      # macOS System
      system.primaryUser = "alik";
      system.stateVersion = 6;
      system.defaults = {
        controlcenter = {
          BatteryShowPercentage = true;
          Bluetooth = true;
        };
        dock = {
          autohide = true;
          mru-spaces = false;
        };
        finder = {
          AppleShowAllExtensions = true;
          AppleShowAllFiles = true;
          ShowPathbar = true;
          FXPreferredViewStyle = "clmv";
          FXRemoveOldTrashItems = true;
        };
        loginwindow.LoginwindowText = "AliKaanSun";
        screencapture.location = "~/Pictures/screenshots";

        CustomUserPreferences = {
          "com.apple.symbolichotkeys" = {
            AppleSymbolicHotKeys = {
              # "60" = {
              #   # Disable '^ + Space' for selecting the previous input source
              #   enabled = false;
              # };
              # "61" = {
              #   # Disable '^ + Option + Space' for selecting the next input source
              #   enabled = false;
              # };
              # Disable 'Cmd + Space' for Spotlight Search
              "64" = {
                enabled = false;
              };
              # Disable 'Cmd + Alt + Space' for Finder search window
              "65" = {
                # Set to false to disable
                enabled = true;
              };
            };
          };
        };
      };

      # programs.ssh.knownHosts = {

      # Homebrew configuration
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
          #mac spesific stuff
          "aldente"
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

      

      documentation.enable = true;
      documentation.man.enable = true;
      documentation.info.enable = true;

    };#Flake output
}#File output
