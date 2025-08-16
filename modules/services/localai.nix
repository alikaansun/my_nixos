{ ... }:
let 
  OllamaHostAddr = "127.0.0.1";
  OWebHostAddr   = "0.0.0.0";

  # LAN exposure
  lanIp           = "192.168.2.20";
  openWebUiPath   = "/openwebui/";
  ollamaPath      = "/ollama/";

  # Public (proxied) base URLs
  openWebUiBaseUrl = "http://${lanIp}${openWebUiPath}";
  ollamaBaseUrl    = "http://${lanIp}${ollamaPath}";

  # Internal upstreams
  openWebUiUpstream = "http://${OWebHostAddr}:11111/";
  ollamaUpstream    = "http://${OllamaHostAddr}:11434/";
in 
{
  networking.firewall.allowedTCPPorts = [ 11111 11434 ];

  # OLLAMA & OPENWEBUI
  services.ollama = {
    enable = true;
    host = "[::]";
    # host = OllamaHostAddr;
    port = 11434;
    acceleration = "rocm";
    # openFirewall = true;
  };

  services.open-webui = {
    enable = true;
    host = OWebHostAddr;
    port = 11111;
    # stateDir = "/home/alik/AppData/open-webui";
    environment ={
      # OLLAMA_API_BASE_URL = ollamaBaseUrl;
      # WEBUI_BASE_PATH = openWebUiPath;
      WEBUI_AUTH = "False";
    };
  };

  # Expose both services on your LAN IP via nginx (same vhost as Miniflux)
  services.nginx.virtualHosts."${lanIp}" = {
    # OpenWebUI at ${openWebUiBaseUrl}
    locations."${openWebUiPath}" = {
      proxyPass = openWebUiUpstream;
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Prefix ${openWebUiPath};
        proxy_read_timeout 3600;
        proxy_send_timeout 3600;
        proxy_buffering off;
        
        # Rewrite paths correctly
        rewrite ^${openWebUiPath}(.*) /$1 break;
      '';
    };


  };
    # Add custom hostname to /etc/hosts
  # networking.extraHosts = ''
  #   127.0.0.1 miniflux.local
  #   192.168.2.20 miniflux.local  
  # '';

  #   # Ollama API at ${ollamaBaseUrl}
  #   locations."${ollamaPath}" = {
  #     proxyPass = ollamaUpstream;
  #     proxyWebsockets = true;
  #     extraConfig = ''
  #       client_max_body_size 0;
  #       proxy_set_header Host $host;
  #       proxy_set_header X-Real-IP $remote_addr;
  #       proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  #       proxy_set_header X-Forwarded-Proto $scheme;
  #       proxy_read_timeout 3600;
  #       proxy_send_timeout 3600;
  #       proxy_buffering off;
  #     '';
  #   };
  # };

}