{
  vars,
  config,
  pkgs,
  ...
}:

{
    sops.secrets = {

    };

    services.ocis = {
      enable = true;

    };
    #   networking.firewall.allowedTCPPorts = [ vars.seafile.port ];

    #   services.caddy.virtualHosts."${vars.seafile.hostName}".extraConfig = ''
    #   tls internal
    #   reverse_proxy ${vars.seafile.IP}:${toString vars.seafile.port}
    # '';

}
