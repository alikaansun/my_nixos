{
  flake.homeModules.wow =
    { inputs, pkgs, ... }:
    let
      # home-manager runs on the global pkgs, so a nixpkgs.overlays entry here would be ignored.
      wow-addons = (inputs.nix-warcraft.overlays.default pkgs pkgs).wow-addons;
    in
    {
      imports = [ inputs.nix-warcraft.homeManagerModules.default ];

      programs.wow = {
        enable = true;
        # Battle.net's clicks land in the wrong place under Wine's native Wayland driver.
        wayland = false;
        versions.retail.addonPackages = with wow-addons; [
          bigwigs.core
          enhance-qol
          gatherlite
          baganator
        ];
      };
    };
}
