{
  # Keeps the Zotero library readable by text tools: every PDF attachment gets a
  # markdown sibling with its figures extracted, and every item gets a stub note in
  # the vault so Obsidian Bases and ripgrep can both index the library.
  #
  # The script is re-runnable and incremental, so hooking it to activation costs
  # nothing after the first run. It is also exposed as `zotero-md-sync` for manual
  # runs (`--dry-run`, `--limit N`).
  flake.homeModules.zotero =
    {
      config,
      pkgs,
      vars,
      ...
    }:
    let
      pythonEnv = import ../_files/pythonEnv.nix { inherit pkgs; };
      zoteroSync = pkgs.writeShellScriptBin "zotero-md-sync" ''
        exec ${pythonEnv}/bin/python3 ${../_files/zotero_sync.py} \
          --zotero "$HOME/${vars.zotero.dir}" \
          --vault "$HOME/${vars.obsidian.vault}" "$@"
      '';
    in
    {
      home.packages = [ zoteroSync ];

      # home-manager runs activation under `set -e`, so an unguarded failure here
      # would abort the whole switch.
      home.activation.zoteroMdSync = config.lib.dag.entryAfter [ "writeBoundary" ] ''
        ${zoteroSync}/bin/zotero-md-sync || echo "  zotero-md-sync failed (non-fatal)" >&2
      '';
    };
}
