{
  config,
  pkgs,
  inputs,
  hostname,
  self,
  ...
}:

{
  imports = [
    self.homeModules.terminal
    # self.homeModules.zed
    self.homeModules.git
    self.homeModules.nvim
    # self.homeModules.skhd
  ];
  home.username = "alik";
  home.homeDirectory = "/Users/alik";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
