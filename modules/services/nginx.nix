{ pkgs,... }:

{
  environment.systemPackages =  [
    pkgs.nginxStable
  ];

  services.nginx = {
    enable = true;
    package = pkgs.nginxStable;
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