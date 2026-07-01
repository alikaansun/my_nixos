{
  flake.homeModules.obs =
    { ... }:
    {
      programs.obsidian = {
        enable = true;

        vaults.ObsNotes.target = "Documents/ObsNotes";

        defaultSettings = {
          app.alwaysUpdateLinks = true;
          appearance.translucency = false;

          corePlugins = [
            "file-explorer"
            "global-search"
            "switcher"
            "graph"
            "backlink"
            "canvas"
            "outgoing-link"
            "tag-pane"
            "properties"
            "page-preview"
            "daily-notes"
            "templates"
            "note-composer"
            "command-palette"
            "editor-status"
            "bookmarks"
            "outline"
            "word-count"
            "file-recovery"
            "sync"
            "bases"
          ];
        };
      };
    };
}
