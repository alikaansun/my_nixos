{
  # Central place for all hand-managed symlinks.
  #
  # Assistant config/state lives in the ObsNotes vault (under <vault>/_drasleona)
  # so it can be edited as notes in Obsidian, and is symlinked back into
  # ~/.claude here. mkOutOfStoreSymlink links to the live path (not a read-only
  # nix store copy), so edits in Obsidian and writes by the agent both land in
  # the vault.
  flake.homeModules.sym =
    {
      config,
      vars,
      ...
    }:
    let
      drasleonaDir = "${config.home.homeDirectory}/${vars.obsidian.vault}/_drasleona";
      link = target: config.lib.file.mkOutOfStoreSymlink target;
    in
    {
      home.file = {
        ".claude/CLAUDE.md".source = link "${drasleonaDir}/CLAUDE.md";
        ".claude/settings.json".source = link "${drasleonaDir}/settings.json";
        ".claude/keybindings.json".source = link "${drasleonaDir}/keybindings.json";
        ".claude/skills".source = link "${drasleonaDir}/skills";
        ".claude/hooks".source = link "${drasleonaDir}/hooks";
        # Claude Code keys its per-project memory dir by project path, so every
        # project that should share the one vault memory store needs its own link.
        ".claude/projects/-Users-alik--dotfiles/memory".source = link "${drasleonaDir}/memory";
        ".claude/projects/-Users-alik-Documents-ObsNotes/memory".source = link "${drasleonaDir}/memory";
      };
    };
}
