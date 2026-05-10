{
  flake.darwinModules.aerospace =
    { lib, config, pkgs, ... }:
    let
      commonBindings = {
        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";
        alt-5 = "workspace 5";
        alt-m = "workspace m";

        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
        alt-shift-4 = "move-node-to-workspace 4";
        alt-shift-5 = "move-node-to-workspace 5";
        alt-shift-m = "move-node-to-workspace m";

        alt-shift-f = "layout floating tiling";

        #App Bindings
        cmd-enter = "exec-and-forget open -b com.mitchellh.ghostty";
        cmd-space = "exec-and-forget open -n -b com.brave.Browser";
        cmd-e = "exec-and-forget open ~"; # finder home director
        ctrl-alt-v = "exec-and-forget open -n -b com.microsoft.VSCode";
        ctrl-alt-d = "exec-and-forget open -b com.hnc.Discord";
        ctrl-alt-o = "exec-and-forget open -b md.obsidian";
        ctrl-alt-k = "exec-and-forget open -b org.keepassxc.keepassxc";
        ctrl-alt-m = "exec-and-forget open -b com.spotify.client";
      };
    in
    {
      services.aerospace = {
        enable = true;
        settings = {
          after-startup-command = [
            "exec-and-forget ${pkgs.sketchybar}/bin/sketchybar"
          ];

          exec-on-workspace-change = [
            "/bin/bash"
            "-c"
            "${pkgs.sketchybar}/bin/sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
          ];

          # start-at-login = true;
          on-focused-monitor-changed = [ "move-mouse window-lazy-center" ];
          enable-normalization-flatten-containers = true;
          enable-normalization-opposite-orientation-for-nested-containers = true;
          accordion-padding = 70;
          key-mapping.preset = "qwerty";
          automatically-unhide-macos-hidden-apps = true;
          gaps = {
            outer.left = 8;
            outer.bottom = 8;
            outer.top = 8;
            outer.right = 8;
            inner.horizontal = 6;
            inner.vertical = 6;
          };

          # App specific behavior
          on-window-detected = [
            {
              "if".app-id = "com.apple.finder";
              run = [ "layout floating" ];
            }
            {
              "if".app-id = "com.apple.systempreferences";
              run = [ "layout floating" ];
            }
            {
              "if".app-id = "com.apple.ActivityMonitor";
              run = [ "layout floating" ];
            }
            {
              "if".app-id = "com.microsoft.VSCode";
              run = [ "move-node-to-workspace 2" ];
            }
            {
              "if".app-id = "com.microsoft.teams2";
              run = [ "move-node-to-workspace 5" ];
            }
            {
              "if".app-id = "com.microsoft.teams";
              run = [ "move-node-to-workspace 5" ];
            }
            {
              "if".app-id = "com.microsoft.Outlook";
              run = [ "move-node-to-workspace 5" ];
            }
          ];

          mode.main.binding = {
            alt-j = "focus left";
            alt-k = "focus down";
            alt-l = "focus up";
            alt-p = "focus right";
            alt-semicolon = "focus right";

            alt-shift-j = "join-with left";
            alt-shift-k = "join-with down";
            alt-shift-l = "join-with up";
            alt-shift-p = "join-with right";
            alt-shift-semicolon = "join-with right";

            # alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

            # cmd-h = ""; # Disable "hide application"
            # cmd-alt-h = ""; # Disable "hide others"

            alt-minus = "resize smart -50";
            alt-equal = "resize smart +50";

            alt-slash = "layout tiles horizontal vertical";
            alt-period = "layout accordion horizontal vertical";

            #modes
            alt-tab = "mode monitor";

          }
          // commonBindings;

          mode.monitor.binding = {
            # Focus monitor (no alt needed, you're already in monitor mode)
            j = "focus left";
            k = "focus down";
            l = "focus up";
            p = "focus right";
            semicolon = "focus right";

            alt-j = [
              "focus-monitor --wrap-around left"
              "mode main"
            ];
            alt-k = [
              "focus-monitor --wrap-around down"
              "mode main"
            ];
            alt-l = [
              "focus-monitor --wrap-around up"
              "mode main"
            ];
            alt-p = [
              "focus-monitor --wrap-around right"
              "mode main"
            ];
            alt-semicolon = [
              "focus-monitor --wrap-around right"
              "mode main"
            ];

            # Move app to monitor
            alt-shift-j = [ "move-node-to-monitor --focus-follows-window --wrap-around left" ];
            alt-shift-k = [ "move-node-to-monitor --focus-follows-window --wrap-around down" ];
            alt-shift-l = [ "move-node-to-monitor --focus-follows-window --wrap-around up" ];
            alt-shift-p = [ "move-node-to-monitor --focus-follows-window --wrap-around right" ];
            alt-shift-semicolon = [ "move-node-to-monitor --focus-follows-window --wrap-around right" ];

            #Main
            alt-tab = "mode main";
            esc = "mode main";
          }
          // commonBindings;
        };
      };

      services.jankyborders = {
        enable = true;
        active_color = "0xfffabd2f"; # gruvbox dark yellow
        # width = 6.0;
        hidpi = true;
        order = "above";
      };

      # services.sketchybar = {
      #   enable = true;
      #   extraPackages = [ pkgs.aerospace ];
      #   config =
      #     let
      #       aerospacePlugin = pkgs.writeShellScript "aerospace.sh" ''
      #         if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
      #           sketchybar --set $NAME background.drawing=on
      #         else
      #           sketchybar --set $NAME background.drawing=off
      #         fi
      #       '';
      #     in
      #     ''
      #       #!/usr/bin/env bash

      #       sketchybar --bar \
      #         height=32 \
      #         position=top \
      #         display=all \
      #         padding_left=10 \
      #         padding_right=10 \
      #         color=0xff1c1e26 \
      #         shadow=off \
      #         border_width=0 \
      #         # topmost=on

      #       sketchybar --add event aerospace_workspace_change

      #       for sid in $(aerospace list-workspaces --all); do
      #         sketchybar --add item space.$sid left \
      #           --subscribe space.$sid aerospace_workspace_change \
      #           --set space.$sid \
      #             background.color=0x44ffffff \
      #             background.corner_radius=5 \
      #             background.height=20 \
      #             background.drawing=off \
      #             label="$sid" \
      #             label.color=0xffe1e3e4 \
      #             click_script="aerospace workspace $sid" \
      #             script="${aerospacePlugin} $sid"
      #       done

      #       sketchybar --update
      #     '';
      # };
    }; # #output
}
