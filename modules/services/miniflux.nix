{ config, pkgs, lib,... }:

{
  config = {
    sops.secrets = {
      miniflux_admin = {
        sopsFile = ../secrets/miniflux_admin.env;
      };
      git_email = {};
    };

  services.miniflux={
    enable = true;
    adminCredentialsFile = config.sops.secrets.miniflux_admin.path;
    config = { #https://miniflux.app/docs/configuration.html
        CLEANUP_FREQUENCY = 48;
        LISTEN_ADDR = "localhost:8080";
    };  
  };
};
}
