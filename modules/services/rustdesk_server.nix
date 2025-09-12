{ pkgs, vars,  ... }:

{

  services.rustdesk-server={
    enable=true;
    openFirewall = true;
    # signal.relayHosts = [];

  };

}
