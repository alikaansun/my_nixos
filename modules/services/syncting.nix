{vars, config, pkgs, ... }:

{
  config = {
    sops.secrets.syncthing = {};

  # systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync folder.  See https://wiki.nixos.org/wiki/Syncthing
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    # I change the address SyncThing uses (which is also how you access the
    # browser UI).  This is to avoid conflicts with the other SyncThing instances
    # I have on the same machine.  Namely, from different WSL2 instances.
    guiAddress = "${vars.syncthing.IP}:${toString vars.syncthing.port}";
    user = "alika";
    group = "users";
    configDir = "/home/alika/.config/syncthing";
    # Override all settings set from the GUI.  This is necessary if I don't want
    # to have changes made from the GUI apply.
    overrideDevices = true;
    overrideFolders = true;
    # Settings: this is where you set up devices and folders
    settings = {
      gui = {
            user = "alik";
            password = config.sops.syncthing.passwd.path;
          };
      devices = {
        "Reania" = {       # Name of SyncThing instance on other machine
          id = config.sops.syncthing.devices.reania.path; # Elided for privacy
        };
        "Phone" = {       # Name of SyncThing instance on mobile device
          id = config.sops.syncthing.devices.phone.path; # Elided for privacy
        };
      };
  
      folders = {
        "Zotero" = {           # The ID of a folder you'd like to sync
          label = "Zotero";       # Optional device-specific folder name
          path = "/mnt/storage/AppData/Zotero";
          # Share with these devices
          devices = [
            "Reania"
            "Phone"
          ];
        };
        "Notes" = {           # The ID of a folder you'd like to sync
          label = "Notes";        # Optional device-specific folder name
          path = "/mnt/storage/AppData/Notes";
          # Share with these devices
          devices = [
            "Reania"
            "Phone"
          ];
        };
        "Keep" = {           # The ID of a folder you'd like to sync
          label = "Keep";        # Optional device-specific folder name
          path = "/mnt/storage/AppData/Keep";
          # Share with these devices
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
