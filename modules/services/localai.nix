{
  flake.nixosModules.localai = { vars, ... }: {
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
      # stateDir="/var/lib/open-webui";
    };

    #Check opencode

    # Create a symlink or bind mount to your storage
    # systemd.tmpfiles.rules = [
    #   "d /mnt/storage/AppData/openwebui 0777 - - -"
    #   "L+ /var/lib/open-webui - - - - /mnt/storage/AppData/openwebui"
    # ];

    # Local access - Remove the port from the hostname
    services.caddy.virtualHosts."${vars.openWebUI.hostName}".extraConfig = ''
      tls internal
      reverse_proxy ${vars.openWebUI.IP}:${toString vars.openWebUI.port}
    '';

  };
}
