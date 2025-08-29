{ vars, ... }:
{
  networking.firewall.allowedTCPPorts = [ vars.openWebUI.port ];

  services.ollama = {
    enable = true;
    host = vars.ollama.IP;
    port = vars.ollama.port;
    acceleration = "rocm";
  };

  services.open-webui = {
    enable = true;
    host = vars.openWebUI.IP;
    port = vars.openWebUI.port;
    environment.WEBUI_AUTH = "True";
  };

  # Local access
  services.caddy.virtualHosts."${vars.openWebUI.hostName}:${toString vars.openWebUI.port}".extraConfig = ''
    tls internal
    reverse_proxy ${vars.openWebUI.IP}:${toString vars.openWebUI.port}
  '';

  # Tailscale access - simple reverse proxy
  services.caddy.virtualHosts."${vars.openWebUI.tailscaleHostName}".extraConfig = ''
    tls internal
    reverse_proxy ${vars.openWebUI.IP}:${toString vars.openWebUI.port}
  '';
}