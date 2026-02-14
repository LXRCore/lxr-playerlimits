--[[
    ██╗     ██╗  ██╗██████╗        ███████╗██╗   ██╗███████╗███╗   ██╗████████╗███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝██║   ██║██╔════╝████╗  ██║╚══██╔══╝██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗█████╗  ██║   ██║█████╗  ██╔██╗ ██║   ██║   ███████╗
    ██║      ██╔██╗ ██╔══██╗╚════╝██╔══╝  ╚██╗ ██╔╝██╔══╝  ██║╚██╗██║   ██║   ╚════██║
    ███████╗██╔╝ ██╗██║  ██║      ███████╗ ╚████╔╝ ███████╗██║ ╚████║   ██║   ███████║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚══════╝  ╚═══╝  ╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝
    
    🐺 LXR Player Limits - Event Handlers
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- SERVER EVENTS
-- ═══════════════════════════════════════════════════════════════════════════════

-- Event: Get player limits info
RegisterNetEvent('lxr-playerlimits:server:getInfo', function()
    local source = source
    local slotInfo = exports[GetCurrentResourceName()]:GetPhysicalSlotInfo()
    
    TriggerClientEvent('lxr-playerlimits:client:receiveInfo', source, slotInfo)
end)

-- Event: Request capacity check
RegisterNetEvent('lxr-playerlimits:server:checkCapacity', function()
    local source = source
    local slotInfo = exports[GetCurrentResourceName()]:GetPhysicalSlotInfo()
    
    local response = {
        atCapacity = slotInfo.usedSlots >= slotInfo.maxSlots,
        nearCapacity = slotInfo.capacityPercent >= (Config.PlayerLimits.warningThreshold * 100),
        percentFull = slotInfo.capacityPercent
    }
    
    TriggerClientEvent('lxr-playerlimits:client:capacityStatus', source, response)
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- RESOURCE LIFECYCLE EVENTS
-- ═══════════════════════════════════════════════════════════════════════════════

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end
    
    if Config.Debug then
        print('[LXR-PlayerLimits] Resource started successfully')
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end
    
    print(string.format(Config.Locale[Config.Lang].resource_stopped))
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- COMPATIBILITY CHECKS
-- ═══════════════════════════════════════════════════════════════════════════════

if Config.Compatibility.checkConflictingResources then
    CreateThread(function()
        Wait(2000)
        
        for _, resourceName in ipairs(Config.Compatibility.conflictingResources) do
            if GetResourceState(resourceName) == 'started' then
                print(string.format([[
                    
                    ═══════════════════════════════════════════════════════════════════════════════
                    ⚠️  WARNING: CONFLICTING RESOURCE DETECTED
                    ═══════════════════════════════════════════════════════════════════════════════
                    
                    Resource '%s' may conflict with lxr-playerlimits.
                    Please ensure only one player limits management resource is active.
                    
                    ═══════════════════════════════════════════════════════════════════════════════
                    
                ]], resourceName))
            end
        end
    end)
end

-- OneSync requirement check
if Config.Compatibility.requireOneSync then
    CreateThread(function()
        Wait(1000)
        
        local oneSyncConvar = GetConvar('onesync', 'off')
        if oneSyncConvar == 'off' then
            print([[
                
                ═══════════════════════════════════════════════════════════════════════════════
                ⚠️  ERROR: ONESYNC REQUIRED
                ═══════════════════════════════════════════════════════════════════════════════
                
                This resource requires OneSync to be enabled.
                Add 'set onesync on' or 'set onesync infinity' to your server.cfg
                
                ═══════════════════════════════════════════════════════════════════════════════
                
            ]])
        end
    end)
end
