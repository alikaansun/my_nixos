{ pkgs,config, ... }:
{
  sops.secrets.git_email={};

  programs.git = {
    enable = true;
    userName = "alik";
    userEmail = config.sops.secrets.git_email.path;
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = "true";
      # safe.directory="/etc/nixos";
      # url = {
      #   "ssh://git@github.com/" = {
      #     insteadOf = "https://github.com/";
      #   };
      # };
    };
  };

}