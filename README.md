# Rounds Fix Fall Thru Map

A small BepInEx plugin for ROUNDS that ensures a client's map pool matches the host's when joining a friend's game. This prevents map-related issues (falling through, missing objects) caused by locally disabled maps.

Status: development

## Features
- Applies the host-approved map list on join by patching UnboundLib's map-handshake response.
- Updates the map menu visuals to reflect the host's allowed maps for the running session.
- Avoids forcing permanent user config changes; behavior follows UnboundLib semantics.

## Dependencies
- BepInEx (plugin framework)
- UnboundLib (REQUIRED) — declared as a hard dependency in the plugin

## Installation
1. Install BepInEx into your ROUNDS install directory.
2. Install UnboundLib into `ROUNDS/BepInEx/plugins`.
3. Build this project and copy the produced DLL to `ROUNDS/BepInEx/plugins` (or the equivalent mod manager profile folder).
4. Launch ROUNDS and join a friend's lobby.

## Building
Recommended (release) — build against a real ROUNDS install so the mod compiles against the correct API:

```bash
# point to your ROUNDS install
dotnet build RoundsFixFallThruMap.slnx -p:RoundsFolder="/path/to/ROUNDS"
```

Developer convenience — local-only validation without the game present:

```bash
# uses included stubs; not recommended for releases
dotnet build RoundsFixFallThruMap.slnx -p:AllowLocalStubs=true
```

Notes:
- The project intentionally fails the build when a real ROUNDS install is not found (unless `AllowLocalStubs` is set). This prevents accidentally shipping a DLL built against the stub API.
- The csproj attempts to auto-detect common Steam and r2modman paths; override `RoundsFolder` or `UnboundLibPath` if necessary.

## Development
- The plugin declares a hard dependency on UnboundLib so BepInEx will load it only when UnboundLib is available.
- Reflection is used defensively to read private UnboundLib fields where necessary to remain compatible across versions.

## License
See LICENSE in the repository.
