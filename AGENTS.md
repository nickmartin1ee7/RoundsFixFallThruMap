# Repository Guide

## Thunderstore Content

- `README.md` is published on the Thunderstore package page. Keep it short and player-facing: describe the problem the mod fixes, its behavior, and installation through Thunderstore Mod Manager.
- Do not add manual installation, build, stub, or implementation details to `README.md` unless they are relevant to package users.
- Keep `manifest.json` `version_number` aligned with the plugin `Version` constant in `RoundsFixFallThruMap/RoundsFixFallThruMap.cs` before creating a release.

## Release Workflow

1. Update the plugin version and `manifest.json` version together.
2. Run `./tools/build-release.sh`. It auto-detects ROUNDS; use `./tools/build-release.sh --rounds /path/to/ROUNDS` to specify an installation explicitly.
3. Do not use `--stubs` for a distributable release. It is for local validation only.
4. `zip` is required. If unavailable, run `nix-shell -p zip --run './tools/build-release.sh'`.
5. Confirm the timestamped archive under `artifacts/` contains only `RoundsFixFallThruMap.dll`, `README.md`, `manifest.json`, and `icon.png`, and that the archived manifest has the intended version.
6. Do not commit generated `artifacts/` archives, `bin/`, or `obj/`; they are ignored by design.

## Local Install / Uninstall Scripts

- `tools/install-local.sh --plugins /path/to/BepInEx/plugins` — copies the pre-built Release DLL (`RoundsFixFallThruMap/bin/Release/netstandard2.1/RoundsFixFallThruMap.dll`) into a local BepInEx plugins directory. Requires `./tools/build-release.sh` to have been run first.
- `tools/uninstall-local.sh --plugins /path/to/BepInEx/plugins` — removes the DLL from a local BepInEx plugins directory.

## CI Release Pipeline

- Pushing a `v*` tag triggers `.github/workflows/release.yml`, which restores the encrypted ROUNDS build dependencies from `ROUNDS/ROUNDS.7z.*`, builds a distributable archive, and publishes it as a GitHub Release.
- The encrypted archive requires the `ROUNDS_ARCHIVE_PASSWORD` Actions secret. Update the parts with: `7z a -t7z -mhe=on -p"$ROUNDS_ARCHIVE_PASSWORD" -v10240k ROUNDS.7z *` (from the unpacked tree) and commit the resulting `ROUNDS/ROUNDS.7z.*` parts. Keep the same password, or update the secret in lockstep.
- Secrets and the archive must stay in sync — never change one without the other.
