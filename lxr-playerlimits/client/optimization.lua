--[[
    ██╗     ██╗  ██╗██████╗         ██████╗ ██████╗ ████████╗██╗███╗   ███╗██╗███████╗ █████╗ ████████╗██╗ ██████╗ ███╗   ██╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔═══██╗██╔══██╗╚══██╔══╝██║████╗ ████║██║╚══███╔╝██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║
    ██║      ╚███╔╝ ██████╔╝█████╗██║   ██║██████╔╝   ██║   ██║██╔████╔██║██║  ███╔╝ ███████║   ██║   ██║██║   ██║██╔██╗ ██║
    ██║      ██╔██╗ ██╔══██╗╚════╝██║   ██║██╔═══╝    ██║   ██║██║╚██╔╝██║██║ ███╔╝  ██╔══██║   ██║   ██║██║   ██║██║╚██╗██║
    ███████╗██╔╝ ██╗██║  ██║      ╚██████╔╝██║        ██║   ██║██║ ╚═╝ ██║██║███████╗██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═════╝ ╚═╝        ╚═╝   ╚═╝╚═╝     ╚═╝╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
    
    🐺 LXR Player Limits - Client-Side Performance Optimization
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- DYNAMIC SYNC DISTANCE OPTIMIZATION
-- ═══════════════════════════════════════════════════════════════════════════════

local lastPlayerCount = 0
local currentSyncDistance = 424.0 -- Default RedM sync distance

local function GetOptimalSyncDistance(playerCount)
    if not Config.PlayerLimits.dynamicSyncDistance then
        return nil
    end
    
    local scaling = Config.PlayerLimits.syncDistanceScaling
    
    -- Find the appropriate sync distance based on player count
    local distances = {}
    for count, distance in pairs(scaling) do
        table.insert(distances, {count = count, distance = distance})
    end
    
    -- Sort by count
    table.sort(distances, function(a, b) return a.count < b.count end)
    
    -- Find the right bracket
    for i = #distances, 1, -1 do
        if playerCount >= distances[i].count then
            return distances[i].distance
        end
    end
    
    return distances[1].distance
end

local function UpdateSyncDistance()
    if not Config.PlayerLimits.optimizeNetworking then
        return
    end
    
    if not Config.PlayerLimits.dynamicSyncDistance then
        return
    end
    
    -- Get current player count from nearby players
    local playerCount = 0
    for _, player in ipairs(GetActivePlayers()) do
        playerCount = playerCount + 1
    end
    
    -- Only update if player count changed significantly
    if math.abs(playerCount - lastPlayerCount) >= 5 then
        local optimalDistance = GetOptimalSyncDistance(playerCount)
        
        if optimalDistance and optimalDistance ~= currentSyncDistance then
            -- Note: There's no native to actually change sync distance client-side
            -- This is for monitoring purposes and server-side can use this data
            currentSyncDistance = optimalDistance
            lastPlayerCount = playerCount
            
            if Config.Debug then
                print(string.format('[LXR-PlayerLimits] [Client] Optimal sync distance for %d players: %.1f', 
                    playerCount, optimalDistance))
            end
            
            -- Trigger server event to log this (optional)
            -- TriggerServerEvent('lxr-playerlimits:server:updateSyncDistance', playerCount, optimalDistance)
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- CLIENT-SIDE PERFORMANCE MONITORING
-- ═══════════════════════════════════════════════════════════════════════════════

local function MonitorClientPerformance()
    if not Config.Performance.enableMemoryProfiling then
        return
    end
    
    local memUsage = collectgarbage('count')
    
    if Config.Debug then
        print(string.format('[LXR-PlayerLimits] [Client] Memory usage: %.2f KB', memUsage))
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- OPTIMIZATION THREADS
-- ═══════════════════════════════════════════════════════════════════════════════

if Config.PlayerLimits.dynamicSyncDistance then
    CreateThread(function()
        while true do
            Wait(30000) -- Check every 30 seconds
            UpdateSyncDistance()
        end
    end)
end

if Config.Performance.enableMemoryProfiling then
    CreateThread(function()
        while true do
            Wait(60000) -- Check every minute
            MonitorClientPerformance()
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════════════

CreateThread(function()
    Wait(5000)
    
    if Config.Debug then
        print('[LXR-PlayerLimits] [Client] Optimization module loaded')
    end
end)
