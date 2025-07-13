{ config, pkgs, lib,... }:

{
  config = {
    # https://github.com/firefly-iii/firefly-iii/blob/main/.env.example
    sops.secrets.firefly.passwd={};
    sops.secrets.git_email={};
    
    services.firefly-iii = {
      enable = true;
      virtualHost = "localhost.finance";
      settings = {
        APP_ENV = "production";
        # APP_KEY_FILE = "/var/secrets/firefly-iii-app-key.txt";
        SITE_OWNER = config.sops.secrets.git_email.path;
        DB_CONNECTION = "mysql";
        DB_HOST = "db";
        DB_PORT = 3306;
        DB_DATABASE = "firefly";
        DB_USERNAME = "firefly";
        DB_PASSWORD_FILE = config.sops.secrets.firefly.passwd.path;
      }
      ;
    };

    # # Enable the database service (MySQL in this example)
    services.mysql = {
      enable = true;
      package = pkgs.mysql80;
      ensureDatabases = [ "firefly" ];
      ensureUsers = [
        {
          name = "firefly";
          ensurePermissions = {
            "firefly.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    # Override automatic startup - this is the key part
    # systemd.services.firefly-iii = {
    #   wantedBy = lib.mkForce [];
    # };
  };
}