# 🐺 LXR Player Limits - RedM Extended Player Capacity

[![RedM](https://img.shields.io/badge/RedM-Extended-red.svg)](https://redm.gg/)
[![Players](https://img.shields.io/badge/Players-128-brightgreen.svg)](https://github.com/LXRCore/lxr-playerlimits)
[![OneSync](https://img.shields.io/badge/OneSync-Infinity-blue.svg)](https://docs.fivem.net/docs/)
[![License](https://img.shields.io/badge/License-Custom-orange.svg)](LICENSE)

**A complete RedM modification that extends player capacity from 31 to 128+ physical players.**

This repository contains:
- 🔧 **C++ source modifications** to RedM/FiveM engine (extends physical player validation)
- 🎮 **Lua resource** for monitoring, optimization, and security
- 📚 **Complete documentation** for building and deploying
- ⚙️ **Production-ready configuration** files

---

## 🚀 Quick Links

- **[Quick Start Guide](QUICKSTART.md)** - Get started in under an hour
- **[Build Instructions](BUILD_INSTRUCTIONS.md)** - Detailed compilation guide
- **[Technical Patches](PATCHES.md)** - Exact code modifications explained
- **[Resource Documentation](lxr-playerlimits/README.md)** - Lua resource usage
- **[Example Configuration](server.cfg.example)** - Production server.cfg

---

## ✨ Features

✅ **Extends RedM from 31 to 128 physical players**  
✅ **C++ engine modifications** with assembly pattern changes  
✅ **Monitoring & optimization** resource included  
✅ **Framework compatible** (LXR-Core, RSG-Core, VORP, etc.)  
✅ **Security features** for validation and exploit prevention  
✅ **Performance optimizations** for high player counts  
✅ **Complete documentation** for building and deployment  

---

## 📋 What's Modified

### C++ Engine Change
**File**: `code/components/gta-game-rdr3/src/NetworkPlayerMgr.cpp`

Changed player validation pattern from `0x20` (32) to `0x80` (128):
```cpp
// Before: Limited to 31 players
return hook::pattern("74 0A 83 F9 20 73 05 E8 ? ? ? ? 48")...

// After: Extended to 127 players
return hook::pattern("74 0A 83 F9 80 73 05 E8 ? ? ? ? 48")...
```

This modifies the assembly instruction from `CMP ECX, 0x20` to `CMP ECX, 0x80`, allowing player indices 0-127.

### Lua Resource
**Directory**: `lxr-playerlimits/`

Complete monitoring and management resource with:
- Real-time capacity tracking
- Performance optimization
- Security validation
- Admin commands
- Multi-framework support

---

## 🛠️ Installation

### Option 1: Quick Start (Recommended)
Follow our [Quick Start Guide](QUICKSTART.md) for a streamlined setup process.

### Option 2: Manual Build
1. Clone this repository
2. Follow [Build Instructions](BUILD_INSTRUCTIONS.md)
3. Deploy with [example server.cfg](server.cfg.example)
4. See [Technical Documentation](TECHNICAL.md) for details

### Build Time
- **Submodule init**: 10-15 minutes
- **Prebuild**: 5-10 minutes  
- **Compilation**: 30-60 minutes
- **Total**: ~45-90 minutes

---

## 📊 Requirements

### Build Requirements
- **CPU**: 8+ cores recommended
- **RAM**: 16 GB minimum, 32 GB recommended
- **Storage**: 50 GB free space
- **OS**: Windows 10/11 or Linux (Ubuntu 20.04+)

### Runtime Requirements (128 players)
- **CPU**: 16 cores
- **RAM**: 32 GB
- **Network**: 200 Mbps bandwidth
- **OneSync**: Infinity mode required

---

## 📖 Documentation

### Getting Started
- [QUICKSTART.md](QUICKSTART.md) - Fast setup guide
- [BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md) - Complete build process
- [server.cfg.example](server.cfg.example) - Example configuration

### Technical Details
- [PATCHES.md](PATCHES.md) - Exact code modifications
- [TECHNICAL.md](lxr-playerlimits/TECHNICAL.md) - Deep technical dive
- [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - Project overview

### Resource Usage
- [lxr-playerlimits/README.md](lxr-playerlimits/README.md) - Resource documentation
- [lxr-playerlimits/INSTALLATION.md](lxr-playerlimits/INSTALLATION.md) - Resource setup

---

## 🎯 Verification

After building and starting your server, you should see:

```
═══════════════════════════════════════════════════════════════════════════
🐺 LXR PLAYER LIMITS - BUILD DETECTION RESULTS
═══════════════════════════════════════════════════════════════════════════

OneSync Enabled:       true
OneSync Mode:          infinity
Custom Build Detected: true
Physical Player Limit: 128
Server Max Clients:    128

═══════════════════════════════════════════════════════════════════════════
```

Test with `/playerlimits` command in-game to verify 128 player capacity.

---

## 🐺 About

**Developed by**: iBoss21 / The Lux Empire  
**Server**: The Land of Wolves (wolves.land)  
**Type**: Georgian Serious Hardcore Roleplay  
**Discord**: https://discord.gg/CrKcWdfd3A  
**Store**: https://theluxempire.tebex.io  

---

## 📜 License & Legal

**Based on**: CitizenFX Collective's FiveM/RedM (https://github.com/citizenfx/fivem)  
**Modifications**: © 2026 iBoss21 / The Lux Empire | wolves.land  

**Important**: 
- This modification is for educational and private server use only
- Building custom binaries may violate terms of service
- Do not distribute modified binaries publicly
- Use only on private/whitelisted servers
- Original CitizenFX license applies to base code - see [code/LICENSE](code/LICENSE)

---

## 🆘 Support

- **Discord**: [Join our community](https://discord.gg/CrKcWdfd3A)
- **GitHub Issues**: [Report issues](https://github.com/LXRCore/lxr-playerlimits/issues)
- **CFX.re Forums**: [Community support](https://forum.cfx.re/)

---

**🐺 Made with ❤️ by The Lux Empire for The Land of Wolves**
