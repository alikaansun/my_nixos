{
  flake.darwinModules.sketchy =
    { lib, pkgs, ... }:
    let
      aerospaceBin = lib.getExe pkgs.aerospace;

      aerospacePlugin = pkgs.writeShellScript "aerospace.sh" ''
        if [ -z "$FOCUSED_WORKSPACE" ]; then
          FOCUSED_WORKSPACE=$(${aerospaceBin} list-workspaces --focused)
        fi
        FOCUSED_APP=$(${aerospaceBin} list-windows --focused --format "%{app-name}" 2>/dev/null || true)

        WORKSPACE=$1

        APPS=$(${aerospaceBin} list-windows --workspace "$WORKSPACE" --format "%{app-name}" | sort -u)
        
        ICON_STR=""
        if [ -n "$APPS" ]; then
          while IFS= read -r app; do
            case "$app" in
              "Brave Browser"|"Brave") ICON=$'\uf268' ;;
              "Ghostty") ICON=$'\uf120' ;;
              "Code"|"VSCode") ICON=$'\uf121' ;;
              "Discord") ICON=$'\uf392' ;;
              "Obsidian") ICON=$'\uf044' ;;
              "KeePassXC") ICON=$'\uf084' ;;
              "Spotify") ICON=$'\uf1bc' ;;
              "Finder") ICON=$'\uf07b' ;;
              "Microsoft Outlook"|"Outlook") ICON=$'\uf0e0' ;;
              "Microsoft Teams"|"Teams"|"teams") ICON=$'\uf0c0' ;;
              "Zotero") ICON=$'\uf02d' ;;
              *) ICON=$'\uf2d0' ;;
            esac
            
            if [ "$app" = "$FOCUSED_APP" ] && [ "$WORKSPACE" = "$FOCUSED_WORKSPACE" ]; then
              # Highlight the active app with brackets
              ICON_STR+=" [ $ICON ]"
            else
              ICON_STR+=" $ICON"
            fi
          done <<< "$APPS"
        fi

        if [ "$WORKSPACE" = "$FOCUSED_WORKSPACE" ]; then
          sketchybar --set $NAME \
            background.drawing=on \
            background.color=0x443c3836 \
            background.border_width=2 \
            background.border_color=0xfffabd2f \
            icon=$WORKSPACE \
            icon.color=0xfffabd2f \
            label="$ICON_STR " \
            label.color=0xfffabd2f
        else
          sketchybar --set $NAME \
            background.drawing=off \
            background.border_width=0 \
            icon=$WORKSPACE \
            icon.color=0xffa89984 \
            label="$ICON_STR " \
            label.color=0xffa89984
        fi
      '';

      batteryPlugin = pkgs.writeShellScript "battery.sh" ''
        PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
        CHARGING=$(pmset -g batt | grep 'AC Power')

        if [ "$PERCENTAGE" = "" ]; then
          exit 0
        fi

        case ''${PERCENTAGE} in
          100|9[0-9]) ICON=$'\uf240' ;;
          [6-8][0-9]) ICON=$'\uf241' ;;
          [3-5][0-9]) ICON=$'\uf242' ;;
          [1-2][0-9]) ICON=$'\uf243' ;;
          *) ICON=$'\uf244' ;;
        esac

        if [ "$CHARGING" != "" ]; then
          ICON=$'\uf0e7'
        fi

        sketchybar --set $NAME icon="$ICON" label="''${PERCENTAGE}%"
      '';
    in
    {
      services.sketchybar = {
        enable = true;
        package = pkgs.sketchybar;
        extraPackages = [ pkgs.aerospace ];
        config = ''
          #!/usr/bin/env bash

          # AeroSpace workspaces in SketchyBar
          sketchybar --bar \
            height=30 \
            position=top \
            display=all \
            color=0xff282828 \
            shadow=off \
            border_width=0 \
            topmost=window

          sketchybar --default \
            background.drawing=off \
            icon.color=0xffebdbb2 \
            label.color=0xffebdbb2 \
            padding_left=4 \
            padding_right=4

          sketchybar --add event aerospace_workspace_change

          for sid in $(${aerospaceBin} list-workspaces --all); do
            sketchybar --add item space.$sid left \
              --subscribe space.$sid aerospace_workspace_change front_app_switched \
              --set space.$sid \
                update_freq=10 \
                icon="$sid" \
                icon.font="FiraCode Nerd Font Mono:Bold:16.0" \
                icon.padding_left=12 \
                label="" \
                label.font="FiraCode Nerd Font Mono:Regular:16.0" \
                label.padding_right=16 \
                background.color=0x44ffffff \
                background.corner_radius=6 \
                background.drawing=off \
                background.height=20 \
                padding_left=5 \
                padding_right=5 \
                click_script="${aerospaceBin} workspace $sid" \
                script="${aerospacePlugin} $sid"
          done

          sketchybar --add item front_app center \
            --subscribe front_app front_app_switched \
            --set front_app \
              script="sketchybar --set \$NAME label=\"\$INFO\"" \
              label.color=0xfffabd2f \
              label.font="FiraCode Nerd Font Mono:Regular:16.0" \
              background.drawing=off \
              padding_left=5 \
              padding_right=5

          sketchybar --add item clock right \
            --set clock \
              update_freq=10 \
              icon=$'\uf017' \
              icon.font="FiraCode Nerd Font Mono:Regular:16.0" \
              icon.color=0xffebdbb2 \
              icon.padding_right=4 \
              label.font="FiraCode Nerd Font Mono:Regular:16.0" \
              label.color=0xffebdbb2 \
              padding_right=8 \
              script="sketchybar --set \$NAME label=\"\$(date '+%H:%M')\""

          sketchybar --add item battery right \
            --subscribe battery system_woke power_source_change \
            --set battery \
              update_freq=120 \
              icon.font="FiraCode Nerd Font Mono:Regular:16.0" \
              icon.color=0xffebdbb2 \
              icon.padding_right=4 \
              label.font="FiraCode Nerd Font Mono:Regular:16.0" \
              label.color=0xffebdbb2 \
              padding_right=8 \
              script="${batteryPlugin}"

          sketchybar --update
        '';
      };
    };
}

