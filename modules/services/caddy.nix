{ pkgs,... }:

{
  environment.systemPackages =  [
    pkgs.caddy
  ];

  services.caddy = {
    enable = true;
    package = pkgs.caddy;
  };

  # Open HTTP/HTTPS ports
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  # systemd.services.caddy.after = [ "network-online.target" ];
    # systemd.services.caddy.wants = [ "network-online.target" ];

  networking.extraHosts = ''
    127.0.0.1 miniflux.arondil.local ai.arondil.local
    # Or map to LAN IP (uncomment and set correct IP):
    # 192.168.2.20 miniflux.arondil.local ai.arondil.local
  '';
  
}