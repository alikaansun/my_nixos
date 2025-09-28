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

  outputs =
    {
      nixpkgs,
      omarchy-nix,
      home-manager,
      sops-nix,
      ...
    }:
    let
      system = "x86_64-linux";
      username = "alik";

      mkOmarchy =
        hostname: actualHost:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { };
          modules = [
            omarchy-nix.nixosModules.default
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops

            (../../hosts/${actualHost}/hardware-configuration.nix)
            ../../modules/locale.nix
            ../../modules/gc.nix
            ../../modules/gaming.nix
            ../../modules/services/kanata.nix
            {
              # Basic system configuration
              boot.loader.systemd-boot.enable = true;
              boot.loader.efi.canTouchEfiVariables = true;

              networking.hostName = actualHost;
              networking.networkmanager.enable = true;

              # time.timeZone = "Europe/Berlin";
              # i18n.defaultLocale = "en_US.UTF-8";

              users.users.${username} = {
                isNormalUser = true;
                description = username;
                extraGroups = [
                  "networkmanager"
                  "wheel"
                ];
              };

              # SOPS configuration
              sops.defaultSopsFile = ../secrets/secrets.yaml;
              sops.age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
              sops.secrets.git_email = { };

              services.mykanata = {
                enable = true;
              };
              # Configure omarchy
              omarchy = {
                full_name = username;
                email_address = "lol@lol.com";
                theme = "gruvbox";
                # theme_overrides = {
                #   wallpaper_path = /home/alik/.dotfiles/modules/desktop/fav.jpg;
                # };
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
                quick_app_bindings = [
                  "SUPER, Y, exec, $webapp=https://youtube.com/"
                  "SUPER SHIFT, G, exec, $webapp=https://web.whatsapp.com/"
                  "SUPER, X, exec, $webapp=https://x.com/"
                  "SUPER SHIFT, X, exec, $webapp=https://x.com/compose/post"

                  "SUPER, return, exec, $terminal"
                  "SUPER, F, exec, $fileManager"
                  "SUPER, B, exec, $browser"
                  "SUPER, M, exec, $music"
                  "SUPER, N, exec, $terminal -e nvim"
                  "SUPER, T, exec, $terminal -e btop"
                  "SUPER, D, exec, $terminal -e lazydocker"
                  "SUPER, G, exec, $messenger"
                  "SUPER, O, exec, obsidian -disable-gpu"
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
