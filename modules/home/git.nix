{

  flake.homeModules.git =
    { pkgs, config, ... }:
    {
      sops.secrets.git_work_email = { };
      programs.git = {
        enable = true;
        signing.format = null;
        settings = {
          user.name = "alikaansun";
          user.email = "77810345+alikaansun@users.noreply.github.com";
          pull.rebase = "true";
          init.defaultBranch = "main";
          core.editor = "nvim";
          push.autoSetupRemote = "true";
        };
        # Replicating this on native Windows (no nix, no sops) — in PowerShell:
        #
        #   git config --global core.editor nvim
        #   git config --global init.defaultBranch main
        #   git config --global pull.rebase true
        #   git config --global push.autoSetupRemote true
        #   git config --global user.name alikaansun
        #   git config --global user.email 77810345+alikaansun@users.noreply.github.com
        #
        #   Set-Content -Path "$HOME\.gitconfig-work" -Value "[user]`n`temail = <work email>"
        #   git config --global includeIf."hasconfig:remote.*.url:git@gitlab.tue.nl:**/**".path "~/.gitconfig-work"
        includes = [
          {
            condition = "hasconfig:remote.*.url:git@gitlab.tue.nl:**/**";
            path = config.sops.secrets.git_work_email.path;
          }
        ];
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
