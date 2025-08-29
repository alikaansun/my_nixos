{ pkgs, lib, vars, ... }:
{
  config = {
    networking.firewall.allowedTCPPorts = [ vars.miniflux.port ];

    services.miniflux = {
      enable = true;
      adminCredentialsFile = "/etc/miniflux.env";
      config = {
        CLEANUP_FREQUENCY = 48;
        LISTEN_ADDR = "${vars.miniflux.IP}:${toString vars.miniflux.port}";
        BASE_URL = "https://${vars.miniflux.tailscaleHostName}";  
      };
    };
    
    # Local access
    services.caddy.virtualHosts."${vars.miniflux.hostName}".extraConfig = ''
      tls internal
      reverse_proxy ${vars.miniflux.IP}:${toString vars.miniflux.port}
    '';

    # Tailscale access - simple reverse proxy
    services.caddy.virtualHosts."${vars.miniflux.tailscaleHostName}:${toString vars.miniflux.port}".extraConfig = ''
      tls internal
      reverse_proxy ${vars.miniflux.IP}:${toString vars.miniflux.port}
    '';
  };
}
