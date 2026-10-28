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

      programs.lazygit =
        let
          # Kanagawa Wave, matching the ghostty palette in terminal.nix
          c = {
            fg = "#dcd7ba";
            gray = "#54546d";
            blue = "#7e9cd8";
            brightBlue = "#7fb4ca";
            red = "#c34043";
            selection = "#2d4f67";
            addBg = "#2b3328";
            addEmphBg = "#3b4a35";
            delBg = "#43242b";
            delEmphBg = "#5a2a33";
          };
        in
        {
          enable = true;
          enableZshIntegration = true;
          settings = {
            git.diffRenderers = [
              {
                command = "${pkgs.delta}/bin/delta --{{colorScheme}} --paging=never --syntax-theme=ansi --plus-style='syntax ${c.addBg}' --minus-style='syntax ${c.delBg}' --plus-emph-style='syntax ${c.addEmphBg}' --minus-emph-style='syntax ${c.delEmphBg}' --hunk-header-decoration-style='${c.blue} box' --file-decoration-style='${c.blue} ul' --file-style='${c.brightBlue} bold'";
              }
            ];
            gui.theme = {
              lightTheme = false;
              activeBorderColor = [
                c.blue
                "bold"
              ];
              inactiveBorderColor = [ c.gray ];
              optionsTextColor = [ c.brightBlue ];
              selectedLineBgColor = [ c.selection ];
              unstagedChangesColor = [ c.red ];
              defaultFgColor = [ c.fg ];
            };
          };
        };
    };
}
