{ pkgs,... }:

{
  environment.systemPackages =  [
    pkgs.avahi
  ];

  services.avahi = {
    enable = true;
    package = pkgs.avahi;
    nssmdns = true; # Integrate with system name resolution
    publish = {
      enable = true;
      addresses = true;
      userServices = true;
      workstation = true;
    };

  };

}