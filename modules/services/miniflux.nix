{ ... }:
let
  # Local host settings
  MinifluxHostAddr = "127.0.0.1";
  MinifluxPort = 8080;
  
  # LAN exposure
  # lanIp = "192.168.2.20";
  hostName="miniflux.local";
  # minifluxPath = "/miniflux/";
  minifluxPath = "/";
  
  # minifluxBaseUrl = "http://${lanIp}${minifluxPath}";
  # minifluxBaseUrl = minifluxPath;
  
  # Internal upstreams
  minifluxUpstream = "http://${MinifluxHostAddr}:${toString MinifluxPort}/";
in
{
  config = {

    sops.secrets = {
      # xxx = {};
    };

    services.miniflux = {
      enable = true;
      adminCredentialsFile = "/etc/miniflux.env";
      config = {
        CLEANUP_FREQUENCY = 48;
        LISTEN_ADDR ="${MinifluxHostAddr}:${toString MinifluxPort}";  
        # YOUTUBE_API_KEY
    };  
  };
  # Enable nginx reverse proxy
    services.nginx = {
      virtualHosts."${hostName}" = {
        locations."${minifluxPath}" = {
          proxyPass = minifluxUpstream;
          proxyWebsockets = true;
          extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          # proxy_set_header X-Forwarded-Prefix ${minifluxPath};
          

         '';
        };
      };
  };

};
  
}
