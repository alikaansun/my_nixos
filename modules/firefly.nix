{ config, pkgs, lib,... }:

{

  sops.defaultSopsFile = ../secrets/firefly.yaml;
  sops.secrets.firefly-db-password = {
    owner = config.services.firefly-iii.user;
  };

  
  services.firefly-iii = {
    enable = true;
    hostname = "finance.localhost"; # Or your preferred domain
    # Database configuration
    database = {
      type = "mysql"; # Or "pgsql" for PostgreSQL
      host = "localhost";
      name = "firefly";
      user = "firefly";
      passwordFile = config.sops.secrets.firefly-db-password.path; # Consider using a secrets management approach
      port = 3306;
    };
  };

  # Enable the database service (MySQL in this example)
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
}