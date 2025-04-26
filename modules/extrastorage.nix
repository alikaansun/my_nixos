{ config, ... }:

{
  fileSystems."/mnt/D" = {
    device = "/dev/disk/by-uuid/218ce1d4-70e8-4b81-aa2b-3abab153a6b4";
    fsType = "ext4";
    options = [ "defaults" "rw" ];
  };

  system.activationScripts.setStoragePermissions = {
    text = ''
      mkdir -p /mnt/D
      chown alik /mnt/D
      chmod -R 777 /mnt/D
    '';
    deps = [];
  };
}