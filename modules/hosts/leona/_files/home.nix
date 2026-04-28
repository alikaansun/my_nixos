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
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in
{
  imports = [
    self.homeModules.terminal
    # self.homeModules.zed
    self.homeModules.git
    self.homeModules.nvim
    inputs.spicetify-nix.homeManagerModules.spicetify
  ];
  home.username = "alik";
  home.homeDirectory = "/Users/alik";
  home.stateVersion = "24.11";
  home.packages = with pkgs; [
    pythonEnv
    typst
  ];

  ##Spicetify
  programs.spicetify = {
    enable = true;
    spicetifyPackage=pkgs.spicetify-cli;
    spotifyPackage=pkgs.spotify;
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      hidePodcasts
      shuffle # shuffle+ (special characters are sanitized out of extension names)
    ];
    theme = spicePkgs.themes.dribbblish;
    colorScheme = "gruvbox-material-dark";
    # theme = spicePkgs.themes.onepunch;
    # colorScheme = "dark";

  };

home.activation = {
  linkNixApps = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    for nix_apps in "/Applications/Nix Apps" "$HOME/Applications/Home Manager Apps" "$HOME/Applications"; do
      if [ -d "$nix_apps" ]; then
        find "$nix_apps" -maxdepth 1 -name '*.app' -print0 | while IFS= read -r -d "" app; do
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
    done
  '';
};

  programs.home-manager.enable = true;
}
