
{ pkgs,inputs,config,... }:

{

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}"]; # Good thing to have for LSP

  nixpkgs.config.allowUnfree = true;
  # Enable networking
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  networking.networkmanager.enable = true;

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
  sops.defaultSopsFile = ./secrets/secrets.yaml;
  # sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/alik/.config/sops/age/keys.txt";
  
  
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alik = {
    # hashedPasswordFile = "/etc/passwdfile";
    isNormalUser = true;
    description = "alik";
    extraGroups = [ "networkmanager" "wheel" "input" "vboxusers" "libvirt" "uinput"];
    # packages = with pkgs; [];
  };
  # home-manager
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "alik" = import ../hosts/${config.networking.hostName}/home.nix;
    };
    backupFileExtension = "backup";

  };
  
  programs.chromium = {
    enable = true;
    enablePlasmaBrowserIntegration = true;
    extensions = [
      "oboonakemofpalcgghocfoadofidjkkk" # keepassxc
      "ekhagklcjbdpajgpjgmbionohlpdbjgc" # zotero
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "cimiefiiaegbelhefglklhhakcgmhkai" # plasmintegration
    ];

  };

  programs.bash.completion.enable=true;

  environment.systemPackages = with pkgs; [
   wget
   age
   sops
   git
   nvd#nixos package version diff tool
   nixd#nix language server
   nixfmt-rfc-style #nix language server
   nerd-fonts.fira-code
   nerd-fonts.meslo-lg
   unrar
   gparted
   nvtopPackages.full
   kdePackages.filelight
   eduvpn-client 
   lm_sensors
   (chromium
  #  .override {commandLineArgs = [
      # "--force-device-scale-factor=1"
      # "--disable-features=UseOzonePlatform"
      #"--enable-features=VaapiVideoDecoder"
      # "--ozone-platform=wayland"  # or "x11" if you prefer
    # ];
  # }
  )
    inputs.zen-browser.packages."${system}".default
  ];
  


}


