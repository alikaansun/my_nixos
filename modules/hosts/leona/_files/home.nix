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
    self.homeModules.git
    self.homeModules.nvim
    self.homeModules.herdr
    self.homeModules.obs
    self.homeModules.sym
    inputs.spicetify-nix.homeManagerModules.spicetify
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  sops.defaultSopsFile = ../../../secrets/secrets.yaml;

  sops.secrets.ssh_work_hostname = { };
  sops.secrets.ssh_work_user = { };

  sops.templates."ssh-work-config".content = ''
    Host work
      HostName ${config.sops.placeholder.ssh_work_hostname}
      User ${config.sops.placeholder.ssh_work_user}
      RequestTTY yes
      RemoteCommand pwsh -NoLogo -NoExit
  '';

  home.username = "alik";
  home.homeDirectory = "/Users/alik";
  home.stateVersion = "24.11";
  home.packages = with pkgs; [
    pythonEnv
    typst
    zotero
  ];

  # Obsidian (programs.obsidian + vault target) is configured in obs.nix.
  # Claude Code config/memory/skills live in the vault and are symlinked into
  # ~/.claude by sym.nix. Both imported above.

  manual.manpages.enable = false;
  manual.html.enable = false;
  manual.json.enable = false;

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

  home.sessionVariables.SOPS_AGE_KEY_FILE = "$HOME/.config/sops/age/keys.txt";

  programs.home-manager.enable = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [ config.sops.templates."ssh-work-config".path ];
  };
}
