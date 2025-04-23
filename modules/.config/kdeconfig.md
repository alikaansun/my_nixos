Commands

cp ~/.config/kdeglobals ~/.dotfiles/modules/.config/
cp ~/.config/kwinrc ~/.dotfiles/modules/.config/
cp ~/.config/kglobalshortcutsrc ~/.dotfiles/modules/.config/
cp ~/.config/kwinrulesrc ~/.dotfiles/modules/.config/
cp ~/.config/kcminputrc ~/.dotfiles/modules/.config/

KDE config file paths
Panel

    .config/plasma-org.kde.plasma.desktop-appletsrc

Appearance

    Global Theme
        .config/kdeglobals
        .config/kscreenlockerrc
        .config/kwinrc
        .config/gtkrc
        .config/gtkrc-2.0
        .config/gtk-4.0/*
        .config/gtk-3.0/*
        .config/ksplashrc
    Application Style
        .config/kdeglobals
    Plasma Style
        .config/plasmarc
    Colors
        .config/kdeglobals
        .config/Trolltech.conf
    Window decorations
        .config/breezerc (or your theme name)
        .config/kwinrc
    Fonts
        .config/kdeglobals
        .config/kcmfonts
    Icons
        .config/kdeglobals [Icons]
    Cursors
        .config/kcminputrc
    Launch Feedback
        .config/klaunchrc
    Font management
        .config/kfontinstuirc
    Splash screen
        .config/ksplashrc

Workspace

    Desktop behavior
        General behavior
            .config/plasmarc
        Screen Edges
            .config/kwinrc
        Desktop Effects
            .config/kwinrc
            .config/kglobalshortcutsrc
        Touch screen
        Screen Locking
            .config/kscreenlockerrc
        Virtual desktops
        Activities
            .config/kactivitymanagerdrc: Activity meta info (activity name, activity icon)
            .config/kactivitymanagerd-switcher: Activity sorting in the activity switcher (probably as higher the number as more high in the ladder)
            .config/kactivitymanagerd-statsrc: Sorting of favourite (most used) applications by activity
            .config/kactivitymanagerd-pluginsrc
            .config/kglobalshortcutsrc
            .config/plasma-org.kde.plasma.desktop-appletsrc: Layout per activity
    Window Management
        Window behavior
            .config/kwinrc
        Window Rules
            .config/kwinrulesrc
        Task switcher
            .config/kglobalshortcutsrc
            .config/kwinrc
        KWin scripts
            .config/kwinrc
    Shortcuts
        Custom Shortcuts
            .config/khotkeysrc
        Global Shortcuts
            .config/kglobalshortcutsrc
    Startup and Shutdown
        Login screen
        Autostart
        Background Services
            .config/kded5rc
        Desktop Session
            .config/ksmserverrc
    Search
        KRunner
            .config/krunnerrc
        File Search
            .config/baloofilerc
        Web Search Keywords
            .config/kuriikwsfiltersrc
            .local/share/kservices5/searchproviders/

System Monitor

    Page Settings
        .local/share/plasma-systemmonitor/: One page file per page

Personalization

    Notifications
        .config/plasmanotifyrc
    Users
    Regional Settings
        Language
            .config/plasma-localerc
        Formats
            .config/plasma-localerc
        Spell Check
        Date & Time
            .config/ktimezonedrc
    Accessibility
        .config/kaccessrc
    Applications
        File associations
            .config/mimeapps.list
        Locations
            .config/user-dirs.dirs
            .local/share/user-places.xbel
        Launch Feedback
        Default Applications
            .config/mimeapps.list
    KDE Wallet
    Online Accounts
    User Feedback
        .config/PlasmaUserFeedback

Network

    Connections
        /etc/NetworkManager/system-connections
    Settings
        Proxy
        Connection Preferences
        SSL Preferences
        Cache
        Cookies
        Browser Identification
        Windows Shares

Hardware

    Input Devices
        Keyboard
            Hardware
                .config/kcminputrc
            Layouts
                .config/kxkbrc
            Advanced
                .config/kxkbrc
        Mouse
            .config/kcminputrc
        Game Controller
        Touchpad
            .config/touchpadxlibinputrc (x11)
            .config/kcminputrc (wayland)
    Display and Monitor
        Compositor
        Gamma
            .config/kgammarc
        Night Color
            .config/kwinrc
    Audio
    Power Management
        Energy Saving
            .config/powermanagementprofilesrc
    Bluetooth
        .config/bluedevilglobalrc
    KDE Connect
        .config/kdeconnect
    Removable Storage
        .config/device_automounter_kcmrc
        .config/kded_device_automounterrc

KDE Applications
Ark

    .config/arkrc

Dolphin

    .config/dolphinrc

Filelight

    .config/filelightrc

Gwenview

    .config/dolphinrc

Kate

    .config/katerc
    .config/katevirc
    .config/kate-externaltoolspluginrc

KCalc

    .config/kcalcrc

KDE Partition Manager

    .config/partitionmanagerrc

Konsole

    .config/konsolerc
    .config/konsolesshconfig

Krusader

    .config/krusaderrc

Spectacle

    .config/spectaclerc

System Monitor

    .config/systemmonitorrc

System Settings

    .config/systemsettingsrc

Settings
changing appearance
on plasma 5.22 and above you can use this self-explanatory commands to change appearance

plasma-apply-colorscheme
plasma-apply-cursortheme
plasma-apply-desktoptheme
plasma-apply-lookandfeel
plasma-apply-wallpaperimage

usage example:
plasma-apply-desktoptheme --list-themes
plasma-apply-desktoptheme breeze-dark

Screen Edges
Active Screen Corners and Edges

Corners are numbered like this:

7 - 8 - 3
6 -   - 2
5 - 4 - 1

actions are defined in [ElectricBorders] and animations are in other groups, probably in [effect-*] and [TabBox]. To Disable them run these commands
Window Decorations

Buttons on the title bar can be customized by these commands

list of symbol meaning:

    N - Application Menu
    S - On all desktops
    H - Context help
    L - Shade
    B - Keep below
    F - Keep above
    M - Menu
    I - Minimize
    A - Maximize
    X - Close
