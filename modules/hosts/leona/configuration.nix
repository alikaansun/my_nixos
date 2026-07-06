{
  inputs,
  self,
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
      # self.darwinModules.skhd
      self.darwinModules.aerospace
      # self.darwinModules.sketchy
      # self.darwinModules.hermes
      self.darwinModules.tailscale
    ];
  };

  # Define the actual configuration module
  flake.darwinModules.hostLeona =
    { pkgs, ... }:
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
          vars = self.vars;
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
      # vesktop's build pins pnpm-10.29.2, flagged insecure after a nixpkgs bump.
      # pnpm is a build-time tool here (not shipped in the app), so permit it.
      nixpkgs.config.permittedInsecurePackages = [ "pnpm-10.29.2" ];
      environment.systemPackages = with pkgs; [
        git
        vscode
        uv
        raycast
        brave
        nixd # nix language server
        nil
        nixfmt # nix formatter
        nixfmt-tree # treefmt
        age
        sops
        wireguard-tools
        klayout
        vesktop
        fastfetch
        duti # set default apps for file types
      ];

      # Make VLC the default player for common video formats
      system.activationScripts.setVlcDefault.text =
        let
          vlc = "org.videolan.vlc";
          # UTIs and bare file extensions to associate with VLC
          targets = [
            # Generic video UTIs
            "public.movie"
            "public.video"
            "public.audiovisual-content"
            "public.mpeg-4"
            "com.apple.quicktime-movie"
            # File extensions (duti accepts bare extensions too)
            "mp4"
            "mkv"
            "avi"
            "mov"
            "webm"
            "flv"
            "wmv"
            "m4v"
            "mpg"
            "mpeg"
            "m2ts"
            "ts"
          ];
          lines = builtins.map (t: "/run/current-system/sw/bin/duti -s ${vlc} ${t} all || true") targets;
        in
        ''
          echo "setting VLC as default video player..." >&2
        ''
        + builtins.concatStringsSep "\n" lines;

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
      system.keyboard.enableKeyMapping = true;
      system.keyboard.remapCapsLockToEscape = true;
      system.defaults = {
        controlcenter = {
          BatteryShowPercentage = true;
          Bluetooth = true;
        };
        WindowManager.EnableStandardClickToShowDesktop = false;
        NSGlobalDomain.NSAutomaticWindowAnimationsEnabled = false;
        NSGlobalDomain._HIHideMenuBar = false;
        NSGlobalDomain.NSWindowShouldDragOnGesture = true;

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

      # Skip the Darwin HTML manual: nix-darwin still passes render-docs'
      # removed `--toc-depth`. The uninstaller bundles its own manual-building
      # system, so it must be dropped too.
      documentation.doc.enable = false;
      system.tools.darwin-uninstaller.enable = false;

    }; # Flake output
} # File output
