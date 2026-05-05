{
  flake.nixosModules.audiobookshelf =
    {
      pkgs,
      lib,
      vars,
      ...
    }:
    {
      networking.firewall.allowedTCPPorts = [ vars.audiobookshelf.port ];

      services.audiobookshelf = {
        enable = true;
        port = vars.audiobookshelf.port;
        host = vars.audiobookshelf.IP;
        dataDir = "media/audiobookshelf";
        openFirewall = true;

      };

      # Local access
      services.caddy.virtualHosts."${vars.audiobookshelf.hostName}".extraConfig = ''
        tls internal
        reverse_proxy ${vars.audiobookshelf.IP}:${toString vars.audiobookshelf.port}
      '';
    };
}
