## Installation

1. **Resource in server.cfg einfügen:**
   ```cfg
   ensure visn_are_sync_fix
   ```

2. **Startreihenfolge beachten:**
   ```cfg
   ensure es_extended
   ensure ox_inventory
   ensure visn_are
   ensure visn_are_sync_fix  # Nach allen anderen laden
   ```

3. **Server neustarten**

## Funktionsweise

Das Script reagiert auf zwei Events:
- `visn_are:resetHealthBuffer` - Wird bei Wiederbelebung getriggert
- `gameEventTriggered` (Damage) - Erkennt Statusänderungen beim Tod

Bei jeder Änderung wird:
1. Der ESX Dead-Status neu gesetzt (`esx:setDead`)
2. Das ox_inventory Weapon-Wheel aktiviert/deaktiviert

## Kompatibilität
- ESX Legacy (neueste Version)
- ox_inventory (neueste Version)
- visn_Are Medical Script

## Support
Bei Problemen prüfe:
1. Ist die Startreihenfolge korrekt?
2. Sind alle Dependencies installiert?
3. Console-Errors beim Serverstart?
