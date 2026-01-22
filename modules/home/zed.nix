{ pkgs, config, ... }:
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
          model = "claude-haiku-4.5";
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
        mode = "light";
        light = "Material Icon Theme";
        dark = "Zed (Default)";
      };

      ui_font_size = 16;
      buffer_font_size = 15;

      theme = {
        mode = "dark";
        light = "Gruvbox Light Hard";
        dark = "Ayu Mirage";
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
            diagnostics = {
              suppress = [ "sema-extra-with" ];
            };
            options = {
              # Host configs
              "nixos-arondil" = {
                expr = "(builtins.getFlake \"/home/alik/.dotfiles/flake.nix\").nixosConfigurations.arondil.options";
              };
              "home-manager-arondil" = {
                expr = "(builtins.getFlake \"/home/alik/.dotfiles/flake.nix\").homeConfigurations.alik@arondil.options";
              };
            };
          };
        };
      };

      languages = {
        Nix = {
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
}
