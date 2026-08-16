using System;
using System.Linq;
using BepInEx;
using HarmonyLib;
using Photon.Pun;
using UnboundLib.Utils;
using UnboundLib.Utils.UI;

namespace RoundsFixFallThruMap
{
    [BepInDependency("com.willis.rounds.unbound", BepInDependency.DependencyFlags.HardDependency)]
    [BepInPlugin(ModId, ModName, Version)]
    [BepInProcess("Rounds.exe")]
    public class RoundsFixFallThruMap : BaseUnityPlugin
    {
        private const string ModId = "com.github.nicks.roundsfixfallthrumap";
        private const string ModName = "Rounds Fix Fall Thru Map";
        private const string Version = "1.0.0";

        private void Awake()
        {
            Harmony.CreateAndPatchAll(typeof(MapSyncPatch));
            Logger.LogInfo("Rounds Fix Fall Thru Map is loaded.");
        }
    }

    [HarmonyPatch(typeof(LevelManager), nameof(LevelManager.RPC_HostMapHandshakeResponse))]
    internal static class MapSyncPatch
    {
        [HarmonyPostfix]
        private static void ReEnableMapsAllowedByHost(string[] levels)
        {
            if (levels == null || PhotonNetwork.IsMasterClient || LevelManager.levels == null)
            {
                return;
            }

            foreach (var map in LevelManager.levels.Keys.ToArray())
            {
                var isAllowed = levels.Contains(map, StringComparer.Ordinal);

                if (isAllowed)
                {
                    LevelManager.EnableLevel(map, false);
                }
                else
                {
                    LevelManager.DisableLevel(map, false);
                }

                if (ToggleLevelMenuHandler.instance != null)
                {
                    foreach (var obj in ToggleLevelMenuHandler.instance.lvlObjs.Where(t => t.name == map))
                    {
                        ToggleLevelMenuHandler.UpdateVisualsLevelObj(obj);
                    }
                }
            }

            if (MapManager.instance != null)
            {
                MapManager.instance.levels = LevelManager.activeLevels.ToArray();
            }
        }
    }
}
