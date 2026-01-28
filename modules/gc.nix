{
  flake.nixosModules.gc =
    { ... }:
    {
      nix.gc.automatic = true;
      nix.gc.dates = "weekly";
      nix.gc.options = "--delete-older-than 10d";
      nix.settings.auto-optimise-store = true;
    };

  flake.darwinModules.gc =
    { ... }:
    {
      nix.gc.automatic = true;
      nix.gc.interval.Day = 7;
      nix.gc.options = "--delete-older-than 10d";
      nix.settings.auto-optimise-store = true;
    };
}
