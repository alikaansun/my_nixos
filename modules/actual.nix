{ config, pkgs, lib,... }:

{
  # https://github.com/firefly-iii/firefly-iii/blob/main/.env.example
  config = {
    sops.secrets = {
      firefly_app_key = {
        owner = "firefly";
        group = "firefly";
      };
      firefly_passwd = {
        owner = "firefly";
        group = "firefly";
      };
      git_email = {};
    };
  
  services.actual = {
    enable = true;
    openFirewall = true;

    };
  };
}
