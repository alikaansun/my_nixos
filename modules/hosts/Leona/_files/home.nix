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
    self.homeModules.terminal
    # self.homeModules.zed
    self.homeModules.git
    self.homeModules.nvim
    self.homeModules.skhd
  ];
  home.username = "alik";
  home.homeDirectory = "/Users/alik";
  home.stateVersion = "24.11";

  home.packages = [
    pythonEnv
  ];

  programs.home-manager.enable = true;
}
