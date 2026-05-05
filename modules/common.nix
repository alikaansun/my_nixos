{
  flake.nixosModules.common =
    {
      pkgs,
      inputs,
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
        shell = pkgs.zsh;
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
      programs.zsh.enable = true;
      # home-manager

      # Enable the X11 windowing system.
      services.xserver.enable = true;
      # Configure keymap in X11
      services.xserver.xkb = {
        layout = "us,tr";
        variant = "";
        # options = "grp:alt_shift_toggle";
      };

      #Wayland
      # services.displayManager.sddm = {
      #   enable = true;
      #   wayland.enable = true;
      # };
      programs.firefox.enable = true;

      environment.systemPackages = with pkgs; [
        age
        sops
        git
        nixd # nix language server
        nil
        nixfmt # nix formatter
        nixfmt-tree # treefmt
        nerd-fonts.fira-code
        nerd-fonts.meslo-lg
        gparted
        kdePackages.filelight
        eduvpn-client
        usbutils
        nfs-utils
        cifs-utils
        trezor-suite
        brave
        # texliveFull
        # protonmail-desktop
        # inputs.zen-browser.packages."${system}".default
      ];
      # Set your time zone.
      time.timeZone = "Europe/Berlin";

      # Select internationalisation properties.
      i18n.defaultLocale = "en_US.UTF-8";
      i18n.extraLocaleSettings = {
        LANGUAGE = "en_US.UTF-8";
        LC_CTYPE = "en_US.UTF-8"; # Optional: ensures input/encoding is English
        LC_ADDRESS = "nl_NL.UTF-8";
        LC_COLLATE = "nl_NL.UTF-8";
        LC_IDENTIFICATION = "nl_NL.UTF-8";
        LC_MEASUREMENT = "nl_NL.UTF-8";
        LC_MESSAGES = "en_US.UTF-8";
        LC_MONETARY = "nl_NL.UTF-8";
        LC_NAME = "nl_NL.UTF-8";
        LC_NUMERIC = "nl_NL.UTF-8";
        LC_PAPER = "nl_NL.UTF-8";
        LC_TELEPHONE = "nl_NL.UTF-8";
        LC_TIME = "nl_NL.UTF-8";
      };
    };
}
