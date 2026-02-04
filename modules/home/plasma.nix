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
            number = 2;
            rows = 1;
            names = [
              "Desktop 1"
              "Desktop 2"
            ];
          };
        };
        krunner = {
          activateWhenTypingOnDesktop = true;
          shortcuts.launch = "Alt + Space";
        };

        shortcuts = {
          kwin = {
            "Switch Window Down" = "Meta+Alt+Down";
            "Switch Window Left" = "Meta+Alt+Left";
            "Switch Window Right" = "Meta+Alt+Right";
            "Switch Window Up" = "Meta+Alt+Up";
            "Switch One Desktop Down" = "Meta+Ctrl+Down";
            "Switch One Desktop Up" = "Meta+Ctrl+Up";
            "Switch One Desktop to the Left" = "Meta+Ctrl+Left";
            "Switch One Desktop to the Right" = "Meta+Ctrl+Right";
            "Window One Desktop Down" = "Meta+Ctrl+Shift+Down";
            "Window One Desktop Up" = "Meta+Ctrl+Shift+Up";
            "Window One Desktop to the Left" = "Meta+Ctrl+Shift+Left";
            "Window One Desktop to the Right" = "Meta+Ctrl+Shift+Right";
            "Switch to Desktop 1" = "Ctrl+F1";
            "Switch to Desktop 2" = "Ctrl+F2";
            "Window Close" = "Alt+F4";
            # "Window Close" = [ "Meta+Q,Alt+F4,Alt+F4,Close Window" ];
          };

          "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = "Meta+Alt+K";
          "ksmserver"."Lock Session" = [
            "Meta+L"
            "Screensaver,Meta+L"
            "Screensaver,Lock Session"
          ];

          # Apps (converted from Hyprland)
          "services/kitty.desktop"."_launch" = "Meta+Return";
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
          "kwinrc"."Desktops"."Name_1" = "Desktop 1";
          "kwinrc"."Desktops"."Name_2" = "Desktop 2";
          "kwinrc"."Desktops"."Number" = 2;
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
