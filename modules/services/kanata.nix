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
    
    boot.kernelModules = [ "uinput" ];
    users.groups.uinput = {};
    
    services.udev.extraRules = ''
      KERNEL=="uinput", GROUP="uinput", MODE="0660", OPTIONS+="static_node=uinput"
      SUBSYSTEM=="input", GROUP="input", MODE="0664"
      KERNEL=="event*", GROUP="input", MODE="0664"
    '';
    
    # Ensure proper permissions on boot
    systemd.tmpfiles.rules = [
      "c /dev/uinput 0660 root uinput"
    ];

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
        };
      };
    };
  };
}