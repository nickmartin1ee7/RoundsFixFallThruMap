using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;

namespace BepInEx
{
    [AttributeUsage(AttributeTargets.Class)]
    public sealed class BepInPluginAttribute : Attribute
    {
        public BepInPluginAttribute(string modId, string modName, string version) { }
    }

    [AttributeUsage(AttributeTargets.Class)]
    public sealed class BepInProcessAttribute : Attribute
    {
        public BepInProcessAttribute(string processName) { }
    }

    public class BaseUnityPlugin
    {
        public BepInEx.Logging.Logger Logger => new BepInEx.Logging.Logger();
    }

    namespace Logging
    {
        public class Logger
        {
            public void LogInfo(string message) { }
        }
    }
}

namespace HarmonyLib
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method)]
    public sealed class HarmonyPatchAttribute : Attribute
    {
        public HarmonyPatchAttribute() { }
        public HarmonyPatchAttribute(Type type, string methodName) { }
    }

    [AttributeUsage(AttributeTargets.Method)]
    public sealed class HarmonyPrefixAttribute : Attribute { }

    [AttributeUsage(AttributeTargets.Method)]
    public sealed class HarmonyPostfixAttribute : Attribute { }

    public class Harmony
    {
        public Harmony(string id) { }

        public static Harmony CreateAndPatchAll(Type type)
        {
            return new Harmony(type.FullName ?? "stub");
        }
    }
}

namespace Photon.Pun
{
    public static class PhotonNetwork
    {
        public static bool IsMasterClient { get; set; }
    }
}

namespace UnityEngine
{
    public class GameObject
    {
        public string name { get; set; }
    }
}

namespace UnboundLib.Utils
{
    public class LevelManager
    {
        public static SortedDictionary<string, Level> levels = new SortedDictionary<string, Level>();
        public static ObservableCollection<string> activeLevels = new ObservableCollection<string>();

        public static bool IsLevelActive(string levelName) => activeLevels.Contains(levelName);

        public static void EnableLevel(string levelName, bool saved = true)
        {
            if (!activeLevels.Contains(levelName))
            {
                activeLevels.Add(levelName);
            }
        }

        public static void DisableLevel(string levelName, bool saved = true)
        {
            if (activeLevels.Contains(levelName))
            {
                activeLevels.Remove(levelName);
            }
        }
    }

    public class Level
    {
        public Level(string name, bool enabled = true, bool selected = false, string category = "Vanilla")
        {
            this.name = name;
            this.enabled = enabled;
            this.selected = selected;
            this.category = category;
        }

        public string name { get; set; }
        public bool enabled { get; set; }
        public bool selected { get; set; }
        public string category { get; set; }
    }
}

namespace UnboundLib.Utils.UI
{
    public class ToggleLevelMenuHandler
    {
        public static ToggleLevelMenuHandler instance { get; set; }
        public List<UnityEngine.GameObject> lvlObjs { get; } = new List<UnityEngine.GameObject>();

        public static void UpdateVisualsLevelObj(UnityEngine.GameObject obj) { }
    }
}

namespace UnboundLib
{
    public static class Unbound
    {
        public static void BuildInfoPopup(string message) { }
        public static void BuildModal() { }
    }
}

public class MapManager
{
    public static MapManager instance { get; set; } = new MapManager();
    public string[] levels { get; set; } = Array.Empty<string>();
}

namespace System.Runtime.CompilerServices
{
    public sealed class IsExternalInit { }
}
