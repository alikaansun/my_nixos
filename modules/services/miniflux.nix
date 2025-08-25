{ pkgs, lib, ... }:
let
  # Local host settings
  MinifluxHostAddr = "127.0.0.1";
  MinifluxPort = 8080;

  # LAN exposure
  lanIp = "192.168.2.20";
  hostName = "arondil.local";
  # Set to "/" for root, or e.g. "/miniflux" (must start with "/"; no trailing slash)
  minifluxPath = "/miniflux";

  baseUrl =
    if minifluxPath == "/"
    then "https://${hostName}"
    else "https://${hostName}${minifluxPath}";

  portStr = toString MinifluxPort;
  
  caddyExtraConfig =
     ''
      tls internal
    '' + (if minifluxPath == "/" then ''
      reverse_proxy ${MinifluxHostAddr}:${portStr}
    '' else ''
      @root path == /
      redir @root ${minifluxPath} 301
      handle_path ${minifluxPath}* {
        reverse_proxy ${MinifluxHostAddr}:${portStr}
      }
    '');
in
{
  config = {
    # Open HTTP/HTTPS
    networking.firewall.allowedTCPPorts = [ 80 443 ];

    services.miniflux = {
      enable = true;
      adminCredentialsFile = "/etc/miniflux.env";
      config = {
        CLEANUP_FREQUENCY = 48;
        LISTEN_ADDR = "${MinifluxHostAddr}:${toString MinifluxPort}";
        BASE_URL = baseUrl;
      };
    };

    # Caddy enable + firewall handled elsewhere; only define the vhost here.
    services.caddy.virtualHosts."${hostName}".extraConfig = caddyExtraConfig;

    # (Optional) If you want systemd to wait for network:
    # systemd.services.caddy.after = [ "network-online.target" ];
    # systemd.services.caddy.wants = [ "network-online.target" ];
  };
}
