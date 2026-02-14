--[[
    ██╗     ██╗  ██╗██████╗        ██████╗ ██╗      █████╗ ██╗   ██╗███████╗██████╗ 
    ██║     ╚██╗██╔╝██╔══██╗      ██╔══██╗██║     ██╔══██╗╚██╗ ██╔╝██╔════╝██╔══██╗
    ██║      ╚███╔╝ ██████╔╝█████╗██████╔╝██║     ███████║ ╚████╔╝ █████╗  ██████╔╝
    ██║      ██╔██╗ ██╔══██╗╚════╝██╔═══╝ ██║     ██╔══██║  ╚██╔╝  ██╔══╝  ██╔══██╗
    ███████╗██╔╝ ██╗██║  ██║      ██║     ███████╗██║  ██║   ██║   ███████╗██║  ██║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═╝     ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝
    
    ██╗     ██╗███╗   ███╗██╗████████╗███████╗    ██████╗ ███████╗███╗   ███╗ ██████╗ ██╗   ██╗ █████╗ ██╗     
    ██║     ██║████╗ ████║██║╚══██╔══╝██╔════╝    ██╔══██╗██╔════╝████╗ ████║██╔═══██╗██║   ██║██╔══██╗██║     
    ██║     ██║██╔████╔██║██║   ██║   ███████╗    ██████╔╝█████╗  ██╔████╔██║██║   ██║██║   ██║███████║██║     
    ██║     ██║██║╚██╔╝██║██║   ██║   ╚════██║    ██╔══██╗██╔══╝  ██║╚██╔╝██║██║   ██║╚██╗ ██╔╝██╔══██║██║     
    ███████╗██║██║ ╚═╝ ██║██║   ██║   ███████║    ██║  ██║███████╗██║ ╚═╝ ██║╚██████╔╝ ╚████╔╝ ██║  ██║███████╗
    ╚══════╝╚═╝╚═╝     ╚═╝╚═╝   ╚═╝   ╚══════╝    ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝ ╚═════╝   ╚═══╝  ╚═╝  ╚═╝╚══════╝
    
    🐺 LXR Core - RedM Player Limits Removal System
    
    This script extends RedM's physical player limit beyond the default 31 players.
    It provides server-side validation, optimization, and monitoring for extended
    player capacity on custom RedM builds with player extension patches applied.
    
    ═══════════════════════════════════════════════════════════════════════════════
    SERVER INFORMATION
    ═══════════════════════════════════════════════════════════════════════════════
    
    Server:      The Land of Wolves 🐺
    Tagline:     Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!
    Description: ისტორია ცოცხლდება აქ! (History Lives Here!)
    Type:        Serious Hardcore Roleplay
    Access:      Discord & Whitelisted
    
    Developer:   iBoss21 / The Lux Empire
    Website:     https://www.wolves.land
    Discord:     https://discord.gg/CrKcWdfd3A
    GitHub:      https://github.com/iBoss21
    Store:       https://theluxempire.tebex.io
    Server:      https://servers.redm.net/servers/detail/8gj7eb
    
    ═══════════════════════════════════════════════════════════════════════════════
    
    Version: 1.0.0
    Performance Target: Zero overhead on standard builds, optimized for 128+ players
    
    Tags: RedM, Georgian, SeriousRP, PlayerLimits, Extended, Performance, LXR
    
    Framework Support:
    - LXR Core (Primary)
    - RSG Core (Compatible)
    - VORP Core (Compatible)
    - RedEM:RP (Compatible)
    - QBR Core (Compatible)
    - QR Core (Compatible)
    - Standalone (Compatible)
    
    ═══════════════════════════════════════════════════════════════════════════════
    CREDITS
    ═══════════════════════════════════════════════════════════════════════════════
    
    Script Author: iBoss21 / The Lux Empire for The Land of Wolves
    Technical Research: Ehbw (Physical player extension fork)
    Based On: CitizenFX RedM Core Modifications
    Inspired by: Community demand for large-scale RP servers
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 RESOURCE NAME PROTECTION - RUNTIME CHECK
-- ═══════════════════════════════════════════════════════════════════════════════

local REQUIRED_RESOURCE_NAME = "lxr-playerlimits"
local currentResourceName = GetCurrentResourceName()

if currentResourceName ~= REQUIRED_RESOURCE_NAME then
    error(string.format([[
        
        ═══════════════════════════════════════════════════════════════════════════════
        ❌ CRITICAL ERROR: RESOURCE NAME MISMATCH ❌
        ═══════════════════════════════════════════════════════════════════════════════
        
        Expected: %s
        Got: %s
        
        This resource is branded and must maintain the correct name.
        Rename the folder to "%s" to continue.
        
        🐺 wolves.land - The Land of Wolves
        
        ═══════════════════════════════════════════════════════════════════════════════
        
    ]], REQUIRED_RESOURCE_NAME, currentResourceName, REQUIRED_RESOURCE_NAME))
end

Config = {}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ SERVER BRANDING & INFO ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.ServerInfo = {
    name = 'The Land of Wolves 🐺',
    tagline = 'Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!',
    description = 'ისტორია ცოცხლდება აქ!', -- History Lives Here!
    type = 'Serious Hardcore Roleplay',
    access = 'Discord & Whitelisted',
    
    -- Contact & Links
    website = 'https://www.wolves.land',
    discord = 'https://discord.gg/CrKcWdfd3A',
    github = 'https://github.com/iBoss21',
    store = 'https://theluxempire.tebex.io',
    serverListing = 'https://servers.redm.net/servers/detail/8gj7eb',
    
    -- Developer Info
    developer = 'iBoss21 / The Lux Empire',
    
    -- Tags
    tags = {'RedM', 'Georgian', 'SeriousRP', 'PlayerLimits', 'Extended', 'Performance', 'LXR'}
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ FRAMEWORK CONFIGURATION ███████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

--[[
    Framework Priority (in order):
    1. LXR-Core (Primary)
    2. RSG-Core (Primary)
    3. VORP Core (Supported)
    4. RedEM:RP (Optional - if detected)
    5. QBR-Core (Optional - if detected)
    6. QR-Core (Optional - if detected)
    7. Standalone (Fallback)
]]

Config.Framework = 'auto' -- 'auto' or manual: 'lxr-core', 'rsg-core', 'vorp_core', 'redem_roleplay', 'qbr-core', 'qr-core', 'standalone'

-- Framework-specific settings
Config.FrameworkSettings = {
    ['lxr-core'] = {
        resource = 'lxr-core',
        notifications = 'ox_lib',
        inventory = 'lxr-inventory',
        events = {
            server = 'lxr-core:server:%s',
            client = 'lxr-core:client:%s',
            callback = 'lxr-core:callback:%s'
        }
    },
    ['rsg-core'] = {
        resource = 'rsg-core',
        notifications = 'ox_lib',
        inventory = 'rsg-inventory',
        events = {
            server = 'RSGCore:Server:%s',
            client = 'RSGCore:Client:%s',
            callback = 'RSGCore:Callback:%s'
        }
    },
    ['vorp_core'] = {
        resource = 'vorp_core',
        notifications = 'vorp',
        inventory = 'vorp_inventory',
        events = {
            server = 'vorp:server:%s',
            client = 'vorp:client:%s'
        }
    },
    ['redem_roleplay'] = {
        resource = 'redem_roleplay',
        notifications = 'redem',
        inventory = 'redem_inventory',
        events = {
            server = 'redem:%s:server',
            client = 'redem:%s:client'
        }
    },
    ['qbr-core'] = {
        resource = 'qbr-core',
        notifications = 'ox_lib',
        inventory = 'qbr-inventory',
        events = {
            server = 'QBR:Server:%s',
            client = 'QBR:Client:%s'
        }
    },
    ['qr-core'] = {
        resource = 'qr-core',
        notifications = 'ox_lib',
        inventory = 'qr-inventory',
        events = {
            server = 'QR:Server:%s',
            client = 'QR:Client:%s'
        }
    },
    ['standalone'] = {
        notifications = 'print',
        inventory = 'none',
        events = {}
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ PLAYER LIMIT CONFIGURATION ████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

--[[
    IMPORTANT: These settings only work with a custom-built RedM client/server
    that has the physical player extension patches applied. 
    
    Standard RedM builds are limited to 31 physical players regardless of these settings.
    
    To build a custom RedM with extended limits, follow the instructions in TECHNICAL.md
]]

Config.PlayerLimits = {
    -- Expected maximum physical player slots (must match your RedM build)
    maxPhysicalPlayers = 128,          -- Set to 32 for standard builds, 64/128/256 for custom builds
    
    -- Server validation
    enforceStrictChecks = true,        -- Validate player indices against max physical slots
    warnOnStandardBuild = true,        -- Warn if standard 32-player limit detected
    
    -- Monitoring
    enableMonitoring = true,           -- Monitor player counts and warn on approaching limits
    warningThreshold = 0.85,           -- Warn when 85% of slots are filled
    criticalThreshold = 0.95,          -- Critical warning at 95% capacity
    
    -- Performance optimization for high player counts
    optimizeNetworking = true,         -- Enable network optimization for 64+ players
    reduceSyncDistance = false,        -- Reduce entity sync distance at high player counts
    dynamicSyncDistance = true,        -- Automatically adjust sync based on player count
    
    -- Sync distance scaling (when dynamicSyncDistance is true)
    syncDistanceScaling = {
        [32] = 424.0,    -- Default sync distance for standard servers
        [64] = 350.0,    -- Reduced distance for 64 players
        [96] = 300.0,    -- Further reduced for 96 players
        [128] = 250.0,   -- Optimized for 128 players
        [256] = 200.0    -- Minimal sync for 256 players
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ BUILD DETECTION ███████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

--[[
    The script will attempt to detect if you're running a custom build with
    extended player support. This is done by checking various game natives and
    server configurations.
]]

Config.BuildDetection = {
    enabled = true,                    -- Enable automatic build detection
    autoAdjustLimits = true,           -- Automatically adjust maxPhysicalPlayers based on detection
    logDetectionResults = true,        -- Log detection results to console
    fallbackToStandard = true          -- Fall back to 32-player mode if custom build not detected
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ SECURITY & ANTI-EXPLOIT ███████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Security = {
    enabled = true,                    -- Enable security checks
    validatePlayerIndices = true,      -- Validate player indices are within bounds
    detectIndexSpoofing = true,        -- Detect attempts to spoof player indices
    blockInvalidPlayers = true,        -- Block operations on invalid player indices
    logSuspiciousActivity = true,      -- Log suspicious player index activity
    kickOnExploit = false,             -- Kick players attempting exploits
    maxPlayerIdValue = 65535           -- Maximum allowed player server ID value
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ PERFORMANCE OPTIMIZATION ██████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Performance = {
    -- Update intervals (in milliseconds)
    monitoringInterval = 30000,        -- Check player count every 30 seconds
    metricsInterval = 60000,           -- Report metrics every 60 seconds
    
    -- Memory optimization
    enableMemoryProfiling = false,     -- Profile memory usage (debug only)
    garbageCollectInterval = 300000,   -- Force GC every 5 minutes on high player count
    
    -- Network optimization
    batchPlayerUpdates = true,         -- Batch player state updates
    useCompression = true,             -- Compress large player data packets
    prioritizeLocalPlayers = true,     -- Prioritize nearby player updates
    
    -- Thread optimization
    useAsyncProcessing = true,         -- Process player data asynchronously
    maxAsyncOperations = 10            -- Max concurrent async operations
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ ADMIN & LOGGING ███████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Admin = {
    -- Logging
    enableDebugLogs = false,           -- Enable verbose debug logging
    logPlayerConnections = true,       -- Log when players connect/disconnect
    logPhysicalSlotUsage = true,       -- Log physical slot allocation
    logPerformanceMetrics = true,      -- Log performance data
    
    -- Commands
    enableAdminCommands = true,        -- Enable admin commands (/playerlimits, /playerstats)
    adminPermission = 'admin',         -- Required permission for admin commands
    
    -- Notifications
    notifyAdminsOnThreshold = true,    -- Notify admins when thresholds are reached
    notifyOnBuildMismatch = true       -- Notify if build doesn't match configuration
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ LANGUAGE CONFIGURATION ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Lang = 'en' -- Language for notifications (en, ge, etc.)

Config.Locale = {
    en = {
        -- System messages
        resource_started = '🐺 LXR Player Limits System Started',
        resource_stopped = 'LXR Player Limits System Stopped',
        build_detected = 'Detected RedM build: %s',
        physical_limit_detected = 'Physical player limit: %d',
        
        -- Warnings
        warning_threshold = 'Warning: Player count at %d%% capacity (%d/%d players)',
        critical_threshold = 'CRITICAL: Player count at %d%% capacity (%d/%d players)',
        standard_build_warning = 'WARNING: Standard RedM build detected (31 player limit)',
        build_mismatch = 'WARNING: Configuration expects %d players but build supports %d',
        
        -- Admin commands
        cmd_playerlimits_usage = 'Usage: /playerlimits',
        cmd_playerlimits_info = 'Player Limits Info:\nPhysical Limit: %d\nCurrent Players: %d\nCapacity: %d%%',
        cmd_playerstats_usage = 'Usage: /playerstats',
        cmd_playerstats_info = 'Player Stats:\nTotal Slots: %d\nUsed Slots: %d\nFree Slots: %d\nPeak Players: %d',
        
        -- Errors
        error_invalid_player = 'Invalid player index: %d',
        error_player_limit_reached = 'Server full: Cannot accept more players',
        error_exploit_detected = 'Player index exploit detected from player %d'
    },
    ge = {
        -- Georgian translations
        resource_started = '🐺 LXR მოთამაშეების ლიმიტის სისტემა გაშვებულია',
        resource_stopped = 'LXR მოთამაშეების ლიმიტის სისტემა გამორთულია',
        build_detected = 'გამოვლენილია RedM ვერსია: %s',
        physical_limit_detected = 'ფიზიკური მოთამაშეების ლიმიტი: %d',
        
        warning_threshold = 'გაფრთხილება: მოთამაშეების რაოდენობა %d%% (%d/%d მოთამაშე)',
        critical_threshold = 'კრიტიკული: მოთამაშეების რაოდენობა %d%% (%d/%d მოთამაშე)',
        standard_build_warning = 'გაფრთხილება: სტანდარტული RedM (31 მოთამაშის ლიმიტი)',
        build_mismatch = 'გაფრთხილება: კონფიგურაცია მოლოდინია %d მოთამაშე მაგრამ ბილდი იძლევა %d',
        
        error_invalid_player = 'არასწორი მოთამაშის ინდექსი: %d',
        error_player_limit_reached = 'სერვერი სავსეა',
        error_exploit_detected = 'ექსპლოიტის მცდელობა მოთამაშისგან %d'
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ COMPATIBILITY SETTINGS █████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Compatibility = {
    -- OneSync settings
    requireOneSync = true,             -- Require OneSync to be enabled
    oneSyncMode = 'infinity',          -- Expected OneSync mode (legacy/infinity)
    
    -- Game build compatibility
    minimumGameBuild = 1491,           -- Minimum required RedM game build
    
    -- Resource compatibility checks
    checkConflictingResources = true,  -- Check for resources that might conflict
    conflictingResources = {
        'other-playerlimits',
        'old-playerlimits-mod'
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ DEBUG SETTINGS ████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Debug = false -- Enable debug mode (verbose logging and extra checks)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ END OF CONFIGURATION ██████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Startup banner
if IsDuplicityVersion() then
    CreateThread(function()
        Wait(1000)
        print([[
        
        ═══════════════════════════════════════════════════════════════════════════════
        
            ██╗     ██╗  ██╗██████╗       ██████╗ ██╗      █████╗ ██╗   ██╗███████╗██████╗ 
            ██║     ╚██╗██╔╝██╔══██╗      ██╔══██╗██║     ██╔══██╗╚██╗ ██╔╝██╔════╝██╔══██╗
            ██║      ╚███╔╝ ██████╔╝█████╗██████╔╝██║     ███████║ ╚████╔╝ █████╗  ██████╔╝
            ██║      ██╔██╗ ██╔══██╗╚════╝██╔═══╝ ██║     ██╔══██║  ╚██╔╝  ██╔══╝  ██╔══██╗
            ███████╗██╔╝ ██╗██║  ██║      ██║     ███████╗██║  ██║   ██║   ███████╗██║  ██║
            ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═╝     ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝
            
            ██╗     ██╗███╗   ███╗██╗████████╗███████╗    ██████╗ ███████╗███╗   ███╗ ██████╗ ██╗   ██╗ █████╗ ██╗     
            ██║     ██║████╗ ████║██║╚══██╔══╝██╔════╝    ██╔══██╗██╔════╝████╗ ████║██╔═══██╗██║   ██║██╔══██╗██║     
            ██║     ██║██╔████╔██║██║   ██║   ███████╗    ██████╔╝█████╗  ██╔████╔██║██║   ██║██║   ██║███████║██║     
            ██║     ██║██║╚██╔╝██║██║   ██║   ╚════██║    ██╔══██╗██╔══╝  ██║╚██╔╝██║██║   ██║╚██╗ ██╔╝██╔══██║██║     
            ███████╗██║██║ ╚═╝ ██║██║   ██║   ███████║    ██║  ██║███████╗██║ ╚═╝ ██║╚██████╔╝ ╚████╔╝ ██║  ██║███████╗
            ╚══════╝╚═╝╚═╝     ╚═╝╚═╝   ╚═╝   ╚══════╝    ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝ ╚═════╝   ╚═══╝  ╚═╝  ╚═╝╚══════╝
            
        ═══════════════════════════════════════════════════════════════════════════════
        
                    🐺 The Land of Wolves - RedM Player Limits Removal
                    
                    Version: 1.0.0
                    Author: iBoss21 / The Lux Empire
                    Server: wolves.land
                    
        ═══════════════════════════════════════════════════════════════════════════════
        
        ]])
    end)
end
