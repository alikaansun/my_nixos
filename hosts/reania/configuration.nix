{ config, pkgs, ... }:

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
                        #../../modules/desktop/hypr.nix
      #  ../../modules/desktop/stylix.nix

      #SERVICES
      ../../modules/services/kanata.nix
    ];

  sops.secrets.git_email={};

  # omarchy = {
  #   full_name = "alik";
  #   email_address = config.sops.secrets.git_email.path;
  #   theme = "gruvbox";
  #   quick_app_bindings=[];
  #   scale=1;
  #   exclude_packages=with pkgs; [
  #   lazydocker
  #   lazygit
  #   docker-compose
  #   fastfetch
  #   vlc
  #   signal-desktop

  #   # Commercial GUIs
  #   typora
  #   dropbox
  #   spotify
    
  #   gh
  #   github-desktop
  #   ];
  #   # theme_overrides = {
  #   #   wallpaper_path =/home/alik/.dotfiles/modules/desktop/fav.jpg;
  #   # };
  #   # add other supported options here if desired
  # };

  services.mykanata = {
    enable = true;
    deviceName = "/dev/input/event0";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "reania"; # Define your hostname.
  networking.extraHosts = ''
  192.168.2.20 miniflux.local
  '';  
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  #hardware.graphics = {
  #  enable = true;
  #  enable32Bit = true;
  #};

  
  # Enable automatic login for the user.services.displayManager.autoLogin
  services.displayManager.autoLogin.enable = false;
  # services.displayManager.autoLogin.user = "alik";

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
