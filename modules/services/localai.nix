{ vars, ... }:
let
  ollamaPort    = vars.ollama.port;
  openWebUiPort = vars.openWebUI.port;
  openWebUiHost = vars.openWebUI.hostName;
in
{
  networking.firewall.allowedTCPPorts = [ ];

  services.ollama = {
    enable = true;
    host = "127.0.0.1";
    port = ollamaPort;
    acceleration = "rocm";
  };

  services.open-webui = {
    enable = true;
    host = "127.0.0.1";
    port = openWebUiPort;
    environment.WEBUI_AUTH = "False";
  };

  services.caddy.virtualHosts."${openWebUiHost}".extraConfig = ''
    tls internal
    reverse_proxy 127.0.0.1:${toString openWebUiPort}
  '';
}