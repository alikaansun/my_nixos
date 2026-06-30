---
name: never-run-rebuild-switch
description: User always runs nixos-rebuild/darwin-rebuild switch themselves — never do it for them
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 70aa497e-3d4c-4f04-800e-a9f4aa3d7c20
---

Never run `darwin-rebuild switch`, `nixos-rebuild switch`, or their aliases (`drs`, `nrs`). The user always applies the rebuild themselves.

**Why:** Rebuild switch is system-altering and the user wants to control when it happens.

**How to apply:** After editing nix config, stop at the point of applying. Tell the user the change is ready and let them run the rebuild. You may still run `nix fmt` and build/eval-only checks (e.g. `nix flake check`, `darwin-rebuild build`) if useful, but not `switch`.
