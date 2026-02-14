# 🐺 LXR Player Limits - RedM Player Extension System

```
██╗     ██╗  ██╗██████╗        ██████╗ ██╗      █████╗ ██╗   ██╗███████╗██████╗ 
██║     ╚██╗██╔╝██╔══██╗      ██╔══██╗██║     ██╔══██╗╚██╗ ██╔╝██╔════╝██╔══██╗
██║      ╚███╔╝ ██████╔╝█████╗██████╔╝██║     ███████║ ╚████╔╝ █████╗  ██████╔╝
██║      ██╔██╗ ██╔══██╗╚════╝██╔═══╝ ██║     ██╔══██║  ╚██╔╝  ██╔══╝  ██╔══██╗
███████╗██╔╝ ██╗██║  ██║      ██║     ███████╗██║  ██║   ██║   ███████╗██║  ██║
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═╝     ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝

             ██╗     ██╗███╗   ███╗██╗████████╗███████╗
             ██║     ██║████╗ ████║██║╚══██╔══╝██╔════╝
             ██║     ██║██╔████╔██║██║   ██║   ███████╗
             ██║     ██║██║╚██╔╝██║██║   ██║   ╚════██║
             ███████╗██║██║ ╚═╝ ██║██║   ██║   ███████║
             ╚══════╝╚═╝╚═╝     ╚═╝╚═╝   ╚═╝   ╚══════╝
```

## 🎯 Overview

**LXR Player Limits** is a production-grade RedM resource that extends the physical player limit beyond the default 31 players. This system provides server-side validation, optimization, and monitoring for extended player capacity on custom RedM builds with player extension patches applied.

### 🐺 Land of Wolves Branding
- **Server**: The Land of Wolves (wolves.land)
- **Developer**: iBoss21 / The Lux Empire
- **Discord**: [Join our community](https://discord.gg/CrKcWdfd3A)
- **Store**: [Tebex Store](https://theluxempire.tebex.io)

---

## ⚠️ Important Notice

**This resource DOES NOT modify the RedM client or server binaries.** It is a Lua-based resource that:
- Monitors and validates player limits
- Provides compatibility for custom-built RedM with extended player support
- Optimizes performance for high player counts
- Works on standard RedM (31 players) but designed for custom builds (64+, 128+, 256+ players)

To actually increase the player limit beyond 31, you need a **custom-built RedM** with physical player extension patches. See [TECHNICAL.md](TECHNICAL.md) for build instructions.

---

## ✨ Features

### Core Features
- 🔍 **Automatic Build Detection** - Detects standard vs custom RedM builds
- 📊 **Real-time Monitoring** - Track player counts and capacity
- 🛡️ **Security Validation** - Validate player indices and prevent exploits
- ⚡ **Performance Optimization** - Dynamic sync distance scaling for high player counts
- 📈 **Metrics & Reporting** - Comprehensive statistics and analytics
- 🎛️ **Admin Commands** - In-game commands for server management

### Framework Support
Works seamlessly with multiple frameworks:
1. **LXR-Core** (Primary)
2. **RSG-Core** (Primary)
3. **VORP Core** (Supported)
4. **RedEM:RP** (Compatible)
5. **QBR-Core** (Compatible)
6. **QR-Core** (Compatible)
7. **Standalone** (No framework required)

### Multi-Language Support
- English (en)
- Georgian (ge) - Full Georgian RP support 🇬🇪

---

## 📦 Installation

### 1. Download & Extract
```bash
cd resources
git clone https://github.com/LXRCore/lxr-playerlimits.git
```

### 2. Configure
Edit `config.lua` to match your server setup:
```lua
Config.PlayerLimits = {
    maxPhysicalPlayers = 128,  -- Set to your build's max (32, 64, 128, 256)
    enableMonitoring = true,
    optimizeNetworking = true
}
```

### 3. Add to server.cfg
```cfg
ensure lxr-playerlimits
```

### 4. Configure OneSync (Required)
```cfg
set onesync on
# or for better performance:
set onesync infinity
```

For detailed installation instructions, see [INSTALLATION.md](INSTALLATION.md).

---

## 🎮 Usage

### Admin Commands

#### `/playerlimits`
Display current player limits and capacity information
```
Physical Limit:    128
Current Players:   45
Free Slots:        83
Capacity:          35.2%
```

#### `/playerstats`
Show detailed player statistics
```
Total Slots:       128
Used Slots:        45
Free Slots:        83
Peak Players:      67
```

#### `/playerslots` (Debug Mode Only)
List all active player slots with IDs

### Exports

#### Server Exports
```lua
-- Get maximum physical player limit
local maxPlayers = exports['lxr-playerlimits']:GetMaxPhysicalPlayers()

-- Get current player count
local currentPlayers = exports['lxr-playerlimits']:GetCurrentPlayerCount()

-- Check if custom build is detected
local isCustom = exports['lxr-playerlimits']:IsCustomBuildDetected()

-- Get detailed slot information
local slotInfo = exports['lxr-playerlimits']:GetPhysicalSlotInfo()
--[[
slotInfo = {
    maxSlots = 128,
    usedSlots = 45,
    freeSlots = 83,
    peakSlots = 67,
    capacityPercent = 35.2,
    customBuild = true,
    oneSyncEnabled = true,
    oneSyncMode = 'infinity'
}
]]
```

#### Client Exports
```lua
-- Get local player's physical ID
local playerId = exports['lxr-playerlimits']:GetLocalPlayerPhysicalId()

-- Check if extended build is active
local isExtended = exports['lxr-playerlimits']:IsExtendedBuildActive()
```

---

## 🔧 Configuration

### Player Limits
```lua
Config.PlayerLimits = {
    maxPhysicalPlayers = 128,          -- Your build's max capacity
    enforceStrictChecks = true,        -- Validate player indices
    enableMonitoring = true,           -- Monitor capacity
    warningThreshold = 0.85,           -- Warn at 85% capacity
    criticalThreshold = 0.95,          -- Critical at 95% capacity
    optimizeNetworking = true,         -- Enable optimizations
    dynamicSyncDistance = true         -- Auto-adjust sync distance
}
```

### Security
```lua
Config.Security = {
    enabled = true,
    validatePlayerIndices = true,
    detectIndexSpoofing = true,
    blockInvalidPlayers = true,
    logSuspiciousActivity = true
}
```

### Performance
```lua
Config.Performance = {
    monitoringInterval = 30000,        -- 30 seconds
    metricsInterval = 60000,           -- 60 seconds
    batchPlayerUpdates = true,
    useCompression = true,
    prioritizeLocalPlayers = true
}
```

For complete configuration options, see `config.lua`.

---

## 📊 How It Works

### Standard RedM (31 Players)
```
┌─────────────────────────────────────┐
│ Standard RedM Build                 │
│ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░  │
│ 31/32 slots (Physical limit)       │
└─────────────────────────────────────┘
```

### Custom Build (128 Players)
```
┌─────────────────────────────────────┐
│ Custom RedM Build (Extended)        │
│ ▓▓▓▓▓▓▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░  │
│ 45/128 slots (Extended capacity)    │
└─────────────────────────────────────┘
```

### Technical Details
For in-depth technical information about how player limits work and how to build a custom RedM with extended support, see [TECHNICAL.md](TECHNICAL.md).

---

## 🔨 Building Custom RedM

To increase beyond 31 players, you need to build custom RedM binaries with these modifications:

1. **Patch NetworkPlayerMgr** - Increase physical player checks
2. **Resize Player Arrays** - Extend CPedIntelligenceComponent arrays
3. **Update Network Components** - Modify player list management
4. **Compile & Deploy** - Build custom client/server binaries

See [TECHNICAL.md](TECHNICAL.md) for complete build instructions based on [Ehbw's fork](https://github.com/Ehbw/fivem-fork/tree/feat/rdr3-physical-player-extension).

---

## 🐞 Troubleshooting

### Server Shows 32 Player Limit
**Problem**: Resource detects 32-player limit despite configuration
**Solution**: You're running standard RedM. You need a custom build for 64+ players.

### Players Can't Connect Beyond 31
**Problem**: Server rejects connections after 31 players
**Solution**: This is the physical limit of standard RedM. Custom build required.

### High CPU/Memory Usage
**Problem**: Performance issues with many players
**Solution**: 
- Enable `Config.Performance.optimizeNetworking = true`
- Enable `Config.PlayerLimits.dynamicSyncDistance = true`
- Reduce sync distances in config

### OneSync Errors
**Problem**: Errors about OneSync not being enabled
**Solution**: Add `set onesync on` or `set onesync infinity` to server.cfg

---

## 📝 Support & Documentation

- **Installation Guide**: [INSTALLATION.md](INSTALLATION.md)
- **Technical Reference**: [TECHNICAL.md](TECHNICAL.md)
- **Discord**: [Join Support Server](https://discord.gg/CrKcWdfd3A)
- **Issues**: [GitHub Issues](https://github.com/LXRCore/lxr-playerlimits/issues)

---

## 🤝 Contributing

We welcome contributions! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

---

## 📜 License

© 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved

This resource is branded for **The Land of Wolves** server. You may use it on your own server, but please maintain attribution and branding.

---

## 🌟 Credits

- **Script Author**: iBoss21 / The Lux Empire
- **Technical Research**: [Ehbw](https://github.com/Ehbw) (Physical player extension fork)
- **Based On**: CitizenFX RedM Core Modifications
- **Inspired By**: Community demand for large-scale RP servers

---

## 🐺 About The Land of Wolves

**The Land of Wolves** (wolves.land) is a serious hardcore Georgian RP server for RedM.

- **Server**: wolves.land
- **Type**: Serious Hardcore Roleplay
- **Language**: Georgian 🇬🇪
- **Access**: Discord & Whitelisted
- **Tagline**: მგლების მიწა - რჩეულთა ადგილი! (Land of Wolves - Place of the Chosen!)

Join our community: [Discord](https://discord.gg/CrKcWdfd3A)

---

**Made with ❤️ by The Lux Empire for The Land of Wolves 🐺**
