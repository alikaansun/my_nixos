let
  kbd = ''
    (defsrc
      esc caps a s d f j k l ;
    )

    (defvar
      tap-time 200
      hold-time 200
    )

    (defalias
      escctrl (tap-hold 100 200 esc lctl)
      ;; With an empty key list this is permissive hold: the mod activates as soon as another
      ;; key is pressed and released while this one is held, otherwise after hold-time.
      a (tap-hold-release-keys $tap-time $hold-time a lsft ())
      s (tap-hold-release-keys $tap-time $hold-time s lalt ())
      d (tap-hold-release-keys $tap-time $hold-time d lmet ())
      f (tap-hold-release-keys $tap-time $hold-time f lctl ())
      j (tap-hold-release-keys $tap-time $hold-time j rctl ())
      k (tap-hold-release-keys $tap-time $hold-time k rmet ())
      l (tap-hold-release-keys $tap-time $hold-time l ralt ())
      ; (tap-hold-release-keys $tap-time $hold-time ; rsft ())
    )

    (deflayer base
      C-b @escctrl @a @s @d @f @j @k @l @;
    )
  '';

  # Without process-unmapped-keys, keys outside defsrc skip the tap-hold decision: they arrive
  # out of order and can't trigger an early hold. prior-idle makes a home-row key pressed within
  # 150ms of another key type immediately, so there's no tap-hold lag mid-word.
  defcfg = ''
    process-unmapped-keys yes
    tap-hold-require-prior-idle 150
  '';

  options =
    { lib, ... }:
    {
      options.services.mykanata.enable = lib.mkEnableOption "kanata with home-row mods";
    };
in
{
  flake.nixosModules.kanata =
    { config, lib, ... }:
    {
      imports = [ options ];

      config = lib.mkIf config.services.mykanata.enable {
        services.kanata = {
          enable = true;
          keyboards.default = {
            extraDefCfg = defcfg;
            config = kbd;
          };
        };
      };
    };

  flake.darwinModules.kanata =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      # kanata's karabiner-driverkit crate speaks this release's daemon IPC; newer ones aren't guaranteed to work.
      driver = pkgs.karabiner-dk.override { driver-version = "6.2.0"; };
      manager = "/Applications/.Karabiner-VirtualHIDDevice-Manager.app";
      vhidDaemon = "${driver}/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon";
      # Input Monitoring is tied to the binary's path, so run a fixed copy rather than a store path
      # that changes on every update.
      kanata = "/usr/local/bin/kanata";
    in
    {
      imports = [ options ];

      config = lib.mkIf config.services.mykanata.enable {
        environment.etc."kanata/config.kbd".text = "(defcfg\n${defcfg})\n${kbd}";

        system.activationScripts.postActivation.text = ''
          # A system extension only activates from a real bundle in /Applications, not a store symlink.
          if ! diff -rq ${driver}/Applications/.Karabiner-VirtualHIDDevice-Manager.app ${manager} >/dev/null 2>&1; then
            rm -rf ${manager}
            cp -R ${driver}/Applications/.Karabiner-VirtualHIDDevice-Manager.app ${manager}
          fi
          # rm before cp: overwriting a signed binary in place gets it killed by the kernel's signature cache.
          if ! cmp -s ${pkgs.kanata}/bin/kanata ${kanata}; then
            mkdir -p /usr/local/bin
            rm -f ${kanata}
            cp ${pkgs.kanata}/bin/kanata ${kanata}
          fi
          launchctl kickstart -k system/org.nixos.karabiner-vhid-daemon || true
          launchctl kickstart -k system/org.nixos.kanata || true
        '';

        launchd.daemons.karabiner-vhid-daemon = {
          command = ''"${vhidDaemon}"'';
          serviceConfig = {
            KeepAlive = true;
            ProcessType = "Interactive";
          };
        };

        # `activate` blocks until the extension is approved in System Settings, so it can't run in
        # the activation script without hanging the rebuild.
        launchd.daemons.karabiner-dk-activate = {
          command = "${manager}/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager activate";
          serviceConfig.RunAtLoad = true;
        };

        launchd.daemons.kanata = {
          command = "${kanata} -c /etc/kanata/config.kbd";
          serviceConfig = {
            KeepAlive = true;
            ProcessType = "Interactive";
            StandardOutPath = "/tmp/kanata.out.log";
            StandardErrorPath = "/tmp/kanata.err.log";
          };
        };
      };
    };
}
