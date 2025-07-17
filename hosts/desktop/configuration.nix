# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs , ... }:


{
  imports =
    [ 
      ./hardware-configuration.nix #Dont disable it
      #CUSTOM-MODULES
      ../../modules/locale.nix #Dont disable it 
      ../../modules/common.nix #Dont disable it 
      ../../modules/gc.nix #garbage collection and store opt
      ../../modules/gaming.nix 
      ../../modules/virtualisation.nix 
      
      #./modules/localai.nix
      #DESKTOP-MODULES
      ../../modules/desktop/kde.nix
      # ./modules/desktop/hypr.nix
      # ./modules/desktop/xfce.nix
      # ./modules/desktop/gnome.nix
      
      #Services
      ../../modules/actual.nix

    ];
  
  #Mount extra drive and make it 
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
  
  # Bridge network for nas
  networking = {
    hostName = "desktop";
  #   interfaces.eno1 = {
  #   ipv4.addresses = [{
  #     address = "192.168.10.1";
  #     prefixLength = 24;
  #   }];
  # };
  };

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
  };
 
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
  };

  networking.firewall.allowedTCPPorts = [ 57621 ];
  networking.firewall.allowedUDPPorts = [ 5353 ];
  # Enable automatic login for the user.services.displayManager.autoLogin
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "alik";

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
  
}
