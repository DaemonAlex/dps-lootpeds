# DPS LootPeds

A modern, State Bag synced ped looting system for FiveM with model-specific loot tables.

![Version](https://img.shields.io/badge/version-3.0.0-blue)
![Framework](https://img.shields.io/badge/framework-QB%20%7C%20QBX%20%7C%20ESX-green)
![License](https://img.shields.io/badge/license-GPL--3.0-orange)

## Status

Running on DelPerroSands since 12 November 2026, in light-loot mode.

## What it is for

It lets a player search a dead NPC and take what was in their pockets. What you find depends on
who the NPC was. A police officer carries different things from a builder or a tourist.

## On its own, and with other scripts

**On its own.** It needs `ox_lib`, `ox_target`, a framework (Qbox, QBCore or ESX) and an
inventory. The player uses the eye on a body, kneels for three seconds and gets items and a
little cash. The body stays where it is and shows "[SEARCHED]" to everyone, so it cannot be
looted twice. The code has 18 kinds of NPC, each with its own loot list. The tables below are
from version 3.0.0 and still say 8.

**With ox_inventory.** Loot goes into the player's inventory. The `wallet` item is used through
ox_inventory: the player opens it and finds cash and sometimes a card, a receipt or a scratch
card. The script also has code for qs-inventory, qb-inventory and codem-inventory. DelPerroSands
does not run those.

**With a paid MDT (wasabi_mdt).** If police alerts are turned on, a looting sends a dispatch call
to the MDT. If the MDT call fails, on-duty police get a plain notification. Police alerts are off
in the config by default.

**With qs-dispatch.** Used for the alert only when wasabi_mdt is not running.

**With ps-evidence.** If evidence is turned on, looting leaves a fingerprint. It is off by
default, and DelPerroSands does not run ps-evidence.

## What Makes This Different?

| Feature | Old Scripts | DPS LootPeds |
|---------|-------------|--------------|
| Anti-Re-Loot | Delete body OR local table | **State Bags** (synced) |
| Body Handling | Delete = immersion break | Keep body, mark as searched |
| Loot Tables | Same for all peds | **Model-specific** (8 categories) |
| Framework | Single framework | **QB/QBX/ESX** bridge |
| Inventory | Single inventory | **ox/qs/qb** bridge |

## Features

### Core
- **State Bag Sync** - Looted status synced across ALL clients
- **Keep Bodies** - No more vanishing corpses (configurable)
- **Visual Indicator** - "[SEARCHED]" text above looted bodies

### Model-Specific Loot
Different peds drop different items:

| Category | Examples | Loot |
|----------|----------|------|
| **Police** | Cops, Security, SWAT | Radio, handcuffs, armor, pistol ammo |
| **Gang** | Ballas, Vagos, Lost MC | Drugs, dirty money, knives, guns |
| **Medical** | Paramedics, Nurses | Bandages, medkits, painkillers |
| **Worker** | Construction, Truckers | Tools, scraps, sandwiches |
| **Beach** | Surfers, Lifeguards | Water, sunscreen, phone |
| **Business** | Suits, Beverly Hills | Cash, jewelry, wallet, creditcard |
| **Homeless** | Tramps, Methheads | Bottles, lighters, drugs |
| **Military** | Marines, Pilots | Armor, rifles, MREs |

### Optional Integrations
- **Police Alerts** - Alert cops when someone loots a body
- **Evidence System** - Leave fingerprints (ps-evidence)
- **qs-dispatch** - Full dispatch integration

## Installation

1. **Download** and extract to your resources folder
2. **Configure** `shared/config.lua`
3. **Add to server.cfg**:
```cfg
ensure ox_lib
ensure ox_target
ensure dps-lootpeds
```

## Dependencies

### Required
- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_target](https://github.com/overextended/ox_target)

### Supported Frameworks
- QBCore
- QBX (Qbox)
- ESX

### Supported Inventories
- ox_inventory
- qs-inventory
- qb-inventory
- codem-inventory

## Configuration

### Basic Settings
```lua
Config.EnableOnStart = true          -- Enable on server start
Config.UseStateBags = true           -- Use State Bags (recommended)
Config.DeletePedsWhenLooted = false  -- Keep bodies (recommended)
Config.UseAllPeds = true             -- Loot any dead NPC
```

### Model-Specific Loot Tables
```lua
Config.PedCategories = {
    gang = {
        patterns = { 'g_m_', 'g_f_' },  -- Matches all gang peds
        cash = { min = 100, max = 500, chance = 70 },
        loot = {
            { item = 'weed_brick', chance = 25 },
            { item = 'weapon_pistol', chance = 25 },
            { item = 'lockpick', chance = 35 },
        }
    },
    -- Add more categories...
}
```

### Restrictions
```lua
Config.Restrictions = {
    requireItem = false,           -- Need an item to loot
    requiredItem = 'lockpick',     -- Which item
    consumeItem = false,           -- Consume it on use
    jobRestricted = false,         -- Restrict to certain jobs
    blacklistedPeds = { 'player_zero' }  -- Can't loot these
}
```

## Commands

| Command | Description |
|---------|-------------|
| `/lootpeds on` | Enable looting system |
| `/lootpeds off` | Disable looting system |

## How State Bags Work

```
Player A loots body → Server sets Entity(ped).state.isLooted = true
                         ↓
                    State Bag syncs to ALL clients
                         ↓
Player B approaches → Checks Entity(ped).state.isLooted
                         ↓
                    Shows "[SEARCHED]" text, can't re-loot
```

**Benefits:**
- No body deletion required
- Synced across all players
- Survives player disconnects
- No performance overhead

## Exports

### Client
```lua
-- Check if system is enabled
exports['dps-lootpeds']:IsSystemEnabled()

-- Check if a specific ped is looted
exports['dps-lootpeds']:IsPedLooted(pedEntity)

-- Manually trigger looting
exports['dps-lootpeds']:LootPed(pedEntity)
```

## Police Integration

Enable police alerts when players loot bodies:

```lua
Config.PoliceIntegration = {
    enabled = true,
    alertOnLoot = true,
    policeJobs = { 'police', 'bcso' },
    minPoliceOnline = 2,
    alertChance = 25,  -- 25% chance
}
```

## Evidence Integration

Leave evidence when looting (requires ps-evidence):

```lua
Config.Evidence = {
    enabled = true,
    fingerprints = true,
    dna = false,
}
```

## Upgrading from mh-lootpeds

1. Remove `mh-lootpeds` from your resources
2. Add `dps-lootpeds`
3. The `provides` in fxmanifest ensures backwards compatibility

## Changelog

### v3.0.0 (Complete Rewrite)
- Added State Bag sync for looted status
- Added model-specific loot tables (8 categories)
- Added framework bridge (QB/QBX/ESX)
- Added inventory bridge (ox/qs/qb)
- Added police alert integration
- Added evidence system integration
- Added visual "[SEARCHED]" indicator
- Removed body deletion requirement
- Improved ox_target integration

### v2.1.0 (Original Fork)
- QBox compatibility
- qs-inventory support

## Credits

- **Original**: [mh-lootpeds](https://github.com/MaDHouSe79/mh-lootpeds) by MaDHouSe
- **Rewrite**: @daemonAlex / DPS Development

## License

GPL-3.0 License

## Recent changes

- **12 November 2026. Light loot, and back on the server.** A new `Config.Light` block makes a body give one or two small items and nothing else: no weapons, no ammunition, no loose cash, and nothing over 500 g. A wallet still holds its cash. The full loot tables are untouched, so setting `Config.Light.enabled = false` brings the full pockets back. The script is running on DelPerroSands again, which also makes the `wallet` item open.
- **12 November 2026.** README: status, what it is for, how it works alone and with paid scripts, other DPS scripts.
- **27 September 2026.** Pockets like life: 18 NPC categories, the wallet item, and six loot
  items that were missing from the inventory fixed.
- **18 August 2026.** Police alerts go to wasabi_mdt, with a direct notification as a fallback.
- **12 August 2026.** Version 3.1.0: security and performance fixes.

## Light loot

`Config.Light` in `shared/config.lua`:

| Setting | Default | Meaning |
|---|---|---|
| `enabled` | `true` | Turn light loot on. Off means the full loot tables. |
| `minItems`, `maxItems` | `1`, `2` | How many items a body gives. |
| `maxWeight` | `500` | The heaviest item, in grams, that counts as small. The weight comes from ox_inventory's item list. |
| `allowWeapons`, `allowAmmo` | `false` | Whether a body can give weapons or ammunition. |
| `maxAmount` | `1` | The most of one item. |
| `cash` | `false` | Whether a body gives loose cash. |

Items are picked by the same chances as the full tables, so a likely item stays likely. An item
the inventory does not know is skipped.

## Author

Made by [DaemonAlex](https://github.com/DaemonAlex) for DelPerroSands.

## Other DPS scripts

All of these are made for DelPerroSands and run together on one Qbox server. Each one works on
its own. The ones marked "pairs with" do more when both are running.

| Script | What it does |
|---|---|
| [dps-inventory](https://github.com/DaemonAlex/dps-inventory) | The inventory: ox_inventory with equipment slots, backpacks, armour plates and a self status panel, in the DelPerroSands colours. |
| [dps-medical](https://github.com/DaemonAlex/dps-medical) | Patient records, illness and diagnostic tests. A companion to wasabi_ambulance. Pairs with dps-inventory: symptoms and diagnoses show on the status panel. |
| [dps-insurance](https://github.com/DaemonAlex/dps-insurance) | Ties m-Insurance into the MDT, impound, hospital and medical chart. Pairs with dps-medical. |
| [dps-studio](https://github.com/DaemonAlex/dps-studio) | Build rooms, doors and portals in game from one panel (`/studio`), with owners and managers so staff do not have to support them. |
| [dps-shops](https://github.com/DaemonAlex/dps-shops) | Shop clerks who greet and react to a robbery, then player-owned shops. |
| [dps-fleet](https://github.com/DaemonAlex/dps-fleet) | Vehicle browser and workshop on one panel: extras, liveries and mods for emergency vehicles. |
| [dps-parking](https://github.com/DaemonAlex/dps-parking) | Parking with valet, impound, violations and reserved spots. |
| [dps-vehiclepersistence](https://github.com/DaemonAlex/dps-vehiclepersistence) | Vehicles stay where they were parked. Pairs with dps-parking. |
| [dps-towjob](https://github.com/DaemonAlex/dps-towjob) | Queue-based tow job with jg-mechanic integration. |
| [dps-services](https://github.com/DaemonAlex/dps-services) | Request a tow and follow it live on the lb-phone and lb-tablet. Pairs with dps-towjob. |
| [dps-autoshops](https://github.com/DaemonAlex/dps-autoshops) | Self-service repair shops when no mechanic is on duty. |
| [dps-cityworker](https://github.com/DaemonAlex/dps-cityworker) | City infrastructure job and career. |
| [dps-ainpcs](https://github.com/DaemonAlex/dps-ainpcs) | NPCs you can talk to, with trust, quests and intel. |
| [dps-badpeds](https://github.com/DaemonAlex/dps-badpeds) | Police interaction with NPCs: stops, arrests, intel and jail records. |
| [dps-gangwars](https://github.com/DaemonAlex/dps-gangwars) | Ambient gang NPCs, territory population and war reinforcements. |
| [dps-rotations](https://github.com/DaemonAlex/dps-rotations) | Moves dealers, harvests and other spots on a fixed schedule. |
| [dps-trains](https://github.com/DaemonAlex/dps-trains) | The train system. Pairs with dps-trains-stock, dps-traintools and dps-transitapp. |
| [dps-transitapp](https://github.com/DaemonAlex/dps-transitapp) | Live train arrival boards on the lb-phone. |
| [dps-faceplant](https://github.com/DaemonAlex/dps-faceplant) | City help, reports and staff tools on the lb-phone and lb-tablet. |
| [dps-chat](https://github.com/DaemonAlex/dps-chat) | A command box for voice-only servers. No chat feed. |
| [dps-filmmode](https://github.com/DaemonAlex/dps-filmmode) | One key hides every HUD layer and gives a smooth free camera for recording. |
