{
  vars,
  config,
  pkgs,
  ...
}:
{
  # Set up the user in case you need consistent UIDs and GIDs. And also to make
  # sure we can write out the secrets file with the proper permissions.
  users.groups.nextcloud = { };
  users.users.nextcloud = {
    isSystemUser = true;
    group = "nextcloud";
  };

  # Set up secrets using your existing sops configuration
  sops.secrets = {
    nextcloud-admin-password = {
      mode = "0600";
      owner = "nextcloud";
      group = "nextcloud";
    };

    nextcloud-db-password = {
      mode = "0600";
      owner = "nextcloud";
      group = "nextcloud";
    };

    nextcloud-secrets = {
      mode = "0600";
      owner = "nextcloud";
      group = "nextcloud";
    };
  };

  # Set up MySQL for Nextcloud
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [
      {
        name = "nextcloud";
        ensurePermissions = {
          "nextcloud.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  # Set up Nextcloud
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud31;
    https = true;
    hostName = vars.nextcloud.hostName;
    secretFile = config.sops.secrets.nextcloud-secrets.path;

    phpOptions."opcache.interned_strings_buffer" = "13";

    config = {
      dbtype = "mysql";
      dbname = "nextcloud";
      dbhost = "localhost";
      dbpassFile = config.sops.secrets.nextcloud-db-password.path;

      adminuser = "admin";
      adminpassFile = config.sops.secrets.nextcloud-admin-password.path;
    };

    settings = {
      maintenance_window_start = 2; # 02:00
      default_phone_region = "DE";
      filelocking.enabled = true;

      redis = {
        host = config.services.redis.servers.nextcloud.bind;
        port = config.services.redis.servers.nextcloud.port;
        dbindex = 0;
        timeout = 1.5;
      };

      trusted_domains = [ vars.nextcloud.hostName "localhost" ];
    };

    caching = {
      redis = true;
      memcached = true;
    };

    # Use your storage mount for data
    datadir = "/mnt/storage/AppData/nextcloud";
  };

  # Set up Redis for caching
  services.redis.servers.nextcloud = {
    enable = true;
    bind = "127.0.0.1";
    port = 6379;
  };

  # Open firewall port
  networking.firewall.allowedTCPPorts = [ vars.nextcloud.port ];

  # Set up Caddy virtual host (using your existing Caddy configuration pattern)
  services.caddy.virtualHosts."${vars.nextcloud.hostName}".extraConfig = ''
    tls internal
    reverse_proxy ${vars.nextcloud.IP}:${toString vars.nextcloud.port}
  '';

  # Create the data directory with proper permissions
  systemd.tmpfiles.rules = [
    "d /mnt/storage/AppData/nextcloud 0770 nextcloud nextcloud -"
  ];
}