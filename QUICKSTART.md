# 🚀 Quick Start Guide - RedM 128 Player Server

Get your RedM server running with 128 player support in under an hour!

---

## 📌 What You'll Get

✅ **RedM server** supporting **128 physical players** (instead of 31)  
✅ **Monitoring resource** for capacity tracking and optimization  
✅ **Production-ready** configuration and documentation  
✅ **Framework compatible** (LXR-Core, RSG-Core, VORP, etc.)

---

## ⚡ Express Setup (3 Steps)

### Step 1: Build the Server (45 minutes)

```bash
# Clone the repository
git clone https://github.com/LXRCore/lxr-playerlimits.git
cd lxr-playerlimits

# Initialize submodules (10-15 minutes)
git submodule update --init --recursive

# Run prebuild (5-10 minutes)
./prebuild.sh  # Linux
# or
prebuild.cmd   # Windows

# Build the project (30-60 minutes)
cd code/build
make -j$(nproc)  # Linux
# or open CitizenMP.sln in Visual Studio and build (Windows)
```

**✅ What was modified**: `code/components/gta-game-rdr3/src/NetworkPlayerMgr.cpp`
- Changed player validation from 32 to 128 (pattern: `0x20` → `0x80`)

### Step 2: Deploy the Server (5 minutes)

```bash
# Create server directory
mkdir -p ~/redm-server/resources

# Copy compiled server files
cp -r code/bin/server/linux/release/* ~/redm-server/

# Copy the player limits resource
cp -r lxr-playerlimits/ ~/redm-server/resources/

# Create server.cfg
cat > ~/redm-server/server.cfg << 'EOF'
# RedM 128-Player Server Configuration
sv_hostname "My RedM 128 Player Server"
sv_maxclients 128
set onesync infinity
sv_licenseKey "YOUR_LICENSE_KEY"
set gamename rdr3
ensure lxr-playerlimits
EOF
```

### Step 3: Start and Test (2 minutes)

```bash
# Start the server
cd ~/redm-server
./FXServer +exec server.cfg

# Look for this message:
# "Custom Build Detected: true"
# "Physical Player Limit: 128"
```

**🎉 Done!** Your 128-player server is running!

---

## 🎮 Testing It Works

### In-Game Commands

Once connected to your server:

```
/playerlimits  - Shows: "Physical Limit: 128"
/playerstats   - Shows: "Total Slots: 128"
```

### Expected Console Output

```
═══════════════════════════════════════════════════════════════════════════════
🐺 LXR PLAYER LIMITS - BUILD DETECTION RESULTS
═══════════════════════════════════════════════════════════════════════════════

OneSync Enabled:       true
OneSync Mode:          infinity
Custom Build Detected: true
Physical Player Limit: 128
Server Max Clients:    128

═══════════════════════════════════════════════════════════════════════════════
```

### Connect 32+ Players

1. Have friends connect to test
2. Watch console for player IDs
3. Verify IDs above 31 work
4. Use `/playerlimits` to see capacity

**Success**: You should be able to have 32+ players online simultaneously!

---

## 📋 Prerequisites Checklist

Before starting, make sure you have:

### Hardware
- [ ] **16 GB RAM** (minimum) or 32 GB (recommended)
- [ ] **8+ CPU cores** (more is better for compilation)
- [ ] **50 GB free disk space**
- [ ] **Fast internet** (for downloading dependencies)

### Software (Linux)
- [ ] Ubuntu 20.04+ or similar
- [ ] Git, Build-essential, CMake
- [ ] Python 3, Node.js

```bash
sudo apt-get update
sudo apt-get install -y git build-essential cmake python3 nodejs
sudo apt-get install -y clang llvm
```

### Software (Windows)
- [ ] Windows 10/11 (64-bit)
- [ ] Visual Studio 2022 Community (with C++ development)
- [ ] Git, Python, Node.js, CMake

```powershell
choco install git python nodejs cmake -y
```

### Other
- [ ] FXServer license key (get from https://keymaster.fivem.net/)
- [ ] Basic knowledge of server administration

---

## 🎯 Recommended Server.cfg

Optimized configuration for 128 players:

```cfg
# ═══════════════════════════════════════════════════════════════════════════
# RedM Extended Player Limits - Optimized Server Configuration
# ═══════════════════════════════════════════════════════════════════════════

# Server Identity
sv_hostname "🐺 The Land of Wolves - 128 Player RP Server"
sv_projectName "RedM Extended"
sv_projectDesc "Serious Hardcore Roleplay | Extended Player Capacity"
sv_maxclients 128

# License (GET YOUR KEY: https://keymaster.fivem.net/)
sv_licenseKey "YOUR_CFXRE_LICENSE_KEY_HERE"

# Game Configuration
set gamename rdr3

# OneSync (CRITICAL - REQUIRED)
set onesync infinity

# Network Optimization
set sv_packetBuffer 10000
set sv_bandwidth 50000
set sv_maxTickRate 50

# Performance Tuning
set onesync_distanceCullVehicles true
set onesync_distanceCullEntity 424.0
set onesync_population false
set onesync_useMapFallback true

# Resources
ensure lxr-playerlimits
# ensure your-framework-here
# ensure your-other-resources

# Admin Permissions
add_ace group.admin command allow
add_principal identifier.steam:YOUR_STEAM_ID_HERE group.admin

# Server Tags
sets tags "roleplay,128players,extended,lxr,onesync"
```

---

## ⚙️ Resource Configuration

Edit `resources/lxr-playerlimits/config.lua`:

```lua
-- For 128-player servers
Config.PlayerLimits = {
    maxPhysicalPlayers = 128,      -- Match your build
    enableMonitoring = true,
    warningThreshold = 0.85,       -- Warn at 85% capacity (109 players)
    criticalThreshold = 0.95,      -- Critical at 95% (122 players)
    optimizeNetworking = true,
    dynamicSyncDistance = true     -- Auto-adjust for performance
}

Config.Performance = {
    monitoringInterval = 30000,    -- Check every 30 seconds
    batchPlayerUpdates = true,     -- Batch updates for efficiency
    useCompression = true          -- Compress network data
}
```

---

## 🔧 Performance Tuning

### For 128 Players

**Server Hardware**:
- **CPU**: 16 cores recommended
- **RAM**: 32 GB recommended
- **Network**: 200 Mbps+ bandwidth
- **Storage**: SSD strongly recommended

**Additional Optimizations**:

```lua
-- In lxr-playerlimits/config.lua
Config.PlayerLimits.syncDistanceScaling = {
    [32] = 424.0,    -- Default
    [64] = 350.0,    -- Slight reduction
    [96] = 300.0,    -- Moderate reduction
    [128] = 250.0,   -- Optimized for 128 (RECOMMENDED)
}
```

**Client Requirements** (for players):
- **CPU**: 6+ cores
- **RAM**: 16 GB
- **GPU**: GTX 1060 / RX 580 or better
- **Internet**: 50 Mbps down, 10 Mbps up

---

## 🐞 Troubleshooting

### Server Still Shows 32 Limit

**Check 1**: Verify the modification was applied
```bash
grep "83 F9 80" code/components/gta-game-rdr3/src/NetworkPlayerMgr.cpp
```
Should output: `return hook::pattern("74 0A 83 F9 80 73 05 E8...`

**Check 2**: Ensure you're using the compiled binaries
```bash
# Make sure you copied from code/bin/server/*/release/
ls -la ~/redm-server/FXServer
```

**Check 3**: Verify server.cfg
```bash
grep "sv_maxclients" ~/redm-server/server.cfg
grep "onesync" ~/redm-server/server.cfg
```

### Build Fails

**Submodule issues**:
```bash
git submodule update --init --recursive --force
```

**Missing dependencies (Linux)**:
```bash
sudo apt-get install -y build-essential cmake clang llvm libssl-dev
```

**Missing dependencies (Windows)**:
- Reinstall Visual Studio 2022 with "Desktop development with C++"

### Players Can't Connect Beyond 31

**OneSync not enabled**:
```cfg
# Add to server.cfg
set onesync infinity
```

**Using wrong binaries**:
- Ensure you copied the custom-built binaries
- Don't use standard FXServer downloads

---

## 📊 Monitoring Your Server

### Console Commands

```
# View player capacity
/playerlimits

# View detailed stats
/playerstats

# Debug slot allocation (admin only)
/playerslots
```

### Expected Output

```
╔══════════════════════════════════════════╗
║   🐺 RedM Player Limits - Status        ║
╠══════════════════════════════════════════╣
║  Physical Limit:    128 slots           ║
║  Current Players:   67 / 128            ║
║  Free Slots:        61                  ║
║  Capacity:          52.3%               ║
╚══════════════════════════════════════════╝
```

### Resource Exports (For Scripts)

```lua
-- Get current capacity
local capacity = exports['lxr-playerlimits']:GetPlayerCapacityPercent()

-- Get max players
local max = exports['lxr-playerlimits']:GetMaxPhysicalPlayers()

-- Check if custom build
local isCustom = exports['lxr-playerlimits']:IsCustomBuildDetected()
```

---

## 🎓 Next Steps

Once your server is running:

1. **Test with players**: Invite friends to test capacity
2. **Monitor performance**: Watch CPU/RAM usage with 64+ players
3. **Optimize settings**: Adjust sync distances if needed
4. **Install frameworks**: Add your preferred RP framework
5. **Add resources**: Install additional resources as needed

---

## 📚 Full Documentation

For detailed information:

- **BUILD_INSTRUCTIONS.md** - Complete build process
- **PATCHES.md** - Technical details of modifications
- **TECHNICAL.md** - Deep dive into player limits
- **lxr-playerlimits/README.md** - Resource documentation

---

## 🆘 Support

Need help?

- **Discord**: https://discord.gg/CrKcWdfd3A
- **GitHub Issues**: https://github.com/LXRCore/lxr-playerlimits/issues
- **CFX.re Forums**: https://forum.cfx.re/

---

## ✅ Success Checklist

- [ ] Successfully built custom RedM binaries
- [ ] Server starts without errors
- [ ] Console shows "Custom Build Detected: true"
- [ ] `/playerlimits` shows "Physical Limit: 128"
- [ ] Can connect more than 31 players
- [ ] Player IDs above 31 work correctly
- [ ] Server performance is acceptable

---

## 🎉 You're Ready!

Your RedM server now supports **128 players** instead of the default 31!

Key features you now have:
- ✅ Extended physical player slots
- ✅ Automatic capacity monitoring
- ✅ Performance optimization
- ✅ Security validation
- ✅ Admin management tools
- ✅ Framework compatibility

**Enjoy your extended capacity server!** 🐺

---

**🐺 Made with ❤️ by iBoss21 / The Lux Empire for The Land of Wolves**

**© 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved**
