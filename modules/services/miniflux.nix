{ ... }:
let
  # Local host settings
  MinifluxHostAddr = "127.0.0.1";
  MinifluxPort = 8080;
  
  # LAN exposure
  lanIp = "192.168.2.20";
  minifluxPath = "/miniflux/";
  
  # Public (proxied) base URLs
  minifluxBaseUrl = "http://${lanIp}${minifluxPath}";
  
  # Internal upstreams
  minifluxUpstream = "http://${MinifluxHostAddr}:${toString MinifluxPort}/";
in
{
  config = {
    sops.secrets = {
      # git_email = {};
    };

    services.miniflux = {
      enable = true;
      adminCredentialsFile = "/etc/miniflux.env";
      config = {
        CLEANUP_FREQUENCY = 48;
        LISTEN_ADDR ="${MinifluxHostAddr}:${toString MinifluxPort}";  # Changed back to localhost since nginx will proxy
    };  
  };

  # Enable nginx reverse proxy
  services.nginx = {
    virtualHosts."${lanIp}" = {
      locations."${minifluxPath}" = {
        proxyPass = minifluxUpstream;
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };
  };

  # Add custom hostname to /etc/hosts
  # networking.extraHosts = ''
  #   "${MinifluxHostAddr}:${toString MinifluxPort}" miniflux.local
  #   "${lanIp}${minifluxPath}" miniflux.local  
  # '';
};

}
