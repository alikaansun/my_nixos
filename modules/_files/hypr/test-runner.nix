{ pkgs }:
let
  # Hyprland imports its environment into the systemd user manager on start and
  # unsets it on exit, even when nested and with HYPRLAND_NO_SD_VARS set. That
  # breaks the KDE session around it.
  systemctlStub = pkgs.writeShellScriptBin "systemctl" "exit 0";
in
pkgs.writeShellApplication {
  name = "hyprland-test";
  runtimeInputs = [
    systemctlStub
    pkgs.hyprland
    pkgs.noctalia
    pkgs.dbus
    pkgs.procps
  ]
  ++ import ./scripts.nix { inherit pkgs; };
  text = ''
    if [ -n "''${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
      echo "hyprland-test only runs under another desktop" >&2
      exit 1
    fi

    root="$HOME/.cache/hyprland-test"
    src="$HOME/.dotfiles/modules/_files/hypr"
    mkdir -p "$root/config/hypr" "$root/config/noctalia/palettes" "$root/data" "$root/state" "$root/cache"
    ln -sfn "$src/hyprland.lua" "$root/config/hypr/hyprland.lua"
    ln -sfn "$src/noctalia.toml" "$root/config/noctalia/config.toml"
    ln -sfn "$src/kanagawa-wave.json" "$root/config/noctalia/palettes/kanagawa-wave.json"
    cat > "$root/config/hypr/host.lua" <<'LUA'
    hl.on("hyprland.start", function() hl.dispatch(hl.dsp.exec_cmd("noctalia")) end)
    LUA

    export XDG_CONFIG_HOME="$root/config" XDG_DATA_HOME="$root/data"
    export XDG_STATE_HOME="$root/state" XDG_CACHE_HOME="$root/cache"
    export HYPRLAND_TEST=1

    cleanup() {
      for pid in $(pgrep -f 'Hyprland --watchdog|start-hyprland|noctalia' || true); do
        if grep -qz '^HYPRLAND_TEST=1$' "/proc/$pid/environ" 2>/dev/null; then
          kill -9 "$pid" 2>/dev/null || true
        fi
      done
      rm -f "''${XDG_RUNTIME_DIR:?}"/noctalia-wayland-*.lock
      rm -rf "''${XDG_RUNTIME_DIR:?}/hypr"
    }
    trap cleanup EXIT

    dbus-run-session -- start-hyprland
  '';
}
