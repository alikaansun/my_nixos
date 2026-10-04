{
  flake.nixosModules.gaming =
    { inputs, pkgs, ... }:
    # let
    #   oldPkgs = import inputs.shad06_nixpkgs { system = pkgs.system; };
    # in
    {
      environment.systemPackages = with pkgs; [
        # lutris
        heroic
        hmcl # minecraft
        # oldPkgs.shadps4
        shadps4
        gamemode
        wineWow64Packages.full
        # wine-staging
        mangohud
      ];

      programs.gamemode.enable = true;

      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        gamescopeSession.enable = true;
        extraCompatPackages = [ pkgs.proton-ge-bin ];
      };

      networking.firewall.allowedTCPPorts = [ 57621 ];
      networking.firewall.allowedUDPPorts = [ 5353 ];
    };
}
