{ pkgs }:
[
  (pkgs.writeShellApplication {
    name = "hypr-desktop-menu";
    runtimeInputs = [ pkgs.jq ];
    text = ''
      main=$(hyprctl monitors all -j | jq -r '.[0].name')
      others=$(hyprctl monitors all -j | jq -r '.[1:][].name')
      choice=$(printf 'Extend\nMirror\nExternal only\n' | noctalia dmenu -p "Displays")
      apply() { hyprctl eval "hl.monitor({ output = \"$1\", $2 })"; }
      enabled='mode = "preferred", position = "auto", scale = 1'
      case "$choice" in
        Extend)
          apply "$main" "$enabled"
          for monitor in $others; do apply "$monitor" "$enabled"; done
          ;;
        Mirror)
          apply "$main" "$enabled"
          for monitor in $others; do apply "$monitor" "$enabled, mirror = \"$main\""; done
          ;;
        "External only")
          if [ -n "$others" ]; then apply "$main" "disabled = true"; fi
          ;;
      esac
    '';
  })
  (pkgs.writeShellApplication {
    name = "hypr-keybind-help";
    runtimeInputs = [ pkgs.jq ];
    text = ''
      hyprctl binds -j | jq -r '
        def mods: [
          (if . / 64 % 2 >= 1 then "Super" else empty end),
          (if . / 4 % 2 >= 1 then "Ctrl" else empty end),
          (if . / 8 % 2 >= 1 then "Alt" else empty end),
          (if . % 2 >= 1 then "Shift" else empty end)
        ] | join("+");
        .[] | "\(.modmask | floor | mods) \(.key)  \(.arg)"
      ' | noctalia dmenu -p "Keybinds" > /dev/null
    '';
  })
  (pkgs.writeShellApplication {
    name = "hypr-record-toggle";
    runtimeInputs = [
      pkgs.jq
      pkgs.procps
      pkgs.coreutils
    ];
    text = ''
      if pkill -INT -x gpu-screen-recorder; then
        noctalia msg notification-show "Recording saved"
        exit 0
      fi
      monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
      mkdir -p "$HOME/Videos"
      noctalia msg notification-show "Recording started"
      exec gpu-screen-recorder -w "$monitor" -f 60 -a default_output \
        -o "$HOME/Videos/recording-$(date +%Y-%m-%d_%H-%M-%S).mp4"
    '';
  })
]
