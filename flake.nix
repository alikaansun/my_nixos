{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stablenixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
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
    omarchy-nix = {
        url = "github:henrysipp/omarchy-nix";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.home-manager.follows = "home-manager";
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
    nvf={
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };  
    shad06_nixpkgs.url="github:nixos/nixpkgs/b95dd9da90309705b8a32f849b80fad1cca16620";
    zen-browser = {
      # url="github:0xc000022070/zen-browser-flake";
      url="github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      system = "x86_64-linux";

      username = "alik";

      mkHost =
        hostname:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/${hostname}/configuration.nix
            inputs.home-manager.nixosModules.default
            inputs.sops-nix.nixosModules.sops
            inputs.stylix.nixosModules.stylix
            # inputs.omarchy-nix.nixosModules.default
          ];
        };

      mkHome =
        hostname:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          modules = [
            inputs.plasma-manager.homeManagerModules.plasma-manager
            inputs.nvf.homeManagerModules.default
            inputs.sops-nix.nixosModules.sops
            # inputs.omarchy-nix.homeManagerModules.default
            ./hosts/${hostname}/home.nix
            {
              home = {
                inherit username;
                homeDirectory = "/home/${username}";
              };
            }
          ];
        };

      mkServer =
        hostname:
        stablenixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/${hostname}/configuration.nix
            inputs.home-manager.nixosModules.default
            inputs.sops-nix.nixosModules.sops
          ];
        };

      mkServerHome =
        hostname:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import stablenixpkgs { inherit system; };
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
          ];
        };
    in
    {
      nixosConfigurations = {
        desktop = mkHost "desktop";
        laptop = mkHost "laptop";
        blade = mkServer "blade"; 
        # nixos = mkHost "laptop";
      };

      homeConfigurations = {
        "alik@desktop" = mkHome "desktop";
        "alik@laptop" = mkHome "laptop";
        "alik@blade" = mkServerHome "blade";
      };
    };
}
