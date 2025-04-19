{ ... }:

{

  stylix.enable = true;
  stylix.image = ./fav.jpg;
  # base16Scheme = "${pkgs.base16-schemes}/share/themes/onedark.yaml";
  stylix.polarity = "dark";
  # stylix.targets.gtk.enable = true;
  # fonts = {
      # monospace = {
        # package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
        # name = "JetBrainsMono Nerd Font";
      # };
    # };
  # fonts.sizes = {
    # applications = 10;
    # terminal = 13;
    # desktop = 10;
    # popups = 10;
  # };

}