{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "alik";
    userEmail = "asunnetcoglu@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = "true";
      # safe.directory="/etc/nixos";
    };
  };
}