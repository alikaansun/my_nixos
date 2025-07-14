{ config, pkgs, lib,... }:

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
}
