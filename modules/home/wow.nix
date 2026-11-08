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
        # nix-warcraft's default still points at proton-ge-nix's removed `v11` attr.
        protonPackage = inputs.proton-ge-nix.packages.${pkgs.stdenv.hostPlatform.system}.proton-ge.steamcompattool;
        versions.forever = {
          # Battle.net installed the game on /mnt/D, not inside the Proton prefix the module defaults to.
          addonDir = "/mnt/D/games/battlenet/World of Warcraft/_forever_/Interface/AddOns";
          addonPackages = with wow-addons; [
            bigwigs.core
            gatherlite
            whats-training
            baganator
            handynotes
            questie
            auctionator
            forever-dungeon-journal
            rarescanner-forever
            rxp-guides
            syndicator
            compass-forever
          ];
        };
      };
    };
}
