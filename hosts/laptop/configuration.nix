# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix #Dont disable it
      #CUSTOM-MODULES
      # ../../modules/bootloader.nix #bootloader #Dont disable it
      ../../modules/locale.nix #Dont disable it
      ../../modules/common.nix #Dont disable it
      ../../modules/gc.nix #garbage collection and store opt
#       ../../modules/extrastorage.nix #extra storage
      ../../modules/gaming.nix
#       ../../modules/virtualisation.nix
#       ../../modules/networking.nix

      #DESKTOP-MODULES
       ../../modules/desktop/kde.nix

      #SERVICES
      ../../modules/services/kanata.nix
    ];


  services.mykanata = {
    enable = true;
    deviceName = "/dev/input/event0";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  networking.hostName = "laptop"; # Define your hostname.
  networking.extraHosts = ''
  192.168.2.20 miniflux.local
  '';  
  networking.firewall.allowedTCPPorts = [ 57621 ];
  networking.firewall.allowedUDPPorts = [ 5353 ];
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  #hardware.graphics = {
  #  enable = true;
  #  enable32Bit = true;
  #};

  
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
  system.stateVersion = "25.05"; # Did you read the comment?

}
