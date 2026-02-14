--[[
    ██╗     ██╗  ██╗██████╗         ██████╗██╗     ██╗███████╗███╗   ██╗████████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝██║     ██║██╔════╝████╗  ██║╚══██╔══╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║     ██║█████╗  ██╔██╗ ██║   ██║   
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║     ██║██╔══╝  ██║╚██╗██║   ██║   
    ███████╗██╔╝ ██╗██║  ██║      ╚██████╗███████╗██║███████╗██║ ╚████║   ██║   
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═════╝╚══════╝╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝   
    
    🐺 LXR Player Limits - Client Framework
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
        print(string.format('[LXR-PlayerLimits] [Client] Framework detected: %s', Framework.Name))
    end
    
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
-- INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════════════

CreateThread(function()
    InitFramework()
end)
