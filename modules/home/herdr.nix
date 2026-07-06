{
  flake.homeModules.herdr =
    {
      inputs,
      pkgs,
      ...
    }:
    let
      tomlFormat = pkgs.formats.toml { };

      # Full schema: `herdr --default-config` or https://herdr.dev/docs/configuration/
      settings = {
        onboarding = true;

        update = {
          channel = "stable";
          version_check = false;
        };

        terminal = {
          default_shell = "zsh";
          shell_mode = "auto";
          new_cwd = "follow";
        };

        theme = {
          name = "gruvbox";
          auto_switch = false;
        };

        ui = {
          sidebar_width = 26;
          confirm_close = true;
          agent_panel_sort = "priority";

          toast = {
            delivery = "system";
            delay_seconds = 1;
          };

          sound = {
            enabled = false;
          };
        };

        session.resume_agents_on_restore = true;

        experimental.kitty_graphics = true;

        keys = {
          prefix = "ctrl+b";

          rename_tab = "prefix+r";
          next_workspace = "prefix+shift+n";
          previous_workspace = "prefix+shift+p";
          rename_workspace = "prefix+shift+r";

          resize_mode = "";
          reload_config = "";
          new_workspace = "prefix+shift+w";
          rename_pane = "prefix+shift+e";

          next_agent = "prefix+shift+j";
          previous_agent = "prefix+shift+k";
        };
      };
    in
    {
      home.packages = [
        inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];

      xdg.configFile."herdr/config.toml".source = tomlFormat.generate "herdr-config.toml" settings;
    };
}
