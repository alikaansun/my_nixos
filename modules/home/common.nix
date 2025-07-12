{ pkgs, inputs, ... }:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  home.username = "alik";
  home.homeDirectory = "/home/alik";
  nixpkgs.config.allowUnfree = true;
  home.enableNixpkgsReleaseCheck=false;
    # Add SOPS configuration for home-manager
  sops.defaultSopsFile = ../../modules/secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/alik/.config/sops/age/keys.txt";
  sops.secrets.git_email={};

}