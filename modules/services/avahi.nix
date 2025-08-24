{ pkgs,... }:

{
  environment.systemPackages =  [
    pkgs.avahi
  ];

  services.avahi = {
    enable = true;
    package = pkgs.avahi;
    nssmdns4 = true; # Integrate with system name resolution
    publish = {
      enable = true;
      addresses = true;
      userServices = true;
      workstation = true;
    };

  };

}