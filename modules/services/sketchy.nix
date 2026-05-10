{
  flake.darwinModules.sketchy =
    { pkgs, ... }:
    let
      # Plugins: small scripts hooked into sketchybar to update items
      aerospacePlugin = pkgs.writeShellScript "aerospace.sh" ''
        if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
          sketchybar --set $NAME \
            background.drawing=on \
            background.color=0xff3c3836 \
            label.color=0xfffabd2f
        else
          sketchybar --set $NAME \
            background.drawing=off \
            label.color=0xffa89984
        fi
      '';

      frontAppPlugin = pkgs.writeShellScript "front_app.sh" ''
        sketchybar --set $NAME label="$INFO"
      '';

      clockPlugin = pkgs.writeShellScript "clock.sh" ''
        sketchybar --set $NAME label="$(date '+%a %d %b  %H:%M')"
      '';

      batteryPlugin = pkgs.writeShellScript "battery.sh" ''
        PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
        CHARGING=$(pmset -g batt | grep -c "AC Power")

        if [ "$PERCENTAGE" = "" ]; then
          sketchybar --set $NAME icon="󰂑" label="?"
          exit 0
        fi

        if [ "$CHARGING" -gt 0 ]; then
          ICON="󰂄"; COLOR=0xff83a598
        elif [ "$PERCENTAGE" -ge 80 ]; then
          ICON="󰁹"; COLOR=0xffb8bb26
        elif [ "$PERCENTAGE" -ge 50 ]; then
          ICON="󰁾"; COLOR=0xfffabd2f
        elif [ "$PERCENTAGE" -ge 25 ]; then
          ICON="󰁻"; COLOR=0xfffe8019
        else
          ICON="󰁺"; COLOR=0xfffb4934
        fi

        sketchybar --set $NAME icon="$ICON" icon.color=$COLOR label="''${PERCENTAGE}%"
      '';

      wifiPlugin = pkgs.writeShellScript "wifi.sh" ''
        SSID=$(networksetup -getairportnetwork en0 | awk -F': ' '{print $2}')
        if [ "$SSID" = "You are not associated with an AirPort network." ] || [ -z "$SSID" ]; then
          sketchybar --set $NAME icon="󰤭" icon.color=0xfffb4934 label.drawing=off
        else
          sketchybar --set $NAME icon="󰤨" icon.color=0xff83a598 label="$SSID" label.drawing=on
        fi
      '';

      bluetoothPlugin = pkgs.writeShellScript "bluetooth.sh" ''
        CONNECTED=$(system_profiler SPBluetoothDataType 2>/dev/null | grep -c "Connected: Yes")
        if [ "$CONNECTED" -eq 0 ]; then
          sketchybar --set $NAME icon="󰂲" icon.color=0xffa89984 label.drawing=off
        else
          sketchybar --set $NAME icon="󰂯" icon.color=0xffd3869b label="''${CONNECTED}" label.drawing=on
        fi
      '';

      onedrivePlugin = pkgs.writeShellScript "onedrive.sh" ''
        IS_RUNNING=$(pgrep -x "OneDrive" > /dev/null 2>&1 && echo "yes" || echo "no")
        if [ "$IS_RUNNING" = "no" ]; then
          sketchybar --set $NAME icon="󰡉" icon.color=0xffa89984 label="off" label.drawing=on
          exit 0
        fi
        LOG="$HOME/Library/Application Support/OneDrive/logs/SyncDiagnostics.log"
        COLOR=0xff83a598
        if [ -f "$LOG" ]; then
          ERRORS=$(tail -50 "$LOG" 2>/dev/null | grep -ci "error")
          [ "$ERRORS" -gt 0 ] && COLOR=0xfffb4934
        fi
        sketchybar --set $NAME icon="󰡉" icon.color=$COLOR label.drawing=off
      '';

      nextcloudPlugin = pkgs.writeShellScript "nextcloud.sh" ''
        IS_RUNNING=$(pgrep -x "Nextcloud" > /dev/null 2>&1 && echo "yes" || echo "no")
        if [ "$IS_RUNNING" = "no" ]; then
          sketchybar --set $NAME icon="󰁧" icon.color=0xffa89984 label="off" label.drawing=on
          exit 0
        fi
        LOG="$HOME/Library/Application Support/Nextcloud/Nextcloud.log"
        COLOR=0xffb8bb26
        if [ -f "$LOG" ]; then
          ERRORS=$(tail -100 "$LOG" 2>/dev/null | grep -ci "\[error\]")
          [ "$ERRORS" -gt 0 ] && COLOR=0xfffb4934
        fi
        sketchybar --set $NAME icon="󰁧" icon.color=$COLOR label.drawing=off
      '';

    in
    {
      services.sketchybar = {
        enable = true;
        extraPackages = [ pkgs.aerospace ];
        configType = "bash";
        config = ''
          #!/usr/bin/env bash

          # Gruvbox Dark palette (aligned with system)
          BG="0xff282828"
          BG1="0xff3c3836"
          FG="0xffebdbb2"
          FG2="0xffa89984"
          YELLOW="0xfffabd2f"
          RED="0xfffb4934"
          GREEN="0xffb8bb26"
          BLUE="0xff83a598"
          AQUA="0xff8ec07c"
          ORANGE="0xfffe8019"
          PURPLE="0xffd3869b"

          sketchybar --bar \
            height=36 \
            position=top \
            display=all \
            padding_left=6 \
            padding_right=6 \
            color=$BG \
            shadow=off \
            border_width=0 \
            notch_width=200 \
            topmost=window

          sketchybar --default \
            icon.font="JetBrainsMono Nerd Font:Bold:14.0" \
            label.font="JetBrainsMono Nerd Font:Regular:13.0" \
            icon.color=$FG \
            label.color=$FG \
            padding_left=4 \
            padding_right=4 \
            background.height=26 \
            background.corner_radius=6 \
            background.drawing=off

          # Aerospace workspace items (left)
          sketchybar --add event aerospace_workspace_change

          for sid in $(aerospace list-workspaces --all); do
            sketchybar --add item space.$sid left \
              --subscribe space.$sid aerospace_workspace_change \
              --set space.$sid \
                background.color=$BG1 \
                background.corner_radius=5 \
                background.height=22 \
                background.drawing=off \
                label="$sid" \
                label.color=$FG2 \
                label.font="JetBrainsMono Nerd Font:Bold:13.0" \
                padding_left=5 \
                padding_right=5 \
                click_script="aerospace workspace $sid" \
                script="${aerospacePlugin} $sid"
          done

          sketchybar --add item space_separator left \
            --set space_separator \
              label="│" \
              label.color=0x44ebdbb2 \
              padding_left=4 \
              padding_right=4

          # Front app name
          sketchybar --add item front_app left \
            --set front_app \
              icon.drawing=off \
              label.font="JetBrainsMono Nerd Font:Bold:13.0" \
              label.color=$YELLOW \
              script="${frontAppPlugin}" \
            --subscribe front_app front_app_switched

          # Center clock
          sketchybar --add item clock center \
            --set clock \
              icon="󰥔" \
              icon.color=$AQUA \
              update_freq=10 \
              script="${clockPlugin}"

          # Right-side plugins
          sketchybar --add item nextcloud right \
            --set nextcloud \
              icon="󰁧" \
              icon.color=$GREEN \
              label.drawing=off \
              update_freq=15 \
              script="${nextcloudPlugin}"

          sketchybar --add item onedrive right \
            --set onedrive \
              icon="󰡉" \
              icon.color=$BLUE \
              label.drawing=off \
              update_freq=15 \
              script="${onedrivePlugin}"

          sketchybar --add item bluetooth right \
            --set bluetooth \
              icon="󰂯" \
              icon.color=$PURPLE \
              label.drawing=off \
              update_freq=30 \
              script="${bluetoothPlugin}"

          sketchybar --add item wifi right \
            --set wifi \
              icon="󰤨" \
              icon.color=$BLUE \
              update_freq=30 \
              script="${wifiPlugin}" \
            --subscribe wifi wifi_change

          sketchybar --add item battery right \
            --set battery \
              update_freq=60 \
              script="${batteryPlugin}" \
            --subscribe battery system_woke power_source_change

          sketchybar --update
        '';
      };
    };
}
