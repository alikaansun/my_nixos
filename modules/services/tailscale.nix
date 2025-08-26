{pkgs,config,...}:
{
environment.systemPackages =  [
    pkgs.tailscale
  ];


services.tailscale={
  enable=true;
  package=pkgs.tailscale;

  
  };

networking.firewall.allowedUDPPorts = [ ${config.services.tailscale.port} ];

}