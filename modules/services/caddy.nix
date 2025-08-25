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
}