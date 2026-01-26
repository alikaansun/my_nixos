{
  description = "Nix/OS\Darwin config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stablenixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    darwin= {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # hyprland.url = "github:hyprwm/Hyprland";
    # hyprland-plugins = {
    #   url = "github:hyprwm/Hyprland-Plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };
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

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    shad06_nixpkgs.url = "github:nixos/nixpkgs/b95dd9da90309705b8a32f849b80fad1cca16620";
    # zen-browser = {
    #   # url="github:0xc000022070/zen-browser-flake";
    #   url = "github:youwen5/zen-browser-flake";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # anifetch = {
    #   url = "github:Notenlish/anifetch";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs =
    {
      self,
      nixpkgs,
      stablenixpkgs,
      home-manager,
      plasma-manager,
      nvf,
      ...
    }@inputs:
    let
      username = "alik";

      vars = import ./modules/vars.nix;

      mkHost =
        hostname: system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs vars; };
          modules = [
            ./hosts/${hostname}/configuration.nix
            inputs.home-manager.nixosModules.default
            inputs.sops-nix.nixosModules.sops
          ];
        };

      mkHome =
        hostname: system: modulesExtra:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system vars; };
          extraSpecialArgs = { inherit hostname; };
          modules = [
            inputs.nvf.homeManagerModules.default
            inputs.sops-nix.nixosModules.sops
            ./hosts/${hostname}/home.nix
            {
              home = {
                inherit username;
                homeDirectory = "/home/${username}";
              };
            }
          ]
          ++ modulesExtra;
        };

      mkServer =
        hostname: system:
        stablenixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs vars; };
          modules = [
            ./hosts/${hostname}/configuration.nix
            inputs.home-manager.nixosModules.default
            inputs.sops-nix.nixosModules.sops
          ];
        };

    in
    {
      nixosConfigurations = {
        arondil = mkHost "arondil" "x86_64-linux";
        reania = mkHost "reania" "x86_64-linux";
        # blade = mkServer "blade" "x86_64-linux";
      };
      darwinConfigurations =
        let
          hostname = "leona";
        in
        {
          ${hostname} = inputs.darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            specialArgs = { inherit inputs vars; };
            modules = [
              ./hosts/${hostname}/configuration.nix

              inputs.sops-nix.darwinModules.sops
              inputs.home-manager.darwinModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${username} = ./hosts/${hostname}/home.nix;

                # Optionally, use home-manager.extraSpecialArgs to pass
                # arguments to home.nix
              }
            ];
          };
        };

      homeConfigurations = {
        "alik@arondil" = mkHome "arondil" "x86_64-linux" [
          inputs.plasma-manager.homeModules.plasma-manager
        ];
        "alik@reania" = mkHome "reania" "x86_64-linux" [
          inputs.plasma-manager.homeModules.plasma-manager
        ];
        # "alik@blade" = mkHome "blade" "x86_64-linux" [ ];
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-tree;
    };
}
