{vars,config,pkgs, ... }:

{
  config = {

  sops.secrets = {
    seafile_email = {};
    seafile_adminpw = {};
    };

  services.seafile = {
    enable = true;
    adminEmail = config.sops.secrets.seafile_email.path;
    initialAdminPassword = config.sops.secrets.seafile_adminpw.path;
    user="seafile";
    group="seafile";
    # ccnetSettings.general.service_url = "https://${vars.seafile.hostName}";
    seafileSettings = {
      fileserver = {
        port = "ipv4:${vars.seafile.port}";
        host = vars.seafile.IP;
      };
    };
    # dataDir = "";
  };
    networking.firewall.allowedTCPPorts = [ vars.seafile.port ];

    services.caddy.virtualHosts."${vars.seafile.hostName}".extraConfig = ''
    tls internal
    reverse_proxy ${vars.seafile.IP}:${toString vars.seafile.port}
  '';

    
  };
}
