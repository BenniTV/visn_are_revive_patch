-- config.lua - Konfiguration für visn_are_sync_fix
-- Anpassbare Optionen
Config = {
    Debug = true,                 -- setze auf false um Debug-Ausgaben zu deaktivieren
    LogPrefix = "[visn_are_sync_fix]",
    UseGameEvent = true,          -- Überwache 'gameEventTriggered' (CEventNetworkEntityDamage)
    SyncOnReset = true,           -- synchronisiere beim 'visn_are:resetHealthBuffer' Event
}

return Config
