{
  config,
  pkgs,
  inputs,
  hostname,
  self,
  ...
}:
let
  pythonEnv = import ../../../_files/pythonEnv.nix { inherit pkgs; };
in
{

  imports = [
    self.homeModules.common
    self.homeModules.plasma
    self.homeModules.zed
    self.homeModules.terminal
    self.homeModules.nvim
    self.homeModules.git
  ];
  
  home.username = "alik";
  home.homeDirectory = "/home/alik";
  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    # Creative apps
    pythonEnv
    blender # 3D modeling and animation
    gimp # Image editing
    texliveFull
    onlyoffice-desktopeditors
    tor-browser
    ardour # Audio recording and editing
    # musescore      # Music notation software
  ];

  # home.file = {
  # };

  # home.sessionVariables = {
  #   # EDITOR = "emacs";
  # };
  
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  

}
