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
      self.darwinModules.homebrew
      self.darwinModules.skhd
    ];
  };

  # Define the actual configuration module
  flake.darwinModules.hostLeona =
    { pkgs, config, ... }:
    {
      imports = [
        inputs.home-manager.darwinModules.home-manager
        inputs.sops-nix.darwinModules.sops
      ];
      services.mykanata.enable = false;
      
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
        uv
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
        age
        sops
        macmon
        klayout
        discord
        fastfetch
      ];
      # Nix settings

      # System configuration
      nix.settings.experimental-features = "nix-command flakes";
      nix.enable = false;

      # Launch agents for apps to start at login
      launchd.user.agents.vanilla = {
        serviceConfig = {
          ProgramArguments = [ "/Applications/Vanilla.app/Contents/MacOS/Vanilla" ];
          RunAtLoad = true;
        };
      };

      # macOS System
      system.primaryUser = "alik";
      system.stateVersion = 6;
      system.defaults = {
        controlcenter = {
          BatteryShowPercentage = true;
          Bluetooth = true;
        };
        WindowManager.EnableStandardClickToShowDesktop = false;
        dock = {
          mouse-over-hilite-stack = true;
          autohide = true;
          mru-spaces = false;
        };
        # NSGlobalDomain = {
        #   AppleWindowTabbingMode = "manual";
        #   # Enable focus-follows-mouse (hover to focus)
        #   "com.apple.mouse.focusFollowsMouse" = true;
        # };
        finder = {
          AppleShowAllExtensions = true;
          AppleShowAllFiles = true;
          ShowPathbar = true;
          FXPreferredViewStyle = "clmv";
          FXRemoveOldTrashItems = true;
        };
        loginwindow.LoginwindowText = "AliKaanSun";
        screencapture.location = "/Users/alik/Nextcloud/ScreenShots";

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
    
      # documentation.enable = true;
      # documentation.man.enable = true;
      # documentation.info.enable = true;

    };#Flake output
}#File output
