{ config, pkgs, lib, ... }:

{
  services.nginx = {
    enable = true;
    # recommendedTlsSettings = true;
    # recommendedOptimisation = true;
    # recommendedGzipSettings = true;
    # recommendedProxySettings = true;
    
    # Global settings
    # appendHttpConfig = ''
    #   # Global nginx settings
    #   client_max_body_size 100M;
    #   server_tokens off;
    # '';
  };

  # Open HTTP/HTTPS ports
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}