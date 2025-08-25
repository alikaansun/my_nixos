{ ... }:
let
  OllamaHostAddr = "127.0.0.1";
  OWebHostAddr   = "127.0.0.1";  # bind only to localhost now

  # OpenWebUI and Ollama internal upstreams
  openWebUiPort = 11111;
  ollamaPort    = 11434;
in
{
  # No need to open these ports externally now (remove if previously set)
  networking.firewall.allowedTCPPorts = [ ];

  services.ollama = {
    enable = true;
    host = OllamaHostAddr;
    port = ollamaPort;
    acceleration = "rocm";
  };

  services.open-webui = {
    enable = true;
    host = OWebHostAddr;
    port = openWebUiPort;
    environment = {
      WEBUI_AUTH = "False";
    };
  };
  
  services.caddy.virtualHosts."ai.arondil.local".extraConfig = ''
    tls internal
    reverse_proxy 127.0.0.1:${toString openWebUiPort}
  '';
  # Expose both services on your LAN IP via nginx (same vhost as Miniflux)
  # services.nginx.virtualHosts."${lanIp}" = {
  #   # OpenWebUI at ${openWebUiBaseUrl}
  #   locations."${openWebUiPath}" = {
  #     proxyPass = openWebUiUpstream;
  #     proxyWebsockets = true;
  #     extraConfig = ''
  #       proxy_set_header Host $host;
  #       proxy_set_header X-Real-IP $remote_addr;
  #       proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  #       proxy_set_header X-Forwarded-Proto $scheme;
  #       proxy_set_header X-Forwarded-Prefix ${openWebUiPath};
  #       proxy_read_timeout 3600;
  #       proxy_send_timeout 3600;
  #       proxy_buffering off;
        
  #       # Rewrite paths correctly
  #       rewrite ^${openWebUiPath}(.*) /$1 break;
  #     '';
  #   };
  # };
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