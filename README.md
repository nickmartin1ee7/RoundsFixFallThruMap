# Rounds Fix Fall Thru Map

This is a small BepInEx plugin for ROUNDS.

It fixes the case where a player has a few maps disabled locally, joins a friend's lobby, and then remains stuck with those maps disabled even though the host has them enabled. The plugin re-applies the host's map list once the handshake arrives and keeps the current in-game map pool aligned with the host.

## How it works

- The plugin hooks the UnboundLib map sync callback.
- When the host replies with the allowed map list, the client re-enables maps that are allowed by the host and disables those that are not.
- The changes are kept temporary for the current match so they do not permanently rewrite the player's config unless the stock UnboundLib behavior does so.

## Install

1. Install BepInEx for ROUNDS.
2. Install UnboundLib.
3. Build this project and copy the generated DLL into `ROUNDS/BepInEx/plugins`.
4. Launch the game and join a friend.

## Build

Edit the `RoundsFolder` path in `RoundsFixFallThruMap.csproj` to match your local ROUNDS install, then run:

```powershell
dotnet build .\RoundsFixFallThruMap.csproj
```

The output DLL is placed in the project output directory and can be copied to the plugin folder.
