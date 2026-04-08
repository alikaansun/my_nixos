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
    self.homeModules.zed
    self.homeModules.git
    self.homeModules.nvim
  ];
  home.username = "alik";
  home.homeDirectory = "/Users/alik";
  home.stateVersion = "24.11";
  home.packages = with pkgs; [
    pythonEnv
    typst
  ];

  home.activation = {
    linkNixApps = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      nix_apps="/Applications/Nix Apps"
      if [ -d "$nix_apps" ]; then
        find "$nix_apps" -maxdepth 1 -name '*.app' | while read -r app; do
          name="$(basename "$app")"
          target="/Applications/$name"
          if [ -L "$target" ]; then
            rm "$target"
          fi
          if [ ! -e "$target" ]; then
            ln -s "$app" "$target"
            echo "  Linked $name" >&2
          fi
        done
      fi
    '';

    # yabai-reloader = ''
    #   run yabai --restart-service
    #   run sudo yabai --load-sa
    #   '';

  };

  programs.home-manager.enable = true;
}
