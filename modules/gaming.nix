{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    protonup
    lutris
    heroic
    hmcl# minecraft
    shadps4 
    gamemode
    wineWowPackages.full
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

  # networking.firewall.allowedTCPPorts = [ 57621 ];
  # networking.firewall.allowedUDPPorts = [ 5353 ];
}