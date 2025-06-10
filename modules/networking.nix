{ config, pkgs, ... }:

{
  # Network configuration for direct NAS connection
  networking = {
    
    interfaces.eno1 = {
      ipv4.addresses = [{
        address = "192.168.10.1";
        prefixLength = 24;
      }];
    };
  };
    # Optional: If you want to enable IP forwarding for the NAS
    # (useful if you want the NAS to access internet through your desktop)
    # enableIPForwarding = true;
}