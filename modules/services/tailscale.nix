{
  flake.nixosModules.tailscale = { pkgs, config, ... }: {
    environment.systemPackages = [
      pkgs.tailscale
    ];

    services.tailscale = {
      enable = true;
      package = pkgs.tailscale;
      useRoutingFeatures = "both";
    };

    networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];
    # Allow Tailscale traffic
    networking.firewall.trustedInterfaces = [ "tailscale0" ];
  };
}
