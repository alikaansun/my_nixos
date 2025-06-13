{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins ={
      url = "github:hyprwm/Hyprland-Plugins";
      inputs.hyprland.follows = "hyprland";
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
  };

  outputs = { self, nixpkgs, ... }@inputs: 
  let
    system = "x86_64-linux";
    
    mkHost = hostname: nixpkgs.lib.nixosSystem{
      inherit system;
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/${hostname}/configuration.nix
        inputs.home-manager.nixosModules.default
        inputs.sops-nix.nixosModules.sops
        inputs.stylix.nixosModules.stylix
      ];
    };
  in {
    nixosConfigurations = {
      desktop = mkHost "desktop";
      laptop = mkHost "laptop";
      # nixos = mkHost "laptop";
  };
};
}