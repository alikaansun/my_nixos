{
  flake.nixosModules.caddy =
    { pkgs, vars, ... }:
    {
      environment.systemPackages = [
        pkgs.caddy
      ];

      services.caddy = {
        enable = true;
        package = pkgs.caddy;
      };

      # Open HTTP/HTTPS ports
      networking.firewall.allowedTCPPorts = [
        80
        443
      ];

    };
}
