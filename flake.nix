{
  description = "Nix/OS\Darwin config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stablenixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    import-tree = {
      url = "github:vic/import-tree";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    shad06_nixpkgs.url = "github:nixos/nixpkgs/b95dd9da90309705b8a32f849b80fad1cca16620";
  };

  outputs =
    inputs@{ self, flake-parts, ... }:
    let
      username = "alik";
      vars = import ./modules/vars.nix;

      helpers = import ./lib/flakehelpers.nix {
        inherit
          self
          inputs
          vars
          username
          ;
        inherit (inputs) nixpkgs stablenixpkgs;
      };

      inherit (helpers)
        mkHost
        mkHome
        mkDarwin
        mkServer
        ;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        # "x86_64-linux"
        "aarch64-darwin"
      ];

      flake = {
        # Expose modules for clear, explicit imports
        nixosModules = {
          # Base modules
          common = import ./modules/common.nix;
          locale = (import ./modules/locale.nix).flake.nixosModules.locale;
          gc = (import ./modules/gc.nix).flake.nixosModules.gc;
          gaming = import ./modules/gaming.nix;
          virtualisation = import ./modules/virtualisation.nix;
          
          # Desktop environments
          kde = import ./modules/desktop/kde.nix;
          hypr = import ./modules/desktop/hypr.nix;
          hyprland = import ./modules/desktop/hyprland.nix;
          stylix = import ./modules/desktop/stylix.nix;
          
          # Services
          avahi = import ./modules/services/avahi.nix;
          caddy = import ./modules/services/caddy.nix;
          glance = import ./modules/services/glance.nix;
          kanata = import ./modules/services/kanata.nix;
          localai = import ./modules/services/localai.nix;
          miniflux = import ./modules/services/miniflux.nix;
          nextcloud = import ./modules/services/nextcloud.nix;
          nginx = import ./modules/services/nginx.nix;
          paperless = import ./modules/services/paperless.nix;
          rustdesk-server = import ./modules/services/rustdesk_server.nix;
          syncthing = import ./modules/services/syncthing.nix;
          tailscale = import ./modules/services/tailscale.nix;
        };
        
        # Home manager modules
        homeModules = {
          git = (import ./modules/home/git.nix).flake.homeModules.git;
          nvim = (import ./modules/home/nvim.nix).flake.homeModules.nvim;
          terminal = (import ./modules/home/terminal.nix).flake.homeModules.terminal;
          zed = (import ./modules/home/zed.nix).flake.homeModules.zed;
          plasma = (import ./modules/home/plasma.nix).flake.homeModules.plasma;
          common = import ./modules/home/common.nix;
        };
        
        # Darwin modules
        darwinModules = {
          gc = (import ./modules/gc.nix).flake.darwinModules.gc;
        };
        
        # NixOS configurations
        nixosConfigurations = {
          arondil = mkHost "arondil" "x86_64-linux";
          reania = mkHost "reania" "x86_64-linux";
          blade = mkServer "blade" "x86_64-linux";
        };

        # Darwin configurations
        darwinConfigurations = {
          leona = mkDarwin "leona" "aarch64-darwin";
        };

        # Home Manager configurations
        homeConfigurations = {
          "alik@arondil" = mkHome "arondil" "x86_64-linux" [
            inputs.plasma-manager.homeModules.plasma-manager
          ];
          "alik@reania" = mkHome "reania" "x86_64-linux" [
            inputs.plasma-manager.homeModules.plasma-manager
          ];
          "alik@leona" = mkHome "leona" "aarch64-darwin" [ ];
        };
      };

      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        {
          # Formatters per system
          formatter = pkgs.nixfmt-tree;

          # Optional: define packages, devShells, checks, etc. per system
          # packages = { };
          # devShells = { };
        };
    };
}
