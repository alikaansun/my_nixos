{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.mykanata;

  # Platform detection
  isDarwin = pkgs.stdenv.isDarwin;
  isAarch64 = pkgs.stdenv.hostPlatform.isAarch64;

  # M-chip Mac detection
  isMmac = isDarwin && isAarch64;

  # Shared Kanata configuration
  kanataConfig = ''
    (defsrc
      caps a s d f j k l ;
    )
    (defvar
      tap-time 150
      hold-time 200
    )

    (defalias
      escctrl (tap-hold 100 100 esc lctl)
      a (multi f24 (tap-hold $tap-time $hold-time a lsft)) 
      s (multi f24 (tap-hold $tap-time $hold-time s lalt)) 
      d (multi f24 (tap-hold $tap-time $hold-time d lmet)) 
      f (multi f24 (tap-hold $tap-time $hold-time f lctl)) 
      j (multi f24 (tap-hold $tap-time $hold-time j rctl)) 
      k (multi f24 (tap-hold $tap-time $hold-time k rmet)) 
      l (multi f24 (tap-hold $tap-time $hold-time l ralt)) 
      ; (multi f24 (tap-hold $tap-time $hold-time ; rsft)) 
    )

    (deflayer base
      @escctrl @a @s @d @f @j @k @l @;
    )
  '';

in

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

  config = mkIf cfg.enable (mkMerge [
    # Linux-specific configuration
    (mkIf (!isDarwin) {
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
    })
    # M-chip Mac (aarch64-darwin) configuration
    (mkIf isMmac {
      environment.etc."kanata/config.kbd".text = kanataConfig;

      launchd.user.agents.kanata = {
        command = "${pkgs.kanata}/bin/kanata -c /etc/kanata/config.kbd";
        serviceConfig = {
          KeepAlive = true;
          RunAtLoad = true;
          StandardOutPath = "/tmp/kanata.out.log";
          StandardErrorPath = "/tmp/kanata.err.log";
        };
      };
    })
  ]);
}
