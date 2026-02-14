--[[
    ██╗     ██╗  ██╗██████╗         ██████╗██╗     ██╗███████╗███╗   ██╗████████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝██║     ██║██╔════╝████╗  ██║╚══██╔══╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║     ██║█████╗  ██╔██╗ ██║   ██║   
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║     ██║██╔══╝  ██║╚██╗██║   ██║   
    ███████╗██╔╝ ██╗██║  ██║      ╚██████╗███████╗██║███████╗██║ ╚████║   ██║   
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═════╝╚══════╝╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝   
    
    🐺 LXR Player Limits - Client Main
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- CLIENT STATE
-- ═══════════════════════════════════════════════════════════════════════════════

local ClientState = {
    extendedBuildActive = false,
    localPlayerPhysicalId = -1,
    serverInfo = nil
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- EXPORTS
-- ═══════════════════════════════════════════════════════════════════════════════

function GetLocalPlayerPhysicalId()
    return PlayerId()
end

function IsExtendedBuildActive()
    return ClientState.extendedBuildActive
end

exports('GetLocalPlayerPhysicalId', GetLocalPlayerPhysicalId)
exports('IsExtendedBuildActive', IsExtendedBuildActive)

-- ═══════════════════════════════════════════════════════════════════════════════
-- EVENT HANDLERS
-- ═══════════════════════════════════════════════════════════════════════════════

RegisterNetEvent('lxr-playerlimits:client:receiveInfo', function(info)
    ClientState.serverInfo = info
    ClientState.extendedBuildActive = info.customBuild
    
    if Config.Debug then
        print(string.format('[LXR-PlayerLimits] [Client] Server info received: %d max players, custom build: %s',
            info.maxSlots, tostring(info.customBuild)))
    end
end)

RegisterNetEvent('lxr-playerlimits:client:capacityStatus', function(status)
    if Config.Debug then
        print(string.format('[LXR-PlayerLimits] [Client] Capacity status: %.1f%% full', status.percentFull))
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════════════

CreateThread(function()
    Wait(2000)
    
    -- Request server info
    TriggerServerEvent('lxr-playerlimits:server:getInfo')
    
    -- Get local player ID
    ClientState.localPlayerPhysicalId = PlayerId()
    
    if Config.Debug then
        print(string.format('[LXR-PlayerLimits] [Client] Local player ID: %d', ClientState.localPlayerPhysicalId))
    end
end)
