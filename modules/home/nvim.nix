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

      borderGreen = "#89D185";

      jupynvimPlugin = pkgs.callPackage ../_files/jupynvim { };

      pythonExtraPaths = [
        "${config.home.homeDirectory}/Documents/Repos/rf_analyzer/src"
        "${config.home.homeDirectory}/Documents/Repos/Imodulator/src"
      ];

      # Keymap builders: `key` defaults to normal-mode + silent; `keyM` takes
      # explicit mode(s) for visual/terminal binds.
      keyM = mode: k: action: desc: {
        inherit mode action desc;
        key = k;
        silent = true;
      };
      key = keyM "n";

      # <leader>b<N> jumps to the Nth buffer in the bufferline.
      bufferKeys = builtins.genList (
        i:
        key "<leader>b${toString (i + 1)}" "<cmd>BufferLineGoToBuffer ${toString (i + 1)}<cr>"
          "Go to buffer ${toString (i + 1)}"
      ) 9;

      # <C-h/j/k/l> window navigation; mode "t" makes it work from inside
      # terminal buffers (toggleterm, Claude) without <C-\><C-n>.
      windowNavKeys =
        builtins.map (dir: keyM [ "n" "t" ] "<C-${dir}>" "<cmd>wincmd ${dir}<cr>" "Window ${dir}")
          [
            "h"
            "j"
            "k"
            "l"
          ];

      # Fold group under <leader>c: each suffix mirrors the native z-command
      # (swap `z` for `<leader>c`).
      foldKeys = builtins.map ({ s, desc }: key "<leader>c${s}" "z${s}" desc) [
        {
          s = "a";
          desc = "Toggle fold under cursor";
        }
        {
          s = "c";
          desc = "Close fold under cursor";
        }
        {
          s = "o";
          desc = "Open fold under cursor";
        }
        {
          s = "M";
          desc = "Close all folds";
        }
        {
          s = "R";
          desc = "Open all folds";
        }
        {
          s = "m";
          desc = "Fold more (one level)";
        }
        {
          s = "r";
          desc = "Fold less (one level)";
        }
        {
          s = "j";
          desc = "Jump to next fold";
        }
        {
          s = "k";
          desc = "Jump to previous fold";
        }
      ];

      nvimKeymaps =
        bufferKeys
        ++ [
          (key "<leader>bx" "<cmd>lua Snacks.bufdelete()<cr>" "Close buffer")
          (key "<leader>bt" "<cmd>enew<cr>" "New buffer")
        ]
        ++ windowNavKeys
        ++ [
          (key "<leader>wv" "<cmd>vsplit<cr>" "Split window vertically")
          (key "<leader>w-" "<cmd>split<cr>" "Split window horizontally")
          (key "<leader>wc" "<cmd>close<cr>" "Close split (keep buffer)")
          (key "<leader>wo" "<cmd>only<cr>" "Close other splits")
          (key "<leader>w=" "<cmd>wincmd =<cr>" "Equalize split sizes")
          (key "<leader>lf" "<cmd>lua require('conform').format({ async = true, lsp_fallback = true })<cr>"
            "Format buffer"
          )
        ]
        ++ foldKeys
        ++ [
          (key "<leader>tp" "<cmd>TypstPreviewToggle<cr>" "Toggle Typst preview")
          (key "<leader>?" "<cmd>Telescope keymaps<cr>" "Search keymaps")
          (key "<leader>e" "<cmd>lua Snacks.explorer()<cr>" "Toggle file tree")
          (key "<leader>ac" "<cmd>ClaudeCode<cr>" "Toggle Claude")
          (keyM [ "n" "v" ] "<leader>as" "<cmd>ClaudeCodeSend<cr>" "Send to Claude")
          (keyM [ "n" "v" ] "<leader>aa" "<cmd>ClaudeCodeDiffAccept<cr>" "Accept diff")
          (keyM [ "n" "v" ] "<leader>ad" "<cmd>ClaudeCodeDiffDeny<cr>" "Deny diff")
          (key "<leader>yp" "<cmd>let @+ = expand('%:p')<cr>" "Yank absolute file path")
          (key "<leader>yr" "<cmd>let @+ = expand('%:.')<cr>" "Yank relative file path")
          (keyM "v" "<leader>y" "\"+y" "Yank selection to clipboard")
          (key "<leader>yy" "\"+yy" "Yank line to clipboard")
          (key "<leader>ya" "<cmd>%y+<cr>" "Yank whole file to clipboard")
          (keyM [ "n" "v" ] "<leader>p" "\"+p" "Paste from clipboard")
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
        python3Packages.pylatexenc
      ];

      programs.nvf = {

        enable = true;
        settings = {
          ##################
          vim = {
            # --- 1. Core & Globals ---
            viAlias = true;
            vimAlias = true;
            lineNumberMode = "number";

            # Set Space as the leader key
            globals = {
              mapleader = " ";
              maplocalleader = " ";
            };
            options = {
              smartindent = false;
              autoindent = false;
              # Treesitter-driven folds so <leader>c can collapse functions.
              foldmethod = "expr";
              foldexpr = "v:lua.vim.treesitter.foldexpr()";
              # Open all folds when a file loads (nothing collapsed until asked)
              foldlevel = 99;
              foldlevelstart = 99;
            };
            # --- 2. UI & Theming ---
            theme = {
              enable = false;
              # name = "gruvbox";
              # style = "dark";
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
              vscode-nvim = {
                package = pkgs.vimPlugins.vscode-nvim;
                setup = ''
                  require("vscode").setup({
                    transparent = true,
                    color_overrides = { vscFront = "#CCCCCC" },
                  })
                  require("vscode").load()
                  vim.api.nvim_set_hl(0, "WinSeparator", { fg = "${borderGreen}" })
                  vim.api.nvim_set_hl(0, "FloatBorder", { fg = "${borderGreen}" })
                  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
                '';
              };
              nvim-surround = {
                package = pkgs.vimPlugins.nvim-surround;
                setup = "require('nvim-surround').setup()";
              };
              smear-cursor = {
                package = pkgs.vimPlugins.smear-cursor-nvim;
                setup = ''
                  require("smear_cursor").setup({
                    cursor_color = "#AEAFAD",
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
                    image = { enabled = true, math = { enabled = false } },
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
              telescope-media-files = {
                package = pkgs.vimPlugins.telescope-media-files-nvim;
                setup = "require('telescope').load_extension('media_files')";
              };
              jupynvim = {
                package = jupynvimPlugin;
                setup = "require('jupynvim').setup({})";
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
              autoSave = ''
                vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave", "WinLeave" }, {
                  command = "silent! wall",
                })
              '';
              autoRead = ''
                vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "TermClose", "TermLeave" }, {
                  command = "silent! checktime",
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
              setupOpts.shade_terminals = false;
            };

            # --- 4. Utilities & Git ---
            binds.whichKey.enable = true; # Keybind helper popups
            git = {
              enable = true;
              git-conflict.mappings = {
                ours = "<leader>gco";
                theirs = "<leader>gct";
                both = "<leader>gcb";
                none = "<leader>gc0";
              };
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
              # Upstream nix injections already cover script/pre*/post*, the
              # write*Script builders, and a `# <lang>` comment above a string.
              # These add the attribute names this config embeds code in.
              queries = [
                {
                  type = "injections";
                  filetypes = [ "nix" ];
                  loadtype = "extends";
                  query = ''
                    (binding attrpath: (attrpath (identifier) @_p)
                      expression: (_ (string_fragment) @injection.content)
                      (#eq? @_p "setup")
                      (#set! injection.language "lua") (#set! injection.combined))

                    (binding attrpath: (attrpath (identifier) @_p)
                      expression: (attrset_expression (binding_set (binding
                        expression: (_ (string_fragment) @injection.content))))
                      (#eq? @_p "luaConfigRC")
                      (#set! injection.language "lua"))

                    (binding attrpath: (attrpath (identifier) @_p)
                      expression: (_ (string_fragment) @injection.content)
                      (#any-of? @_p "initContent" "config" "text")
                      (#set! injection.language "bash") (#set! injection.combined))
                  '';
                }
              ];
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
            # current ruff rejects (indent-width is no longer a [format] key), hence
            # mkForce to override the preset. No `--config` style flags of our own: ruff
            # auto-discovers each project's [tool.ruff]/ruff.toml by walking up from the
            # file, so project config wins (CLI --config would override it). Absent a
            # project config it falls back to ruff defaults (4-space, double quotes).
            # --force-exclude keeps ruff honoring exclude patterns for the explicitly
            # named file conform passes via --stdin-filename.
            formatter.conform-nvim.setupOpts.formatters.ruff.args = lib.mkForce [
              "format"
              "--force-exclude"
              "--stdin-filename"
              "$FILENAME"
              "-"
            ];

            # Format nix with the same treefmt that `nix fmt` runs, rather than
            # nvf's nixfmt preset: that one passes --indent=<shiftwidth>, so
            # Neovim's default of 8 reindents whole files away from `nix fmt`.
            # cwd follows the buffer so treefmt resolves the right tree root.
            formatter.conform-nvim.setupOpts = {
              formatters.treefmt = {
                command = lib.getExe pkgs.nixfmt-tree;
                args = [
                  "--stdin"
                  "$FILENAME"
                ];
                stdin = true;
                cwd = lib.generators.mkLuaInline "function(self, ctx) return ctx.dirname end";
              };
              formatters_by_ft.nix = [ "treefmt" ];
            };

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
                # Formatting comes from the treefmt entry above, not an nvf preset.
                format.enable = false;
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

            keymaps = nvimKeymaps;

            #End of Vim
          };
          ############
        };
      };
    };
}
