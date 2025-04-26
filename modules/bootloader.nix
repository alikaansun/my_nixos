{ config, ... }:

{
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      efiSupport = true;
      #efiInstallAsRemovable = true;
      device = "nodev";
      fontSize = 30;
      timeoutStyle = "hidden";
    };
    # timeout = 5;
  };
  ##Old configuration
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
}