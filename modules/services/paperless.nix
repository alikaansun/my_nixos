{
  flake.nixosModules.paperless =
    { pkgs, vars, ... }:
    {

      #basic config
      # environment.etc."paperless-admin-pass".text = "admin";
      # services.paperless = {
      #   enable = true;
      #   passwordFile = "/etc/paperless-admin-pass";
      # };
      #more advanced config

      services.paperless = {
        enable = true;
        datadir = "nexcloud/appdata/paperless/data";
        package = pkgs.paperless;
        address = vars.paperless.IP;
        port = vars.paperless.port;

        consumptionDirIsPublic = true;
        settings = {
          # check b4 deploying + https
          PAPERLESS_CONSUMER_IGNORE_PATTERN = [
            ".DS_STORE/*"
            "desktop.ini"
          ];
          PAPERLESS_OCR_LANGUAGE = "nld+eng";
          PAPERLESS_OCR_USER_ARGS = {
            optimize = 1;
            pdfa_image_compression = "lossless";
          };
          PAPERLESS_URL = "https://${vars.paperless.hostName}";
        };
      };

      # Local access
      services.caddy.virtualHosts."${vars.paperless.hostName}".extraConfig = ''
        tls internal
        reverse_proxy ${vars.paperless.IP}:${toString vars.paperless.port}
      '';

    };
}
