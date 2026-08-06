{
  flake.nixosModules.navidrome =
    { ... }:
    {
      services.navidrome.enable = true;
    };
}
