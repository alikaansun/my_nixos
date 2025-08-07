{ ... }:

{
  # https://github.com/firefly-iii/firefly-iii/blob/main/.env.example
  config = {
    sops.secrets = {
      firefly_app_key = {};
      firefly_passwd = {};
      git_email = {};
    };
  
  services.actual = {
    enable = true;
    openFirewall = true;

    };
  };

  #   # https://github.com/firefly-iii/firefly-iii/blob/main/.env.example
  # config = {
  #   sops.secrets = {
  #     firefly_app_key = {
  #       owner = "firefly";
  #       group = "firefly";
  #     };
  #     firefly_passwd = {
  #       owner = "firefly";
  #       group = "firefly";
  #     };
  #     git_email = {};
  #   };
  

  
  # services.firefly-iii = {
  #   enable = true;
  #   virtualHost = "localhost.finance";
  #   settings = {
  #     APP_ENV = "production";
  #     APP_KEY_FILE = config.sops.secrets.firefly_app_key.path;
  #     SITE_OWNER = config.sops.secrets.git_email.path;
  #     DB_CONNECTION = "mysql";
  #     DB_HOST = "localhost";  # Changed from "db" to "localhost"
  #     DB_PORT = 3306;
  #     DB_DATABASE = "firefly";
  #     DB_USERNAME = "firefly";
  #     DB_PASSWORD_FILE = config.sops.secrets.firefly_passwd.path;
  #   };
  # };

  # # Enable the database service (MySQL)
  # services.mysql = {
  #   enable = true;
  #   package = pkgs.mysql80;
  #   ensureDatabases = [ "firefly" ];
  #   ensureUsers = [
  #     {
  #       name = "firefly";
  #       ensurePermissions = {
  #         "firefly.*" = "ALL PRIVILEGES";
  #       };
  #       # passwordFile = config.sops.secrets.firefly_passwd.path;
  #       # Add password file for the MySQL user
  #     }
  #   ];
  # };
  # # users.mysql.


  # services.nginx = {
  #   enable = true;
  #   recommendedTlsSettings = true;
  #   recommendedOptimisation = true;
  #   recommendedGzipSettings = true;
  #   recommendedProxySettings = true;
  # };
  # # Optional: Override automatic startup if needed
  # # systemd.services.firefly-iii = {
  # #   wantedBy = lib.mkForce [];
  # # };
  # };
}
