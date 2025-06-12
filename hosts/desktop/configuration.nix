# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs , ... }:


{
  imports =
    [ 
      ./hardware-configuration.nix #Dont disable it
      #CUSTOM-MODULES
      ../../modules/bootloader.nix #bootloader #Dont disable it
      ../../modules/locale.nix #Dont disable it 
      ../../modules/gc.nix #garbage collection and store opt
      ../../modules/extrastorage.nix #extra storage
      ../../modules/gaming.nix 
      ../../modules/virtualisation.nix 
      ../../modules/networking.nix
      
      #./modules/localai.nix
      #DESKTOP-MODULES
      ../../modules/desktop/kde.nix
      # ./modules/desktop/hypr.nix
      # ./modules/desktop/xfce.nix
      # ./modules/desktop/gnome.nix
      
      # ./modules/desktop/stylix.nix
      # inputs.home-manager.nixosModules.default
    ];
  
  

  

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

 
  
  networking.hostName = "desktop"; # Define your hostname.

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
 
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

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alik = {
    # hashedPasswordFile = "/etc/passwdfile";
    isNormalUser = true;
    description = "alik";
    extraGroups = [ "networkmanager" "wheel" "input" "vboxusers" "libvirt" ];
    # packages = with pkgs; [];
  };
  # home-manager
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "alik" = import ./home.nix;
    };
    backupFileExtension = "backup";

  };


  environment.systemPackages = with pkgs; [
   wget
   git
   nvd#nixos package version diff tool
   nixd#nix language server
   alejandra #nix language server
   nerd-fonts.fira-code
   nerd-fonts.meslo-lg
   chromium
   unrar
   gparted
   nvtopPackages.full
   kdePackages.filelight
   eduvpn-client 

	#];   
#})
  ];

  networking.firewall.allowedTCPPorts = [ 57621 ];
  networking.firewall.allowedUDPPorts = [ 5353 ];
  # Enable automatic login for the user.services.displayManager.autoLogin
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "alik";
  #Programs
  
    # List services that you want to enable:


  #trezord adds required udev rules to start the bridge  
  services.trezord.enable = true;
  

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
