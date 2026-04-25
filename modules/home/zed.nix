{
  flake.homeModules.zed =
    { hostname, pkgs, ... }:
    let
      isDarwin = pkgs.stdenv.isDarwin;
      flakePath = if isDarwin then "/Users/alik/.dotfiles" else "/home/alik/.dotfiles";
      osConfigName = if isDarwin then "darwinConfigurations" else "nixosConfigurations";
      osName = if isDarwin then "darwin" else "nixos";
    in
    {
      programs.zed-editor = {
        enable = true;
        # Automatically install extensions
        extensions = [
          "nix"
          "toml"
          "material icon theme"
          "latex"
          "csv"
          "rainbow csv"
          "python lsp"
        ];

        # This replaces your settings.json
        userSettings = {
          agent = {
            default_model = {
              provider = "copilot_chat";
              model = "claude-sonnet-4.6";
            };
            model_parameters = [ ];
          };

          git_panel = {
            tree_view = true;
            dock = "right";
          };

          session = {
            trust_all_worktrees = true;
          };

          terminal = {
            font_family = "FiraCode Nerd Font Mono";
          };

          base_keymap = "VSCode";

          minimap = {
            show = "never";
          };

          scrollbar = {
            axes = {
              vertical = true;
            };
          };

          autosave = "on_focus_change";
          buffer_font_family = "FiraCode Nerd Font";
          show_edit_predictions = false;

          icon_theme = {
            mode = "dark";
            light = "Material Icon Theme";
            dark = "Material Icon Theme";
          };

          ui_font_size = 17;
          buffer_font_size = 15;

          theme = {
            mode = "dark";
            light = "Gruvbox Light Hard";
            dark = "Gruvbox Dark Hard";
          };

          lsp = {
            nil = {
              settings = {
                diagnostics = {
                  ignored = [ "unused_binding" ];
                };
              };
            };
            nixd = {
              settings = {
                diagnostic = {
                  suppress = [ "sema-extra-with" ];
                };
                # options = {
                #   # Host configs
                #   nixos = {
                #     expr = "(builtins.getFlake \"${flakePath}\").nixosConfigurations.arondil.options";
                #   };
                #   nix-darwin = {
                #     expr = "(builtins.getFlake \"${flakePath}\").darwinConfigurations.leona.options";
                #   };
                #   home-manager = {
                #     expr = "(builtins.getFlake \"${flakePath}\").darwinConfigurations.leona.options.home-manager.users.type.getSubOptions []";
                #   };
                # };
              };
            };
          };

          languages = {
            Nix = {
              language_servers = [
                "nixd"
                "nil"
              ];
              format_on_save = "on";
              formatter = {
                external = {
                  command = "nixfmt";
                  arguments = [ ];
                };
              };
            };
            Python = {
              format_on_save = "off";
            };
          };
        };
      };
    };
}
