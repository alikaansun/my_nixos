{ config, lib, ... }:

with lib;

let
  cfg = config.services.mykanata;
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

  config = mkIf cfg.enable {
    services.kanata = {
      enable = true;
      keyboards = {
        internalKeyboard = {
          devices = [ cfg.deviceName ];
          extraDefCfg = "process-unmapped-keys yes";
          config = ''
            (defsrc
              caps a s d f j k l ;
            )
            (defvar
              tap-time 150
              hold-time 200
            )

            (defalias
              escctrl (tap-hold 100 100 esc lctl)
              a (multi f24 (tap-hold $tap-time $hold-time a lctl)) 
              s (multi f24 (tap-hold $tap-time $hold-time s lmet)) 
              d (multi f24 (tap-hold $tap-time $hold-time d lalt)) 
              f (multi f24 (tap-hold $tap-time $hold-time f lsft)) 
              j (multi f24 (tap-hold $tap-time $hold-time j rsft)) 
              k (multi f24 (tap-hold $tap-time $hold-time k ralt)) 
              l (multi f24 (tap-hold $tap-time $hold-time l rmet)) 
              ; (multi f24 (tap-hold $tap-time $hold-time ; rctl)) 
            )

            (deflayer base
              @escctrl @a @s @d @f @j @k @l @;
            )
          '';
        };
      };
    };
  };
}