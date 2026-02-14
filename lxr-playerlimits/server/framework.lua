--[[
    ██╗     ██╗  ██╗██████╗        ███████╗██████╗  █████╗ ███╗   ███╗███████╗██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝██╔══██╗██╔══██╗████╗ ████║██╔════╝██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝
    ██║      ╚███╔╝ ██████╔╝█████╗█████╗  ██████╔╝███████║██╔████╔██║█████╗  ██║ █╗ ██║██║   ██║██████╔╝█████╔╝ 
    ██║      ██╔██╗ ██╔══██╗╚════╝██╔══╝  ██╔══██╗██╔══██║██║╚██╔╝██║██╔══╝  ██║███╗██║██║   ██║██╔══██╗██╔═██╗ 
    ███████╗██╔╝ ██╗██║  ██║      ██║     ██║  ██║██║  ██║██║ ╚═╝ ██║███████╗╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝ ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
    
    🐺 LXR Player Limits - Server Framework Detection
    Detects and initializes the appropriate framework (LXR, RSG, VORP, etc.)
]]

Framework = {}
Framework.Name = 'standalone'
Framework.Object = nil

-- ═══════════════════════════════════════════════════════════════════════════════
-- FRAMEWORK DETECTION
-- ═══════════════════════════════════════════════════════════════════════════════

local function DetectFramework()
    if Config.Framework ~= 'auto' then
        return Config.Framework
    end
    
    -- Priority order detection
    local frameworks = {
        'lxr-core',
        'rsg-core',
        'vorp_core',
        'redem_roleplay',
        'qbr-core',
        'qr-core'
    }
    
    for _, fw in ipairs(frameworks) do
        if GetResourceState(fw) == 'started' then
            return fw
        end
    end
    
    return 'standalone'
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- FRAMEWORK INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════════════

local function InitFramework()
    Framework.Name = DetectFramework()
    
    if Config.Debug then
        print(string.format('[LXR-PlayerLimits] Framework detected: %s', Framework.Name))
    end
    
    -- Initialize framework-specific object
    if Framework.Name == 'lxr-core' then
        Framework.Object = exports['lxr-core']:GetCoreObject()
    elseif Framework.Name == 'rsg-core' then
        Framework.Object = exports['rsg-core']:GetCoreObject()
    elseif Framework.Name == 'vorp_core' then
        Framework.Object = exports.vorp_core:GetCore()
    elseif Framework.Name == 'redem_roleplay' then
        Framework.Object = exports['redem_roleplay']:RedEM()
    elseif Framework.Name == 'qbr-core' then
        Framework.Object = exports['qbr-core']:GetCoreObject()
    elseif Framework.Name == 'qr-core' then
        Framework.Object = exports['qr-core']:GetCoreObject()
    end
    
    return Framework
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- HELPER FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

function Framework.GetPlayer(source)
    if Framework.Name == 'lxr-core' or Framework.Name == 'rsg-core' or 
       Framework.Name == 'qbr-core' or Framework.Name == 'qr-core' then
        return Framework.Object.Functions.GetPlayer(source)
    elseif Framework.Name == 'vorp_core' then
        return Framework.Object.getUser(source)
    elseif Framework.Name == 'redem_roleplay' then
        return Framework.Object.GetPlayer(source)
    end
    return nil
end

function Framework.GetPlayers()
    if Framework.Name == 'lxr-core' or Framework.Name == 'rsg-core' or 
       Framework.Name == 'qbr-core' or Framework.Name == 'qr-core' then
        return Framework.Object.Functions.GetPlayers()
    elseif Framework.Name == 'vorp_core' then
        local players = {}
        for _, player in pairs(GetPlayers()) do
            local user = Framework.Object.getUser(player)
            if user then
                table.insert(players, player)
            end
        end
        return players
    elseif Framework.Name == 'redem_roleplay' then
        return Framework.Object.GetPlayers()
    end
    return GetPlayers()
end

function Framework.Notify(source, message, type)
    local settings = Config.FrameworkSettings[Framework.Name]
    
    if not settings then
        return
    end
    
    if settings.notifications == 'ox_lib' then
        TriggerClientEvent('ox_lib:notify', source, {
            description = message,
            type = type or 'info'
        })
    elseif settings.notifications == 'vorp' then
        TriggerClientEvent('vorp:TipRight', source, message, 5000)
    elseif settings.notifications == 'redem' then
        TriggerClientEvent('redem_roleplay:ShowAdvancedRightNotification', source, message, 'GENERIC_TEXTURES', 'tick', 'COLOR_WHITE', 5000)
    else
        TriggerClientEvent('chat:addMessage', source, {
            args = { '[LXR]', message }
        })
    end
end

function Framework.HasPermission(source, permission)
    if Framework.Name == 'lxr-core' or Framework.Name == 'rsg-core' or 
       Framework.Name == 'qbr-core' or Framework.Name == 'qr-core' then
        local Player = Framework.GetPlayer(source)
        if Player then
            return Player.PlayerData.job.grade.level >= 4 or IsPlayerAceAllowed(source, permission)
        end
    elseif Framework.Name == 'vorp_core' then
        local User = Framework.GetPlayer(source)
        if User then
            return User.getGroup() == 'admin' or IsPlayerAceAllowed(source, permission)
        end
    elseif Framework.Name == 'redem_roleplay' then
        local Player = Framework.GetPlayer(source)
        if Player then
            return Player.getGroup() == 'admin' or IsPlayerAceAllowed(source, permission)
        end
    end
    
    return IsPlayerAceAllowed(source, permission)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════════════

CreateThread(function()
    InitFramework()
end)
