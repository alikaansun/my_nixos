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
        onboarding = true; # skip the first-run wizard

        update = {
          channel = "stable";
          version_check = false; # Nix owns updates, not herdr's self-checker
        };

        terminal = {
          default_shell = "zsh";
          shell_mode = "auto"; # "auto" | "login" | "non_login"
          new_cwd = "follow"; # "follow" | "home" | "current" | <path>
        };

        theme = {
          name = "gruvbox"; # matches your Stylix Gruvbox Dark
          auto_switch = false;
        };

        ui = {
          sidebar_width = 32;
          confirm_close = true;
          agent_panel_sort = "priority"; # roll workspaces up by most urgent agent state

          toast = {
            delivery = "system"; # "off" | "herdr" | "terminal" | "system"
            delay_seconds = 1;
          };

          sound = {
            enabled = true;
            # Per-agent sound: "default" | "on" | "off"
            agents.claude = "on";
          };
        };

        # Native session restore for Claude Code (and Codex, Copilot CLI, etc.)
        # when you start running agents inside herdr.
        session.resume_agents_on_restore = true;
      };
    in
    {
      home.packages = [
        inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];

      xdg.configFile."herdr/config.toml".source =
        tomlFormat.generate "herdr-config.toml" settings;
    };
}
