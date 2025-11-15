{ inputs, pkgs, ... }:
# let
#   oldPkgs = import inputs.shad06_nixpkgs { system = pkgs.system; };
# in
{
  environment.systemPackages = with pkgs; [
    protonup-ng
    lutris
    heroic
    hmcl # minecraft
    # oldPkgs.shadps4
    shadps4
    gamemode
    wineWowPackages.full
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
  };

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/alik/.steam/root/compatibilitytools.d";
  };

  # Gamescope fails to launch when used within Steam
  # Gamescope may fail to start due to missing Xorg libraries. (#214275) To resolve this override the steam package to add them:
  # programs.steam.package = pkgs.steam.override {
  #   extraPkgs = pkgs:
  #     with pkgs; [
  #       xorg.libXcursor
  #       xorg.libXi
  #       xorg.libXinerama
  #       xorg.libXScrnSaver
  #       libpng
  #       libpulseaudio
  #       libvorbis
  #       stdenv.cc.cc.lib
  #       libkrb5
  #       keyutils
  #     ];
  # };
  networking.firewall.allowedTCPPorts = [ 57621 ];
  networking.firewall.allowedUDPPorts = [ 5353 ];
}
