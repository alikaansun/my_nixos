{
  flake.nixosModules.stylix = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      base16-schemes
    ];
    stylix = {
      enable = true;
      image = ./fav.jpg;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
      polarity = "dark";
      targets.gtk.enable = true;
      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.fira-code;
          name = "Fira Code Mono Nerd Font";
        };
        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };
        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans";
        };
        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
        sizes = {
          applications = 10;
          terminal = 13;
          desktop = 10;
          popups = 10;
        };
      };

      # };
    };
  };
}
