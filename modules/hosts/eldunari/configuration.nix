{
  inputs,
  self,
  config,
  ...
}:
{
  # Define the nixosConfiguration for this host
  flake.nixosConfigurations.eldunari = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs self;
      vars = self.vars;
    };

    modules = [
      self.nixosModules.hostEldunari
    ];
  };

  # Define the actual configuration module
  flake.nixosModules.hostEldunari =
    {
      config,
      lib,
      pkgs,
      inputs,
      ...
    }:
    {
      imports = [
        #
        #<nixos-wsl/modules> #before the flake input
        inputs.nixos-wsl.nixosModules.default
        inputs.home-manager.nixosModules.home-manager

        # Custom modules
        self.nixosModules.gc
      ];

      wsl.enable = true;
      wsl.defaultUser = "alik";
      wsl.wslConf.interop.appendWindowsPath = true;
      wsl.useWindowsDriver = true;
      wsl.startMenuLaunchers = true;

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      nixpkgs.config.allowUnfree = true;
      nixpkgs.hostPlatform = "x86_64-linux";
      networking.hostName = "eldunari";
      networking.resolvconf.enable = false;
      users.users.alik.isNormalUser = true;
      users.users.alik.home = "/home/alik";
      users.users.alik.shell = pkgs.zsh;
      programs.zsh.enable = true;
      environment.systemPackages = with pkgs; [
        age
        sops
        git
        nixd # nix language server
        nil
        nixfmt # nix formatter
        nixfmt-tree # treefmt
        nerd-fonts.fira-code
        nerd-fonts.meslo-lg
        wget
      ];

      programs.nix-ld.enable = true;

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;

        extraSpecialArgs = {
          inherit inputs self;
          hostname = config.networking.hostName;
        };

        users = {
          alik = import ./_files/home.nix;
        };

        backupFileExtension = "backup";
      };

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It's perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "25.11"; # Did you read the comment?

    };
}
