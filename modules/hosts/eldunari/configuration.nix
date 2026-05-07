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
      ...
    }:
    {
      imports = [
        # include NixOS-WSL modules
        <nixos-wsl/modules>
      ];

      wsl.enable = true;
      wsl.defaultUser = "nixos";

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It's perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "25.11"; # Did you read the comment?

    };
}
