{ pkgs, vars, config, ... }:

{
  config={
    sops.secrets = {
      arondil_ipv4= {};
    };
    
    services.rustdesk-server={
    enable=true;
    openFirewall = true;
    signal.relayHosts = [ config.sops.secrets.arondil_ipv4.path];
    # relay.extraArgs=["-k" "_"];
    # signal.extraArgs=["-k" "_"];
    };
  };

  

}
