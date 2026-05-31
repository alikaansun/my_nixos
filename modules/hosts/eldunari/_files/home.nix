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
    self.homeModules.nvim
    self.homeModules.git

  ];

  home.username = "alik";
  home.homeDirectory = "/home/alik";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [

    texliveFull
    typst

  ];

  manual.manpages.enable = false;
  manual.html.enable = false;
  manual.json.enable = false;

  programs.home-manager.enable = true;

}
