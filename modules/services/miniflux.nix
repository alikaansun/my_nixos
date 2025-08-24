{ pkgs,... }:
let
  # Local host settings
  MinifluxHostAddr = "127.0.0.1";
  MinifluxPort = 8080;
  
  # LAN exposure
  lanIp = "192.168.2.20";
  hostName="miniflux.local";
  minifluxPath = "/miniflux";
  # minifluxPath = "/";

  
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
#     services.caddy = {
#       enable = true;
      

# };
  
};



#end
}
