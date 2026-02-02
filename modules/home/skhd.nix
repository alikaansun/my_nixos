{
  flake.homeModules.skhd =
    {
      pkgs,
      config,
      ...
    }:
    {
      services.skhd = {
        enable = true;

        config = ''
          # Application launcher shortcuts (matching plasma config)
          cmd - return : open -a "Kitty"
          cmd - space : open -a "Brave-Browser"
          ctrl + alt - v : open -a "Visual Studio Code"
          ctrl + alt - d : open -a "Discord"
          ctrl + alt - o : open -a "Obsidian"
          ctrl + alt - k : open -a "KeePassXC"

          # Lock screen
          cmd - l : pmset displaysleepnow
        '';
      };
    };

  # Darwin module for skhd .app wrapper (needed for Accessibility permissions)
  flake.darwinModules.skhd =
    { pkgs, config, ... }:
    {
      # Create .app wrapper for skhd so it can be added to Accessibility permissions
      system.activationScripts.postActivation.text = ''
        mkdir -p /Applications/skhd.app/Contents/MacOS
        cat > /Applications/skhd.app/Contents/Info.plist << 'EOF'
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>CFBundleExecutable</key>
            <string>skhd</string>
            <key>CFBundleIdentifier</key>
            <string>com.koekeishiya.skhd</string>
            <key>CFBundleName</key>
            <string>skhd</string>
            <key>CFBundleVersion</key>
            <string>1.0</string>
        </dict>
        </plist>
        EOF
        ln -sf /etc/profiles/per-user/alik/bin/skhd /Applications/skhd.app/Contents/MacOS/skhd
      '';
    };
}
