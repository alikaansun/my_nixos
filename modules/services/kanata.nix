let
  # Shared Kanata configuration
  kanataConfig = ''
    (defsrc
      caps a s d f j k l ;
    )
    
    (defvar
      ;; Match QMK's default TAPPING_TERM of 200ms
      tap-time 200
      hold-time 200
      ;; Match QMK's default QUICK_TAP_TERM (same as TAPPING_TERM)
      quick-tap 200
    )
    
    (defalias
      escctrl (tap-hold 100 200 esc lctl)
      ;; tap-hold-release-keys: hold triggers only after hold-time expires,
      ;; NOT on any intermediate key press. This matches QMK's default
      ;; mod-tap behavior (no PERMISSIVE_HOLD, no HOLD_ON_OTHER_KEY_PRESS).
      ;; The quick-tap parameter allows fast key repeat when double-tapping,
      ;; matching QMK's QUICK_TAP_TERM.
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
      @escctrl @a @s @d @f @j @k @l @;
    )
  '';

  commonOptions =
    { lib, ... }:
    with lib;
    {
      options.services.mykanata = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable the Kanata service.";
        };

        deviceName = mkOption {
          type = types.str;
          default = "/dev/input/event0";
          description = "The device name string for the keyboard.";
        };
      };
    };
in
{
  flake.nixosModules.kanata =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    with lib;
    let
      cfg = config.services.mykanata;
    in
    {
      imports = [ commonOptions ];

      config = mkIf cfg.enable {
        boot.kernelModules = [ "uinput" ];
        users.groups.uinput = { };

        services.udev.extraRules = ''
          KERNEL=="uinput", GROUP="uinput", MODE="0660", OPTIONS+="static_node=uinput"
        '';

        systemd.tmpfiles.rules = [
          "c /dev/uinput 0660 root uinput"
        ];

        systemd.services."kanata-internalKeyboard".serviceConfig = {
          User = "alik";
          SupplementaryGroups = [
            "input"
            "uinput"
          ];
        };

        services.kanata = {
          enable = true;
          keyboards = {
            internalKeyboard = {
              devices = [ cfg.deviceName ];
              extraDefCfg = "process-unmapped-keys yes";
              config = kanataConfig;
            };
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
    with lib;
    let
      cfg = config.services.mykanata;

      # Create an app bundle with actual binary copy for macOS permissions
      kanataApp = pkgs.runCommand "Kanata.app" { } ''
        mkdir -p $out/Contents/MacOS
        cat > $out/Contents/Info.plist << EOF
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
          <key>CFBundleExecutable</key>
          <string>kanata</string>
          <key>CFBundleIdentifier</key>
          <string>org.kanata.app</string>
          <key>CFBundleName</key>
          <string>Kanata</string>
          <key>CFBundleVersion</key>
          <string>1.0</string>
          <key>LSUIElement</key>
          <true/>
        </dict>
        </plist>
        EOF
        # Copy instead of symlink for proper TCC recognition
        cp ${pkgs.kanata}/bin/kanata $out/Contents/MacOS/kanata
        chmod +x $out/Contents/MacOS/kanata
      '';
    in
    {
      imports = [ commonOptions ];

      config = mkIf cfg.enable {
        environment.etc."kanata/config.kbd".text = kanataConfig;

        # Install app bundle to /Applications
        # After rebuild, grant permissions:
        # 1. System Settings → Privacy & Security → Input Monitoring
        #    Add /Applications/Kanata.app and enable it
        # 2. OR use Full Disk Access (includes Input Monitoring)
        #    System Settings → Privacy & Security → Full Disk Access
        #    Add /Applications/Kanata.app and enable it
        # 3. Restart: sudo launchctl kickstart -k system/org.nixos.kanata
        system.activationScripts.postActivation.text = ''
          rm -rf /Applications/Kanata.app
          cp -R ${kanataApp} /Applications/Kanata.app
          chmod -R u+w /Applications/Kanata.app
        '';

        launchd.daemons.kanata = {
          command = "/Applications/Kanata.app/Contents/MacOS/kanata -c /etc/kanata/config.kbd";
          serviceConfig = {
            KeepAlive = true;
            RunAtLoad = true;
            StandardOutPath = "/tmp/kanata.out.log";
            StandardErrorPath = "/tmp/kanata.err.log";
          };
        };
      };
    };
}
