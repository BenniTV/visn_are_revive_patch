-- load optional config; config.lua is declared as shared_script in fxmanifest
local ok, C = pcall(function() return Config end)
if not ok or not C then
    C = {}
    C.Debug = true
    C.LogPrefix = "[visn_are_sync_fix]"
    C.UseGameEvent = true
    C.SyncOnReset = true
end

local function dbg(...)
    if not C.Debug then return end
    local parts = {}
    for i = 1, select('#', ...) do
        parts[#parts+1] = tostring(select(i, ...))
    end
    print(C.LogPrefix .. " " .. table.concat(parts, " "))
end

local lastDeadState = false

-- Helper wrappers with debug
local function setEsxDead(val)
    TriggerEvent('esx:setDead', val)
    dbg('esx:setDead ->', tostring(val))
end

local function setOxWeaponWheel(enabled)
    if exports and exports.ox_inventory then
        local ok2 = pcall(function() exports.ox_inventory:weaponWheel(enabled) end)
        dbg('ox_inventory:weaponWheel ->', tostring(enabled), 'success=', tostring(ok2))
    else
        dbg('ox_inventory export not available')
    end
end

-- Event-basierte Überwachung: Reagiert nur bei Statusänderung
RegisterNetEvent('visn_are:resetHealthBuffer', function()
    dbg('Event visn_are:resetHealthBuffer received')
    if not C.SyncOnReset then return end
    if lastDeadState then
        lastDeadState = false
        setEsxDead(false)
        setOxWeaponWheel(true)
    end
end)

-- Überwacht Statusänderungen (nur bei Events, kein Polling)
if C.UseGameEvent then
    AddEventHandler('gameEventTriggered', function(name, args)
        if name ~= 'CEventNetworkEntityDamage' then return end
        local ok3, healthBuffer = pcall(function() return exports['visn_are']:GetHealthBuffer() end)
        if not ok3 or not healthBuffer then
            dbg('GetHealthBuffer failed or returned nil')
            return
        end
        if healthBuffer.unconscious ~= lastDeadState then
            dbg('Dead state changed', tostring(lastDeadState), '->', tostring(healthBuffer.unconscious))
            lastDeadState = healthBuffer.unconscious
            setEsxDead(healthBuffer.unconscious)
            setOxWeaponWheel(not healthBuffer.unconscious)
        end
    end)
else
    dbg('UseGameEvent disabled in config')
end

dbg('visn_are_sync_fix initialized; Debug=', tostring(C.Debug))
