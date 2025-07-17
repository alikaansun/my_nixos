{ pkgs,inputs, ... }:
{
  imports = [
  inputs.plasma-manager.homeManagerModules.plasma-manager
  ];

  programs.plasma= { 
    enable = true;
    workspace = {  
      theme="breeze-dark";
      wallpaper="/home/alik/.dotfiles/modules/desktop/fav.jpg";
      lookAndFeel = "org.kde.breezedark.desktop";
      clickItemTo="select";
      iconTheme="breeze-dark";
      cursor = {
        theme = "breeze_cursors";
        # size = 24;
      };
    }; 
    kscreenlocker = {
      appearance = {
        wallpaper = "/home/alik/.dotfiles/modules/desktop/fav1.jpg";
        showMediaControls = true;
        };
    };

    kwin = {
      effects = {
        dimAdminMode.enable = true;
        snapHelper.enable = false;
      };
      nightLight = {
        enable = true;
        mode = "times";
        temperature.day = 4900;
        temperature.night = 4100;
        time.evening="20:00"; 
        time.morning="06:30";
      };
      titlebarButtons = {
        left = [ "more-window-actions" ];
        right = [ "keep-above-windows" "minimize" "maximize" "close" ];
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
    krunner={
      activateWhenTypingOnDesktop=true;
      shortcuts.launch="Alt + Space";
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
        "Window Close" = ["Alt+4" "Alt+F4,Alt+F4,Close Window"];

      };
      "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = "Meta+Alt+K";
      "ksmserver"."Lock Session" = ["Meta+L" "Screensaver,Meta+L" "Screensaver,Lock Session"];
      "services/Alacritty.desktop"."New" = "Ctrl+Alt+T";
      # "services/chromium-browser.desktop"."new-window" = "Meta+Space";
      "services/zen-beta.desktop"."_launch" = "Meta+Space";
      "services/code.desktop"."_launch" = "Ctrl+Alt+V";
      "services/discord.desktop"."_launch" = "Ctrl+Alt+D";
      "services/obsidian.desktop"."_launch" = "Ctrl+Alt+O";
      "services/org.kde.konsole.desktop"."_launch" = [ ];
      "services/org.kde.spectacle.desktop"."RectangularRegionScreenShot" = "Print";
      "services/org.kde.spectacle.desktop"."_launch" = "Meta+Shift+S";
      "services/org.keepassxc.KeePassXC.desktop"."_launch" = "Ctrl+Alt+K";
      "services/steam.desktop"."_launch" = "Ctrl+Alt+S";
      "services/thunderbird.desktop"."_launch" = "Ctrl+Alt+M";

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
    # panels = [
    #   { 
    #   location= "top";
    #   alignment="center";
    #   hiding= false;
    #   floating=false;

    #   widgets=[
    #     "org.kde.plasma.global-menu"
    #     "org.kde.plasma.marginsseparator"
    #     {
    #       kickoff = {
    #         sortAlphabetically = true;
    #         icon = "nix-snowflake-white";
    #       };
    #     }
    #     {
    #       pager = {
    #         general = {
    #         showWindowOutlines = true;
    #         showApplicationIconsOnWindowOutlines = true;
    #         navigationWrapsAround = true;
    #         selectingCurrentVirtualDesktop = "doNothing";
    #         };
    #       };
    #     }

    #   ];
    #   }
    # ];


  #     programs.plasma = {

  #       kscreenlocker.autoLock = false;

  #       panels = [
  #         {
  #           location = "bottom";
  #           widgets = [
  #             {
  #               kickoff = {
  #                 sortAlphabetically = true;
  #                 icon = "nix-snowflake-white";
  #               };
  #             }
  #             {
  #               pager = {
  #                 general = {
  #                   showWindowOutlines = true;
  #                   showApplicationIconsOnWindowOutlines = true;
  #                   showOnlyCurrentScreen = true;
  #                   navigationWrapsAround = true;
  #                   displayedText = "desktopNumber";
  #                   selectingCurrentVirtualDesktop = "doNothing";
  #                 };
  #               };
  #             }
  #             {
  #               iconTasks = {
  #                 launchers = [
  #                   "applications:firefox.desktop"
  #                   "applications:systemsettings.desktop"
  #                   "applications:org.kde.dolphin.desktop"
  #                   "applications:org.kde.konsole.desktop"
  #                   "applications:org.kde.kate.desktop"
  #                 ];
  #                 behavior = {
  #                   showTasks = {
  #                     onlyInCurrentScreen = true;
  #                     onlyInCurrentDesktop = true;
  #                     onlyInCurrentActivity = true;
  #                   };
  #                 };
  #               };
  #             }
  #             "org.kde.plasma.marginsseparator"
  #             {
  #               systemTray.items = {
  #                 shown = [
  #                   "org.kde.plasma.battery"
  #                 ];
  #                 hidden = [
  #                   "org.kde.plasma.addons.katesessions"
  #                 ];
  #                 configs = {
  #                   battery.showPercentage = true;
  #                 };
  #               };
  #             }
  #             {
  #               digitalClock = {
  #                 time = {
  #                   showSeconds = "always";
  #                   format = "24h";
  #                 };
  #                 calendar = {
  #                   firstDayOfWeek = "monday";
  #                   showWeekNumbers = true;
  #                   plugins = [ "holidaysevents" "astronomicalevents" ];
  #                 };
  #               };
  #             }
  #             "org.kde.plasma.showdesktop"
  #           ];
  #           hiding = "none";
  #           floating = false;
  #         }
  #       ];

  #       window-rules = [
  #         {
  #           description = "Plasma Desktop Workspace";
  #           match = {
  #             window-class = {
  #               value = "org.kde.plasmashell";
  #               type = "exact";
  #               match-whole = false;
  #             };
  #           };
  #           apply = {
  #             skippager = {
  #               value = true;
  #               apply = "force";
  #             };
  #             skipswitcher = {
  #               value = true;
  #               apply = "force";
  #             };
  #             skiptaskbar = {
  #               value = true;
  #               apply = "force";
  #             };
  #           };
  #         }
  #         {
  #           description = "Discord";
  #           match = {
  #             window-class = {
  #               value = "discord";
  #               type = "exact";
  #               match-whole = false;
  #             };
  #             title = {
  #               value = "Discord$|Discord Updater";
  #               type = "regex";
  #             };
  #           };
  #           apply = {
  #             maximizehoriz = {
  #               value = true;
  #               apply = "initially";
  #             };
  #             maximizevert = {
  #               value = true;
  #               apply = "initially";
  #             };
  #             screen = {
  #               value = 1;
  #               apply = "remember";
  #             };
  #             activity = {
  #               value = "Communication";
  #               apply = "force";
  #             };
  #             desktops = {
  #               value = "Desktop_1";
  #               apply = "force";
  #             };
  #           };
  #         }
  #         {
  #           description = "Ferdi";
  #           match = {
  #             window-class = {
  #               value = "^Ferdi";
  #               type = "regex";
  #               match-whole = false;
  #             };
  #             title = {
  #               value = "^Ferdi";
  #               type = "regex";
  #             };
  #           };
  #           apply = {
  #             maximizehoriz = {
  #               value = true;
  #               apply = "initially";
  #             };
  #             maximizevert = {
  #               value = true;
  #               apply = "initially";
  #             };
  #             screen = {
  #               value = 2;
  #               apply = "remember";
  #             };
  #             activity = {
  #               value = "Communication";
  #               apply = "force";
  #             };
  #             desktops = {
  #               value = "Desktop_1";
  #               apply = "force";
  #             };
  #           };
  #         }
  #       ];

  #       powerdevil = {
  #         AC = {
  #           autoSuspend = {
  #             action = "nothing";
  #           };
  #           dimDisplay.enable = false;
  #           powerProfile = "performance";
  #           turnOffDisplay.idleTimeout = "never";
  #         };
  #         battery = {
  #           autoSuspend = {
  #             action = "sleep";
  #             idleTimeout = 600;
  #           };
  #           whenSleepingEnter = "standby";
  #           dimDisplay = {
  #             idleTimeout = 300;
  #           };
  #           powerProfile = "powerSaving";
  #           turnOffDisplay = {
  #             idleTimeout = 600;
  #           };
  #         };
  #         lowBattery = {
  #           whenLaptopLidClosed = "shutDown";
  #           powerProfile = "powerSaving";
  #         };
  #         batteryLevels = {
  #           criticalLevel = 3;
  #           lowLevel = 10;
  #           criticalAction = "shutDown";
  #         };
  #       };

  #       kwin = {
  #         effects = {
  #           blur.enable = true;
  #           dimAdminMode.enable = true;
  #           wobblyWindows.enable = true;
  #           minimization.animation = "magiclamp";
  #         };
  #         nightLight = {
  #           enable = true;
  #           location.latitude = "52";
  #           location.longitude = "13";
  #           mode = "location";
  #           temperature.night = 2700;
  #         };
  #         titlebarButtons = {
  #           left = [ "more-window-actions" ];
  #           right = [ "keep-above-windows" "minimize" "maximize" "close" ];
  #         };
  #         virtualDesktops = {
  #           number = 4;
  #           rows = 1;
  #           names = [
  #             "Desktop 1"
  #             "Desktop 2"
  #             "Desktop 3"
  #             "Desktop 4"
  #           ];
  #         };
  #       };

  #       shortcuts = {
  #         "org.kde.konsole.desktop"."_launch" = "Ctrl+Alt+T";
  #         kwin = {
  #           "Switch One Desktop to the Left" = "Ctrl+Alt+Left";
  #           "Switch One Desktop to the Right" = "Ctrl+Alt+Right";
  #           "Window Close" = "Alt+F4\tMeta+Q";
  #           "Kill Window" = "Meta+Ctrl+Esc\tCtrl+Alt+Esc";
  #           "Expose" = "Ctrl+F9\tMeta+A";
  #           "Window Maximize" = "Meta+PgUp\tMeta+Up";
  #           "Window Quick Tile Top" = "none";
  #           "Window One Desktop to the Left" = "Meta+Ctrl+Shift+Left\tCtrl+Alt+Shift+Left";
  #           "Window One Desktop to the Right" = "Meta+Ctrl+Shift+Right\tCtrl+Alt+Shift+Right";
  #         };
  #         mediacontrol.playpausemedia = "Media Play\tCtrl+Alt+D";
  #         plasmashell."manage activities" = "none";
  #         plasmashell."switch to next activity" = "Meta+Tab";
  #       };

  #       hotkeys.commands = {
  #         "change-keyboard-layout" = {
  #           name = "Change Keyboard Layout";
  #           key = "Ctrl+Alt+K";
  #           command = "/home/${vars.user}/bin/change-keyboard-layout";
  #           logs.enabled = false;
  #         };
  #         "spectacle" = {
  #           name = "Spectacle Screenshot";
  #           key = "Meta+Shift+S";
  #           command = "${pkgs.kdePackages.spectacle}/bin/spectacle -r";
  #           logs.enabled = false;
  #         };
  #         "xrandr-display" = {
  #           name = "Toggle Display";
  #           key = "Ctrl+Alt+Shift+S";
  #           command = "${pkgs.bash}/bin/bash -c \"/home/${vars.user}/bin/xrandr-display && /home/${vars.user}/bin/switch-display linux && xdotool key ctrl+alt+shift+d\"";
  #           logs.enabled = false;
  #         };
  #         "switch-windows" = {
  #           name = "Switch Display to Windows Output";
  #           key = "Ctrl+Alt+Shift+A";
  #           command = "/home/${vars.user}/bin/switch-display windows";
  #           logs.enabled = false;
  #         };
  #         "reload-plasma" = {
  #           name = "Reload Plasma";
  #           key = "Meta+Shift+K";
  #           command = "${pkgs.systemd}/bin/systemctl --user restart plasma-plasmashell";
  #           logs.enabled = false;
  #         };
  #       };

  #       configFile = {
  #         PlasmaDiscoverUpdates.Global.RequiredNotificationInterval = -1;
  #         plasmashellrc."Notification Messages".klipperClearHistoryAskAgain = false;
  #         ksmserverrc.General.loginMode = "emptySession";
  #         ksmserverrc.General.shutdownType = 2;
  #         kwinrc.MouseBindings.CommandActiveTitlebar2 = "Minimize";
  #         kwinrc.MouseBindings.CommandAllWheel = "Maximize/Restore";
  #         kwinrc.MouseBindings.CommandInactiveTitlebar2 = "Minimize";
  #         kwinrc.MouseBindings.CommandTitlebarWheel = "Previous/Next Desktop";
  #         kwinrc.Windows.DelayFocusInterval = 0;
  #         kwinrc.Windows.FocusPolicy = "FocusFollowsMouse";
  #         kwinrc.Windows.NextFocusPrefersMouse = true;
  #         kcminputrc.Mouse.XLbInptAccelProfileFlat = true;
  #         kded5rc.Module-device_automounter.autoload = false;
  #         kactivitymanagerdrc.activities.Default = "Default";
  #         kactivitymanagerdrc.activities.Communication = "Communication";
  #         kactivitymanagerdrc.activities-icons.Default = "activities";
  #         kactivitymanagerdrc.activities-icons.Communication = "activities";
  #         kactivitymanagerdrc.main.currentActivity = "Default";
  #         kxkbrc.Layout.Use = true;
  #         kxkbrc.Layout.Options = "grp:win_space_toggle,caps:escape";
  #         kxkbrc.Layout.ResetOldOptions = true;
  #         kxkbrc.Layout.ShowLayoutIndicator = true;
  #         systemsettingsrc.systemsettings_sidebar_mode.HighlightNonDefaultSettings = true;
  #         "flameshot/flameshot.ini".General.showDesktopNotification = false;
  #         "flameshot/flameshot.ini".General.showStartupLaunchMessage = false;
  #         "flameshot/flameshot.ini".General.autoCloseIdleDaemon = true;
  #         "flameshot/flameshot.ini".General.disabledTrayIcon = true;
  #         "flameshot/flameshot.ini".General.saveLastRegion = true;
  #       };

  #       dataFile = {
  #         "dolphin/view_properties/global/.directory"."Dolphin"."SortRole" = "modificationtime";
  #         "dolphin/view_properties/global/.directory"."Dolphin"."ViewMode" = 1;
  #         "dolphin/view_properties/global/.directory"."Settings"."HiddenFilesShown" = true;
  #       };

  #     };
  #   };
  # };
}
