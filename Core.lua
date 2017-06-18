local BonusRollFilter = LibStub("AceAddon-3.0"):NewAddon("BonusRollFilter", "AceConsole-3.0", "AceHook-3.0")
local BRF_ShowBonusRoll = false
local BRF_RollFrame = nil
local BRF_UserAction = false

local BRF_NightholdEncounters = {1706,1725,1731,1751,1762,1713,1761,1732,1743,1737}
local BRF_NightmareEncounters = {1703,1744,1738,1667,1704,1750,1726}
local BRF_TrialOfValorEncounters = {1819, 1830, 1829}
local BRF_WorldBossEncounters = {1790,1956,1883,1774,1789,1795,1770,1769,1884,1783,1749,1763,1885,1756,1796}
local BRF_TombOfSargerasEncounters = {1862, 1867, 1856, 1903, 1861, 1896, 1897, 1873, 1898}

local BonusRollFilter_OptionsDefaults = {
    profile = {
        [14] = {
            -- Nighthold
            [1706] = false,
            [1725] = false,
            [1731] = false,
            [1751] = false,
            [1762] = false,
            [1713] = false,
            [1761] = false,
            [1732] = false,
            [1743] = false,
            [1737] = false,
            -- Emerald Nightmare
            [1703] = false,
            [1744] = false,
            [1738] = false,
            [1667] = false,
            [1704] = false,
            [1750] = false,
            [1726] = false,
            -- Trial of Valor
            [1819] = false,
            [1830] = false,
            [1829] = false,
            -- World bosses
            [1790] = false,
            [1956] = false,
            [1883] = false,
            [1774] = false,
            [1789] = false,
            [1795] = false,
            [1770] = false,
            [1769] = false,
            [1884] = false,
            [1783] = false,
            [1749] = false,
            [1763] = false,
            [1885] = false,
            [1756] = false,
            [1796] = false,
            -- Tomb of Sargeras
            [1862] = false, 
            [1867] = false, 
            [1856] = false, 
            [1903] = false, 
            [1861] = false, 
            [1896] = false, 
            [1897] = false, 
            [1873] = false, 
            [1898] = false
        },
        [15] = {
            -- Nighthold
            [1706] = false,
            [1725] = false,
            [1731] = false,
            [1751] = false,
            [1762] = false,
            [1713] = false,
            [1761] = false,
            [1732] = false,
            [1743] = false,
            [1737] = false,
            -- Emerald Nightmare
            [1703] = false,
            [1744] = false,
            [1738] = false,
            [1667] = false,
            [1704] = false,
            [1750] = false,
            [1726] = false,
            -- Trial of Valor
            [1819] = false,
            [1830] = false,
            [1829] = false,
            -- Tomb of Sargeras
            [1862] = false, 
            [1867] = false, 
            [1856] = false, 
            [1903] = false, 
            [1861] = false, 
            [1896] = false, 
            [1897] = false, 
            [1873] = false, 
            [1898] = false
        },
        [16] = {
            -- Nighthold
            [1706] = false,
            [1725] = false,
            [1731] = false,
            [1751] = false,
            [1762] = false,
            [1713] = false,
            [1761] = false,
            [1732] = false,
            [1743] = false,
            [1737] = false,
            -- Emerald Nightmare
            [1703] = false,
            [1744] = false,
            [1738] = false,
            [1667] = false,
            [1704] = false,
            [1750] = false,
            [1726] = false,
            -- Trial of Valor
            [1819] = false,
            [1830] = false,
            [1829] = false,
            -- Tomb of Sargeras
            [1862] = false, 
            [1867] = false, 
            [1856] = false, 
            [1903] = false, 
            [1861] = false, 
            [1896] = false, 
            [1897] = false, 
            [1873] = false, 
            [1898] = false
        },
        [17] = {
            -- Nighthold
            [1706] = false,
            [1725] = false,
            [1731] = false,
            [1751] = false,
            [1762] = false,
            [1713] = false,
            [1761] = false,
            [1732] = false,
            [1743] = false,
            [1737] = false,
            -- Emerald Nightmare
            [1703] = false,
            [1744] = false,
            [1738] = false,
            [1667] = false,
            [1704] = false,
            [1750] = false,
            [1726] = false,
            -- Trial of Valor
            [1819] = false,
            [1830] = false,
            [1829] = false,
            -- Tomb of Sargeras
            [1862] = false, 
            [1867] = false, 
            [1856] = false, 
            [1903] = false, 
            [1861] = false, 
            [1896] = false, 
            [1897] = false, 
            [1873] = false, 
            [1898] = false
        },
        [23] = false
    }
}

local BonusRollFilter_OptionsTable = {
    type = "group",
    args = {
        helpText = {
            name = "Select bosses below that you DON'T want bonus rolls to appear on",
            fontSize = "medium",
            type = "description",
        },
        tombOfSargeras = {
            name = "Tomb of Sargeras",
            type = "group",
            order = 1,
            args = {
                tombOfSargerasAllLFROn = {
                    name = "Hide all rolls in LFR",
                    desc = "Hide bonus rolls for all Tomb of Sargeras bosses in LFR",
                    order = 1,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_TombOfSargerasEncounters) do
                            BonusRollFilter.db.profile[17][value] = true
                        end
                    end,
                },
                tombOfSargerasAllLFROff = {
                    name = "Show all rolls in LFR",
                    desc = "Show bonus rolls for all Tomb of Sargeras bosses in LFR",
                    order = 1,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_TombOfSargerasEncounters) do
                            BonusRollFilter.db.profile[17][value] = false
                        end
                    end,
                },
                lfr={
                    name = "LFR",
                    type = "multiselect",
                    order = 3,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[17][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[17][key]
                    end,
                    values={
                        [1862] = "Goroth", 
                        [1867] = "Demonic Inquisition", 
                        [1856] = "Harjatan", 
                        [1903] = "Sisters of the Moon", 
                        [1861] = "Mistress Sassz'ine", 
                        [1896] = "The Desolate Host", 
                        [1897] = "Maiden of Vigilance", 
                        [1873] = "Fallen Avatar", 
                        [1898] = "Kil'jaeden"
                    }
                },
                tombOfSargerasAllNormalOn = {
                    name = "Hide all rolls on normal",
                    desc = "Hide bonus rolls for all Tomb of Sargeras bosses on normal",
                    order = 4,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_TombOfSargerasEncounters) do
                            BonusRollFilter.db.profile[14][value] = true
                        end
                    end,
                },
                tombOfSargerasAllNormalOff = {
                    name = "Show all rolls on normal",
                    desc = "Show bonus rolls for all Tomb of Sargeras bosses on normal",
                    order = 5,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_TombOfSargerasEncounters) do
                            BonusRollFilter.db.profile[14][value] = false
                        end
                    end,
                },
                normal={
                    name = "Normal",
                    type = "multiselect",
                    order = 6,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[14][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[14][key]
                    end,
                    values={
                        [1862] = "Goroth", 
                        [1867] = "Demonic Inquisition", 
                        [1856] = "Harjatan", 
                        [1903] = "Sisters of the Moon", 
                        [1861] = "Mistress Sassz'ine", 
                        [1896] = "The Desolate Host", 
                        [1897] = "Maiden of Vigilance", 
                        [1873] = "Fallen Avatar", 
                        [1898] = "Kil'jaeden"
                    }
                },
                tombOfSargerasdAllHeroicOn = {
                    name = "Hide all rolls on heroic",
                    desc = "Hide bonus rolls for all Tomb of Sargeras bosses on heroic",
                    order = 7,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_TombOfSargerasEncounters) do
                            BonusRollFilter.db.profile[15][value] = true
                        end
                    end,
                },
                tombOfSargerasAlHeroicOff = {
                    name = "Show all rolls on heroic",
                    desc = "Show bonus rolls for all Tomb of Sargeras bosses on heroic",
                    order = 8,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_TombOfSargerasEncounters) do
                            BonusRollFilter.db.profile[15][value] = false
                        end
                    end,
                },
                heroic={
                    name = "Heroic",
                    type = "multiselect",
                    order = 9,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[15][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[15][key]
                    end,
                    values={
                        [1862] = "Goroth", 
                        [1867] = "Demonic Inquisition", 
                        [1856] = "Harjatan", 
                        [1903] = "Sisters of the Moon", 
                        [1861] = "Mistress Sassz'ine", 
                        [1896] = "The Desolate Host", 
                        [1897] = "Maiden of Vigilance", 
                        [1873] = "Fallen Avatar", 
                        [1898] = "Kil'jaeden"
                    }
                },
                tombOfSargerasAllMythicOn = {
                    name = "Hide all rolls on mythic",
                    desc = "Hides bonus rolls for all Tomb of Sargeras bosses on mythic",
                    order = 10,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_TombOfSargerasEncounters) do
                            BonusRollFilter.db.profile[16][value] = true
                        end
                    end,
                },
                tombOfSargerasAllMythicOff = {
                    name = "Show all rolls on mythic",
                    desc = "Show bonus rolls for all Tomb of Sargeras bosses on mythic",
                    order = 11,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_TombOfSargerasEncounters) do
                            BonusRollFilter.db.profile[16][value] = false
                        end
                    end,
                },
                mythic={
                    name = "Mythic",
                    type = "multiselect",
                    order = 12,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[16][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[16][key]
                    end,
                    values={
                        [1862] = "Goroth", 
                        [1867] = "Demonic Inquisition", 
                        [1856] = "Harjatan", 
                        [1903] = "Sisters of the Moon", 
                        [1861] = "Mistress Sassz'ine", 
                        [1896] = "The Desolate Host", 
                        [1897] = "Maiden of Vigilance", 
                        [1873] = "Fallen Avatar", 
                        [1898] = "Kil'jaeden"
                    }
                }
            }
        },
        nighthold={
            name = "The Nighthold",
            type = "group",
            order = 2,
            args={
                nightholdAllLFROn = {
                    name = "Hide all rolls in LFR",
                    desc = "Hide bonus rolls for all Nighthold bosses in LFR",
                    order = 1,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_NightholdEncounters) do
                            BonusRollFilter.db.profile[17][value] = true
                        end
                    end,
                },
                nightholdAllLFROff = {
                    name = "Show all rolls in LFR",
                    desc = "Show bonus rolls for all Nighthold bosses in LFR",
                    order = 2,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_NightholdEncounters) do
                            BonusRollFilter.db.profile[17][value] = false
                        end
                    end,
                },
                lfr={
                    name = "LFR",
                    type = "multiselect",
                    order = 3,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[17][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[17][key]
                    end,
                    values={
                        [1706] = "Skorpyron",
                        [1725] = "Chronomatic Anomaly",
                        [1731] = "Trilliax",
                        [1751] = "Spellblade Aluriel",
                        [1762] = "Tichondrius",
                        [1713] = "Krosus",
                        [1761] = "High Botanist Tel'arn",
                        [1732] = "Star Augur Etraeus",
                        [1743] = "Grand Magistrix Elisande",
                        [1737] = "Gul'dan",
                    }
                },
                nightholdAllNormalOn = {
                    name = "Hide all rolls on normal",
                    desc = "Hide bonus rolls for all Nighthold bosses on normal",
                    order = 4,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_NightholdEncounters) do
                            BonusRollFilter.db.profile[14][value] = true
                        end
                    end,
                },
                nightholdAllNormalOff = {
                    name = "Show all rolls on normal",
                    desc = "Show bonus rolls for all Nighthold bosses on normal",
                    order = 5,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_NightholdEncounters) do
                            BonusRollFilter.db.profile[14][value] = false
                        end
                    end,
                },
                normal={
                    name = "Normal",
                    type = "multiselect",
                    order = 6,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[14][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[14][key]
                    end,
                    values={
                        [1706] = "Skorpyron",
                        [1725] = "Chronomatic Anomaly",
                        [1731] = "Trilliax",
                        [1751] = "Spellblade Aluriel",
                        [1762] = "Tichondrius",
                        [1713] = "Krosus",
                        [1761] = "High Botanist Tel'arn",
                        [1732] = "Star Augur Etraeus",
                        [1743] = "Grand Magistrix Elisande",
                        [1737] = "Gul'dan",
                    }
                },
                nightholdAllHeroicOn = {
                    name = "Hide all rolls on heroic",
                    desc = "Hide bonus rolls for all Nighthold bosses on heroic",
                    order = 7,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_NightholdEncounters) do
                            BonusRollFilter.db.profile[15][value] = true
                        end
                    end,
                },
                nightholdAlHeroicOff = {
                    name = "Show all rolls on heroic",
                    desc = "Show bonus rolls for all Nighthold bosses on heroic",
                    order = 8,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_NightholdEncounters) do
                            BonusRollFilter.db.profile[15][value] = false
                        end
                    end,
                },
                heroic={
                    name = "Heroic",
                    type = "multiselect",
                    order = 9,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[15][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[15][key]
                    end,
                    values={
                        [1706] = "Skorpyron",
                        [1725] = "Chronomatic Anomaly",
                        [1731] = "Trilliax",
                        [1751] = "Spellblade Aluriel",
                        [1762] = "Tichondrius",
                        [1713] = "Krosus",
                        [1761] = "High Botanist Tel'arn",
                        [1732] = "Star Augur Etraeus",
                        [1743] = "Grand Magistrix Elisande",
                        [1737] = "Gul'dan",
                    }
                },
                nightholdAllMythicOn = {
                    name = "Hide all rolls on mythic",
                    desc = "Hides bonus rolls for all Nighthold bosses on mythic",
                    order = 10,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_NightholdEncounters) do
                            BonusRollFilter.db.profile[16][value] = true
                        end
                    end,
                },
                nightholdAllMythicOff = {
                    name = "Show all rolls on mythic",
                    desc = "Show bonus rolls for all Nighthold bosses on mythic",
                    order = 11,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_NightholdEncounters) do
                            BonusRollFilter.db.profile[16][value] = false
                        end
                    end,
                },
                mythic={
                    name = "Mythic",
                    type = "multiselect",
                    order = 12,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[16][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[16][key]
                    end,
                    values={
                        [1706] = "Skorpyron",
                        [1725] = "Chronomatic Anomaly",
                        [1731] = "Trilliax",
                        [1751] = "Spellblade Aluriel",
                        [1762] = "Tichondrius",
                        [1713] = "Krosus",
                        [1761] = "High Botanist Tel'arn",
                        [1732] = "Star Augur Etraeus",
                        [1743] = "Grand Magistrix Elisande",
                        [1737] = "Gul'dan",
                    }
                }
            }
        },
        emeraldNightmare={
            name = "Emerald Nightmare",
            type = "group",
            order = 3,
            args={
                emeraldNightmareAllLFROn = {
                    name = "Hide all rolls in LFR",
                    desc = "Hide bonus rolls for all Emerald Nightmare bosses in LFR",
                    order = 1,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_NightmareEncounters) do
                            BonusRollFilter.db.profile[17][value] = true
                        end
                    end,
                },
                emeraldNightmareAllLFROff = {
                    name = "Show all rolls in LFR",
                    desc = "Show bonus rolls for all Emerald Nightmare bosses in LFR",
                    order = 2,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_NightmareEncounters) do
                            BonusRollFilter.db.profile[17][value] = false
                        end
                    end,
                },
                lfr={
                    name = "LFR",
                    type = "multiselect",
                    order = 3,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[17][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[17][key]
                    end,
                    values={
                        [1703] = "Nythendra",
                        [1744] = "Elerethe Renferal",
                        [1738] = "Il'gynoth, Heart of Corruption",
                        [1667] = "Ursoc",
                        [1704] = "Dragons of Nightmare",
                        [1750] = "Cenarius",
                        [1726] = "Xavius",
                    }
                },
                emeraldNightmareAllNormalOn = {
                    name = "Hide all rolls on normal",
                    desc = "Hide bonus rolls for all Emerald Nightmare bosses on normal",
                    order = 4,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_NightmareEncounters) do
                            BonusRollFilter.db.profile[14][value] = true
                        end
                    end,
                },
                emeraldNightmareAllNormalOff = {
                    name = "Show all rolls on normal",
                    desc = "Show bonus rolls for all Emerald Nightmare bosses on normal",
                    order = 5,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_NightmareEncounters) do
                            BonusRollFilter.db.profile[14][value] = false
                        end
                    end,
                },
                normal={
                    name = "Normal",
                    type = "multiselect",
                    order = 6,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[14][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[14][key]
                    end,
                    values={
                        [1703] = "Nythendra",
                        [1744] = "Elerethe Renferal",
                        [1738] = "Il'gynoth, Heart of Corruption",
                        [1667] = "Ursoc",
                        [1704] = "Dragons of Nightmare",
                        [1750] = "Cenarius",
                        [1726] = "Xavius",
                    }
                },
                emeraldNightmareAllHeroicOn = {
                    name = "Hide all rolls on heroic",
                    desc = "Hide bonus rolls for all Emerald Nightmare bosses on heroic",
                    order = 7,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_NightmareEncounters) do
                            BonusRollFilter.db.profile[15][value] = true
                        end
                    end,
                },
                emeraldNightmareAlHeroicOff = {
                    name = "Show all rolls on heroic",
                    desc = "Show bonus rolls for all Emerald Nightmare bosses on heroic",
                    order = 8,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_NightmareEncounters) do
                            BonusRollFilter.db.profile[15][value] = false
                        end
                    end,
                },
                heroic={
                    name = "Heroic",
                    type = "multiselect",
                    order = 9,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[15][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[15][key]
                    end,
                    values={
                        [1703] = "Nythendra",
                        [1744] = "Elerethe Renferal",
                        [1738] = "Il'gynoth, Heart of Corruption",
                        [1667] = "Ursoc",
                        [1704] = "Dragons of Nightmare",
                        [1750] = "Cenarius",
                        [1726] = "Xavius",
                    }
                },
                emeraldNightmareAllMythicOn = {
                    name = "Hide all rolls on mythic",
                    desc = "Hides bonus rolls for all Emerald Nightmare bosses on mythic",
                    order = 10,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_NightmareEncounters) do
                            BonusRollFilter.db.profile[16][value] = true
                        end
                    end,
                },
                emeraldNightmareAllMythicOff = {
                    name = "Show all rolls on mythic",
                    desc = "Show bonus rolls for all Emerald Nightmare bosses on mythic",
                    order = 11,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_NightmareEncounters) do
                            BonusRollFilter.db.profile[16][value] = false
                        end
                    end,
                },
                mythic={
                    name = "Mythic",
                    type = "multiselect",
                    order = 12,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[16][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[16][key]
                    end,
                    values={
                        [1703] = "Nythendra",
                        [1744] = "Elerethe Renferal",
                        [1738] = "Il'gynoth, Heart of Corruption",
                        [1667] = "Ursoc",
                        [1704] = "Dragons of Nightmare",
                        [1750] = "Cenarius",
                        [1726] = "Xavius",
                    }
                }
            }
        },
        trialOfValor={
            name = "Trial of Valor",
            type = "group",
            order = 4,
            args={
                trialOfValorAllLFROn = {
                    name = "Hide all rolls in LFR",
                    desc = "Hide bonus rolls for all Trial of Valor bosses in LFR",
                    order = 1,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_TrialOfValorEncounters) do
                            BonusRollFilter.db.profile[17][value] = true
                        end
                    end,
                },
                trialOfValorAllLFROff = {
                    name = "Show all rolls in LFR",
                    desc = "Show bonus rolls for all Trial of Valor bosses in LFR",
                    order = 2,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_TrialOfValorEncounters) do
                            BonusRollFilter.db.profile[17][value] = false
                        end
                    end,
                },
                lfr={
                    name = "LFR",
                    type = "multiselect",
                    order = 3,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[17][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[17][key]
                    end,
                    values={
                        [1819] = "Odyn",
                        [1830] = "Guarm",
                        [1829] = "Helya",
                    }
                },
                trialOfValorAllNormalOn = {
                    name = "Hide all rolls on normal",
                    desc = "Hide bonus rolls for all Trial of Valor bosses on normal",
                    order = 4,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_TrialOfValorEncounters) do
                            BonusRollFilter.db.profile[14][value] = true
                        end
                    end,
                },
                trialOfValorAllNormalOff = {
                    name = "Show all rolls on normal",
                    desc = "Show bonus rolls for all Trial of Valor bosses on normal",
                    order = 5,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_TrialOfValorEncounters) do
                            BonusRollFilter.db.profile[14][value] = false
                        end
                    end,
                },
                normal={
                    name = "Normal",
                    type = "multiselect",
                    order = 6,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[14][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[14][key]
                    end,
                    values={
                        [1819] = "Odyn",
                        [1830] = "Guarm",
                        [1829] = "Helya",
                    }
                },
                trialOfValorAllHeroicOn = {
                    name = "Hide all rolls on heroic",
                    desc = "Hide bonus rolls for all Trial of Valor bosses on heroic",
                    order = 7,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_TrialOfValorEncounters) do
                            BonusRollFilter.db.profile[15][value] = true
                        end
                    end,
                },
                trialOfValorAlHeroicOff = {
                    name = "Show all rolls on heroic",
                    desc = "Show bonus rolls for all Trial of Valor bosses on heroic",
                    order = 8,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_TrialOfValorEncounters) do
                            BonusRollFilter.db.profile[15][value] = false
                        end
                    end,
                },
                heroic={
                    name = "Heroic",
                    type = "multiselect",
                    order = 9,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[15][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[15][key]
                    end,
                    values={
                        [1819] = "Odyn",
                        [1830] = "Guarm",
                        [1829] = "Helya",
                    }
                },
                trialOfValorAllMythicOn = {
                    name = "Hide all rolls on mythic",
                    desc = "Hides bonus rolls for all Trial of Valor bosses on mythic",
                    order = 10,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_TrialOfValorEncounters) do
                            BonusRollFilter.db.profile[16][value] = true
                        end
                    end,
                },
                trialOfValorAllMythicOff = {
                    name = "Show all rolls on mythic",
                    desc = "Show bonus rolls for all Trial of Valor bosses on mythic",
                    order = 11,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_TrialOfValorEncounters) do
                            BonusRollFilter.db.profile[16][value] = false
                        end
                    end,
                },
                mythic={
                    name = "Mythic",
                    type = "multiselect",
                    order = 12,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[16][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[16][key]
                    end,
                    values={
                        [1819] = "Odyn",
                        [1830] = "Guarm",
                        [1829] = "Helya",
                    }
                }
            }
        },
        worldBosses={
            name = "World Bosses",
            type = "group",
            order = 5,
            args={
                worldBossesAllOn = {
                    name = "Hide rolls for all world bosses",
                    desc = "Hide bonus rolls for all world bosses",
                    order = 1,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_WorldBossEncounters) do
                            BonusRollFilter.db.profile[14][value] = true
                        end
                    end,
                },
                worldBossesAllOff = {
                    name = "Show rolls for all world bosses",
                    desc = "Show bonus rolls for all world bosses",
                    order = 2,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_WorldBossEncounters) do
                            BonusRollFilter.db.profile[14][value] = false
                        end
                    end,
                },
                normal={
                    name = "World Bosses",
                    type = "multiselect",
                    order = 4,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[14][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[14][key]
                    end,
                    values={
                        [1790] = "Ana-Mouz",
                        [1956] = "Apocron",
                        [1883] = "Brutallus",
                        [1774] = "Calamir",
                        [1789] = "Drugon the Frostblood",
                        [1795] = "Flotsam",
                        [1770] = "Humongris",
                        [1769] = "Levantus",
                        [1884] = "Malificus",
                        [1783] = "Na'zak the Fiend",
                        [1749] = "Nithogg",
                        [1763] = "Shar'thos",
                        [1885] = "Si'vash",
                        [1756] = "The Soultakers",
                        [1796] = "Withered J'im",
                    }
                }
            }
        },
        dungeons={
            name = "Mythic Dungeons",
            type = "group",
            order = 6,
            args={
                disable = {
                    name = "Mythic Dungeons",
                    desc = "Disables bonus rolls in mythic dungeons",
                    descStyle = "inline",
                    type = "toggle",
                    set = function(info, val) BonusRollFilter.db.profile[23] = val end,
                    get = function(info) return BonusRollFilter.db.profile[23] end
                }
            }
        },
    }
}

function BonusRollFilter:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("BRF_Data", BonusRollFilter_OptionsDefaults)
    LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("BonusRollFilter", BonusRollFilter_OptionsTable)
    LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("BonusRollFilter_Profiles",LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db))
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("BonusRollFilter", "BonusRollFilter")
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("BonusRollFilter_Profiles", "Profiles", "BonusRollFilter")

    self:RegisterChatCommand("brf", "SlashCommand")
    self:RegisterChatCommand("bonusrollfilter", "SlashCommand")

    self:SecureHookScript(BonusRollFrame, "OnShow", "BonusRollFrame_OnShow")
    self:SecureHookScript(BonusRollFrame.PromptFrame.RollButton, "OnClick", "RollButton_OnClick")
    self:SecureHookScript(BonusRollFrame.PromptFrame.PassButton, "OnClick", "PassButton_OnClick")
end

function BonusRollFilter:RollButton_OnClick()
    BRF_UserAction = true
end

function BonusRollFilter:PassButton_OnClick()
    BRF_UserAction = true
end

function BonusRollFilter:BonusRollFrame_OnShow(frame)
    BRF_RollFrame = frame
    BRF_UserAction = false

    if (BRF_RollFrame.difficultyID == 23) then
        if (self.db.profile[BRF_RollFrame.difficultyID] == true and BRF_ShowBonusRoll == false) then
            self:Print('Bonus roll hidden, type "/brf show" to open it again.')
            BRF_RollFrame:Hide()
        end
    elseif(self.db.profile[BRF_RollFrame.difficultyID][BRF_RollFrame.encounterID] == true and BRF_ShowBonusRoll == false) then
        self:Print('Bonus roll hidden, type "/brf show" to open it again.')
        BRF_RollFrame:Hide()
    end
    BRF_ShowBonusRoll = false
end

function BonusRollFilter:SlashCommand(command)
    if (command == "") then
        self:Print("Version: " .. GetAddOnMetadata("BonusRollFilter", "Version"))
        self:Print("/brf show - shows the bonus roll if hidden")
        self:Print("/brf config - opens the configuration window")
    elseif (command == "show") then
        BonusRollFilter:ShowRoll()
    elseif (command == "config") then
        InterfaceOptionsFrame_OpenToCategory("BonusRollFilter")
        InterfaceOptionsFrame_OpenToCategory("BonusRollFilter")
    end
end

function BonusRollFilter:ShowRoll()
    if BRF_RollFrame ~= nil and (BRF_RollFrame:IsVisible() == false and time() <= BRF_RollFrame.endTime and BRF_UserAction == false) then
        BRF_ShowBonusRoll = true
        BRF_RollFrame:Show()
    else
        self:Print("No active bonus roll to show")
    end
end
