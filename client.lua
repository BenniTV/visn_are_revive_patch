
local lastDeadState = false

-- Event-basierte Überwachung: Reagiert nur bei Statusänderung
RegisterNetEvent('visn_are:resetHealthBuffer', function()
    -- Spieler wurde wiederbelebt
    if lastDeadState then
        lastDeadState = false
        TriggerEvent('esx:setDead', false)
        exports.ox_inventory:weaponWheel(true)
    end
end)

-- Überwacht Statusänderungen (nur bei Events, kein Polling)
AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventNetworkEntityDamage' then
        local healthBuffer = exports['visn_are']:GetHealthBuffer()
        if healthBuffer.unconscious ~= lastDeadState then
            lastDeadState = healthBuffer.unconscious
            TriggerEvent('esx:setDead', healthBuffer.unconscious)
            exports.ox_inventory:weaponWheel(not healthBuffer.unconscious)
        end
    end
end)
