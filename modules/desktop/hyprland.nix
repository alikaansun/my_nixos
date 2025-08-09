{ pkgs,inputs,config, ... }:
{

  home.packages = with pkgs; [
    swww
    grim
    slurp
    waybar
    wl-clipboard
    rofi-wayland
    hyprpolkitagent
    # Additional packages for waybar modules
    pavucontrol      # Volume control GUI
    blueman          # Bluetooth manager
    networkmanager   # Network management
    htop             # System monitor
    powertop         # Power management
    # hyprland-qtutils  # needed for banners and ANR messages
  ];

  programs.waybar = {
    enable = true; 
    package = pkgs.waybar;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ "hyprland/workspaces" "hyprland/language" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [ 
          "custom/clipboard" 
          "pulseaudio" 
          "bluetooth" 
          "network" 
          "cpu" 
          "memory"
          "custom/gpu"
          "battery"
          "custom/performance"
          "tray" 
          "clock" 
        ];

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}: {icon}";
          format-icons = {
            "1" = "○";
            "2" = "○";
            "3" = "○";
            "4" = "○";
            "5" = "○";
            active = "●";
            default = "○";
          };
          persistent-workspaces = {
            "1" = [];
            "2" = [];
            "3" = [];
            "4" = [];
            "5" = [];
          };
        };

        "hyprland/window" = {
          format = "{}";
          max-length = 50;
        };

        "hyprland/language" = {
          format = " {}";
          format-en = "EN";
          format-ir = "FA";
          format-tr = "TR";
        };

        "custom/clipboard" = {
          format = "📋";
          tooltip-format = "Clipboard Manager";
          on-click = "wl-paste | rofi -dmenu -p 'Clipboard:'";
          interval = 1;
        };

        "pulseaudio" = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-muted = "🔇";
          format-icons = {
            headphone = "🎧";
            hands-free = "🎧";
            headset = "🎧";
            phone = "📞";
            portable = "📱";
            car = "🚗";
            default = ["🔈" "🔉" "🔊"];
          };
          on-click = "pavucontrol";
          on-click-right = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
          scroll-step = 5;
        };

        "bluetooth" = {
          format = " {status}";
          format-disabled = "";
          format-off = "";
          format-on = "";
          format-connected = " {device_alias}";
          format-connected-battery = " {device_alias} {device_battery_percentage}%";
          tooltip-format = "{controller_alias}\t{controller_address}";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          on-click = "blueman-manager";
        };

        "network" = {
          format-wifi = "  {essid} ({signalStrength}%)";
          format-ethernet = "🌐 {ifname}";
          format-disconnected = "⚠ Disconnected";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}";
          tooltip-format-wifi = "{essid} ({signalStrength}%): {ipaddr}/{cidr}";
          on-click = "nm-connection-editor";
        };

        "cpu" = {
          interval = 10;
          format = "🖥️ {usage}%";
          max-length = 15;
          on-click = "kitty -e htop";
          tooltip-format = "CPU Usage: {usage}%\nLoad: {load}";
        };

        "memory" = {
          interval = 30;
          format = "🧠 {percentage}%";
          max-length = 15;
          tooltip-format = "RAM: {used:0.1f}G/{total:0.1f}G ({percentage}%)\nSwap: {swapUsed:0.1f}G/{swapTotal:0.1f}G";
          on-click = "kitty -e htop";
        };

        "custom/gpu" = {
          format = "🎮 {}%";
          interval = 5;
          exec = pkgs.writeShellScript "gpu-usage" ''
            # Try different methods to get GPU usage
            if command -v nvidia-smi >/dev/null 2>&1; then
              nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | head -n1
            elif [ -f /sys/class/drm/card0/device/gpu_busy_percent ]; then
              cat /sys/class/drm/card0/device/gpu_busy_percent
            elif command -v radeontop >/dev/null 2>&1; then
              radeontop -d - -l 1 | grep -o 'gpu [0-9]*' | cut -d' ' -f2
            else
              echo "N/A"
            fi
          '';
          tooltip-format = "GPU Utilization";
          on-click = "kitty -e watch -n1 nvidia-smi";
        };

        "battery" = {
          interval = 60;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "⚡ {capacity}%";
          format-plugged = "🔌 {capacity}%";
          format-full = "🔋 Full";
          format-icons = ["🪫" "🔋" "🔋" "🔋" "🔋"];
          tooltip-format = "Battery: {capacity}%\nTime: {time}\nPower: {power}W";
          on-click = "kitty -e powertop";
        };

        "custom/performance" = {
          format = "⚡ {}";
          interval = 30;
          exec = pkgs.writeShellScript "performance-mode" ''
            # Check CPU governor
            governor=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || echo "unknown")
            case "$governor" in
              "performance") echo "PERF" ;;
              "powersave") echo "ECO" ;;
              "ondemand") echo "AUTO" ;;
              "conservative") echo "CONS" ;;
              "schedutil") echo "SCHED" ;;
              *) echo "UNK" ;;
            esac
          '';
          tooltip-format = "Performance Profile\nClick to change";
          on-click = pkgs.writeShellScript "toggle-performance" ''
            current=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
            if [ "$current" = "performance" ]; then
              echo "powersave" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
              notify-send "Performance" "Switched to Power Save mode"
            else
              echo "performance" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
              notify-send "Performance" "Switched to Performance mode"
            fi
          '';
        };

        "clock" = {
          format = "{:%H:%M}";
          format-alt = "{:%Y-%m-%d}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            on-click-right = "mode";
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
        };

        "tray" = {
          spacing = 10;
        };
      };
    };
  };

  home.sessionVariables = {
    # HiDPI scaling
    NIXOS_OZONE_WL = "1";  # Enables native Wayland support
    
    # Wayland-specific
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

    # Configure Qt scaling
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };
  
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      # Essential keybindings
      "$mod" = "SUPER";
      
      # Monitor configuration with proper scaling
      monitor = [
        # Adjust these values based on your display
        # Format: name,resolution,position,scale
        # "eDP-1,preferred,auto,1.25"  # 1.25x scaling for most laptops
        # Or for specific monitor:
        "eDP-1,1920x1080,0x0,1.25"
      ];

      # Environment variables for proper scaling
      env = [
        "GDK_SCALE,1.25"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_SCALE_FACTOR,1.25"
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];
      
      bind = [
        "$mod, Return, exec, kitty"
        "$mod, D, exec, rofi -show drun"
        "$mod, Q, killactive"
        "$mod SHIFT, E, exit"
        "$mod, V, togglefloating"
        "$mod, F, fullscreen"
        # Add workspace switching
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
      ];
      
      # Auto-start essential services
      exec-once = [
        "waybar"
        "swww-daemon"
        "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent"
      ];
      
      # Basic appearance
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };
      
      decoration = {
        rounding = 10;
      };
    };


    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    systemd = {
      enable = true;
      enableXdgAutostart = true;
      variables = ["--all"];
    };
    xwayland = {
      enable = true;
    };
    
    # plugins = [
    #     inputs.hyprland-plugins.packages."${pkgs.system}".hyprbars
    # ];

  };

}