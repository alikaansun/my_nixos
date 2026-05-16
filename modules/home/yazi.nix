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
            lazygit = pkgs.fetchFromGitHub {
              owner = "Lil-Dank";
              repo = "lazygit.yazi";
              rev = "e73fd74c2af3300368b33da1cfbab6a8649a41a8";
              hash = "sha256-KPvjXjYE0W4Q2xZiVfMwZbtalHt0FbgLtEK4sUWbYOI=";
            };
          }
          // pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
            clippy = pkgs.fetchFromGitHub {
              owner = "gallardo994";
              repo = "clippy.yazi";
              rev = "8ce55413976ebd1922dbc4fc27ced9776823df54";
              hash = "sha256-oB9DkNWvUDbSAPnxtv56frlWWYz5vtu2BJVvWH/Uags=";
            };
          }
          // pkgs.lib.optionalAttrs pkgs.stdenv.isLinux {
            clipboard = pkgs.fetchFromGitHub {
              owner = "XYenon";
              repo = "clipboard.yazi";
              rev = "68b506d9a9c2c5dde01a078a589520f551d05fe5";
              sha256 = "1377hqip0cbp0zr3y091k8fvpcnarr27x30lx1cjxxjvq68p1l4c";
            };
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
              ]
              ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
                {
                  on = [
                    "c"
                    "y"
                  ];
                  run = ["yank"
                   "plugin clippy"];
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
            preview = {
              # image_filter = "lanczos3";
              # image_quality = 90;
              tab_size = 1;
              max_width = 600;
              max_height = 900;
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
              edit = [
                {
                  run = "nvim %s"; 
                  block = true;
                }
              ];
              klayout = [
                {
                  run =
                    if pkgs.stdenv.isDarwin then
                      "open -a klayout %1"
                    else
                      "klayout %1"; 
                  orphan = true;
                  desc = "Open in KLayout";
                }
              ];
            };
            open = {
              prepend_rules = [
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