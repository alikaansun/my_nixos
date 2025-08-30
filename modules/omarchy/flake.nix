{
  description = "Omarchy function library";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    omarchy-nix = {
      url = "github:henrysipp/omarchy-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, omarchy-nix, home-manager, sops-nix, ... }: 
    let
      system = "x86_64-linux";
      username = "alik";

      mkOmarchy = hostname: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { };
        modules = [
          omarchy-nix.nixosModules.default
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          {
            # Basic system configuration
            boot.loader.systemd-boot.enable = true;
            boot.loader.efi.canTouchEfiVariables = true;
            
            networking.hostName = hostname;
            networking.networkmanager.enable = true;
            
            time.timeZone = "Europe/Berlin";
            i18n.defaultLocale = "en_US.UTF-8";
            
            users.users.${username} = {
              isNormalUser = true;
              description = username;
              extraGroups = [ "networkmanager" "wheel" ];
            };
            
            # SOPS configuration
            sops.defaultSopsFile = ./secrets/secrets.yaml;
            sops.age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
            sops.secrets.git_email = {};
            
            # Configure omarchy
            omarchy = {
              full_name = username;
              email_address = "lol@lol.com";
              theme = "gruvbox";
              scale = 1;
              exclude_packages = with nixpkgs.legacyPackages.${system}; [
                lazydocker
                lazygit
                docker-compose
                fastfetch
                vlc
                signal-desktop
                typora
                dropbox
                spotify
                gh
                github-desktop
              ];
            };
            
            home-manager = {
              users.${username} = {
                imports = [ omarchy-nix.homeManagerModules.default ];
                home.stateVersion = "25.05";
              };
              extraSpecialArgs = { };
              backupFileExtension = "backup";
            };
            
            system.stateVersion = "25.05";
          }
        ];
      };
    in
    {
      lib = { inherit mkOmarchy; };
    };
}