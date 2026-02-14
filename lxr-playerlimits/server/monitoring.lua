--[[
    ██╗     ██╗  ██╗██████╗        ███╗   ███╗ ██████╗ ███╗   ██╗██╗████████╗ ██████╗ ██████╗ ██╗███╗   ██╗ ██████╗ 
    ██║     ╚██╗██╔╝██╔══██╗      ████╗ ████║██╔═══██╗████╗  ██║██║╚══██╔══╝██╔═══██╗██╔══██╗██║████╗  ██║██╔════╝ 
    ██║      ╚███╔╝ ██████╔╝█████╗██╔████╔██║██║   ██║██╔██╗ ██║██║   ██║   ██║   ██║██████╔╝██║██╔██╗ ██║██║  ███╗
    ██║      ██╔██╗ ██╔══██╗╚════╝██║╚██╔╝██║██║   ██║██║╚██╗██║██║   ██║   ██║   ██║██╔══██╗██║██║╚██╗██║██║   ██║
    ███████╗██╔╝ ██╗██║  ██║      ██║ ╚═╝ ██║╚██████╔╝██║ ╚████║██║   ██║   ╚██████╔╝██║  ██║██║██║ ╚████║╚██████╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝ 
    
    🐺 LXR Player Limits - Performance & Health Monitoring
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- MONITORING STATE
-- ═══════════════════════════════════════════════════════════════════════════════

local MonitoringData = {
    startTime = os.time(),
    lastMetricsReport = 0,
    playerCountHistory = {},
    performanceMetrics = {
        avgTickTime = 0,
        peakMemory = 0,
        totalConnections = 0,
        totalDisconnects = 0
    }
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- PERFORMANCE MONITORING
-- ═══════════════════════════════════════════════════════════════════════════════

local function CollectPerformanceMetrics()
    if not Config.Performance.enableMemoryProfiling then
        return
    end
    
    -- Collect memory usage
    local memUsage = collectgarbage('count')
    if memUsage > MonitoringData.performanceMetrics.peakMemory then
        MonitoringData.performanceMetrics.peakMemory = memUsage
    end
    
    -- Log metrics if configured
    if Config.Admin.logPerformanceMetrics then
        if Config.Debug then
            print(string.format('[LXR-PlayerLimits] [Metrics] Memory: %.2f KB | Peak: %.2f KB', 
                memUsage, MonitoringData.performanceMetrics.peakMemory))
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- PLAYER COUNT HISTORY
-- ═══════════════════════════════════════════════════════════════════════════════

local function RecordPlayerCount()
    local currentCount = #GetPlayers()
    local timestamp = os.time()
    
    table.insert(MonitoringData.playerCountHistory, {
        timestamp = timestamp,
        count = currentCount
    })
    
    -- Keep only last hour of data (1 sample per minute = 60 samples)
    if #MonitoringData.playerCountHistory > 60 then
        table.remove(MonitoringData.playerCountHistory, 1)
    end
end

local function GetAveragePlayerCount()
    if #MonitoringData.playerCountHistory == 0 then
        return 0
    end
    
    local total = 0
    for _, entry in ipairs(MonitoringData.playerCountHistory) do
        total = total + entry.count
    end
    
    return math.floor(total / #MonitoringData.playerCountHistory)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- METRICS REPORTING
-- ═══════════════════════════════════════════════════════════════════════════════

local function ReportMetrics()
    if not Config.Admin.logPerformanceMetrics then
        return
    end
    
    local currentTime = os.time()
    if currentTime - MonitoringData.lastMetricsReport < 300 then -- Report every 5 minutes
        return
    end
    
    local slotInfo = exports[GetCurrentResourceName()]:GetPhysicalSlotInfo()
    local avgPlayers = GetAveragePlayerCount()
    local uptime = currentTime - MonitoringData.startTime
    
    print(string.format([[
        
        ═══════════════════════════════════════════════════════════════════════════════
        🐺 LXR PLAYER LIMITS - METRICS REPORT
        ═══════════════════════════════════════════════════════════════════════════════
        
        Uptime:            %d hours, %d minutes
        Current Players:   %d / %d (%.1f%%)
        Average Players:   %d (last hour)
        Peak Players:      %d
        
        Total Connections:    %d
        Total Disconnects:    %d
        
        Custom Build:      %s
        OneSync:           %s (%s)
        
        ═══════════════════════════════════════════════════════════════════════════════
        
    ]],
        math.floor(uptime / 3600),
        math.floor((uptime % 3600) / 60),
        slotInfo.usedSlots,
        slotInfo.maxSlots,
        slotInfo.capacityPercent,
        avgPlayers,
        slotInfo.peakSlots,
        MonitoringData.performanceMetrics.totalConnections,
        MonitoringData.performanceMetrics.totalDisconnects,
        tostring(slotInfo.customBuild),
        tostring(slotInfo.oneSyncEnabled),
        slotInfo.oneSyncMode
    ))
    
    MonitoringData.lastMetricsReport = currentTime
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- EVENT HANDLERS
-- ═══════════════════════════════════════════════════════════════════════════════

AddEventHandler('playerConnecting', function()
    MonitoringData.performanceMetrics.totalConnections = MonitoringData.performanceMetrics.totalConnections + 1
    
    if Config.Admin.logPlayerConnections then
        local source = source
        if Config.Debug then
            print(string.format('[LXR-PlayerLimits] Player connecting: %s [%d]', GetPlayerName(source), source))
        end
    end
end)

AddEventHandler('playerDropped', function()
    MonitoringData.performanceMetrics.totalDisconnects = MonitoringData.performanceMetrics.totalDisconnects + 1
    
    if Config.Admin.logPlayerConnections then
        local source = source
        if Config.Debug then
            print(string.format('[LXR-PlayerLimits] Player dropped: %s [%d]', GetPlayerName(source), source))
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- MONITORING THREADS
-- ═══════════════════════════════════════════════════════════════════════════════

CreateThread(function()
    while true do
        Wait(Config.Performance.monitoringInterval or 30000)
        
        if Config.PlayerLimits.enableMonitoring then
            RecordPlayerCount()
            CollectPerformanceMetrics()
        end
    end
end)

CreateThread(function()
    while true do
        Wait(Config.Performance.metricsInterval or 60000)
        
        if Config.Admin.logPerformanceMetrics then
            ReportMetrics()
        end
    end
end)

-- Garbage collection for high player counts
if Config.Performance.garbageCollectInterval then
    CreateThread(function()
        while true do
            Wait(Config.Performance.garbageCollectInterval)
            
            local playerCount = #GetPlayers()
            if playerCount > 64 then
                collectgarbage('collect')
                if Config.Debug then
                    print('[LXR-PlayerLimits] Forced garbage collection (high player count)')
                end
            end
        end
    end)
end
