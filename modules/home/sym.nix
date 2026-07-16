{
  # Central place for all hand-managed symlinks.
  #
  # Claude Code config/state lives in the ObsNotes vault (under <vault>/_claude)
  # so it can be edited as notes in Obsidian, and is symlinked back into
  # ~/.claude here. mkOutOfStoreSymlink links to the live path (not a read-only
  # nix store copy), so edits in Obsidian and writes by Claude Code both land in
  # the vault.
  flake.homeModules.sym =
    {
      config,
      vars,
      ...
    }:
    let
      claudeDir = "${config.home.homeDirectory}/${vars.obsidian.vault}/_claude";
      link = target: config.lib.file.mkOutOfStoreSymlink target;
    in
    {
      home.file = {
        ".claude/CLAUDE.md".source = link "${claudeDir}/CLAUDE.md";
        ".claude/settings.json".source = link "${claudeDir}/settings.json";
        ".claude/keybindings.json".source = link "${claudeDir}/keybindings.json";
        ".claude/skills".source = link "${claudeDir}/skills";
        ".claude/hooks".source = link "${claudeDir}/hooks";
        # Claude Code's per-project memory dir for this repo.
        ".claude/projects/-Users-alik--dotfiles/memory".source = link "${claudeDir}/memory";
      };
    };
}
