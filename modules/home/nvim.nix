{
  flake.homeModules.nvim =
    {
      inputs,
      pkgs,
      lib,
      config,
      hostname,
      ...
    }:
    let
      dotfilesFlake = "${config.home.homeDirectory}/.dotfiles";
      systemAttr = if pkgs.stdenv.isDarwin then "darwinConfigurations" else "nixosConfigurations";
      flakeRef = "(builtins.getFlake \"${dotfilesFlake}\")";

      pythonExtraPaths = [
        "${config.home.homeDirectory}/Documents/Repos/rf_analyzer/src"
        "${config.home.homeDirectory}/Documents/Repos/Imodulator/src"
      ];
    in
    {
      imports = [ inputs.nvf.homeManagerModules.default ];

      home.packages = with pkgs; [
        tree-sitter
        imagemagick
        ghostscript
        ripgrep
        fd
        mermaid-cli
        tectonic
        trash-cli
      ];

      programs.nvf = {

        enable = true;
        settings = {
          ##################
          vim = {
            # --- 1. Core & Globals ---
            viAlias = true;
            vimAlias = true;

            # Set Space as the leader key
            globals = {
              mapleader = " ";
              maplocalleader = " ";
            };
            options = {
              smartindent = false;
              autoindent = false;
              # Open all folds when a file loads (no collapsed markdown headers)
              foldlevel = 99;
              foldlevelstart = 99;
            };
            # --- 2. UI & Theming ---
            theme = {
              enable = true;
              name = "gruvbox";
              style = "dark";
            };

            ui = {
              colorizer.enable = true; # Highlight color codes (e.g., #FFFFFF)
              borders = {
                enable = true;
                plugins = {
                  lsp-signature.enable = true;
                };
              };
            };

            statusline.lualine.enable = true;

            # Show open buffers as tabs for easy switching in the same session
            tabline.nvimBufferline = {
              enable = true;
              setupOpts.options.diagnostics = false;
            };

            extraPlugins = {
              kanagawa = {
                package = pkgs.vimPlugins.kanagawa-nvim;
              };
              nvim-surround = {
                package = pkgs.vimPlugins.nvim-surround;
                setup = "require('nvim-surround').setup()";
              };
              smear-cursor = {
                package = pkgs.vimPlugins.smear-cursor-nvim;
                setup = ''
                  require("smear_cursor").setup({
                    cursor_color = "#fbf1c7",
                    stiffness = 0.8,
                    trailing_stiffness = 0.6,
                    stiffness_insert_mode = 0.9,
                    trailing_stiffness_insert_mode = 0.7,
                    distance_stop_animating = 0.5,
                  })
                '';
              };
              snacks-nvim = {
                package = pkgs.vimPlugins.snacks-nvim;
                setup = ''
                  require("snacks").setup({
                    image = { enabled = true },
                    explorer = { enabled = true },
                    picker = { enabled = true },
                    indent = { enabled = true },
                    notifier = { enabled = true },
                    scroll = { enabled = true },
                    statuscolumn = { enabled = true },
                    dashboard = {
                      enabled = true,
                      sections = {
                        { section = "header" },
                        { section = "keys", gap = 1 },
                        { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = { 2, 2 } },
                        { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
                      },
                    },
                  })
                '';
              };
              csvview-nvim = {
                package = pkgs.vimPlugins.csvview-nvim;
                setup = "require('csvview').setup()";
              };
              render-markdown-nvim = {
                package = pkgs.vimPlugins.render-markdown-nvim;
                setup = "require('render-markdown').setup()";
              };
              claudecode-nvim = {
                package = pkgs.vimPlugins.claudecode-nvim;
                setup = "require('claudecode').setup()";
              };
            };

            luaConfigRC = {
              datFileType = ''
                vim.filetype.add {
                  extension = {
                    dat = "csv"
                  }
                }
              '';
              # Treesitter's nix indent queries misjudge let/in and attrsets,
              # producing erratic indentation on <CR> that other filetypes'
              # grammars don't suffer from. Fall back to plain autoindent
              # (copy previous line) for nix; nixfmt fixes real formatting
              # on save anyway.
              nixIndentFix = ''
                vim.api.nvim_create_autocmd("FileType", {
                  pattern = "nix",
                  callback = function()
                    vim.opt_local.indentexpr = ""
                    vim.opt_local.autoindent = true
                  end,
                })
              '';
            };

            # --- 3. Navigation & Terminal ---
            telescope.enable = true; # Fuzzy finder for files, ripgrep, etc.

            terminal.toggleterm = {
              enable = true;
              lazygit.enable = true;
              mappings = {
                open = "<c-t>";
              };
            };

            # --- 4. Utilities & Git ---
            binds.whichKey.enable = true; # Keybind helper popups
            git.enable = true;

            notes.obsidian = {
              enable = true;
            };

            # --- 5. LSP, Autocomplete & Core Language Features ---
            autocomplete.nvim-cmp = {
              enable = true;
              # Drop cmp-buffer: it suggests any token in the buffer (numbers,
              # words inside strings/comments) with no syntax awareness.
              # Keep completion LSP-driven, like VSCode.
              setupOpts.sources = lib.mkForce (
                map (name: { inherit name; }) [
                  "nvim_lsp"
                  "path"
                ]
              );
            };

            treesitter = {
              enable = true;
              indent.enable = true;
              grammars =
                with pkgs.vimPlugins.nvim-treesitter.builtGrammars;
                [
                  css
                  html
                  javascript
                  latex
                  markdown
                  markdown_inline
                  scss
                  svelte
                  tsx
                  typst
                  vue
                  regex
                  yaml
                ]
                ++ [
                  pkgs.tree-sitter-grammars.tree-sitter-norg
                ];
            };

            lsp = {
              enable = true;
              lspSignature.enable = true;
              servers.basedpyright.settings.basedpyright.analysis.extraPaths = pythonExtraPaths;
              # basedpyright has no formatting capability, so the default
              # <leader>lf -> vim.lsp.buf.format errors on Python files.
              # Route through conform instead, which has ruff-fix registered
              # and falls back to the LSP formatter for everything else.
              mappings.format = null;
            };

            # nvf's ruff preset passes `--config "format.indent-width = ..."`, which
            # current ruff rejects (indent-width is no longer a [format] key). The
            # preset also defines these args itself, hence mkForce to override it.
            formatter.conform-nvim.setupOpts.formatters.ruff.args = lib.mkForce [
              "format"
              "--config"
              "format.indent-style = 'tab'"
              "--config"
              "format.quote-style = 'double'"
              "--force-exclude"
              "--stdin-filename"
              "$FILENAME"
              "-"
            ];

            lsp.servers.nixd.settings = {
              nixpkgs.expr = "import ${flakeRef}.inputs.nixpkgs { }";
              formatting.command = [ "nixfmt" ];
              options = {
                nixos.expr = "${flakeRef}.${systemAttr}.${hostname}.options";
                home-manager.expr = "${flakeRef}.${systemAttr}.${hostname}.options.home-manager.users.type.getSubOptions []";
              };
            };

            # --- 6. Specific Language Support ---
            languages = {
              enableFormat = true;
              enableTreesitter = true;
              # enableExtraDiagnostics = true;

              nix = {
                enable = true;
                format = {
                  enable = true;
                  type = [ "nixfmt" ];
                };
                lsp.enable = true;
                lsp.servers = [ "nixd" ];
              };

              bash.enable = true;
              python = {
                enable = true;
                format = {
                  enable = true;
                  type = [
                    "ruff-fix"
                    "ruff"
                  ];
                };
                lsp = {
                  enable = true;
                  servers = [ "basedpyright" ];
                };
              };
              clang.enable = true;
              typst = {
                enable = true;
                extensions.typst-preview-nvim.enable = true;
                format.enable = true;
                lsp.enable = true;
                treesitter.enable = true;
              };
            };

            keymaps =
              # <leader>b<N> jumps to the Nth buffer in the bufferline
              (builtins.genList (i: {
                key = "<leader>b${toString (i + 1)}";
                action = "<cmd>BufferLineGoToBuffer ${toString (i + 1)}<cr>";
                mode = "n";
                desc = "Go to buffer ${toString (i + 1)}";
                silent = true;
              }) 9)
              ++ [
                {
                  key = "<leader>bx";
                  action = "<cmd>lua Snacks.bufdelete()<cr>";
                  mode = "n";
                  desc = "Close buffer";
                  silent = true;
                }
                {
                  key = "<leader>bt";
                  action = "<cmd>enew<cr>";
                  mode = "n";
                  desc = "New buffer";
                  silent = true;
                }
              ]
              # <C-h/j/k/l> window navigation; mode "t" makes it work from
              # inside terminal buffers (toggleterm, Claude) without <C-\><C-n>
              ++ (map
                (dir: {
                  key = "<C-${dir}>";
                  action = "<cmd>wincmd ${dir}<cr>";
                  mode = [
                    "n"
                    "t"
                  ];
                  desc = "Window ${dir}";
                  silent = true;
                })
                [
                  "h"
                  "j"
                  "k"
                  "l"
                ]
              )
              ++ [
                {
                  key = "<leader>wv";
                  action = "<cmd>vsplit<cr>";
                  mode = "n";
                  desc = "Split window vertically";
                  silent = true;
                }
                {
                  key = "<leader>w-";
                  action = "<cmd>split<cr>";
                  mode = "n";
                  desc = "Split window horizontally";
                  silent = true;
                }
                {
                  key = "<leader>wc";
                  action = "<cmd>close<cr>";
                  mode = "n";
                  desc = "Close split (keep buffer)";
                  silent = true;
                }
                {
                  key = "<leader>wo";
                  action = "<cmd>only<cr>";
                  mode = "n";
                  desc = "Close other splits";
                  silent = true;
                }
                {
                  key = "<leader>w=";
                  action = "<cmd>wincmd =<cr>";
                  mode = "n";
                  desc = "Equalize split sizes";
                  silent = true;
                }
                {
                  key = "<leader>lf";
                  action = "<cmd>lua require('conform').format({ async = true, lsp_fallback = true })<cr>";
                  mode = "n";
                  desc = "Format buffer";
                  silent = true;
                }
                {
                  key = "<leader>tp";
                  action = "<cmd>TypstPreviewToggle<cr>";
                  mode = "n";
                  desc = "Toggle Typst preview";
                  silent = true;
                }
                {
                  key = "<leader>?";
                  action = "<cmd>Telescope keymaps<cr>";
                  mode = "n";
                  desc = "Search keymaps";
                  silent = true;
                }
                {
                  key = "<leader>e";
                  action = "<cmd>lua Snacks.explorer()<cr>";
                  mode = "n";
                  desc = "Toggle file tree";
                  silent = true;
                }
                {
                  key = "<leader>ac";
                  action = "<cmd>ClaudeCode<cr>";
                  mode = "n";
                  desc = "Toggle Claude";
                  silent = true;
                }
                {
                  key = "<leader>as";
                  action = "<cmd>ClaudeCodeSend<cr>";
                  mode = [
                    "n"
                    "v"
                  ];
                  desc = "Send to Claude";
                  silent = true;
                }
                {
                  key = "<leader>aa";
                  action = "<cmd>ClaudeCodeDiffAccept<cr>";
                  mode = [
                    "n"
                    "v"
                  ];
                  desc = "Accept diff";
                  silent = true;
                }
                {
                  key = "<leader>ad";
                  action = "<cmd>ClaudeCodeDiffDeny<cr>";
                  mode = [
                    "n"
                    "v"
                  ];
                  desc = "Deny diff";
                  silent = true;
                }
                {
                  key = "<leader>yp";
                  action = "<cmd>let @+ = expand('%:p')<cr>";
                  mode = "n";
                  desc = "Yank absolute file path";
                  silent = true;
                }
                {
                  key = "<leader>yr";
                  action = "<cmd>let @+ = expand('%:.')<cr>";
                  mode = "n";
                  desc = "Yank relative file path";
                  silent = true;
                }
                {
                  key = "<leader>y";
                  action = "\"+y";
                  mode = "v";
                  desc = "Yank selection to clipboard";
                  silent = true;
                }
                {
                  key = "<leader>yy";
                  action = "\"+yy";
                  mode = "n";
                  desc = "Yank line to clipboard";
                  silent = true;
                }
                {
                  key = "<leader>ya";
                  action = "<cmd>%y+<cr>";
                  mode = "n";
                  desc = "Yank whole file to clipboard";
                  silent = true;
                }
                {
                  key = "<leader>p";
                  action = "\"+p";
                  mode = [
                    "n"
                    "v"
                  ];
                  desc = "Paste from clipboard";
                  silent = true;
                }
              ];

            #End of Vim
          };
          ############
        };
      };
    };
}
