# FixFallThruMap

A small BepInEx plugin for ROUNDS that ensures a client's map pool matches the host's when joining a friend's game. Prevents map-related issues (falling through, missing objects) caused by locally disabled maps.

Status: development

## Features
- Apply host-approved map list on join (patches UnboundLib handshake).
- Update map menu visuals for the session.
- Non-destructive: does not permanently change user config.

## Dependencies
- UnboundLib (willis81808-UnboundLib-3.2.14)
- BepInEx (BepInExPack_ROUNDS-5.4.1901)

## Installation (r2modman)
1. Open r2modman and select the TOP profile (or your profile).
2. Copy the packaged ZIP's DLL into the profile's BepInEx/plugins folder:
   `~/.config/r2modmanPlus-local/ROUNDS/profiles/TOP/BepInEx/plugins/`
3. Launch ROUNDS via r2modman and confirm the plugin loads.

## Manual install
Copy `RoundsFixFallThruMap.dll` to `ROUNDS/BepInEx/plugins/` then start the game.

## Packaging (Thunderstore)
Package ZIP must contain the following at the archive root:
- icon.png (256×256 PNG)
- README.md (this file, UTF-8)
- manifest.json (Thunderstore v1 fields: name, version_number, website_url, description, dependencies)

Use `./build-release.sh` to build and produce a timestamped ZIP in `artifacts/`. Validate the manifest with: https://thunderstore.io/tools/manifest-v1-validator/ before uploading.

## Building
Release (recommended):
```bash
./build-release.sh --rounds /path/to/ROUNDS
```
Developer (stubs):
```bash
./build-release.sh --stubs
```

## Release notes
- Keep `manifest.json` dependency strings exact (Team-Package-Version) before publishing.
- Bump `version_number` in `manifest.json` for each new Thunderstore upload.

## License
See LICENSE in the repository.
