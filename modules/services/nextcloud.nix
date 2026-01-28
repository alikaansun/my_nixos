{
  flake.nixosModules.nextcloud = {
    vars,
    config,
    pkgs,
    ...
  }: {
    systemd.tmpfiles.rules = [
    "d /mnt/storage/AppData 0755 root root -"
    "d /mnt/storage/AppData/nextcloud 0770 nextcloud nextcloud -"
  ];

  # Set up secrets using your existing sops configuration
  sops.secrets = {
    nextcloud_admin_pw = {
      # mode = "0400";
      # owner = "nextcloud";
      # group = "nextcloud";
    };
    nextcloud_db_pw = {
      # mode = "0400";
      # owner = "nextcloud";
      # group = "nextcloud";
    };
  };

  environment.etc."nextcloud-admin-pass".text = config.sops.secrets.nextcloud_db_pw.path;
  # environment.etc."nextcloud-admin-pass".text = "Alksjfks77!fa";
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud32;
    hostName = vars.nextcloud.hostName;
    config = {
      # adminpassFile = "/etc/nextcloud-admin-pass";
      adminpassFile = "/etc/nc_admin_pass";
      adminuser = "admin";
      dbtype = "sqlite";
    };
    settings = {
      trusted_domains = [
        "0.0.0.0"
        # config.sops.secrets.arondil_ipv4.path
        "127.0.0.1"
        "localhost"
        "192.168.*.*"
      ];
      # trusted_proxies = [
      #   "127.0.0.1"
      # ];
    };
    https = true;
    # Let NixOS install and configure the database automatically.
    database.createLocally = true;
    # Let NixOS install and configure Redis caching automatically.
    configureRedis = true;
    # Increase the maximum file upload size to avoid problems uploading videos.
    maxUploadSize = "16G";
    # Use your storage mount for data
    # datadir = "/mnt/storage/AppData/nextcloud";
  };
  # Open firewall port
  networking.firewall.allowedTCPPorts = [ vars.nextcloud.port ];

  # # Set up Caddy virtual host (using your existing Caddy configuration pattern)
  # services.caddy.virtualHosts."${vars.nextcloud.hostName}".extraConfig = ''
  #   tls internal
  #   reverse_proxy ${vars.nextcloud.IP}:${toString vars.nextcloud.port}
  # '';
  };
}
