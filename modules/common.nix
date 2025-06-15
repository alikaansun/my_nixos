
{ pkgs,inputs,... }:

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
   nixfmt-rfc-style #nix language server
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
  services.trezord.enable = true;


}


