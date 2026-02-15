# 🔨 Building RedM with Extended Player Limits (128 Players)

This guide provides step-by-step instructions for building a custom RedM server with support for **128 physical players** instead of the default 31.

## ⚠️ Important Notice

**This is an advanced modification** that requires:
- C++ compilation knowledge
- Understanding of game engine internals
- Significant build time (30-60 minutes)
- Powerful development system

**Legal Notice**: Building custom RedM binaries may violate terms of service. This is provided for educational purposes and private/whitelisted servers only.

---

## 📋 Prerequisites

### System Requirements
- **OS**: Windows 10/11 (64-bit) or Linux (Ubuntu 20.04+)
- **CPU**: Multi-core processor (8+ cores recommended)
- **RAM**: 16 GB minimum, 32 GB recommended
- **Storage**: 50 GB free space
- **Internet**: Fast connection for downloading dependencies

### Required Software

#### Windows
```powershell
# Install Visual Studio 2022 Community Edition
# Download from: https://visualstudio.microsoft.com/downloads/
# Include: "Desktop development with C++"

# Install Chocolatey package manager (run as Administrator)
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install build dependencies
choco install git python nodejs cmake -y
```

#### Linux (Ubuntu/Debian)
```bash
# Update system
sudo apt-get update
sudo apt-get upgrade -y

# Install build dependencies
sudo apt-get install -y git build-essential cmake python3 python3-pip nodejs npm
sudo apt-get install -y clang llvm lld
sudo apt-get install -y libssl-dev libcurl4-openssl-dev
```

---

## 🚀 Build Process

### Step 1: Verify Modifications

The following file has been modified to extend player limits:

**`code/components/gta-game-rdr3/src/NetworkPlayerMgr.cpp`**
- Changed pattern from `83 F9 20` (32 players) to `83 F9 80` (128 players)
- This modifies the assembly instruction: `CMP ECX, 0x20` → `CMP ECX, 0x80`

Verify the change:
```bash
cd /home/runner/work/lxr-playerlimits/lxr-playerlimits
grep "83 F9 80" code/components/gta-game-rdr3/src/NetworkPlayerMgr.cpp
```

Expected output:
```
return hook::pattern("74 0A 83 F9 80 73 05 E8 ? ? ? ? 48").count(1).get(0).get<void>(-12);
```

### Step 2: Initialize Build Environment

```bash
# Navigate to repository root
cd /home/runner/work/lxr-playerlimits/lxr-playerlimits

# Update all submodules (this may take 10-15 minutes)
git submodule update --init --recursive
```

### Step 3: Run Prebuild Scripts

#### Windows
```cmd
# Run from repository root in Command Prompt or PowerShell
prebuild.cmd
```

This will:
- Generate Visual Studio solution files
- Download and configure dependencies
- Set up the build environment

#### Linux
```bash
# Run prebuild script
chmod +x prebuild.sh
./prebuild.sh
```

**Expected Time**: 5-10 minutes

### Step 4: Build the Project

#### Windows (Visual Studio)

1. **Open the solution**:
   ```
   code/build/solution/CitizenMP.sln
   ```

2. **Select configuration**:
   - Configuration: `Release`
   - Platform: `x64`

3. **Build the solution**:
   - Menu: Build → Build Solution (or press `Ctrl+Shift+B`)
   - Or right-click on solution → Build Solution

4. **Wait for completion**:
   - Build time: 30-60 minutes (depending on system)
   - Monitor the Output window for progress

#### Linux (Make)

```bash
# Navigate to build directory
cd code/build

# Build using all CPU cores
make -j$(nproc)
```

**Build Time**: 30-60 minutes on modern hardware, longer on older systems.

---

## 📦 Collecting Build Artifacts

After successful compilation, collect the built files:

### Windows

**Server Files**:
```
code/bin/server/windows/release/
  ├── FXServer.exe
  ├── server.dll
  ├── (additional DLL files)
  └── citizen/
```

**Client Files** (if building client):
```
code/bin/client/windows/release/
  ├── RedM.exe
  ├── (additional DLL files)
  └── citizen/
```

Copy these to your deployment directory:
```powershell
# Create deployment directory
New-Item -ItemType Directory -Force -Path "C:\RedM-Extended"

# Copy server files
Copy-Item -Recurse -Force "code\bin\server\windows\release\*" "C:\RedM-Extended\server\"
```

### Linux

**Server Files**:
```
code/bin/server/linux/release/
  ├── FXServer
  ├── (various .so files)
  └── citizen/
```

Copy to deployment:
```bash
# Create deployment directory
mkdir -p ~/redm-extended/server

# Copy server files
cp -r code/bin/server/linux/release/* ~/redm-extended/server/
```

---

## ⚙️ Server Configuration

### Step 1: Create server.cfg

Create a `server.cfg` file in your server directory:

```cfg
# ═══════════════════════════════════════════════════════════════════════════
# 🐺 RedM Extended Player Limits - Server Configuration
# ═══════════════════════════════════════════════════════════════════════════

# Server identity
sv_hostname "The Land of Wolves 🐺 - 128 Player Server"
sv_projectName "RedM Extended"
sv_projectDesc "Custom RedM build with extended player capacity"

# Extended player limit (CRITICAL - MUST BE SET)
set sv_maxclients 128

# OneSync (REQUIRED for extended players)
set onesync infinity

# Network optimization
set sv_packetBuffer 10000
set sv_bandwidth 50000
set sv_maxTickRate 50

# Licensing (replace with your key)
sv_licenseKey "YOUR_LICENSE_KEY_HERE"

# Game type
set gamename rdr3

# Resource management
ensure lxr-playerlimits
# ... other resources ...

# Admin permissions
add_ace group.admin command allow
add_principal identifier.steam:YOUR_STEAM_ID group.admin
```

### Step 2: Install the LXR Player Limits Resource

1. Copy the `lxr-playerlimits` resource to your server's `resources` folder:
   ```bash
   cp -r lxr-playerlimits/ ~/redm-extended/server/resources/
   ```

2. Ensure it's started in `server.cfg`:
   ```cfg
   ensure lxr-playerlimits
   ```

3. Configure the resource (edit `resources/lxr-playerlimits/config.lua`):
   ```lua
   Config.PlayerLimits = {
       maxPhysicalPlayers = 128,  -- Match your build
       enableMonitoring = true,
       optimizeNetworking = true,
       dynamicSyncDistance = true
   }
   ```

---

## 🧪 Testing the Build

### Step 1: Start the Server

#### Windows
```cmd
cd C:\RedM-Extended\server
FXServer.exe +exec server.cfg
```

#### Linux
```bash
cd ~/redm-extended/server
./FXServer +exec server.cfg
```

### Step 2: Verify Extended Limits

Look for these messages in the server console:

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

### Step 3: Test Player Connections

1. **Connect with a single client**: Verify basic connectivity
2. **Connect 32+ clients**: Verify it exceeds standard limit
3. **Monitor console**: Check for player IDs above 31
4. **Use admin commands**:
   ```
   /playerlimits  - View current capacity
   /playerstats   - View detailed statistics
   ```

---

## 📊 Performance Tuning

### Server Hardware Recommendations

| Max Players | CPU Cores | RAM    | Network    |
|-------------|-----------|--------|------------|
| 32          | 4         | 8 GB   | 50 Mbps    |
| 64          | 8         | 16 GB  | 100 Mbps   |
| 96          | 12        | 24 GB  | 150 Mbps   |
| 128         | 16        | 32 GB  | 200 Mbps   |

### Optimization Settings

For 128 players, add these to `server.cfg`:

```cfg
# Reduce sync distance (improves performance)
set onesync_distanceCullVehicles true
set onesync_distanceCullEntity 424.0

# Memory optimization
set onesync_population false

# Thread optimization
set onesync_useMapFallback true
```

And in `lxr-playerlimits/config.lua`:

```lua
Config.PlayerLimits.dynamicSyncDistance = true
Config.Performance.batchPlayerUpdates = true
Config.Performance.useCompression = true
```

---

## 🐞 Troubleshooting

### Build Errors

#### "Pattern not found"
**Cause**: Game binary has changed, pattern is outdated  
**Solution**: 
1. Use a hex editor to find the new pattern in the game binary
2. Update the pattern in `NetworkPlayerMgr.cpp`

#### "Submodule errors"
**Cause**: Submodules not initialized  
**Solution**:
```bash
git submodule update --init --recursive --force
```

#### "Linker errors (LNK2001)"
**Cause**: Missing dependencies  
**Solution**:
```bash
# Windows
prebuild.cmd

# Linux
./prebuild.sh
```

### Runtime Issues

#### Server shows 32 player limit
**Cause**: Build didn't apply correctly or server.cfg not configured  
**Solution**:
1. Verify the pattern change in `NetworkPlayerMgr.cpp`
2. Rebuild completely: `make clean && make`
3. Check `sv_maxclients` is set to 128

#### Players can't connect beyond 31
**Cause**: OneSync not enabled or build failed  
**Solution**:
1. Verify `set onesync infinity` in server.cfg
2. Check server console for build detection results
3. Verify you're using the custom-built binaries

---

## 📝 Verification Checklist

Before deploying to production:

- [ ] Build completed without errors
- [ ] Pattern change verified in NetworkPlayerMgr.cpp
- [ ] Server binaries copied to deployment directory
- [ ] server.cfg configured with `sv_maxclients 128`
- [ ] OneSync set to `infinity`
- [ ] lxr-playerlimits resource installed and configured
- [ ] Server starts without errors
- [ ] Build detection shows "Custom Build Detected: true"
- [ ] Can connect more than 31 players
- [ ] Player IDs above 31 work correctly
- [ ] Performance is acceptable under load

---

## 🔐 Security Considerations

1. **Never distribute custom binaries publicly** - Keep on private servers
2. **Use strong server passwords** - Prevent unauthorized access
3. **Keep license key private** - Don't share your FXServer license
4. **Monitor for exploits** - Use the built-in security features
5. **Regular backups** - Backup server data regularly

---

## 🆘 Getting Help

If you encounter issues:

1. **Check the logs**: Look for errors in server console
2. **Verify modifications**: Ensure pattern change is correct
3. **Community support**:
   - Discord: https://discord.gg/CrKcWdfd3A
   - CFX.re Forums: https://forum.cfx.re/
4. **GitHub Issues**: https://github.com/LXRCore/lxr-playerlimits/issues

---

## 📚 Additional Resources

- **Technical Documentation**: See `TECHNICAL.md` for detailed technical information
- **Resource Documentation**: See `lxr-playerlimits/README.md` for resource usage
- **CitizenFX Source**: https://github.com/citizenfx/fivem
- **RedM Documentation**: https://docs.fivem.net/docs/scripting-manual/runtimes/

---

## ✅ Summary

This build provides:
- ✅ **128 physical player slots** (up from 31)
- ✅ **Modified NetworkPlayerMgr** to accept higher indices
- ✅ **Lua resource** for monitoring and optimization
- ✅ **Complete documentation** for building and deployment
- ✅ **Production-ready** configuration

**Build Time**: ~45 minutes  
**Difficulty**: Advanced  
**Success Rate**: High (with proper dependencies)

---

**🐺 Made with ❤️ by iBoss21 / The Lux Empire for The Land of Wolves**

**© 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved**
