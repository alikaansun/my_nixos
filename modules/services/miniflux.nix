{ pkgs, lib, vars, ... }:
let
  hostName = vars.miniflux.hostName;
  port     = vars.miniflux.port;
  baseUrl  = "https://${hostName}";
in
{
  config = {
    services.miniflux = {
      enable = true;
      adminCredentialsFile = "/etc/miniflux.env";
      config = {
        CLEANUP_FREQUENCY = 48;
        LISTEN_ADDR = "127.0.0.1:${toString port}";
        BASE_URL = baseUrl;
      };
    };

    services.caddy.virtualHosts."${hostName}".extraConfig = ''
      tls internal
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
}
