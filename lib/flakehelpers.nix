{
  nixpkgs,
  stablenixpkgs,
  inputs,
  vars,
  username,
  self,
}:

{
  mkHost =
    hostname: system:
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs vars self; };
      modules = [
        "${self}/hosts/${hostname}/configuration.nix"
        inputs.home-manager.nixosModules.default
        inputs.sops-nix.nixosModules.sops
      ];
    };

  mkHome =
    hostname: system: modulesExtra:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { inherit system vars; };
      extraSpecialArgs = { inherit hostname self; };
      modules = [
        inputs.nvf.homeManagerModules.default
        inputs.sops-nix.nixosModules.sops
        "${self}/hosts/${hostname}/home.nix"
        {
          home = {
            inherit username;
            homeDirectory = "/home/${username}";
          };
        }
      ]
      ++ modulesExtra;
    };

  mkDarwin =
    hostname: system:
    inputs.darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { inherit inputs vars; };
      modules = [
        "${self}/hosts/${hostname}/configuration.nix"
        inputs.sops-nix.darwinModules.sops
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username} = "${self}/hosts/${hostname}/home.nix";
        }
      ];
    };

  mkServer =
    hostname: system:
    stablenixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs vars; };
      modules = [
        "${self}/hosts/${hostname}/configuration.nix"
        inputs.home-manager.nixosModules.default
        inputs.sops-nix.nixosModules.sops
      ];
    };
}
