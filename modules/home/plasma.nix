{
  flake.homeModules.plasma =
    { pkgs, inputs, ... }:
    {
      imports = [
        inputs.plasma-manager.homeModules.plasma-manager
      ];

      programs.plasma = {
        enable = true;
        workspace = {
          theme = "breeze-dark";
          # wallpaper = "/home/alik/.dotfiles/modules/desktop/fav.jpg";
          lookAndFeel = "org.kde.breezedark.desktop";
          clickItemTo = "select";
          iconTheme = "breeze-dark";
          cursor = {
            theme = "breeze_cursors";
            # size = 24;
          };
        };
        kscreenlocker = {
          lockOnStartup = true;
          passwordRequired = true;
          timeout = 5;
          appearance = {
            # wallpaper = "/home/alik/.dotfiles/modules/desktop/fav1.jpg";
            showMediaControls = true;
          };
        };

        kwin = {
          effects = {
            dimAdminMode.enable = true;
            snapHelper.enable = false;
            shakeCursor.enable = true;
          };
          nightLight = {
            enable = true;
            mode = "times";
            temperature.day = 4900;
            temperature.night = 4100;
            time.evening = "20:00";
            time.morning = "06:30";
          };
          titlebarButtons = {
            left = [ "more-window-actions" ];
            right = [
              "keep-above-windows"
              "minimize"
              "maximize"
              "close"
            ];
          };
          virtualDesktops = {
            number = 5;
            rows = 1;
            names = [
              "Desktop 1"
              "Desktop 2"
              "Desktop 3"
              "Desktop 4"
              "Desktop 5"
            ];
          };
        };
        krunner = {
          activateWhenTypingOnDesktop = true;
          shortcuts.launch = "Alt + Space";
        };

        shortcuts = {
          kwin = {
            # Window focus movement — matches aerospace's non-standard
            # alt-j/k/l/p = left/down/up/right layout on leona.
            "Switch Window Left" = [
              "Alt+J"
              "Meta+Alt+Left"
            ];
            "Switch Window Down" = [
              "Alt+K"
              "Meta+Alt+Down"
            ];
            "Switch Window Up" = [
              "Alt+L"
              "Meta+Alt+Up"
            ];
            "Switch Window Right" = [
              "Alt+P"
              "Alt+Semicolon"
              "Meta+Alt+Right"
            ];
            "Switch One Desktop Down" = "Meta+Ctrl+Down";
            "Switch One Desktop Up" = "Meta+Ctrl+Up";
            "Switch One Desktop to the Left" = "Meta+Ctrl+Left";
            "Switch One Desktop to the Right" = "Meta+Ctrl+Right";
            "Window One Desktop Down" = "Meta+Ctrl+Shift+Down";
            "Window One Desktop Up" = "Meta+Ctrl+Shift+Up";
            "Window One Desktop to the Left" = "Meta+Ctrl+Shift+Left";
            "Window One Desktop to the Right" = "Meta+Ctrl+Shift+Right";

            # Workspace switching — matches aerospace's alt-1..5 / alt-m
            "Switch to Desktop 1" = "Alt+1";
            "Switch to Desktop 2" = "Alt+2";
            "Switch to Desktop 3" = "Alt+3";
            "Switch to Desktop 4" = "Alt+4";
            "Switch to Desktop 5" = "Alt+5";

            # Move window to workspace — matches aerospace's alt-shift-1..5 / alt-shift-m
            "Window to Desktop 1" = "Alt+Shift+1";
            "Window to Desktop 2" = "Alt+Shift+2";
            "Window to Desktop 3" = "Alt+Shift+3";
            "Window to Desktop 4" = "Alt+Shift+4";
            "Window to Desktop 5" = "Alt+Shift+5";
            "Window Close" = "Meta+W"; # matches macOS Cmd+W (close window/tab)
          };

          "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = "Meta+Alt+K";
          "ksmserver"."Lock Session" = [
            "Meta+L"
            "Screensaver,Meta+L"
            "Screensaver,Lock Session"
          ];

          # Apps (converted from Hyprland)
          "services/com.mitchellh.ghostty.desktop"."_launch" = "Meta+Return";
          # "services/zen.desktop"."_launch" = "Meta+Space";
          "services/brave-browser.desktop"."new-window" = "Meta+Space";
          "services/code.desktop"."_launch" = "Ctrl+Alt+V";
          "services/vesktop.desktop"."_launch" = "Ctrl+Alt+D";
          "services/obsidian.desktop"."_launch" = "Ctrl+Alt+O";
          "services/org.keepassxc.KeePassXC.desktop"."_launch" = "Ctrl+Alt+K";
          "services/steam.desktop"."_launch" = "Ctrl+Alt+S";
          "services/thunderbird.desktop"."_launch" = "Ctrl+Alt+M";

          # Optional: keep the alternate terminal binding if you still want it
          # "services/kitty.desktop"."New" = "Ctrl+Alt+T";

          # Screenshots (you can keep as-is, or align both to region capture)
          "services/org.kde.spectacle.desktop"."_launch" = "Meta+Shift+S";
          "services/org.kde.spectacle.desktop"."CurrentMonitorScreenShot" = "Print";
          "services/org.kde.spectacle.desktop"."RectangularRegionScreenShot" = "Ctrl+Print";
        };

        configFile = {
          "kwinrc"."Plugins"."translucencyEnabled" = true;
          "kwinrc"."Effect-translucency"."DropdownMenus" = 80;
          "kwinrc"."Effect-translucency"."IndividualMenuConfig" = true;
          "kwinrc"."Effect-translucency"."Menus" = 80;
          "kwinrc"."Effect-translucency"."PopupMenus" = 80;
          "kwinrc"."Effect-translucency"."TornOffMenus" = 90;
          "kwinrc"."TabBox"."LayoutName" = "compact";
          "kwinrc"."Plugins"."dimscreenEnabled" = true;

          "kwinrc"."Desktops"."Id_1" = "Desktop_1";
          "kwinrc"."Desktops"."Id_2" = "Desktop_2";
          "kwinrc"."Desktops"."Id_3" = "Desktop_3";
          "kwinrc"."Desktops"."Id_4" = "Desktop_4";
          "kwinrc"."Desktops"."Id_5" = "Desktop_5";
          "kwinrc"."Desktops"."Name_1" = "Desktop 1";
          "kwinrc"."Desktops"."Name_2" = "Desktop 2";
          "kwinrc"."Desktops"."Name_3" = "Desktop 3";
          "kwinrc"."Desktops"."Name_4" = "Desktop 4";
          "kwinrc"."Desktops"."Name_5" = "Desktop 5";
          "kwinrc"."Desktops"."Number" = 5;
          "kwinrc"."Desktops"."Rows" = 1;

          "kwalletrc"."Wallet"."First Use" = false;
        };

        dataFile = {
          "dolphin/view_properties/global/.directory"."Dolphin"."SortRole" = "modificationtime";
          "dolphin/view_properties/global/.directory"."Dolphin"."ViewMode" = 1;
          "dolphin/view_properties/global/.directory"."Settings"."HiddenFilesShown" = true;
        };
      };
    };
}
