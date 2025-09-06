{vars, config, pkgs, ... }:

{
  config = {
    sops.secrets = {
      synct_passwd = {};
      synct_reania = {};
      synct_phone = {};
    };

  # systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync folder.  See https://wiki.nixos.org/wiki/Syncthing
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    # I change the address SyncThing uses (which is also how you access the
    # browser UI).  This is to avoid conflicts with the other SyncThing instances
    # I have on the same machine.  Namely, from different WSL2 instances.
    # guiAddress = "${vars.syncthing.IP}:${toString vars.syncthing.port}";
    # configDir = "/home/alika/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    # Settings: this is where you set up devices and folders
    settings = {
      # gui = {
            # user = "alik";
            # password = config.sops.secrets.synct_passwd.path;
          # };
      devices = {
        "Reania" = {       
          id = config.sops.secrets.synct_reania.path; 
        };
        "Phone" = {      
          id = config.sops.secrets.synct_phone.path; 
        };
      };
  
      folders = {
        "Zotero" = {           
          label = "Zotero";       
          path = "/mnt/storage/AppData/Zotero";
          devices = [
            "Reania"
            "Phone"
          ];
        };
        "Notes" = {         
          label = "Notes";        
          path = "/mnt/storage/AppData/Notes";
          devices = [
            "Reania"
            "Phone"
          ];
        };
        "Keep" = {           
          label = "Keep";        
          path = "/mnt/storage/AppData/Keep";
          devices = [
            "Reania"
            "Phone"
          ];
        };
      };
    };
  };
  
      # networking.firewall.allowedTCPPorts = [ vars.seafile.port ];
  
      # services.caddy.virtualHosts."${vars.seafile.hostName}".extraConfig = ''
      #   tls internal
      #   reverse_proxy 127.0.0.1:${toString vars.seafile.port}
      # '';
    };
}
