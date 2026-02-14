# 📦 Installation Guide - LXR Player Limits

## Quick Start

```bash
# 1. Download
cd resources
git clone https://github.com/LXRCore/lxr-playerlimits.git

# 2. Configure
nano lxr-playerlimits/config.lua

# 3. Add to server.cfg
echo "ensure lxr-playerlimits" >> server.cfg

# 4. Restart server
restart lxr-playerlimits
```

---

## Detailed Installation

### Step 1: Prerequisites

#### Required
- ✅ RedM Server (Latest build)
- ✅ OneSync enabled (`set onesync on` or `set onesync infinity`)
- ✅ Server access (FTP/SSH)

#### Optional (for 64+ players)
- ⚠️ Custom-built RedM with player extension patches
- ⚠️ See [TECHNICAL.md](TECHNICAL.md) for build instructions

---

### Step 2: Download the Resource

#### Method 1: Git Clone (Recommended)
```bash
cd /path/to/your/server/resources
git clone https://github.com/LXRCore/lxr-playerlimits.git
```

#### Method 2: Manual Download
1. Go to https://github.com/LXRCore/lxr-playerlimits
2. Click "Code" → "Download ZIP"
3. Extract to your server's `resources` folder
4. **Ensure the folder is named** `lxr-playerlimits` (not `lxr-playerlimits-main`)

---

### Step 3: Configuration

#### Basic Configuration

Edit `lxr-playerlimits/config.lua`:

```lua
-- Set your maximum player limit
Config.PlayerLimits = {
    maxPhysicalPlayers = 32,  -- Change to 64, 128, or 256 for custom builds
    enforceStrictChecks = true,
    enableMonitoring = true
}

-- Set your framework (or leave as 'auto')
Config.Framework = 'auto'  -- Detects LXR-Core, RSG-Core, VORP, etc.

-- Set your language
Config.Lang = 'en'  -- 'en' for English, 'ge' for Georgian
```

#### Standard Build (31 Players)
```lua
Config.PlayerLimits = {
    maxPhysicalPlayers = 32,
    warnOnStandardBuild = true,  -- Will warn that you're on standard build
}
```

#### Custom Build (128 Players)
```lua
Config.PlayerLimits = {
    maxPhysicalPlayers = 128,
    warnOnStandardBuild = false,
    optimizeNetworking = true,    -- Enable for 64+ players
    dynamicSyncDistance = true    -- Auto-reduce sync distance
}
```

---

### Step 4: Server Configuration

#### server.cfg Setup

Add to your `server.cfg`:

```cfg
# ═══════════════════════════════════════════════════════════════════
# LXR Player Limits Configuration
# ═══════════════════════════════════════════════════════════════════

# Enable OneSync (REQUIRED)
set onesync infinity

# Set max clients (match your build capacity)
set sv_maxclients 32
# For custom builds: set sv_maxclients 64, 128, or 256

# Ensure the resource
ensure lxr-playerlimits

# ═══════════════════════════════════════════════════════════════════
```

#### Performance Optimization (for 64+ players)

```cfg
# Network optimizations
set sv_packetBuffer 10000
set sv_bandwidth 50000

# Tick rate (reduce slightly for high player counts)
set sv_maxTickRate 50

# Entity limits
set onesync_maxEntityCullingRange 350.0  # Reduce from 424
set onesync_populationCulling 1

# Memory optimizations
set sv_scriptHookAllowed 0
```

---

### Step 5: Framework Setup

#### LXR-Core
```lua
-- No additional setup needed
-- Resource auto-detects LXR-Core
```

#### RSG-Core
```lua
-- No additional setup needed
-- Resource auto-detects RSG-Core
```

#### VORP Core
```lua
-- No additional setup needed
-- Resource auto-detects VORP
```

#### Standalone (No Framework)
```lua
Config.Framework = 'standalone'
```

---

### Step 6: Permissions

#### Admin Commands
Admin commands require ACE permissions:

```cfg
# server.cfg
add_ace group.admin lxr-playerlimits.admin allow

# Grant admin group to specific users
add_principal identifier.steam:YOUR_STEAM_ID group.admin
add_principal identifier.license:YOUR_LICENSE group.admin
```

#### Command Permissions
```cfg
# Allow specific commands
add_ace group.admin command.playerlimits allow
add_ace group.admin command.playerstats allow
add_ace group.admin command.playerslots allow
```

---

### Step 7: Verification

#### Start the Resource
```bash
# Console or RCON
ensure lxr-playerlimits
```

#### Check Server Console
Look for the startup banner:
```
═══════════════════════════════════════════════════════════════════════════════

    ██╗     ██╗  ██╗██████╗       ██████╗ ██╗      █████╗ ██╗   ██╗███████╗██████╗ 
    ██║     ╚██╗██╔╝██╔══██╗      ██╔══██╗██║     ██╔══██╗╚██╗ ██╔╝██╔════╝██╔══██╗
    ██║      ╚███╔╝ ██████╔╝█████╗██████╔╝██║     ███████║ ╚████╔╝ █████╗  ██████╔╝
    ...
    
    🐺 The Land of Wolves - RedM Player Limits Removal
    Version: 1.0.0
    
═══════════════════════════════════════════════════════════════════════════════

🐺 LXR PLAYER LIMITS - BUILD DETECTION RESULTS
═══════════════════════════════════════════════════════════════════════════════

OneSync Enabled:       true
OneSync Mode:          infinity
Custom Build Detected: false
Physical Player Limit: 32
Server Max Clients:    32

═══════════════════════════════════════════════════════════════════════════════
```

#### Test Admin Commands
In-game or console:
```
/playerlimits
```

Expected output:
```
═══════════════════════════════════════════════════════════════════════════════
🐺 LXR PLAYER LIMITS - STATUS
═══════════════════════════════════════════════════════════════════════════════

Physical Limit:    32
Current Players:   1
Free Slots:        31
Peak Players:      1
Capacity:          3.1%

Custom Build:      false
OneSync:           true (infinity)

═══════════════════════════════════════════════════════════════════════════════
```

---

## Upgrade Guide

### Updating from Older Versions

#### Method 1: Git Pull
```bash
cd /path/to/resources/lxr-playerlimits
git pull origin main
restart lxr-playerlimits
```

#### Method 2: Manual Update
1. Download latest version
2. Backup your `config.lua`
3. Replace all files except `config.lua`
4. Compare new `config.lua` for new options
5. Restart resource

---

## Configuration Examples

### Example 1: Standard RedM Server (31 Players)
```lua
Config.PlayerLimits = {
    maxPhysicalPlayers = 32,
    enforceStrictChecks = true,
    warnOnStandardBuild = true,
    enableMonitoring = true,
    warningThreshold = 0.85,
    optimizeNetworking = false,  -- Not needed for 32 players
    dynamicSyncDistance = false
}
```

### Example 2: Custom Build (64 Players)
```lua
Config.PlayerLimits = {
    maxPhysicalPlayers = 64,
    enforceStrictChecks = true,
    warnOnStandardBuild = false,
    enableMonitoring = true,
    warningThreshold = 0.80,
    criticalThreshold = 0.90,
    optimizeNetworking = true,
    dynamicSyncDistance = true,
    
    syncDistanceScaling = {
        [32] = 424.0,
        [64] = 350.0
    }
}
```

### Example 3: Custom Build (128 Players)
```lua
Config.PlayerLimits = {
    maxPhysicalPlayers = 128,
    enforceStrictChecks = true,
    warnOnStandardBuild = false,
    enableMonitoring = true,
    warningThreshold = 0.75,
    criticalThreshold = 0.85,
    optimizeNetworking = true,
    dynamicSyncDistance = true,
    reduceSyncDistance = true,
    
    syncDistanceScaling = {
        [32]  = 424.0,
        [64]  = 350.0,
        [96]  = 300.0,
        [128] = 250.0
    }
}

Config.Performance = {
    monitoringInterval = 30000,
    metricsInterval = 60000,
    enableMemoryProfiling = true,
    garbageCollectInterval = 300000,
    batchPlayerUpdates = true,
    useCompression = true
}
```

---

## Troubleshooting

### Resource Won't Start

#### Problem: `Error parsing config.lua`
**Solution**:
```bash
# Check for syntax errors
lua5.3 -l config.lua

# Common issues:
# - Missing commas
# - Unmatched brackets
# - Invalid Lua syntax
```

#### Problem: `Resource name mismatch`
**Solution**: The folder MUST be named `lxr-playerlimits`
```bash
# Rename if needed
mv lxr-playerlimits-main lxr-playerlimits
```

### OneSync Issues

#### Problem: `WARNING: ONESYNC REQUIRED`
**Solution**: Add to server.cfg:
```cfg
set onesync on
# OR (recommended)
set onesync infinity
```

### Framework Detection Issues

#### Problem: Framework not detected
**Solution**: 
1. Ensure your framework is started BEFORE lxr-playerlimits
2. Check framework resource name matches config
3. Try manual framework setting:
```lua
Config.Framework = 'lxr-core'  -- or 'rsg-core', 'vorp_core', etc.
```

### Permission Issues

#### Problem: Commands don't work
**Solution**: Add ACE permissions:
```cfg
add_ace group.admin lxr-playerlimits.admin allow
add_principal identifier.steam:YOUR_ID group.admin
```

### Build Detection Issues

#### Problem: Shows 32 limit but you have custom build
**Solution**:
1. Verify `sv_maxclients` is set correctly in server.cfg
2. Check you're using custom-built binaries (FXServer.exe/FXServer)
3. Enable debug mode to see detection details:
```lua
Config.Debug = true
```

---

## Performance Tuning

### Low-End Servers (32 Players)
```lua
Config.Performance = {
    monitoringInterval = 60000,    -- Check less frequently
    metricsInterval = 300000,      -- Report every 5 minutes
    enableMemoryProfiling = false,
    garbageCollectInterval = nil   -- Disable
}
```

### High-End Servers (128+ Players)
```lua
Config.Performance = {
    monitoringInterval = 15000,    -- Check more frequently
    metricsInterval = 30000,       -- Report every 30 seconds
    enableMemoryProfiling = true,
    garbageCollectInterval = 180000, -- Every 3 minutes
    batchPlayerUpdates = true,
    useCompression = true,
    prioritizeLocalPlayers = true,
    useAsyncProcessing = true,
    maxAsyncOperations = 20
}
```

---

## Support

### Getting Help

1. **Check Documentation**
   - [README.md](README.md) - Overview
   - [TECHNICAL.md](TECHNICAL.md) - Technical details
   - This file - Installation guide

2. **Common Issues**: See Troubleshooting section above

3. **Discord Support**: https://discord.gg/CrKcWdfd3A

4. **GitHub Issues**: https://github.com/LXRCore/lxr-playerlimits/issues

5. **Server Logs**: Enable debug mode:
```lua
Config.Debug = true
Config.Admin.enableDebugLogs = true
```

---

## Next Steps

After installation:

1. ✅ Verify resource started successfully
2. ✅ Test admin commands work
3. ✅ Monitor player connections
4. ✅ Check capacity warnings appear
5. ✅ Review performance metrics

For custom builds (64+ players):
1. ✅ Follow [TECHNICAL.md](TECHNICAL.md) to build custom RedM
2. ✅ Update `maxPhysicalPlayers` in config
3. ✅ Enable optimizations in config
4. ✅ Test with increasing player counts
5. ✅ Monitor server performance

---

**🐺 Made with ❤️ by The Lux Empire for The Land of Wolves**

**Need help?** Join our Discord: https://discord.gg/CrKcWdfd3A
