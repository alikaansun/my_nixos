{

  flake.homeModules.git =
    { pkgs, config, ... }:
    {
      # sops.secrets.git_email = { };
      programs.git = {
        enable = true;
        signing.format = null;
        settings = {
          user.name = "alik";
          user.email = "asunnetcoglu@gmail.com"; # config.sops.secrets.git_email.path;
          pull.rebase = "true";
          init.defaultBranch = "main";
          # safe.directory="/etc/nixos";
          # url = {
          #   "ssh://git@github.com/" = {
          #     insteadOf = "https://github.com/";
          #   };
          # };
        };
      };

      programs.lazygit = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          gui.theme = {
            lightTheme = false;
            activeBorderColor = [
              "#a9b665"
              "bold"
            ];
            inactiveBorderColor = [ "#a89984" ];
            optionsTextColor = [ "#7daea3" ];
            selectedLineBgColor = [ "#32302f" ];
            unstagedChangesColor = [ "#ea6962" ];
            defaultFgColor = [ "#d4be98" ];
          };
        };
      };
    };
}
