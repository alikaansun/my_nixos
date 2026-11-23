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

  # duti only takes effect for a real UTI with the viewer/editor roles; bare
  # extensions and the "all" role are silently ignored on recent macOS.
  vlcAssociations =
    let
      utis = [
        "public.movie"
        "public.video"
        "public.audiovisual-content"
        "public.mpeg-4"
        "public.mpeg-2-video"
        "public.avi"
        "com.apple.quicktime-movie"
        "org.matroska.mkv"
        "public.mp3"
        "com.microsoft.waveform-audio"
        "public.aiff-audio"
      ];
      set = uti: role: "${pkgs.duti}/bin/duti -s org.videolan.vlc ${uti} ${role} || true";
    in
    builtins.concatStringsSep "\n" (
      builtins.concatMap (uti: [
        (set uti "viewer")
        (set uti "editor")
      ]) utis
    );
in
{
  imports = [
    self.homeModules.terminal
    self.homeModules.git
    self.homeModules.nvim
    self.homeModules.herdr
    self.homeModules.obs
    self.homeModules.sym
    self.homeModules.zotero
    # inputs.spicetify-nix.homeManagerModules.spicetify
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  sops.defaultSopsFile = ../../../secrets/secrets.yaml;

  sops.secrets.arondil_ipv4 = { };
  sops.secrets.arondil_lan_ipv4 = { };
  sops.secrets.ssh_work_hostname = { };
  sops.secrets.ssh_work_user = { };

  sops.templates."ssh-arondil-config".content = ''
    Host arondil
      HostName ${config.sops.placeholder.arondil_ipv4}
      User alik
      RequestTTY yes

    Host arondil-lan
      HostName ${config.sops.placeholder.arondil_lan_ipv4}
      User alik
      UserKnownHostsFile ~/.ssh/known_hosts ${config.sops.templates."arondil-known-hosts".path}
  '';
  # Pinned host key so non-interactive SSH (herdr machine status) never hits the trust prompt.
  sops.templates."arondil-known-hosts".content = ''
    ${config.sops.placeholder.arondil_lan_ipv4} ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK1BsXhFSLeipd2GMqDvzRoxYP9GzRWICY05cW19nSxr
  '';
  # herdr runs `ssh -T <target> <cmd>`, which ssh rejects when RemoteCommand is set,
  # so it gets its own alias without one.
  sops.templates."ssh-work-config".content = ''
    Host work ${config.sops.placeholder.ssh_work_hostname}
      RequestTTY yes
      RemoteCommand pwsh -NoLogo -NoExit

    Host work work-herdr ${config.sops.placeholder.ssh_work_hostname}
      HostName ${config.sops.placeholder.ssh_work_hostname}
      User ${config.sops.placeholder.ssh_work_user}
      IdentityFile ~/.ssh/id_ed25519
      IdentitiesOnly yes
  '';

  # herdr's saved-machine catalog. Being a store symlink, `herdr machine add/rename/remove`
  # can't write it; add machines here instead.
  xdg.stateFile."herdr/client/endpoints.json".text = builtins.toJSON {
    version = 1;
    ssh = [
      {
        id = "1acd50db388c6235ac9dbb43b351a1e3";
        label = "work";
        target = "work-herdr";
        session = "default";
        enabled = true;
      }
    ];
  };

  home.username = "alik";
  home.homeDirectory = "/Users/alik";
  home.stateVersion = "24.11";
  home.packages = with pkgs; [
    pythonEnv
    typst
    nodejs
  ];

  manual.manpages.enable = false;
  manual.html.enable = false;
  manual.json.enable = false;

  home.activation = {
    linkNixApps = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      # Links to apps dropped from the config dangle and block a Homebrew cask of the same name.
      for link in /Applications/*.app; do
        if [ -L "$link" ] && [ ! -e "$link" ]; then
          rm "$link"
          echo "  Removed stale link $(basename "$link")" >&2
        fi
      done
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

    setVlcDefault = config.lib.dag.entryAfter [ "linkNixApps" ] ''
      ${vlcAssociations}
    '';
  };

  home.sessionVariables.SOPS_AGE_KEY_FILE = "$HOME/.config/sops/age/keys.txt";

  programs.home-manager.enable = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [
      config.sops.templates."ssh-arondil-config".path
      config.sops.templates."ssh-work-config".path
    ];
  };
}
