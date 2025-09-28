{
  pkgs,
  inputs,
  config,
  ...
}:

{

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ]; # Good thing to have for LSP

  nixpkgs.config.allowUnfree = true;

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  # sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/alik/.config/sops/age/keys.txt";

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alik = {
    # hashedPasswordFile = "/etc/passwdfile";
    isNormalUser = true;
    description = "alik";
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "vboxusers"
      "libvirt"
      "uinput"
    ];
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,tr";
    variant = "";
    # options = "grp:alt_shift_toggle";
  };

  #Wayland
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  programs.chromium = {
    enable = true;
    enablePlasmaBrowserIntegration = true;
    extensions = [
      "oboonakemofpalcgghocfoadofidjkkk" # keepassxc
      "ekhagklcjbdpajgpjgmbionohlpdbjgc" # zotero
      "cimiefiiaegbelhefglklhhakcgmhkai" # plasmintegration
    ];

  };

  programs.bash.completion.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    age
    sops
    git
    nvd # nixos package version diff tool
    nix-output-monitor
    tldr
    nixd # nix language server
    nixfmt-rfc-style # nix formatter
    nixfmt-tree # treefmt
    nerd-fonts.fira-code
    nerd-fonts.meslo-lg
    unrar
    gparted
    nvtopPackages.full
    kdePackages.filelight
    eduvpn-client
    lm_sensors
    pciutils
    nfs-utils
    cifs-utils
    trezor-suite
    (
      chromium
      #  .override {commandLineArgs = [
      # "--force-device-scale-factor=1"
      # "--disable-features=UseOzonePlatform"
      #"--enable-features=VaapiVideoDecoder"
      # "--ozone-platform=wayland"  # or "x11" if you prefer
      # ];
      # }
    )
    # inputs.zen-browser.packages."${system}".default
  ];

}
