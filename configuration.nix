# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs , ... }:


{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 10d";
  nix.settings.auto-optimise-store = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  networking.hostName = "nixos"; # Define your hostname.

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LANG= "en_US.UTF-8";

    LC_ADDRESS = "nl_NL.UTF-8";
  
    LC_IDENTIFICATION = "nl_NL.UTF-8";
 
    LC_MEASUREMENT = "nl_NL.UTF-8";
    
    LC_MONETARY = "nl_NL.UTF-8";
 
    LC_NAME = "nl_NL.UTF-8";
 
    LC_NUMERIC = "nl_NL.UTF-8";
 
    LC_PAPER = "nl_NL.UTF-8";
 
    LC_TELEPHONE = "nl_NL.UTF-8";
 
    LC_TIME = "nl_NL.UTF-8";
 
  };
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;


  # Configure keymap in X11
  services.xserver.xkb = {
  layout = "us,ir,tr";   # Add US and Iranian layouts
  variant = "";       # Use default variants for both layouts
  # options = "grp:alt_shift_toggle";  # Use Alt+Shift to switch between layouts
  };
 
  # Enable CUPS to print documents.
  services.printing.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    # prime.sync.enable = true;
  };
  # hardware.nvidia
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alik = {
    # hashedPasswordFile = "/etc/passwdfile";
    isNormalUser = true;
    description = "alik";
    extraGroups = [ "networkmanager" "wheel" "input" "vboxusers" "libvirt" ];
    packages = with pkgs; [
      thunderbird
      vscode
      obsidian
      neofetch
      klayout
      discord
      vlc
      heroic
      nextcloud-client
      tor-browser
      # davinci-resolve
      ffmpeg
	];
  };
  # home-manager
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "alik" = import ./home.nix;
    };

  };


  # home-manager.users.alik = {pkgs,...}:
  #   {
  #     programs.oh-my-posh.enable = true;
  #     programs.oh-my-posh.useTheme = "emodipt-extend";
  #   };

  environment.systemPackages = with pkgs; [
   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
   wget
   git
   nixd
   nerd-fonts.fira-code
  #  oh-my-posh
   protonup
   lutris
   steam
   hmcl #minecraft
   ungoogled-chromium
   mangohud
   gamemode
   spotify
   ghostty
   obs-studio
   shadps4
   nix-output-monitor
   unrar
   nvtopPackages.full
   nvd#nixos package version diff tool
   kdePackages.filelight
   foliate #ebook
   blender
   obs-studio
   eduvpn-client 
   gimp
   mpb
   virtiofsd# share files (virtmanager) 
	#];
#})
  ];

  environment.sessionVariables = {
    # HOME = "/home/alik";
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/alik/.steam/root/compatibilitytools.d";

  };
  networking.firewall.allowedTCPPorts = [ 57621 ];
  networking.firewall.allowedUDPPorts = [ 5353 ];
  # Enable automatic login for the user.services.displayManager.autoLogin
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "alik";

  #virtualbox setup
  # virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true;
  # virtualisation.virtualbox.guest.enable = true;
  # virtualisation.virtualbox.host.addNetworkInterface = false;
  #virt-manager
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  #Programs
  programs.firefox.enable = true;
  programs.kdeconnect.enable = true;

  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    gamescopeSession.enable = true;

};
  #STYLIX
  # stylix.image= /home/alik/Pictures/20241210_204004.jpg;

  # programs.heroic = {
    # enable = true;
  # };





  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

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
