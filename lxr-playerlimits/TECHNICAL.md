# 🔧 Technical Documentation - RedM Player Limit Extension

## Table of Contents
1. [Understanding the Limitation](#understanding-the-limitation)
2. [Technical Architecture](#technical-architecture)
3. [Building Custom RedM](#building-custom-redm)
4. [Code Modifications](#code-modifications)
5. [Testing & Validation](#testing--validation)
6. [Performance Considerations](#performance-considerations)

---

## Understanding the Limitation

### The 31-Player Problem

RedM, like FiveM, is built on the RAGE engine (Rockstar Advanced Game Engine) used in Grand Theft Auto V and Red Dead Redemption 2. The engine has a **hardcoded limitation of 32 physical player slots** (indices 0-31), which means a maximum of **31 players + 1 host**.

### Where the Limit is Enforced

The limitation exists in multiple places:

#### 1. NetworkPlayerMgr.cpp
**Location**: `code/components/gta-game-rdr3/src/NetworkPlayerMgr.cpp`

```cpp
static hook::cdecl_stub<CNetGamePlayer*(int)> getPlayerFromNetGame([] ()
{
    // Pattern search for player validation
    // "74 0A 83 F9 20 73 05 E8" where 0x20 = 32 decimal
    return hook::pattern("74 0A 83 F9 20 73 05 E8 ? ? ? ? 48").count(1).get(0).get<void>(-12);
});
```

**The Problem**: `83 F9 20` is an x86 assembly instruction:
```assembly
CMP ECX, 0x20    ; Compare ECX register with 0x20 (32 decimal)
```

This checks if the player index is less than 32. Indices >= 32 are rejected.

#### 2. Player Arrays
**Location**: `code/components/gta-net-rdr3/src/netPlayerArrayPatch.cpp`

```cpp
extern CNetGamePlayer* g_players[256];           // Can hold 256 players
extern CNetGamePlayer* g_playerListRemote[256];  // Can hold 256 players
```

While the arrays are sized for 256 players, the game only uses the first 32 slots due to validation checks.

#### 3. CPedIntelligenceComponent Arrays
**Location**: `code/components/gta-net-rdr3/src/PlayerArrayResizes.cpp`

Various game components have player-related arrays hardcoded to 32 elements:
- Intelligence arrays
- Vehicle scene arrays
- Network dependency arrays
- Object synchronization arrays

---

## Technical Architecture

### How OneSync Works

**OneSync** is CFX.re's custom networking layer that allows more players by:
1. Managing entity synchronization server-side
2. Dynamically streaming entities to nearby players
3. Reducing bandwidth by prioritizing relevant entities

However, OneSync still respects the **physical player slot limitation** of 32 players unless the underlying game code is patched.

### Physical vs Virtual Players

- **Physical Players**: Players with slots in the game engine's player array (0-31 by default)
- **Virtual Players**: With OneSync Infinity, players can exist server-side without physical slots, but they have limited interaction capabilities

### The Extension Approach

The [Ehbw fork](https://github.com/Ehbw/fivem-fork/tree/feat/rdr3-physical-player-extension) patches the RedM source to:

1. **Increase the comparison value** from `0x20` (32) to `0x80` (128) or higher
2. **Resize hardcoded arrays** from 32 to 128/256 elements
3. **Patch inline player list checks** throughout the codebase
4. **Update memory allocations** for player-related structures

---

## Building Custom RedM

### Prerequisites

#### System Requirements
- **OS**: Windows 10/11 (64-bit) or Linux
- **RAM**: 16 GB minimum, 32 GB recommended
- **Storage**: 50 GB free space
- **CPU**: Multi-core processor (compilation is CPU-intensive)

#### Required Tools

**Windows**:
```powershell
# Install Visual Studio 2022 Community Edition
# Include: Desktop development with C++

# Install dependencies
choco install git python nodejs -y
choco install cmake -y
```

**Linux**:
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y git build-essential cmake python3 nodejs

# Install Clang/LLVM
sudo apt-get install -y clang llvm
```

### Step-by-Step Build Process

#### 1. Clone the Extended Fork

```bash
# Create build directory
mkdir ~/redm-build
cd ~/redm-build

# Clone the physical player extension fork
git clone --recursive https://github.com/Ehbw/fivem-fork.git
cd fivem-fork

# Checkout the player extension branch
git checkout feat/rdr3-physical-player-extension

# Initialize submodules
git submodule update --init --recursive
```

#### 2. Configure the Build

```bash
# Set build configuration
export PREMIUM_BUILD=1  # Optional: Premium build features

# Configure max players (edit before building)
# Open code/components/gta-game-rdr3/src/NetworkPlayerMgr.cpp
# Change the pattern from "83 F9 20" to "83 F9 80" for 128 players
# Change to "83 F9 FF" for 256 players
```

#### 3. Run Prebuild Scripts

**Windows**:
```cmd
prebuild.cmd
```

**Linux**:
```bash
./prebuild.sh
```

This generates build files and prepares the environment.

#### 4. Build the Project

**Windows** (Visual Studio):
```powershell
# Open code/build/solution/CitizenMP.sln in Visual Studio 2022
# Select "Release" configuration
# Build -> Build Solution (Ctrl+Shift+B)
```

**Linux** (Make):
```bash
cd code/build
make -j$(nproc)  # Use all CPU cores
```

**Build Time**: Expect 30-60 minutes on a modern system, longer on older hardware.

#### 5. Collect Build Artifacts

After successful compilation:

**Windows**:
```
code/bin/server/windows/release/
  ├── FXServer.exe
  ├── server.dll
  └── (other server files)

code/bin/client/windows/release/
  ├── RedM.exe
  ├── (other client files)
  └── citizen/
```

**Linux**:
```
code/bin/server/linux/release/
  ├── FXServer
  ├── *.so files
  └── (other server files)
```

---

## Code Modifications

### Key Files Modified in the Fork

#### 1. NetworkPlayerMgr.cpp
**Purpose**: Change player index validation

**Original**:
```cpp
return hook::pattern("74 0A 83 F9 20 73 05 E8 ? ? ? ? 48").count(1).get(0).get<void>(-12);
```

**Modified** (for 128 players):
```cpp
return hook::pattern("74 0A 83 F9 80 73 05 E8 ? ? ? ? 48").count(1).get(0).get<void>(-12);
```

The change: `20` (32 dec) → `80` (128 dec)

#### 2. PlayerArrayResizes.cpp
**Purpose**: Resize CPedIntelligenceComponent arrays

This file uses advanced disassembly techniques to find and resize stack-allocated arrays from 32 to 128+ elements.

```cpp
template<int NewStackSize, int kMaxInstructions = 2048, int kMaxStackResizes = 128>
void IncreaseFunctionStack(void* address, std::initializer_list<StackResizes> list)
{
    // Disassembles function code
    // Finds array size references
    // Patches them to new size
}
```

#### 3. netPlayerArrayPatch.cpp
**Purpose**: Patch inline player list access

Replaces hardcoded array access patterns with dynamic lookups:

```cpp
static CNetGamePlayer* GetPlayerByIndex(uint8_t index)
{
    if (index < 0 || index >= 256)  // Changed from 32 to 256
    {
        return nullptr;
    }
    return g_players[index];
}
```

### Assembly-Level Changes

The core modification is patching x86-64 assembly:

**Before (32 players)**:
```assembly
CMP ECX, 0x20    ; 83 F9 20
JA  fail_label   ; 73 05
```

**After (128 players)**:
```assembly
CMP ECX, 0x80    ; 83 F9 80  
JA  fail_label   ; 73 05
```

---

## Testing & Validation

### Build Validation

After building, test your custom binaries:

#### 1. Server Test
```bash
# Run custom FXServer
./FXServer.exe +set gamename rdr3 +exec server.cfg

# Check log for:
# "Server initialized with 128 player slots" (or your max)
```

#### 2. Connection Test
```bash
# Set sv_maxclients in server.cfg
set sv_maxclients 128

# Enable OneSync
set onesync infinity

# Start server and connect with clients
# Monitor player IDs in console
```

#### 3. Capacity Test
```lua
-- Server console
-- Connect 32+ players and verify they all get physical slots

-- Check player IDs
for _, player in ipairs(GetPlayers()) do
    print(string.format("Player: %d", player))
end

-- With standard build: stops at 31
-- With custom build: continues to your limit (64, 128, 256)
```

### Performance Testing

Test with increasing player counts:

| Players | CPU Usage | RAM Usage | Network |
|---------|-----------|-----------|---------|
| 32      | Baseline  | ~2 GB     | ~5 Mbps |
| 64      | +30%      | ~3.5 GB   | ~8 Mbps |
| 96      | +60%      | ~5 GB     | ~12 Mbps|
| 128     | +100%     | ~7 GB     | ~15 Mbps|

---

## Performance Considerations

### Server Requirements by Player Count

| Max Players | CPU Cores | RAM    | Network    |
|-------------|-----------|--------|------------|
| 32          | 4         | 8 GB   | 50 Mbps    |
| 64          | 8         | 16 GB  | 100 Mbps   |
| 96          | 12        | 24 GB  | 150 Mbps   |
| 128         | 16        | 32 GB  | 200 Mbps   |
| 256         | 32        | 64 GB  | 500 Mbps   |

### Optimization Strategies

#### 1. OneSync Infinity
**Always use OneSync Infinity** for large player counts:
```cfg
set onesync infinity
```

Benefits:
- Better entity streaming
- Reduced client-side load
- Improved scalability

#### 2. Sync Distance Reduction
Reduce entity sync distance as player count increases:

```lua
-- Dynamically adjust based on player count
Config.PlayerLimits.syncDistanceScaling = {
    [32]  = 424.0,  -- Default
    [64]  = 350.0,  -- -17%
    [96]  = 300.0,  -- -29%
    [128] = 250.0,  -- -41%
    [256] = 200.0,  -- -53%
}
```

#### 3. Entity Culling
Implement aggressive entity culling:
- Limit vehicle spawns
- Reduce NPC density
- Cull distant props/objects

#### 4. Network Optimization
```cfg
# Server.cfg optimizations
set sv_maxclients 128
set sv_packetBuffer 10000
set sv_bandwidth 50000

# Reduce tick rate slightly
set sv_maxTickRate 50  # Down from 60
```

### Known Limitations

#### 1. Client Performance
Player clients need powerful hardware:
- **CPU**: 6+ cores recommended
- **GPU**: RTX 2060 or equivalent
- **RAM**: 16 GB minimum
- **Internet**: 50+ Mbps down, 10+ Mbps up

#### 2. Script Compatibility
Some scripts may have hardcoded 32-player assumptions:
```lua
-- Bad (assumes 32 max)
for i = 0, 31 do
    local player = GetPlayerPed(i)
end

-- Good (dynamic)
for _, playerId in ipairs(GetPlayers()) do
    local player = GetPlayerPed(playerId)
end
```

#### 3. Memory Usage
Each additional player slot increases server memory by ~50-100 MB.

---

## Troubleshooting Build Issues

### Common Build Errors

#### Error: "Pattern not found"
**Cause**: Game build changed, patterns outdated
**Solution**: Update patterns in NetworkPlayerMgr.cpp to match current build

#### Error: "Linker error LNK2001"
**Cause**: Missing dependencies
**Solution**: Run `git submodule update --recursive`

#### Error: "Stack overflow in array resize"
**Cause**: Array resize patch failed
**Solution**: Check PlayerArrayResizes.cpp patterns

### Getting Help

- **Fork Repository**: https://github.com/Ehbw/fivem-fork
- **CFX.re Forums**: https://forum.cfx.re/
- **Discord**: https://discord.gg/fivem

---

## References

- **Ehbw's Physical Player Extension**: https://github.com/Ehbw/fivem-fork/tree/feat/rdr3-physical-player-extension
- **CitizenFX Source**: https://github.com/citizenfx/fivem
- **RedM Documentation**: https://docs.fivem.net/docs/scripting-manual/runtimes/
- **RAGE Architecture**: http://www.rage-multiplayer.com/

---

## Legal Notice

**Important**: Building custom FiveM/RedM binaries may violate the terms of service. This documentation is provided for **educational purposes** and for use with **private/whitelisted servers only**.

- Do not distribute custom binaries publicly
- Do not use on commercial servers without proper licensing
- Respect Rockstar Games' intellectual property
- Follow CFX.re's terms of service

---

## Conclusion

Extending RedM beyond 31 players requires:
1. Custom compilation of RedM source code
2. Assembly-level patches to player validation
3. Array resizing throughout the codebase
4. Extensive testing and optimization

This is a **complex, advanced modification** that requires C++ knowledge and understanding of game engine internals.

**The LXR Player Limits resource** provides the **Lua-side management** for servers running these custom builds, handling monitoring, validation, and optimization at the resource level.

---

**🐺 Made by iBoss21 / The Lux Empire for The Land of Wolves**
