{

  flake.darwinModules.aerospace =
    { pkgs, ... }:
    {
      services.aerospace = {
        enable = true;
        settings = {
          persistent-workspaces = [
            "1"
            "2"
            "3"
            "4"
            "5"
          ];
          on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
          enable-normalization-flatten-containers = true;
          enable-normalization-opposite-orientation-for-nested-containers = true;
          # exec-on-workspace-change = ["/bin/bash c sketchybar --trigger aerospace_workspace_change FOCUSED=$AEROSPACE_FOCUSED_WORKSPACE"];
          gaps = {
            outer.left = 8;
            outer.bottom = 8;
            outer.top = 8;
            outer.right = 8;
          };
          mode.main.binding = {
            alt-j = "focus left";
            alt-k = "focus down";
            alt-l = "focus up";
            alt-p = "focus right";

            alt-1 = "workspace 1";
            alt-2 = "workspace 2";
            alt-3 = "workspace 3";
            alt-4 = "workspace 4";
            alt-5 = "workspace 5";

            cmd-h = ""; # Disable "hide application"
            cmd-alt-h = ""; # Disable "hide others"

            #modes
            alt-r = "mode resize";
          };
          mode.service.binding = {
            alt-shift-j = [
              "join-with left"
              "mode main"
            ];
            alt-shift-k = [
              "join-with down"
              "mode main"
            ];
            alt-shift-l = [
              "join-with up"
              "mode main"
            ];
            alt-shift-p = [
              "join-with right"
              "mode main"
            ];
            f = [
              "layout floating tiling"
              "mode main"
            ];
          };
          # on-window-detected = [];
        };

      };

    };
}
