{
  # Expects the host to import sops-nix and set sops.defaultSopsFile / sops.age.keyFile.
  flake.homeModules.ssh =
    {
      config,
      lib,
      osConfig,
      ...
    }:
    {
      sops.secrets.arondil_ipv4 = { };
      sops.secrets.arondil_lan_ipv4 = { };
      sops.secrets.ssh_work_hostname = { };
      sops.secrets.ssh_work_user = { };

      # Pinned host key so non-interactive SSH (herdr machine status) never hits the trust prompt.
      sops.templates."arondil-known-hosts".content = ''
        ${config.sops.placeholder.arondil_lan_ipv4} ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK1BsXhFSLeipd2GMqDvzRoxYP9GzRWICY05cW19nSxr
      '';
      # One file on purpose: home-manager joins `includes` into a single `Include a b` line,
      # and VS Code Remote-SSH silently skips multi-path Include lines.
      sops.templates."ssh-config".content = ''
        Host arondil
          HostName ${config.sops.placeholder.arondil_ipv4}
          User alik
          RequestTTY yes

        Host arondil-lan
          HostName ${config.sops.placeholder.arondil_lan_ipv4}
          User alik
          UserKnownHostsFile ~/.ssh/known_hosts ${config.sops.templates."arondil-known-hosts".path}

        # herdr (`ssh -T <target> <cmd>`) and VS Code can't use an alias with RemoteCommand,
        # so they connect via work-herdr.
        Host work ${config.sops.placeholder.ssh_work_hostname}
          RequestTTY yes
          RemoteCommand pwsh -NoLogo -NoExit

        Host work work-herdr ${config.sops.placeholder.ssh_work_hostname}
          HostName ${config.sops.placeholder.ssh_work_hostname}
          User ${config.sops.placeholder.ssh_work_user}
          IdentityFile ~/.ssh/id_ed25519
          IdentitiesOnly yes
      '';

      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        includes = [ config.sops.templates."ssh-config".path ];
      };

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
        ]
        ++ lib.optional (osConfig.networking.hostName != "arondil") {
          id = "cce40968d8cdfc9846a85808dc71f010";
          label = "arondil";
          target = "arondil-lan";
          session = "default";
          enabled = true;
        };
      };
    };
}
