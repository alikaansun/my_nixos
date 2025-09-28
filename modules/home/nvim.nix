{ inputs, ... }:
{
  imports = [ inputs.nvf.homeManagerModules.default ];
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

}
