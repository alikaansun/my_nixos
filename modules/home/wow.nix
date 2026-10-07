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
        versions.retail.addonPackages = with wow-addons; [
          bigwigs.core
        ];
      };
    };
}
