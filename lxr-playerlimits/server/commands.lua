--[[
    ██╗     ██╗  ██╗██████╗         ██████╗ ██████╗ ███╗   ███╗███╗   ███╗ █████╗ ███╗   ██╗██████╗ ███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝██╔═══██╗████╗ ████║████╗ ████║██╔══██╗████╗  ██║██╔══██╗██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║██╔████╔██║██╔████╔██║███████║██╔██╗ ██║██║  ██║███████╗
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║██║╚██╔╝██║██║╚██╔╝██║██╔══██║██║╚██╗██║██║  ██║╚════██║
    ███████╗██╔╝ ██╗██║  ██║      ╚██████╗╚██████╔╝██║ ╚═╝ ██║██║ ╚═╝ ██║██║  ██║██║ ╚████║██████╔╝███████║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ ╚══════╝
    
    🐺 LXR Player Limits - Admin Commands
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- COMMAND: /playerlimits
-- ═══════════════════════════════════════════════════════════════════════════════

RegisterCommand('playerlimits', function(source, args, rawCommand)
    if not Config.Admin.enableAdminCommands then
        return
    end
    
    if source ~= 0 and not Framework.HasPermission(source, Config.Admin.adminPermission) then
        Framework.Notify(source, 'You do not have permission to use this command', 'error')
        return
    end
    
    local slotInfo = exports[GetCurrentResourceName()]:GetPhysicalSlotInfo()
    
    local message = string.format([[
        
        ═══════════════════════════════════════════════════════════════════════════════
        🐺 LXR PLAYER LIMITS - STATUS
        ═══════════════════════════════════════════════════════════════════════════════
        
        Physical Limit:    %d
        Current Players:   %d
        Free Slots:        %d
        Peak Players:      %d
        Capacity:          %.1f%%
        
        Custom Build:      %s
        OneSync:           %s (%s)
        
        ═══════════════════════════════════════════════════════════════════════════════
        
    ]],
        slotInfo.maxSlots,
        slotInfo.usedSlots,
        slotInfo.freeSlots,
        slotInfo.peakSlots,
        slotInfo.capacityPercent,
        tostring(slotInfo.customBuild),
        tostring(slotInfo.oneSyncEnabled),
        slotInfo.oneSyncMode
    )
    
    if source == 0 then
        print(message)
    else
        TriggerClientEvent('chat:addMessage', source, {
            args = { message }
        })
    end
end, false)

-- ═══════════════════════════════════════════════════════════════════════════════
-- COMMAND: /playerstats
-- ═══════════════════════════════════════════════════════════════════════════════

RegisterCommand('playerstats', function(source, args, rawCommand)
    if not Config.Admin.enableAdminCommands then
        return
    end
    
    if source ~= 0 and not Framework.HasPermission(source, Config.Admin.adminPermission) then
        Framework.Notify(source, 'You do not have permission to use this command', 'error')
        return
    end
    
    local slotInfo = exports[GetCurrentResourceName()]:GetPhysicalSlotInfo()
    local players = GetPlayers()
    
    local message = string.format([[
        
        ═══════════════════════════════════════════════════════════════════════════════
        🐺 LXR PLAYER STATS
        ═══════════════════════════════════════════════════════════════════════════════
        
        Total Slots:       %d
        Used Slots:        %d
        Free Slots:        %d
        Peak Players:      %d
        
        Framework:         %s
        
        ═══════════════════════════════════════════════════════════════════════════════
        
    ]],
        slotInfo.maxSlots,
        slotInfo.usedSlots,
        slotInfo.freeSlots,
        slotInfo.peakSlots,
        Framework.Name
    )
    
    if source == 0 then
        print(message)
    else
        TriggerClientEvent('chat:addMessage', source, {
            args = { message }
        })
    end
end, false)

-- ═══════════════════════════════════════════════════════════════════════════════
-- COMMAND: /playerslots (debug)
-- ═══════════════════════════════════════════════════════════════════════════════

RegisterCommand('playerslots', function(source, args, rawCommand)
    if not Config.Admin.enableAdminCommands or not Config.Debug then
        return
    end
    
    if source ~= 0 and not Framework.HasPermission(source, Config.Admin.adminPermission) then
        Framework.Notify(source, 'You do not have permission to use this command', 'error')
        return
    end
    
    local players = GetPlayers()
    
    local message = string.format([[
        
        ═══════════════════════════════════════════════════════════════════════════════
        🐺 LXR PLAYER SLOTS (DEBUG)
        ═══════════════════════════════════════════════════════════════════════════════
        
        Active Players (%d):
        
    ]], #players)
    
    for _, playerId in ipairs(players) do
        message = message .. string.format('  [%3d] %s\n', playerId, GetPlayerName(playerId))
    end
    
    message = message .. '\n═══════════════════════════════════════════════════════════════════════════════\n'
    
    if source == 0 then
        print(message)
    else
        TriggerClientEvent('chat:addMessage', source, {
            args = { message }
        })
    end
end, false)

-- ═══════════════════════════════════════════════════════════════════════════════
-- COMMAND SUGGESTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

TriggerEvent('chat:addSuggestion', '/playerlimits', 'Display player limits information')
TriggerEvent('chat:addSuggestion', '/playerstats', 'Display detailed player statistics')
if Config.Debug then
    TriggerEvent('chat:addSuggestion', '/playerslots', 'Display active player slots (debug)')
end
