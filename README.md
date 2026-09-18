<img src="https://raw.githubusercontent.com/LXRCore/.github/main/profile/lxrcore-logo.png" alt="LXRCore" width="72" align="left" style="margin-right:12px">

# lxr-playerlimits — Extended-slot RedM build notes (archived)

This repository is **not a resource**. It is a fork of the Cfx.re source
tree carrying one patch — the 32 → 128 physical player slot change in
`code/components/gta-game-rdr3/src/NetworkPlayerMgr.cpp` — with build
notes in `BUILD_INSTRUCTIONS.md` and the diff in `PATCHES.md`.

The `lxr-playerlimits/` resource folder that once shipped with it is
retired: the LXRCore v3 core needs nothing from it (`Config.Server` in
`lxr-core` covers whitelist, closed-server and slot behaviour), and it is
not part of the recipe.

The repository is archived for reference. Building custom RedM binaries
may violate the platform terms; the notes are for private, whitelisted
servers only.

## Licence

The Cfx.re tree keeps its own licence (`code/LICENSE`). The patch and
notes: © 2026 iBoss21 / LXRCore — All Rights Reserved.
