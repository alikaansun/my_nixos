{ pkgs, config, ... }:
{

  sops.secrets.git_email = { };

  programs.git = {
    enable = true;
    settings = {
      user.name = "alik";
      user.email = config.sops.secrets.git_email.path;
      pull.rebase = "true";
      init.defaultBranch = "main";
      # safe.directory="/etc/nixos";
      # url = {
      #   "ssh://git@github.com/" = {
      #     insteadOf = "https://github.com/";
      #   };
      # };
    };
  };

}
