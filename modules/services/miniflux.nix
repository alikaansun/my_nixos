{
  flake.nixosModules.miniflux =
    {
      pkgs,
      lib,
      vars,
      ...
    }:
    {
      networking.firewall.allowedTCPPorts = [ vars.miniflux.port ];

      services.miniflux = {
        enable = true;
        adminCredentialsFile = "/etc/miniflux.env";
        config = {
          CLEANUP_FREQUENCY = 48;
          LISTEN_ADDR = "${vars.miniflux.IP}:${toString vars.miniflux.port}";
          BASE_URL = "https://${vars.miniflux.hostName}";
        };
      };

      # Local access
      services.caddy.virtualHosts."${vars.miniflux.hostName}".extraConfig = ''
        tls internal
        reverse_proxy ${vars.miniflux.IP}:${toString vars.miniflux.port}
      '';
    };
}
