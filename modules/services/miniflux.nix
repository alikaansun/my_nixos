{ config, pkgs, lib,... }:

{
  config = {
    sops.secrets = {
      # git_email = {};
    };

  services.miniflux={
    enable = true;
    adminCredentialsFile = "/etc/miniflux.env";
    config = { #https://miniflux.app/docs/configuration.html
        CLEANUP_FREQUENCY = 48;
        LISTEN_ADDR = "localhost:8080";
    };  
  };
};
}
