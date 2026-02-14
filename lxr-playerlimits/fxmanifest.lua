--[[
    ██╗     ██╗  ██╗██████╗        ██████╗ ██╗      █████╗ ██╗   ██╗███████╗██████╗ 
    ██║     ╚██╗██╔╝██╔══██╗      ██╔══██╗██║     ██╔══██╗╚██╗ ██╔╝██╔════╝██╔══██╗
    ██║      ╚███╔╝ ██████╔╝█████╗██████╔╝██║     ███████║ ╚████╔╝ █████╗  ██████╔╝
    ██║      ██╔██╗ ██╔══██╗╚════╝██╔═══╝ ██║     ██╔══██║  ╚██╔╝  ██╔══╝  ██╔══██╗
    ███████╗██╔╝ ██╗██║  ██║      ██║     ███████╗██║  ██║   ██║   ███████╗██║  ██║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═╝     ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝
    
    🐺 LXR Core - RedM Player Limits Removal System
    Version: 1.0.0
    Author: iBoss21 / The Lux Empire
    Server: wolves.land
]]

fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

game 'rdr3'

author 'iBoss21 / The Lux Empire'
description '🐺 LXR Core - RedM Player Limits Removal System | Extends RedM beyond 31 physical players | wolves.land'
version '1.0.0'

-- ═══════════════════════════════════════════════════════════════════════════════
-- RESOURCE METADATA
-- ═══════════════════════════════════════════════════════════════════════════════

lua54 'yes'

-- ═══════════════════════════════════════════════════════════════════════════════
-- SHARED FILES
-- ═══════════════════════════════════════════════════════════════════════════════

shared_scripts {
    'config.lua'
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- SERVER FILES
-- ═══════════════════════════════════════════════════════════════════════════════

server_scripts {
    'server/framework.lua',
    'server/main.lua',
    'server/monitoring.lua',
    'server/commands.lua',
    'server/events.lua'
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- CLIENT FILES
-- ═══════════════════════════════════════════════════════════════════════════════

client_scripts {
    'client/framework.lua',
    'client/main.lua',
    'client/optimization.lua'
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- DEPENDENCIES
-- ═══════════════════════════════════════════════════════════════════════════════

-- Optional dependencies (detected at runtime)
-- dependencies {
--     'lxr-core',
--     'rsg-core',
--     'vorp_core'
-- }

-- ═══════════════════════════════════════════════════════════════════════════════
-- EXPORTS
-- ═══════════════════════════════════════════════════════════════════════════════

-- Server exports
server_exports {
    'GetMaxPhysicalPlayers',
    'GetCurrentPlayerCount',
    'GetPhysicalPlayerLimit',
    'IsCustomBuildDetected',
    'GetPlayerCapacityPercent',
    'GetPhysicalSlotInfo'
}

-- Client exports
client_exports {
    'GetLocalPlayerPhysicalId',
    'IsExtendedBuildActive'
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- FILES
-- ═══════════════════════════════════════════════════════════════════════════════

files {
    'README.md',
    'TECHNICAL.md',
    'INSTALLATION.md'
}
