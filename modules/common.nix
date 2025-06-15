
{ pkgs,inputs,... }:

{

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}"]; # Good thing to have for LSP

  nixpkgs.config.allowUnfree = true;
  # Enable networking
  networking.networkmanager.enable = true;


  environment.systemPackages = with pkgs; [
   wget
   git
   nvd#nixos package version diff tool
   nixd#nix language server
   nixfmt-rfc-style #nix language server
   nerd-fonts.fira-code
   nerd-fonts.meslo-lg
   chromium
   unrar
   gparted
   nvtopPackages.full
   kdePackages.filelight
   eduvpn-client 

	#];   
#})
  ];
  services.trezord.enable = true;


}


