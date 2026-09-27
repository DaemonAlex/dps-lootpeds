--[[
    dps-lootpeds Configuration
    Model-Specific Loot Tables with State Bag Support

    DPS 2026-09-27: pockets like life. Every category rolls three kinds of thing:
    junk (high chance, worth nothing), useful (medium), juicy (rare). Cash mostly
    lives in the wallet item now (open it to find out), with a small direct roll.
]]

Config = {}

-- ═══════════════════════════════════════════════════════
-- GENERAL SETTINGS
-- ═══════════════════════════════════════════════════════

Config.Debug = false
Config.Locale = 'en'

-- System Behavior
Config.EnableOnStart = true
Config.UseTarget = true                  -- Use ox_target for interaction
Config.InteractionDistance = 2.5         -- Distance to interact with corpses

-- Body Handling (IMPORTANT: State Bags prevent re-looting WITHOUT deletion)
Config.DeletePedsWhenLooted = false      -- FALSE = Keep body, use State Bags
Config.UseStateBags = true               -- Sync looted status across all clients
Config.BodyDespawnTime = 300000          -- 5 minutes before marking for cleanup (if not deleted)

-- Admin Settings
Config.AdminOnly = false
Config.Commands = {
    toggle = 'lootpeds',                 -- /lootpeds on/off
    reload = 'reloadloot'                -- /reloadloot (admin: reload loot tables)
}

-- ═══════════════════════════════════════════════════════
-- LOOTING ANIMATION
-- ═══════════════════════════════════════════════════════

Config.Animation = {
    duration = 3000,                     -- Search time in ms
    dict = 'amb@medic@standing@kneel@base',
    clip = 'base',
    canCancel = true,
    disable = {
        move = true,
        car = true,
        combat = true
    }
}

-- ═══════════════════════════════════════════════════════
-- WALLET (used through ox_inventory: server export dps-lootpeds.usewallet)
-- ═══════════════════════════════════════════════════════

Config.Wallet = {
    cash = { min = 10, max = 140 },          -- most wallets
    fat = { chance = 6, min = 250, max = 600 }, -- the odd fat one
    extras = {                               -- what else is in there
        { item = 'creditcard', chance = 30 },
        { item = 'receipt', chance = 45 },
        { item = 'businesscard', chance = 20 },
        { item = 'scratchcard', chance = 12 },
        { item = 'coupon', chance = 15 },
        { item = 'giftcard', chance = 6 },
        { item = 'photo', chance = 10 },
    }
}

-- ═══════════════════════════════════════════════════════
-- LOOT CATEGORIES
-- Patterns are substrings of the ped model name (first match wins, so keep
-- them specific: never a bare 'a_m_' that swallows another category).
-- ═══════════════════════════════════════════════════════

-- Shared pocket lint, spliced into most civilian tables
local JUNK = {
    { item = 'receipt', chance = 35 },
    { item = 'chewinggum', chance = 25 },
    { item = 'tissues', chance = 20 },
    { item = 'coins', chance = 40, amount = { 1, 3 } },
    { item = 'pen', chance = 15 },
    { item = 'housekeys', chance = 30 },
    { item = 'busticket', chance = 12 },
    { item = 'hairtie', chance = 10 },
    { item = 'mints', chance = 10 },
    { item = 'lighter', chance = 20 },
    { item = 'cigarette', chance = 18 },
}

local function withJunk(list)
    local out = {}
    for i = 1, #JUNK do out[#out + 1] = JUNK[i] end
    for i = 1, #list do out[#out + 1] = list[i] end
    return out
end

Config.PedCategories = {
    -- Police/Security
    police = {
        patterns = { 's_m_y_cop', 's_f_y_cop', 's_m_y_sheriff', 's_f_y_sheriff', 's_m_y_hwaycop',
                     's_m_m_security', 's_m_y_swat', 's_m_m_prisguard', 's_m_m_fiboffice',
                     's_m_m_ciasec', 's_m_m_chemsec', 's_m_y_devinsec', 'csb_cop' },
        cash = { min = 20, max = 80, chance = 30 },
        loot = withJunk({
            { item = 'radio', chance = 60 },
            { item = 'handcuffs', chance = 40 },
            { item = 'weapon_flashlight', chance = 50 },
            { item = 'weapon_nightstick', chance = 30 },
            { item = 'weapon_stungun', chance = 15 },
            { item = 'armor', chance = 25 },
            { item = 'pistol_ammo', chance = 70, amount = { 1, 3 } },
            { item = 'weapon_pistol', chance = 10 },
            { item = 'weapon_combatpistol', chance = 5 },
            { item = 'wallet', chance = 60 },
            { item = 'phone', chance = 50 },
            { item = 'coffee', chance = 35 },
            { item = 'donut', chance = 30 },
            { item = 'notebook', chance = 25 },
        })
    },

    -- Gang Members
    gang = {
        patterns = { 'g_m_', 'g_f_', 'csb_ballasog', 'csb_vagspeak', 'a_m_y_mexthug' },
        cash = { min = 60, max = 400, chance = 60 },
        loot = withJunk({
            { item = 'weed_brick', chance = 12 },
            { item = 'coke_bag', chance = 8 },
            { item = 'meth_baggy', chance = 10 },
            { item = 'joint', chance = 40 },
            { item = 'lockpick', chance = 30 },
            { item = 'weapon_knife', chance = 35 },
            { item = 'weapon_switchblade', chance = 30 },
            { item = 'weapon_bat', chance = 15 },
            { item = 'weapon_pistol', chance = 18 },
            { item = 'weapon_microsmg', chance = 5 },
            { item = 'pistol_ammo', chance = 50, amount = { 1, 5 } },
            { item = 'smg_ammo', chance = 20, amount = { 1, 3 } },
            { item = 'markedbills', chance = 15 },
            { item = 'goldchain', chance = 10 },
            { item = 'phone', chance = 55 },
            { item = 'oldphone', chance = 25 },
            { item = 'vape', chance = 25 },
            { item = 'fakerolex', chance = 12 },
            { item = 'carkeys', chance = 10 },
        })
    },

    -- Medical/EMS
    medical = {
        patterns = { 's_m_m_paramedic', 's_f_y_scrubs', 's_m_y_autopsy', 's_m_m_doctor', 'csb_trafficwarden' },
        cash = { min = 20, max = 80, chance = 40 },
        loot = withJunk({
            { item = 'bandage', chance = 80 },
            { item = 'firstaid', chance = 40 },
            { item = 'painkillers', chance = 60 },
            { item = 'ifak', chance = 20 },
            { item = 'medkit', chance = 10 },
            { item = 'phone', chance = 50 },
            { item = 'wallet', chance = 55 },
            { item = 'coffee', chance = 40 },
            { item = 'keycard', chance = 30 },
        })
    },

    -- Construction/Industrial/Trades
    worker = {
        patterns = { 's_m_y_construct', 's_m_y_dockwork', 's_m_m_dockwork', 's_m_m_gardener', 's_m_m_trucker',
                     's_m_y_garbage', 's_m_m_ups', 's_m_y_xmech', 's_m_m_autoshop', 's_m_m_janitor',
                     's_m_m_migrant', 's_f_y_migrant', 's_m_y_pestcont', 's_m_m_postal', 's_m_m_lathandy',
                     's_m_m_mariachi', 'a_m_m_mexlabor' },
        cash = { min = 10, max = 60, chance = 50 },
        loot = withJunk({
            { item = 'weapon_wrench', chance = 30 },
            { item = 'weapon_hammer', chance = 25 },
            { item = 'screwdriverset', chance = 30 },
            { item = 'repairkit', chance = 15 },
            { item = 'duct_tape', chance = 40 },
            { item = 'metalscrap', chance = 50 },
            { item = 'plastic', chance = 35 },
            { item = 'sandwich', chance = 60 },
            { item = 'coffee', chance = 55 },
            { item = 'wallet', chance = 55 },
            { item = 'phone', chance = 45 },
            { item = 'oldphone', chance = 20 },
            { item = 'water', chance = 40 },
        })
    },

    -- Beach/Tourist
    beach = {
        patterns = { 'a_m_y_beach', 'a_f_y_beach', 'a_m_y_surfer', 'a_f_y_topless',
                     'a_m_y_sunbathe', 's_m_y_baywatch', 's_f_y_baywatch', 'a_m_y_jetski',
                     'a_m_o_beach', 'a_m_m_trampbeac', 'a_m_y_musclbeac' },
        cash = { min = 5, max = 40, chance = 35 },
        loot = withJunk({
            { item = 'water', chance = 70 },
            { item = 'sunscreen', chance = 50 },
            { item = 'sunglasses', chance = 45 },
            { item = 'phone', chance = 55 },
            { item = 'wallet', chance = 35 },
            { item = 'sandwich', chance = 30 },
            { item = 'joint', chance = 15 },
            { item = 'earbuds', chance = 30 },
            { item = 'condom', chance = 12 },
        })
    },

    -- Tourists proper
    tourist = {
        patterns = { 'a_m_m_tourist', 'a_f_m_tourist', 'a_f_y_tourist', 'a_m_y_tourist', 'a_m_m_paparazzi' },
        cash = { min = 20, max = 120, chance = 50 },
        loot = withJunk({
            { item = 'camera', chance = 40 },
            { item = 'phone', chance = 70 },
            { item = 'wallet', chance = 70 },
            { item = 'sunglasses', chance = 40 },
            { item = 'water', chance = 50 },
            { item = 'keycard', chance = 35 },
            { item = 'powerbank', chance = 25 },
            { item = 'umbrella', chance = 10 },
            { item = 'photo', chance = 20 },
            { item = 'cheapwatch', chance = 25 },
        })
    },

    -- Business/Rich
    business = {
        patterns = { 'a_m_y_business', 'a_f_y_business', 'a_m_m_business', 'a_f_m_business',
                     'a_m_y_bevhills', 'a_f_y_bevhills', 'a_m_m_bevhills', 'a_f_m_bevhills',
                     'a_m_y_vinewood', 'a_f_y_vinewood', 'u_m_m_bankman', 'ig_bankman',
                     'a_m_y_golfer', 'a_m_m_golfer', 'a_f_y_golfer', 'a_m_y_tennis', 'a_f_y_tennis',
                     'a_m_m_malibu', 'a_f_y_scdressy', 'a_m_y_smartcaspat', 'a_m_m_og_boss' },
        cash = { min = 60, max = 400, chance = 55 },
        loot = withJunk({
            { item = 'phone', chance = 85 },
            { item = 'wallet', chance = 85 },
            { item = 'creditcard', chance = 35 },
            { item = 'rolex', chance = 8 },
            { item = 'diamond_watch', chance = 4 },
            { item = 'silver_watch', chance = 12 },
            { item = 'goldchain', chance = 8 },
            { item = 'diamond_ring', chance = 4 },
            { item = 'golden_ring', chance = 6 },
            { item = 'cigar', chance = 25 },
            { item = 'carkeys', chance = 30 },
            { item = 'businesscard', chance = 50 },
            { item = 'perfume', chance = 20 },
            { item = 'sunglasses', chance = 30 },
            { item = 'casino_chips', chance = 10, amount = { 5, 60 } },
            { item = 'laptop', chance = 5 },
        })
    },

    -- Club and nightlife
    clubber = {
        patterns = { 'a_m_y_clubcust', 'a_f_y_clubcust', 's_f_y_stripper', 's_m_m_strperf', 'a_m_y_gay',
                     'a_f_y_juggalo', 'a_m_y_juggalo', 's_m_y_clubbar', 's_f_y_clubbar', 'a_m_y_downtown' },
        cash = { min = 20, max = 200, chance = 55 },
        loot = withJunk({
            { item = 'phone', chance = 75 },
            { item = 'wallet', chance = 60 },
            { item = 'vape', chance = 40 },
            { item = 'joint', chance = 25 },
            { item = 'cocaine_baggy', chance = 8 },
            { item = 'condom', chance = 35 },
            { item = 'lipstick', chance = 30 },
            { item = 'perfume', chance = 15 },
            { item = 'fakerolex', chance = 15 },
            { item = 'silver_ring', chance = 8 },
            { item = 'earbuds', chance = 25 },
            { item = 'casino_chips', chance = 6, amount = { 2, 20 } },
        })
    },

    -- Students, hipsters, young city crowd
    young = {
        patterns = { 'a_m_y_hipster', 'a_f_y_hipster', 'a_m_y_hippy', 'a_f_y_hippie', 'a_m_y_stbla',
                     'a_m_y_stlat', 'a_m_y_stwhi', 'a_f_y_genhot', 'a_m_y_genstreet', 'a_f_y_genstreet',
                     'a_m_y_skater', 'a_f_y_skater', 'a_m_y_epsilon', 'a_f_y_epsilon', 'a_m_y_latino',
                     'a_m_y_ktown', 'a_m_y_indian', 'a_f_y_indian', 'a_m_y_soucent', 'a_f_y_soucent',
                     'a_m_y_eastsa', 'a_f_y_eastsa', 'a_m_y_hasjew', 'a_m_y_dhill', 'a_m_y_polynesian' },
        cash = { min = 5, max = 60, chance = 45 },
        loot = withJunk({
            { item = 'phone', chance = 80 },
            { item = 'wallet', chance = 55 },
            { item = 'earbuds', chance = 45 },
            { item = 'vape', chance = 35 },
            { item = 'joint', chance = 20 },
            { item = 'powerbank', chance = 20 },
            { item = 'notebook', chance = 15 },
            { item = 'sunglasses', chance = 25 },
            { item = 'oldphone', chance = 15 },
            { item = 'cheapwatch', chance = 20 },
            { item = 'sprunk', chance = 25 },
        })
    },

    -- Joggers, cyclists, gym
    fitness = {
        patterns = { 'a_m_y_runner', 'a_f_y_runner', 'a_m_y_cyclist', 'a_m_y_roadcyc', 'a_f_y_fitness',
                     'a_m_y_fitness', 'a_f_y_yoga', 'a_m_y_yoga', 'a_m_y_hiker', 'a_f_y_hiker' },
        cash = { min = 0, max = 20, chance = 20 },
        loot = {
            { item = 'water', chance = 80 },
            { item = 'earbuds', chance = 60 },
            { item = 'phone', chance = 65 },
            { item = 'housekeys', chance = 50 },
            { item = 'hairtie', chance = 30 },
            { item = 'sunscreen', chance = 20 },
            { item = 'cheapwatch', chance = 30 },
            { item = 'coins', chance = 20, amount = { 1, 2 } },
        }
    },

    -- Older folks
    elderly = {
        patterns = { 'a_m_o_genstreet', 'a_f_o_genstreet', 'a_m_o_soucent', 'a_f_o_soucent', 'a_m_o_ktown',
                     'a_f_o_ktown', 'a_m_o_salton', 'a_f_o_salton', 'a_f_o_indian', 'a_m_o_acult' },
        cash = { min = 10, max = 90, chance = 60 },
        loot = withJunk({
            { item = 'wallet', chance = 75 },
            { item = 'oldphone', chance = 40 },
            { item = 'newspaper', chance = 45 },
            { item = 'painkillers', chance = 40 },
            { item = 'tissues', chance = 40 },
            { item = 'mints', chance = 35 },
            { item = 'photo', chance = 25 },
            { item = 'umbrella', chance = 20 },
            { item = 'coupon', chance = 30 },
            { item = 'silver_watch', chance = 6 },
            { item = 'golden_ring', chance = 5 },
        })
    },

    -- County: farmers, hillbillies, Salton
    country = {
        patterns = { 'a_m_m_hillbilly', 'a_m_m_farmer', 'a_m_m_rurmeth', 'a_f_y_rurmeth', 'a_m_m_salton',
                     'a_f_m_salton', 'a_m_y_salton', 'a_m_m_mexcntry', 'a_m_m_acult', 'a_m_y_acult',
                     'a_f_m_fatcult', 'a_f_m_prolhost', 'a_m_m_prolhost' },
        cash = { min = 5, max = 70, chance = 50 },
        loot = withJunk({
            { item = 'wallet', chance = 55 },
            { item = 'pocketknife', chance = 40 },
            { item = 'cigarette', chance = 40 },
            { item = 'lighter', chance = 45 },
            { item = 'oldphone', chance = 35 },
            { item = 'phone', chance = 30 },
            { item = 'water', chance = 30 },
            { item = 'weapon_knife', chance = 10 },
            { item = 'meth_baggy', chance = 8 },
            { item = 'duct_tape', chance = 20 },
            { item = 'scratchcard', chance = 25 },
            { item = 'carkeys', chance = 15 },
        })
    },

    -- Service and shop staff
    staff = {
        patterns = { 's_m_m_bouncer', 's_m_y_barman', 's_f_y_bartender', 's_m_y_waiter', 's_f_y_shop',
                     's_f_m_shop', 's_m_m_linecook', 's_m_y_chef', 's_m_y_busboy', 's_m_y_ammucity',
                     's_m_m_ammucountry', 's_m_y_airworker', 's_f_y_airhostess', 's_m_m_lifeinvad',
                     's_m_m_movprem', 's_m_y_valet', 's_f_y_sweatshop', 's_m_m_highsec', 's_m_y_shop_mask' },
        cash = { min = 10, max = 90, chance = 55 },
        loot = withJunk({
            { item = 'wallet', chance = 60 },
            { item = 'phone', chance = 65 },
            { item = 'keycard', chance = 40 },
            { item = 'coffee', chance = 30 },
            { item = 'sandwich', chance = 25 },
            { item = 'notebook', chance = 20 },
            { item = 'vape', chance = 20 },
            { item = 'coins', chance = 60, amount = { 2, 6 } },
        })
    },

    -- Street workers and dealers
    street = {
        patterns = { 's_f_y_hooker', 's_m_y_dealer', 'a_m_y_methhead' },
        cash = { min = 20, max = 250, chance = 65 },
        loot = withJunk({
            { item = 'phone', chance = 70 },
            { item = 'oldphone', chance = 30 },
            { item = 'condom', chance = 50 },
            { item = 'lipstick', chance = 30 },
            { item = 'joint', chance = 30 },
            { item = 'cocaine_baggy', chance = 15 },
            { item = 'crack_baggy', chance = 15 },
            { item = 'crackpipe', chance = 25 },
            { item = 'pocketknife', chance = 25 },
            { item = 'markedbills', chance = 10 },
            { item = 'fakerolex', chance = 10 },
        })
    },

    -- Homeless/Vagrant
    homeless = {
        patterns = { 'a_m_m_tramp', 'a_f_m_tramp', 'a_m_o_tramp', 'a_m_m_skidrow',
                     'a_f_m_skidrow', 'u_m_o_tramp' },
        cash = { min = 1, max = 12, chance = 25 },
        loot = {
            { item = 'coins', chance = 60, amount = { 1, 4 } },
            { item = 'water', chance = 25 },
            { item = 'burger', chance = 20 },
            { item = 'weapon_bottle', chance = 40 },
            { item = 'lighter', chance = 60 },
            { item = 'cigarette', chance = 40 },
            { item = 'joint', chance = 25 },
            { item = 'crackpipe', chance = 25 },
            { item = 'newspaper', chance = 45 },
            { item = 'scratchcard', chance = 30 },
            { item = 'receipt', chance = 30 },
            { item = 'oldphone', chance = 15 },
            { item = 'dogtag', chance = 5 },
        }
    },

    -- Inmates
    inmate = {
        patterns = { 's_m_y_prisoner', 's_m_y_prismuscl', 'u_m_y_prisoner' },
        cash = { min = 0, max = 10, chance = 15 },
        loot = {
            { item = 'cigarette', chance = 60 },
            { item = 'lighter', chance = 40 },
            { item = 'pocketknife', chance = 20 },
            { item = 'chewinggum', chance = 30 },
            { item = 'photo', chance = 20 },
            { item = 'coins', chance = 25, amount = { 1, 2 } },
        }
    },

    -- Military
    military = {
        patterns = { 's_m_m_marine', 's_m_y_marine', 's_m_y_armymech', 's_m_y_blackops',
                     's_m_m_pilot_01', 's_m_m_pilot_02', 's_m_y_pilot' },
        cash = { min = 20, max = 150, chance = 30 },
        loot = withJunk({
            { item = 'armor', chance = 50 },
            { item = 'weapon_combatpistol', chance = 30 },
            { item = 'weapon_carbinerifle', chance = 10 },
            { item = 'rifle_ammo', chance = 60, amount = { 2, 5 } },
            { item = 'pistol_ammo', chance = 70, amount = { 2, 4 } },
            { item = 'radio', chance = 50 },
            { item = 'mre', chance = 40 },
            { item = 'bandage', chance = 60 },
            { item = 'dogtag', chance = 70 },
            { item = 'wallet', chance = 40 },
        })
    },

    -- Default (everyone else)
    default = {
        patterns = {}, -- Fallback for unmatched peds
        cash = { min = 5, max = 60, chance = 40 },
        loot = withJunk({
            { item = 'phone', chance = 55 },
            { item = 'wallet', chance = 55 },
            { item = 'water', chance = 30 },
            { item = 'sandwich', chance = 25 },
            { item = 'earbuds', chance = 20 },
            { item = 'sunglasses', chance = 15 },
            { item = 'oldphone', chance = 15 },
            { item = 'bandage', chance = 10 },
            { item = 'carkeys', chance = 8 },
            { item = 'lockpick', chance = 4 },
            { item = 'weapon_knife', chance = 6 },
            { item = 'cheapwatch', chance = 12 },
            { item = 'silver_ring', chance = 3 },
        })
    }
}

-- ═══════════════════════════════════════════════════════
-- CASH SETTINGS
-- ═══════════════════════════════════════════════════════

Config.Cash = {
    Type = 'cash',      -- 'cash' or 'bank'
    Dirty = false,      -- Use dirty money instead (if your server has it)
    DirtyItem = 'markedbills'  -- Item name for dirty money
}

-- ═══════════════════════════════════════════════════════
-- POLICE INTEGRATION (Optional)
-- ═══════════════════════════════════════════════════════

Config.PoliceIntegration = {
    enabled = false,                     -- Enable police alerts
    alertOnLoot = true,                  -- Alert police when someone loots a body
    policeJobs = { 'police', 'bcso', 'sasp', 'rpd', 'rcso' },
    minPoliceOnline = 2,                 -- Minimum police needed for alerts
    alertChance = 25,                    -- % chance to trigger alert
}

-- ═══════════════════════════════════════════════════════
-- EVIDENCE SYSTEM (Optional - for ps-evidence/qb-evidence)
-- ═══════════════════════════════════════════════════════

Config.Evidence = {
    enabled = false,                     -- Leave evidence when looting
    fingerprints = true,                 -- Leave fingerprints on body
    dna = false,                         -- Leave DNA (requires gloves check)
}

-- ═══════════════════════════════════════════════════════
-- RESTRICT LOOTING
-- ═══════════════════════════════════════════════════════

Config.Restrictions = {
    requireItem = false,                 -- Require an item to loot
    requiredItem = 'lockpick',           -- Item needed
    consumeItem = false,                 -- Consume the item when looting

    -- Ped model blacklist (cannot loot these)
    blacklistedPeds = {
        -- Main story characters
        'player_zero',      -- Michael
        'player_one',       -- Franklin
        'player_two',       -- Trevor
        -- Add any other peds you don't want looted
    },

    -- Only allow looting if player has certain jobs
    jobRestricted = false,
    allowedJobs = { 'unemployed' },      -- If restricted, only these jobs can loot
}

-- ═══════════════════════════════════════════════════════
-- PED MODELS - Full list for ox_target
-- These are all peds that CAN be looted
-- ═══════════════════════════════════════════════════════

Config.UseAllPeds = true                 -- If true, allows looting any dead NPC ped

-- If UseAllPeds is false, only these specific models can be looted
Config.PedModels = {
    -- Add specific models here if UseAllPeds = false
    -- Example: "a_m_y_hipster_01", "g_m_y_ballasout_01"
}
