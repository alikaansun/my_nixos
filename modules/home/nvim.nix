{
  flake.homeModules.nvim =
    { inputs, pkgs, ... }:
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
            tabline.nvimBufferline.enable = true;

            extraPlugins = {
              nvim-surround = {
                package = pkgs.vimPlugins.nvim-surround;
                setup = "require('nvim-surround').setup()";
              };
              smear-cursor = {
                package = pkgs.vimPlugins.smear-cursor-nvim;
                setup = ''
                  require("smear_cursor").setup({
                    cursor_color = "#fbf1c7",
                  })
                '';
              };
              snacks-nvim = {
                package = pkgs.vimPlugins.snacks-nvim;
                setup = ''
                  require("snacks").setup({
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
            autocomplete.nvim-cmp.enable = true;

            treesitter = {
              enable = true;
              indent.enable = false;
              grammars =
                with pkgs.vimPlugins.nvim-treesitter.builtGrammars;
                [
                  css
                  html
                  javascript
                  latex
                  scss
                  svelte
                  tsx
                  typst
                  vue
                  regex
                ]
                ++ [
                  pkgs.tree-sitter-grammars.tree-sitter-norg
                ];
            };

            lsp = {
              enable = true;
              lspSignature.enable = true;
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
              python.enable = true;
              clang.enable = true;
              typst = {
                enable = true;
                extensions.typst-preview-nvim.enable = true;
                format.enable = true;
                lsp.enable = true;
                treesitter.enable = true;
              };
            };

            keymaps = [
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
            ];

            #End of Vim
          };
          ############
        };
      };
    };
}
