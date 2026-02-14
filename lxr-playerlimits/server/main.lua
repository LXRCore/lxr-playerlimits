--[[
    ██╗     ██╗  ██╗██████╗        ███╗   ███╗ █████╗ ██╗███╗   ██╗
    ██║     ╚██╗██╔╝██╔══██╗      ████╗ ████║██╔══██╗██║████╗  ██║
    ██║      ╚███╔╝ ██████╔╝█████╗██╔████╔██║███████║██║██╔██╗ ██║
    ██║      ██╔██╗ ██╔══██╗╚════╝██║╚██╔╝██║██╔══██║██║██║╚██╗██║
    ███████╗██╔╝ ██╗██║  ██║      ██║ ╚═╝ ██║██║  ██║██║██║ ╚████║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝
    
    🐺 LXR Player Limits - Server Main Logic
    Build detection, validation, and core functionality
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- STATE VARIABLES
-- ═══════════════════════════════════════════════════════════════════════════════

local PlayerLimits = {
    detectedLimit = 32,              -- Detected physical player limit
    customBuildActive = false,       -- Whether custom build is detected
    currentPlayers = 0,              -- Current player count
    peakPlayers = 0,                 -- Peak player count this session
    oneSyncEnabled = false,          -- OneSync status
    oneSyncMode = 'unknown',         -- OneSync mode (legacy/infinity)
    lastWarningTime = 0,             -- Last time a capacity warning was sent
    playerSlots = {}                 -- Track physical player slots
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- BUILD DETECTION
-- ═══════════════════════════════════════════════════════════════════════════════

local function DetectBuildCapabilities()
    if not Config.BuildDetection.enabled then
        PlayerLimits.detectedLimit = Config.PlayerLimits.maxPhysicalPlayers
        return
    end
    
    -- Check OneSync status
    local oneSyncConvar = GetConvar('onesync', 'off')
    PlayerLimits.oneSyncEnabled = oneSyncConvar ~= 'off'
    PlayerLimits.oneSyncMode = oneSyncConvar
    
    if Config.Debug then
        print(string.format('[LXR-PlayerLimits] OneSync Status: %s (Mode: %s)', 
            tostring(PlayerLimits.oneSyncEnabled), PlayerLimits.oneSyncMode))
    end
    
    -- Check server configuration
    local svMaxClients = GetConvarInt('sv_maxclients', 32)
    
    -- Attempt to detect custom build by checking maximum server ID
    -- Standard RedM builds will fail beyond 31 physical players
    -- Custom builds will support higher indices
    
    -- Simple heuristic: if sv_maxclients > 32, assume custom build
    if svMaxClients > 32 then
        PlayerLimits.customBuildActive = true
        PlayerLimits.detectedLimit = math.min(svMaxClients, Config.PlayerLimits.maxPhysicalPlayers)
    else
        PlayerLimits.customBuildActive = false
        PlayerLimits.detectedLimit = 32
    end
    
    if Config.BuildDetection.autoAdjustLimits then
        Config.PlayerLimits.maxPhysicalPlayers = PlayerLimits.detectedLimit
    end
    
    if Config.BuildDetection.logDetectionResults then
        print(string.format([[
            
            ═══════════════════════════════════════════════════════════════════════════════
            🐺 LXR PLAYER LIMITS - BUILD DETECTION RESULTS
            ═══════════════════════════════════════════════════════════════════════════════
            
            OneSync Enabled:       %s
            OneSync Mode:          %s
            Custom Build Detected: %s
            Physical Player Limit: %d
            Server Max Clients:    %d
            
            ═══════════════════════════════════════════════════════════════════════════════
            
        ]], 
            tostring(PlayerLimits.oneSyncEnabled),
            PlayerLimits.oneSyncMode,
            tostring(PlayerLimits.customBuildActive),
            PlayerLimits.detectedLimit,
            svMaxClients
        ))
    end
    
    -- Warn if not using custom build
    if not PlayerLimits.customBuildActive and Config.PlayerLimits.warnOnStandardBuild then
        print([[
            
            ═══════════════════════════════════════════════════════════════════════════════
            ⚠️  WARNING: STANDARD REDM BUILD DETECTED
            ═══════════════════════════════════════════════════════════════════════════════
            
            This server is running a standard RedM build with a 31 player limit.
            To enable support for more than 31 players, you need a custom-built
            RedM client/server with physical player extension patches.
            
            See TECHNICAL.md for build instructions.
            
            ═══════════════════════════════════════════════════════════════════════════════
            
        ]])
    end
    
    -- Warn on configuration mismatch
    if Config.BuildDetection.logDetectionResults and 
       Config.PlayerLimits.maxPhysicalPlayers ~= PlayerLimits.detectedLimit then
        print(string.format([[
            
            ═══════════════════════════════════════════════════════════════════════════════
            ⚠️  WARNING: CONFIGURATION MISMATCH
            ═══════════════════════════════════════════════════════════════════════════════
            
            Config expects:  %d players
            Build supports:  %d players
            
            The configuration will be automatically adjusted to match the detected limit.
            
            ═══════════════════════════════════════════════════════════════════════════════
            
        ]], Config.PlayerLimits.maxPhysicalPlayers, PlayerLimits.detectedLimit))
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- PLAYER VALIDATION
-- ═══════════════════════════════════════════════════════════════════════════════

local function ValidatePlayerIndex(playerId)
    if not Config.Security.enabled then
        return true
    end
    
    if not Config.Security.validatePlayerIndices then
        return true
    end
    
    -- Check if player ID is within valid range
    if playerId < 1 or playerId > Config.Security.maxPlayerIdValue then
        if Config.Security.logSuspiciousActivity then
            -- Log to console for immediate visibility
            print(string.format('[LXR-PlayerLimits] [SECURITY] Invalid player ID detected: %d', playerId))
            
            -- TODO: Implement webhook/database logging for audit trails
            -- Example: TriggerEvent('lxr-playerlimits:logSecurityEvent', {
            --     type = 'invalid_player_id',
            --     playerId = playerId,
            --     timestamp = os.time()
            -- })
        end
        return false
    end
    
    return true
end

local function OnPlayerConnecting(name, setKickReason, deferrals)
    deferrals.defer()
    
    local source = source
    
    -- Wait a moment for player to fully initialize
    Wait(0)
    
    -- Validate player
    if not ValidatePlayerIndex(source) then
        if Config.Security.blockInvalidPlayers then
            deferrals.done('Invalid player index. Please reconnect.')
            return
        end
    end
    
    -- Check if we're at capacity
    local currentCount = #GetPlayers()
    if currentCount >= PlayerLimits.detectedLimit then
        if Config.Debug then
            print(string.format('[LXR-PlayerLimits] Server at capacity: %d/%d', currentCount, PlayerLimits.detectedLimit))
        end
        -- Don't block, let server handle it, just log
    end
    
    deferrals.done()
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- PLAYER COUNT MONITORING
-- ═══════════════════════════════════════════════════════════════════════════════

local function UpdatePlayerCount()
    local players = GetPlayers()
    PlayerLimits.currentPlayers = #players
    
    -- Update peak
    if PlayerLimits.currentPlayers > PlayerLimits.peakPlayers then
        PlayerLimits.peakPlayers = PlayerLimits.currentPlayers
    end
    
    -- Track physical slots
    for _, playerId in ipairs(players) do
        PlayerLimits.playerSlots[playerId] = true
    end
    
    -- Calculate capacity percentage
    local capacityPercent = (PlayerLimits.currentPlayers / PlayerLimits.detectedLimit) * 100
    
    -- Check thresholds
    if Config.PlayerLimits.enableMonitoring then
        local warningThreshold = Config.PlayerLimits.warningThreshold * 100
        local criticalThreshold = Config.PlayerLimits.criticalThreshold * 100
        local currentTime = os.time()
        
        -- Only warn once per 5 minutes
        if currentTime - PlayerLimits.lastWarningTime > 300 then
            if capacityPercent >= criticalThreshold then
                local message = string.format(
                    Config.Locale[Config.Lang].critical_threshold,
                    math.floor(capacityPercent),
                    PlayerLimits.currentPlayers,
                    PlayerLimits.detectedLimit
                )
                print(string.format('[LXR-PlayerLimits] CRITICAL: %s', message))
                
                if Config.Admin.notifyAdminsOnThreshold then
                    NotifyAdmins(message, 'error')
                end
                
                PlayerLimits.lastWarningTime = currentTime
            elseif capacityPercent >= warningThreshold then
                local message = string.format(
                    Config.Locale[Config.Lang].warning_threshold,
                    math.floor(capacityPercent),
                    PlayerLimits.currentPlayers,
                    PlayerLimits.detectedLimit
                )
                print(string.format('[LXR-PlayerLimits] WARNING: %s', message))
                
                if Config.Admin.notifyAdminsOnThreshold then
                    NotifyAdmins(message, 'warning')
                end
                
                PlayerLimits.lastWarningTime = currentTime
            end
        end
    end
end

function NotifyAdmins(message, type)
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        if Framework.HasPermission(playerId, Config.Admin.adminPermission) then
            Framework.Notify(playerId, message, type)
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- EXPORTS
-- ═══════════════════════════════════════════════════════════════════════════════

function GetMaxPhysicalPlayers()
    return PlayerLimits.detectedLimit
end

function GetCurrentPlayerCount()
    return PlayerLimits.currentPlayers
end

function GetPhysicalPlayerLimit()
    return PlayerLimits.detectedLimit
end

function IsCustomBuildDetected()
    return PlayerLimits.customBuildActive
end

function GetPlayerCapacityPercent()
    return (PlayerLimits.currentPlayers / PlayerLimits.detectedLimit) * 100
end

function GetPhysicalSlotInfo()
    return {
        maxSlots = PlayerLimits.detectedLimit,
        usedSlots = PlayerLimits.currentPlayers,
        freeSlots = PlayerLimits.detectedLimit - PlayerLimits.currentPlayers,
        peakSlots = PlayerLimits.peakPlayers,
        capacityPercent = GetPlayerCapacityPercent(),
        customBuild = PlayerLimits.customBuildActive,
        oneSyncEnabled = PlayerLimits.oneSyncEnabled,
        oneSyncMode = PlayerLimits.oneSyncMode
    }
end

exports('GetMaxPhysicalPlayers', GetMaxPhysicalPlayers)
exports('GetCurrentPlayerCount', GetCurrentPlayerCount)
exports('GetPhysicalPlayerLimit', GetPhysicalPlayerLimit)
exports('IsCustomBuildDetected', IsCustomBuildDetected)
exports('GetPlayerCapacityPercent', GetPlayerCapacityPercent)
exports('GetPhysicalSlotInfo', GetPhysicalSlotInfo)

-- ═══════════════════════════════════════════════════════════════════════════════
-- EVENT HANDLERS
-- ═══════════════════════════════════════════════════════════════════════════════

AddEventHandler('playerConnecting', OnPlayerConnecting)

AddEventHandler('playerDropped', function()
    local source = source
    PlayerLimits.playerSlots[source] = nil
    UpdatePlayerCount()
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════════════

CreateThread(function()
    Wait(1000) -- Wait for frameworks to load
    
    DetectBuildCapabilities()
    UpdatePlayerCount()
    
    print(string.format(Config.Locale[Config.Lang].resource_started))
    print(string.format(Config.Locale[Config.Lang].physical_limit_detected, PlayerLimits.detectedLimit))
end)
