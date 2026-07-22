{
  flake = {
    homeModules.yazi =
      {
        pkgs,
        inputs,
        config,
        ...
      }:
      {
        programs.yazi = {
          enable = true;
          enableBashIntegration = false;
          shellWrapperName = "y";
          enableZshIntegration = true;
          plugins = {
            lazygit = inputs.yazi-lazygit;
            nbpreview = inputs.yazi-nbpreview;
            zoom = inputs.yazi-zoom;

          }
          // pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
            clippy = inputs.yazi-clippy;
          }
          // pkgs.lib.optionalAttrs pkgs.stdenv.isLinux {
            clipboard = inputs.yazi-clipboard;
          };
          keymap = {
            mgr = {
              prepend_keymap = [
                {
                  on = [
                    "g"
                    "i"
                  ];
                  run = "plugin lazygit";
                  desc = "Run lazygit";
                }
                {
                  on = "-";
                  run = "plugin zoom -1";
                  desc = "Zoom out hovered file";
                }
                {
                  on = "+";
                  run = "plugin zoom 1";
                  desc = "Zoom in hovered file";
                }

              ]
              ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
                {
                  on = [
                    "c"
                    "y"
                  ];
                  run = [
                    "yank"
                    "plugin clippy"
                  ];
                  desc = "Yank and Copy to system clipboard";
                }
              ]
              ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
                {
                  on = [
                    "c"
                    "y"
                  ];
                  run = [
                    "yank"
                    "plugin clipboard -- --action=copy"
                  ];
                  desc = "Yank and Copy to system clipboard";
                }
              ];
            };
          };
          extraPackages = with pkgs; [
            glow
            ouch
            fzf
            zoxide
            _7zz-rar
            exiftool
            imagemagick
          ];
          settings = {
            plugin = {
              prepend_previewers = [
                {
                  url = "*.ipynb";
                  run = "nbpreview";
                }
              ];
            };
            preview = {
              # image_filter = "lanczos3";
              # image_quality = 90;
              tab_size = 1;
              max_width = 1800;
              max_height = 2000;
              cache_dir = "";
              ueberzug_scale = 1;
              ueberzug_offset = [
                0
                0
                0
                0
              ];
            };
            yazi = {
              ratio = [
                1
                4
                3
              ];
              sort_by = "natural";
              sort_sensitive = true;
              sort_reverse = false;
              sort_dir_first = true;
              linemode = "none";
              show_hidden = true;
              show_symlink = true;
            };
            opener = {
              vlc = [
                {
                  run = if pkgs.stdenv.isDarwin then "open -a VLC %1" else "vlc %1";
                  orphan = true;
                  desc = "Open in VLC";
                }
              ];
              edit = [
                {
                  run = "nvim %s";
                  block = true;
                }
              ];
              klayout = [
                {
                  run = if pkgs.stdenv.isDarwin then "open -a klayout %1" else "klayout %1";
                  orphan = true;
                  desc = "Open in KLayout";
                }
              ];
            };
            open = {
              prepend_rules = [
                {
                  mime = "video/*";
                  use = "vlc";
                }
                {
                  mime = "audio/*";
                  use = "vlc";
                }
                {
                  url = "*.gds";
                  use = "klayout";
                }
              ];
            };
          };
        };
      };
  };
}
