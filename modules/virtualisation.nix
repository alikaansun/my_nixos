{
  flake.nixosModules.virtualisation = { config, pkgs, ... }: {
    # Enable libvirtd and virt-manager
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
    # Enable waydroid
    # virtualisation.waydroid.enable = true;

    # Add virtiofsd to system packages
    environment.systemPackages = with pkgs; [
      virtiofsd
      docker-client
    ];

    virtualisation.docker.enable = true;
  };
}
