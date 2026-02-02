let
  # Shared Kanata configuration
  kanataConfig = ''
    (defsrc
      caps a s d f j k l ;
    )
    (defvar
      tap-time 150
      hold-time 300
      ;; Require another key press during hold to trigger modifier
      ;; This prevents accidental modifier activation during fast typing
    )

    (defalias
      escctrl (tap-hold 100 150 esc lctl)
      ;; tap-hold-press: tap action on quick release, hold action only when
      ;; another key is pressed while holding - much better for fast typing
      a (tap-hold-press $tap-time $hold-time a lsft)
      s (tap-hold-press $tap-time $hold-time s lalt)
      d (tap-hold-press $tap-time $hold-time d lmet)
      f (tap-hold-press $tap-time $hold-time f lctl)
      j (tap-hold-press $tap-time $hold-time j rctl)
      k (tap-hold-press $tap-time $hold-time k rmet)
      l (tap-hold-press $tap-time $hold-time l ralt)
      ; (tap-hold-press $tap-time $hold-time ; rsft)
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
