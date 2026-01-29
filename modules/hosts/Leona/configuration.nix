{
  inputs,
  self,
  config,
  ...
}:
{
  # Define the darwinConfiguration for this host
  flake.darwinConfigurations.Leona = inputs.nix-darwin.lib.darwinSystem {
    specialArgs = { 
      inherit inputs self;
      vars = self.vars;
    };
    modules = [
      self.darwinModules.hostLeona
    ];
  };

  # Define the actual configuration module
  flake.darwinModules.hostLeona =
    { pkgs, config, ... }:
    {
      imports = [
        inputs.nix-homebrew.darwinModules.nix-homebrew
        inputs.home-manager.darwinModules.home-manager
      ];
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit inputs self;
          hostname = "Leona";
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

      # System packages
      system.primaryUser = "alik";
      environment.systemPackages = with pkgs; [
        vim
        git
        vscode
        keepassxc
        raycast
      ];

      # Nix settings
      nix.settings.experimental-features = "nix-command flakes";
      nixpkgs.config.allowUnfree = true;

      # System configuration
      nix.enable = false;
      system.stateVersion = 6;
      nixpkgs.hostPlatform = "aarch64-darwin";

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
          "chromium"
          "nextcloud"
          "whatsapp"
          "obsidian"
        ];
        onActivation.cleanup = "zap";
      };

      # macOS System Defaults
      system.defaults = {
        dock.autohide = true;
        dock.mru-spaces = false;
        finder.AppleShowAllExtensions = true;
        finder.FXPreferredViewStyle = "clmv";
        loginwindow.LoginwindowText = "AliKaanSun";
        screencapture.location = "~/Pictures/screenshots";
      };
    };
}