{ config, pkgs, ... }:

{
  # Enable libvirtd and virt-manager
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Add virtiofsd to system packages
  environment.systemPackages = with pkgs; [
    virtiofsd
  ];
}