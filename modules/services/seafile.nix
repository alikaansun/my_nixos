{vars, config, pkgs, ... }:

{
  config = {
    sops.secrets = {
      seafile_email = {};
      seafile_adminpw = {};
    };

    services.mysql = {
      enable = true;
      package = pkgs.mariadb;
      settings = {
        mysqld = {
          innodb_file_per_table = 1;
          innodb_buffer_pool_size = "128M";
        };
      };
      initialDatabases = [
        { name = "seafile-db"; }
        { name = "seahub-db"; }
        { name = "ccnet-db"; }
      ];
      ensureUsers = [
        {
          name = "seafile";
          ensurePermissions = {
            "seafile-db.*" = "ALL PRIVILEGES";
            "seahub-db.*" = "ALL PRIVILEGES";
            "ccnet-db.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    services.seafile = {
      enable = true;
      adminEmail = config.sops.secrets.seafile_email.path;
      initialAdminPassword = config.sops.secrets.seafile_adminpw.path;
      ccnetSettings.General.SERVICE_URL = "https://${vars.seafile.hostName}";
      seafileSettings = {
        fileserver = {
          port = vars.seafile.port;
          host = vars.seafile.IP;
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ vars.seafile.port ];

    services.caddy.virtualHosts."${vars.seafile.hostName}".extraConfig = ''
      tls internal
      reverse_proxy 127.0.0.1:${toString vars.seafile.port}
    '';
  };
}
