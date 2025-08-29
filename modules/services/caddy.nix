{ pkgs,vars,... }:

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
    ${vars.miniflux.IP} miniflux.arondil.local ai.arondil.local ${vars.miniflux.tailscaleHostName} ${vars.openWebUI.tailscaleHostName}
  '';
  
}