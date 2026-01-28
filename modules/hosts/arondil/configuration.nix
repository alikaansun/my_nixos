{
  inputs,
  self,
  config,
  ...
}:
{
  # Define the nixosConfiguration for this host
  flake.nixosConfigurations.arondil = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs self; };

    modules = [
      self.nixosModules.hostArondil
      inputs.home-manager.nixosModules.home-manager
      {
        # home-manager = {
        #   useGlobalPkgs = true;
        #   useUserPackages = true;

        #   extraSpecialArgs = {
        #     inherit inputs;
        #     hostname = "arondil";
        #   };

        #   users = {
        #     alik = ./hosts/arondil/home.nix;
        #   };

        #   backupFileExtension = "backup";
        # };
      }
    ];
  };

  #Homeconfig
  flake.homeConfigurations."alik@arondil" = inputs.home-manager.lib.homeManagerConfiguration{



    
  };





  # Define the actual configuration module
  flake.nixosModules.hostArondil =
    { pkgs, ... }:
    {
      imports = [
        # ./hardware-configuration.nix # Dont disable it

        # Core system modules
        inputs.home-manager.nixosModules.home-manager
        inputs.sops-nix.nixosModules.sops

        #CUSTOM-MODULES
        self.nixosModules.locale # Dont disable it
        self.nixosModules.common # Dont disable it
        self.nixosModules.gc # garbage collection and store opt
        self.nixosModules.gaming
        self.nixosModules.virtualisation

        #self.nixosModules.localai

        #DESKTOP-MODULES
        self.nixosModules.kde
        self.nixosModules.caddy
        self.nixosModules.tailscale
        self.nixosModules.nextcloud

      ];
      home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;

          extraSpecialArgs = {
            inherit inputs;
            hostname = "arondil";
          };

          users = {
            alik = import ./hosts/arondil/home.nix;
          };

          backupFileExtension = "backup";
        };

      #Mount extra drive and make it
      fileSystems."/mnt/D" = {
        device = "/dev/disk/by-uuid/218ce1d4-70e8-4b81-aa2b-3abab153a6b4";
        fsType = "ext4";
        options = [
          "defaults"
          "rw"
        ];
      };
      fileSystems."/mnt/storage" = {
        device = "/dev/disk/by-uuid/d9fa4b2b-2319-4a8f-b84b-859182eaa719";
        fsType = "ext4";
        options = [
          "defaults"
          "rw"
          "user"
          "exec"
        ];
      };

      system.activationScripts.setStoragePermissions = {
        text = ''
          mkdir -p /mnt/D
          chown alik /mnt/D
          chmod -R 777 /mnt/D

          mkdir -p /mnt/storage
          mkdir -p /mnt/storage/AppData/openwebui

          # Set ownership for the mount point
          chown alik:users /mnt/storage
          chmod 755 /mnt/storage
          chown alik:users /mnt/storage/AppData
          chmod 755 /mnt/storage/AppData
        '';
        deps = [ ];
      };

      # Bridge network for nas
      networking = {
        hostName = "arondil";
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

      nixpkgs.config.rocmSupport = true;
      services.xserver.videoDrivers = [ "amdgpu" ];
      # services.xserver.videoDrivers = ["nvidia"];
      # hardware.nvidia = {
      #   modesetting.enable = true;
      #   open = true;
      # };

      # Enable automatic login for the user.services.displayManager.autoLogin
      services.displayManager.autoLogin.enable = true;
      services.displayManager.autoLogin.user = "alik";

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

    };
}
