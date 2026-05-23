{
  flake.homeModules.nvim =
    { inputs, pkgs, ... }:
    {
      imports = [ inputs.nvf.homeManagerModules.default ];

      home.packages = with pkgs; [
        tree-sitter

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

            # --- 5. LSP, Autocomplete & Core Language Features ---
            autocomplete.nvim-cmp.enable = true;

            treesitter = {
              enable = true;
            };

            lsp = {
              enable = true;
              # lsp-signature is EXCELLENT!
              # It shows a popup with the function arguments you are typing.
              lspSignature.enable = true;
            };

            # --- 6. Specific Language Support ---
            languages = {
              enableFormat = true;
              enableTreesitter = true; # Relies on the core treesitter enabled above
              enableExtraDiagnostics = true;

              nix = {
                enable = true;
                format = {
                  type = "nixfmt";
                };
              };

              bash.enable = true;
              python.enable = true;
              clang.enable = true;
            };
          };
          ############
        };
      };
    };
}
