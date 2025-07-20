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
      ../../modules/katana.nix
#       ../../modules/virtualisation.nix
#       ../../modules/networking.nix

      #./modules/localai.nix
      #DESKTOP-MODULES
       ../../modules/desktop/kde.nix
      # ../../modules/desktop/hypr.nix
      # ../../modules/desktop/xfce.nix
      # ../../modules/desktop/gnome.nix

      # ../../modules/desktop/stylix.nix
      # inputs.home-manager.nixosModules.default
    ];


  services.kanata = {
    enable = true;
    deviceName = "/dev/input/event0"; # Change this to your actual device if needed
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  networking.hostName = "laptop"; # Define your hostname.

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  
  #nix-shell -p libinput
  #sudo libinput list-devices
  # services.kanata={
  #   enable = true;
  #   keyboards = {
  #     internalKeyboard ={
  #       devices = [ "/dev/input/event0" ];
  #       extraDefCfg = "process-unmapped-keys yes";#danger-enable-cmd yes";
  #       config = "
  #         (defsrc
  #           caps a s d f j k l ;
  #         )
  #         (defvar
  #           tap-time 150
  #           hold-time 200
  #         )

  #         (defalias
  #           escctrl (tap-hold 100 100 esc lctl)
  #           a (multi f24 (tap-hold $tap-time $hold-time a lctl)) 
  #           s (multi f24 (tap-hold $tap-time $hold-time s lmet)) 
  #           d (multi f24 (tap-hold $tap-time $hold-time d lalt)) 
  #           f (multi f24 (tap-hold $tap-time $hold-time f lsft)) 
  #           j (multi f24 (tap-hold $tap-time $hold-time j rsft)) 
  #           k (multi f24 (tap-hold $tap-time $hold-time k ralt)) 
  #           l (multi f24 (tap-hold $tap-time $hold-time l rmet)) 
  #           ; (multi f24 (tap-hold $tap-time $hold-time ; rctl)) 
  #         )

  #         (deflayer base
  #           @escctrl @a @s @d @f @j @k @l @;
  #         )
  #       ";
  #     };
  #   };
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  #hardware.graphics = {
  #  enable = true;
  #  enable32Bit = true;
  #};




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
