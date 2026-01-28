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
    flake-parts.lib.mkFlake { inherit inputs; } (
      inputs.import-tree ./modules
      // {
        systems = [
          "x86_64-linux"
          "aarch64-darwin"
        ];
        imports = [
        inputs.home-manager.flakeModules.home-manager
        ];

        flake = {
          homeConfigurations
          # Host configurations are defined in modules/hosts/*/configuration.nix
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
      }
    );
}
