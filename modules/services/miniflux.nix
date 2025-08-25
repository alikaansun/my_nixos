{ pkgs, lib, ... }:
let
  # Local host settings
  MinifluxHostAddr = "127.0.0.1";
  MinifluxPort = 8080;

  # Dedicated Miniflux hostname
  hostName = "miniflux.arondil.local";

  # Always root for Miniflux
  minifluxPath = "/";

  baseUrl = "https://${hostName}";
  portStr = toString MinifluxPort;

  caddyExtraConfig = ''
    tls internal
    reverse_proxy ${MinifluxHostAddr}:${portStr}
  '';
in
{
  config = {
    services.miniflux = {
      enable = true;
      adminCredentialsFile = "/etc/miniflux.env";
      config = {
        CLEANUP_FREQUENCY = 48;
        LISTEN_ADDR = "${MinifluxHostAddr}:${portStr}";
        BASE_URL = baseUrl;
      };
    };

    services.caddy.virtualHosts."${hostName}".extraConfig = caddyExtraConfig;
  };
}
