{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # hyprland.url = "github:hyprwm/Hyprland";
    # hyprland-plugins ={
    #   url = "github:hyprwm/Hyprland-Plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };
    # stylix.url = "github:danth/stylix";
    # soundshed.url = "github:soundshed/soundshed-app";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: 
  let
    system = "x86_64-linux";
  in {
    # use "nixos", or your hostname as the name of the configuration
    # it's a better practice than "default" shown in the video
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
        inputs.home-manager.nixosModules.default
        # inputs.stylix.nixosModules.stylix
      ];
    };
    
    # Add packages output so nix copy works
    # packages.${system}.default = self.nixosConfigurations.nixos.config.system.build.toplevel;
  };
}
