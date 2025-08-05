{ config, pkgs, lib, ... }:

{
  config = {
    sops.secrets = {
      # git_email = {};
    };


  # Enable nginx reverse proxy
  services.nginx = {
    virtualHosts."192.168.2.20" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:8080";
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
  networking.extraHosts = ''
    127.0.0.1 miniflux.local
    192.168.2.20 miniflux.local  # Replace with your actual IP
  '';
};

}
