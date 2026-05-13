{
  flake.homeModules.nvim =
    { inputs, pkgs, ... }:
    {
      imports = [ inputs.nvf.homeManagerModules.default ];
      
      home.packages = with pkgs; [
        tree-sitter-cli
      ];

      programs.nvf = {

        enable = true;
        settings = {
          ##################
          vim = {
            viAlias = false;
            vimAlias = true;
            theme = {
              enable = true;
              name = "gruvbox";
              style = "dark";
            };
            languages = {
              enableTreesitter = true;
              nix.enable = true;
              bash.enable = true;
              python.enable = true;
              clang.enable = true;
            };
            statusline.lualine.enable = true;
            telescope.enable = true;
          };
          ############
        };
      };
    };
}
