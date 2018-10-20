local BonusRollFilter = LibStub("AceAddon-3.0"):NewAddon("BonusRollFilter", "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
local BRF_ShowBonusRoll = false
local BRF_RollFrame = nil
local BRF_RollFrameDifficultyIdBackup = nil
local BRF_RollFrameEncounterIdBackup = nil
local BRF_RollFrameEndTimeBackup = nil
local BRF_UserAction = false

local BRF_OptionsOrder = 1

-- MoP uses spellID instead of encounterID for raids before Siege of Orgrimmar since the rollframe does not include encounterID for those
local BRF_MopWorldBosses = {
    [132205] = "Sha of Anger",
    [132206] = "Salyis's Warband",
    [136381] = "Nalak, The Storm Lord",
    [137554] = "Oondasta",
    [148317] = "Timeless Isle Celestials",
    [148316] = "Ordos, Fire-God of the Yaungol",
}

local BRF_MogushanVaults = {
    [125144] = "The Stone Guard",
    [132189] = "Feng the Accursed",
    [132190] = "Gara'jal the Spiritbinder",
    [132191] = "The Spirit Kings",
    [132192] = "Elegon",
    [132193] = "Will of the Emperor",
}

local BRF_HeartOfFear = {
    [132194] = "Imperial Vizier Zor'lok",
    [132195] = "Blade Lord Ta'yak",
    [132196] = "Garalon",
    [132197] = "Wind Lord Mel'jarak",
    [132198] = "Amber-Shaper Un'sok",
    [132199] = "Grand Empress Shek'zeer",
}

local BRF_TerraceOfEndlessSpring = {
    [132200] =  "Protectors of the Endless",
    [132201] =  "Tsulong",
    [132202] =  "Lei Shi",
    [132203] =  "Sha of Fear",
}

local BRF_ThroneOfThunder = {
    [139674] = "Jin'rokh the Breaker",
    [139677] = "Horridon",
    [139679] = "Council of Elders",
    [139680] = "Tortos",
    [139682] = "Megaera",
    [139684] = "Ji-Kun",
    [139686] = "Durumu the Forgotten",
    [139687] = "Primordius",
    [139688] = "Dark Animus",
    [139689] = "Iron Qon",
    [139690] = "Twin Consorts",
    [139691] = "Lei Shen",
}

local BRF_SiegeOfOrgrimmar = {
    [852] = "Immerseus",
    [849] = "The Fallen Protectors",
    [866] = "Norushen",
    [867] = "Sha of Pride",
    [881] = "Galakras",
    [864] = "Iron Juggernaut",
    [856] = "Kor'kron Dark Shaman",
    [850] = "General Nazgrim",
    [846] = "Malkorok",
    [870] = "Spoils of Pandaria",
    [851] = "Thok the Bloodthirsty",
    [865] = "Siegecrafter Blackfuse",
    [853] = "Paragons of the Klaxxi",
    [869] = "Garrosh Hellscrea",
}

local BRF_DraenorWorldBosses = {
    [1291] = "Drov the Ruiner",
    [1211] = "Tarlna the Ageless",
    [1262] = "Rukhmar",
    [1452] = "Supreme Lord Kazzak",
}

local BRF_Highmaul = {
    [1128] = "Kargath Bladefist",
    [971] =  "The Butcher",
    [1195] = "Tectus",
    [1196] = "Brackenspore",
    [1148] = "Twin Ogron",
    [1153] = "Ko'ragh",
    [1197] = "Imperator Mar'gok",
}

local BRF_BlackrockFoundry = {
    [1202] = "Oregorger",
    [1155] = "Hans'gar and Franzok",
    [1122] = "Beastlord Darmac",
    [1161] = "Gruul",
    [1123] = "Flamebender Ka'graz",
    [1147] = "Operator Thogar",
    [1154] = "The Blast Furnace",
    [1162] = "Kromog",
    [1203] = "The Iron Maidens",
    [959] = "Blackhand",
}

local BRF_HellfireCitadel = {
    [1426] = "Hellfire Assault",
    [1425] = "Iron Reaver",
    [1392] = "Kormrok",
    [1432] = "Hellfire High Council",
    [1396] = "Kilrogg Deadeye",
    [1372] = "Gorefiend",
    [1433] = "Shadow-Lord Iskar",
    [1427] = "Socrethar the Eternal",
    [1391] = "Fel Lord Zakuun",
    [1447] = "Xhul'horac",
    [1394] = "Tyrant Velhari",
    [1395] = "Mannoroth",
    [1438] = "Archimond",
}

local BRF_TombOfSargerasEncounters = {
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

local BRF_NightholdEncounters = {
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

local BRF_NightmareEncounters = {
    [1703] = "Nythendra",
    [1744] = "Elerethe Renferal",
    [1738] = "Il'gynoth, Heart of Corruption",
    [1667] = "Ursoc",
    [1704] = "Dragons of Nightmare",
    [1750] = "Cenarius",
    [1726] = "Xavius",
}

local BRF_TrialOfValorEncounters = {
    [1819] = "Odyn",
    [1830] = "Guarm",
    [1829] = "Helya",
}

local BRF_AntorusEncounters = {
    [1992] =  "Garothi Worldbreaker", 
    [1987] =  "Felhounds of Sargeras", 
    [1997] =  "Antoran High Command", 
    [1985] =  "Portal Keeper Hasabel", 
    [2025] =  "Eonar the Life-Binder", 
    [2009] =  "Imonar the Soulhunter", 
    [2004] =  "Kin'garoth", 
    [1983] =  "Varimathras", 
    [1986] =  "The Coven of Shivarra", 
    [1984] =  "Aggramar",
    [2031] =  "Argus the Unmaker",
}

local BRF_WorldBossEncountersLegion = {
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

local BRF_ArugsInvasionEncounters = {
    [2010] = "Matron Folnuna",
    [2011] = "Mistress Alluradel",
    [2012] = "Inquisitor Meto",
    [2013] = "Occularus",
    [2014] = "Sotanathor",
    [2015] = "Pit Lord Vilemus",
}

local BRF_UldirEncounters = {
    [2168] = "Taloc",
    [2167] = "MOTHER",
    [2146] = "Fetid Devourer",
    [2169] = "Zek'voz, Herald of N'zoth",
    [2166] = "Vectis",
    [2195] = "Zul, Reborn",
    [2194] = "Mythrax the Unraveler",
    [2147] = "G'huun"
}

local BRF_BFAWorldBosses = {
    [2139] = "T'zane",
    [2141] = "Ji'arak",
    [2197] = "Hailstone Construct",
    [2199] = "Azurethos, The Winged Typhoon",
    [2198] = "Warbringer Yenajz",
    [2210] = "Dunegorger Kraulok"
}

local faction, locFaction = UnitFactionGroup("player")

if (faction == FACTION_ALLIANCE or locFaction == FACTION_ALLIANCE) then
    BRF_BFAWorldBosses[2213] = "Doom's Howl"
else
    BRF_BFAWorldBosses[2212] = "The Lion's Roar"
end

local BonusRollFilter_OptionsDefaults = {
    profile = {
        [14] = {
            ["*"] = false
        },
        [15] = {
            ["*"] = false
        },
        [16] = {
            ["*"] = false 
        },
        [17] = {
            ["*"] = false
        },
        [23] = false,
        [8] = false,
        disableKeystoneLevelToggle = false,
        disableKeystoneLevel = 0,
    }
}

function ValidateNumeric(info,val)
    if not tonumber(val) then
      return false;
    end

    return true
end

function BonusRollFilter:GenerateWorldbossSettings(name, encounters)
    local tempTable = {}

    tempTable.name = name
    tempTable.type = "group"
    tempTable.order = BRF_OptionsOrder
    tempTable.args = {
            worldBossesAllOn = {
                name = "Hide rolls for all bosses",
                desc = "Hide bonus rolls for all bosses",
                order = 1,
                type = "execute",
                func = function(info, val)
                    for key, value in pairs(encounters) do
                        BonusRollFilter.db.profile[14][key] = true
                    end
                end,
            },
            worldBossesAllOff = {
                name = "Show rolls for all bosses",
                desc = "Show bonus rolls for all bosses",
                order = 1,
                type = "execute",
                func = function(info, val)
                    for key, value in pairs(encounters) do
                        BonusRollFilter.db.profile[14][key] = false
                    end
                end,
            },
            normal={
                name = "Bosses",
                type = "multiselect",
                order = 3,
                set = function(info, key, value)
                    BonusRollFilter.db.profile[14][key] = value
                end,
                get = function(info, key)
                    return BonusRollFilter.db.profile[14][key]
                end,
                values = encounters
            },
        }

    BRF_OptionsOrder = BRF_OptionsOrder + 1
    return tempTable
end

function BonusRollFilter:GenerateRaidSettings(name, encounters, enableLFR, enableNormal, enableHeroic, enableMythic)
    local tempTable = {}

    tempTable.name = name
    tempTable.type = "group"
    tempTable.order = BRF_OptionsOrder
    tempTable.args = {}

        if enableLFR then
            DEFAULT_CHAT_FRAME:AddMessage("INSIDE LFG CHECK")
            tempTable.args.AllLFROn = {
                name = "Hide all rolls in LFR",
                desc = "Hide bonus rolls for all "..name.." bosses in LFR",
                order = 1,
                type = "execute",
                func = function(info, val)
                    for key, value in pairs(encounters) do
                        BonusRollFilter.db.profile[17][key] = true
                    end
                end,
            }
            tempTable.args.AllLFROff = {
                name = "Show all rolls in LFR",
                desc = "Show bonus rolls for all "..name.." bosses in LFR",
                order = 1,
                type = "execute",
                func = function(info, val)
                    for key, value in pairs(encounters) do
                        BonusRollFilter.db.profile[17][key] = false
                    end
                end,
            }
            tempTable.args.lfr={
                name = "LFR",
                type = "multiselect",
                order = 3,
                set = function(info, key, value)
                    BonusRollFilter.db.profile[17][key] = value
                end,
                get = function(info, key)
                    return BonusRollFilter.db.profile[17][key]
                end,
                values = encounters
            }
        end

        if enableNormal then
            tempTable.args.AllNormalOn = {
                name = "Hide all rolls on normal",
                desc = "Hide bonus rolls for all "..name.." bosses on normal",
                order = 4,
                type = "execute",
                func = function(info, val)
                    for key, value in pairs(encounters) do
                        BonusRollFilter.db.profile[14][key] = true
                    end
                end,
            }
            tempTable.args.AllNormalOff = {
                name = "Show all rolls on normal",
                desc = "Show bonus rolls for all "..name.." bosses on normal",
                order = 5,
                type = "execute",
                func = function(info, val)
                    for key, value in pairs(encounters) do
                        BonusRollFilter.db.profile[14][key] = false
                    end
                end,
            }
            tempTable.args.normal={
                name = "Normal",
                type = "multiselect",
                order = 6,
                set = function(info, key, value)
                    BonusRollFilter.db.profile[14][key] = value
                end,
                get = function(info, key)
                    return BonusRollFilter.db.profile[14][key]
                end,
                values = encounters
            }
        end

        if enableHeroic then
            tempTable.args.AllHeroicOn = {
                name = "Hide all rolls on heroic",
                desc = "Hide bonus rolls for all "..name.." bosses on heroic",
                order = 7,
                type = "execute",
                func = function(info, val)
                    for key, value in pairs(encounters) do
                        BonusRollFilter.db.profile[15][key] = true
                    end
                end,
            }
            tempTable.args.AllHeroicOff = {
                name = "Show all rolls on heroic",
                desc = "Show bonus rolls for all "..name.." bosses on heroic",
                order = 8,
                type = "execute",
                func = function(info, val)
                    for key, value in pairs(encounters) do
                        BonusRollFilter.db.profile[15][key] = false
                    end
                end,
            }
            tempTable.args.heroic={
                name = "Heroic",
                type = "multiselect",
                order = 9,
                set = function(info, key, value)
                    BonusRollFilter.db.profile[15][key] = value
                end,
                get = function(info, key)
                    return BonusRollFilter.db.profile[15][key]
                end,
                values = encounters
            }
        end

        if enableMythic then
            tempTable.args.AllMythicOn = {
                name = "Hide all rolls on mythic",
                desc = "Hides bonus rolls for all "..name.." bosses on mythic",
                order = 10,
                type = "execute",
                func = function(info, val)
                    for key, value in pairs(encounters) do
                        BonusRollFilter.db.profile[16][key] = true
                    end
                end,
            }
            tempTable.args.AllMythicOff = {
                name = "Show all rolls on mythic",
                desc = "Show bonus rolls for all "..name.." bosses on mythic",
                order = 11,
                type = "execute",
                func = function(info, val)
                    for key, value in pairs(encounters) do
                        BonusRollFilter.db.profile[16][key] = false
                    end
                end,
            }
            tempTable.args.mythic={
                name = "Mythic",
                type = "multiselect",
                order = 12,
                set = function(info, key, value)
                    BonusRollFilter.db.profile[16][key] = value
                end,
                get = function(info, key)
                    return BonusRollFilter.db.profile[16][key]
                end,
                values = encounters
            }
        end

    BRF_OptionsOrder = BRF_OptionsOrder + 1
    return tempTable
end

local BonusRollFilter_OptionsTable = {
    type = "group",
    args = {
        helpText = {
            name = "Select bosses below that you DON'T want bonus rolls to appear on",
            fontSize = "medium",
            type = "description",
        },
        bfaCategory = {
            name = "Battle for Azeroth",
            order = 1,
            type = "group",
            args = {
                uldir          = BonusRollFilter:GenerateRaidSettings("Uldir", BRF_UldirEncounters, true, true, true, true),
                worldBossesBFA = BonusRollFilter:GenerateWorldbossSettings("World Bosses", BRF_BFAWorldBosses)
            }
        },
        legionCategory = {
            name = "Legion",
            order = 2,
            type = "group",
            args = {
                antorus           = BonusRollFilter:GenerateRaidSettings("Antorus, the Burning Throne", BRF_AntorusEncounters, true, true, true, true),
                tombOfSargeras    = BonusRollFilter:GenerateRaidSettings("Tomb of Sargeras", BRF_TombOfSargerasEncounters, true, true, true, true),
                nighthold         = BonusRollFilter:GenerateRaidSettings("The Nighthold", BRF_NightholdEncounters, true, true, true, true),
                trialOfValor      = BonusRollFilter:GenerateRaidSettings("Trial of Valor", BRF_TrialOfValorEncounters, true, true, true, true),
                emeraldNightmare  = BonusRollFilter:GenerateRaidSettings("Emerald Nightmare", BRF_NightmareEncounters, true, true, true, true),
                argusInvasions    = BonusRollFilter:GenerateWorldbossSettings("Argus Invasion Points", BRF_ArugsInvasionEncounters),
                worldBossesLegion = BonusRollFilter:GenerateWorldbossSettings("World Bosses", BRF_WorldBossEncountersLegion),
            }
        },
        wodCategory = {
            name = "Warlords of Draenor",
            order = 3,
            type = "group",
            args = {
                citadel           = BonusRollFilter:GenerateRaidSettings("Hellfire Citadel", BRF_HellfireCitadel, true, true, true, true),
                foundry           = BonusRollFilter:GenerateRaidSettings("Blackrock Foundry", BRF_BlackrockFoundry, true, true, true, true),
                highmaul          = BonusRollFilter:GenerateRaidSettings("Highmaul", BRF_Highmaul, true, true, true, true),
                worldBossesWOD    = BonusRollFilter:GenerateWorldbossSettings("World Bosses", BRF_DraenorWorldBosses)
            }
        },
        mopCategory = {
            name = "Mists of Pandaria",
            order = 4,
            type = "group",
            args = {
                siege           = BonusRollFilter:GenerateRaidSettings("Siege of Orgrimmar", BRF_SiegeOfOrgrimmar, true, true, true, true),
                throne          = BonusRollFilter:GenerateRaidSettings("Throne of Thunder", BRF_ThroneOfThunder, true, true, true, false),
                terrace         = BonusRollFilter:GenerateRaidSettings("Terrace of Endless Spring", BRF_TerraceOfEndlessSpring, true, true, true, false),
                hearthOfFear    = BonusRollFilter:GenerateRaidSettings("Heart of Fear", BRF_HeartOfFear, true, true, true, false),
                vaults          = BonusRollFilter:GenerateRaidSettings("Mogu'shan Vaults", BRF_MogushanVaults, true, true, true, false),
                worldBossesMOP  = BonusRollFilter:GenerateWorldbossSettings("World Bosses", BRF_MopWorldBosses)
            }
        },
        dungeons={
            name = "Mythic Dungeons",
            type = "group",
            order = 4,
            args={
                mythicHeader = {
                    name = "Normal mythic",
                    type = "header",
                    order = 1
                },
                disable = {
                    name = "Mythic Dungeons",
                    order = 2,
                    desc = "Disables bonus rolls in mythic dungeons",
                    descStyle = "inline",
                    type = "toggle",
                    set = function(info, val) BonusRollFilter.db.profile[23] = val end,
                    get = function(info) return BonusRollFilter.db.profile[23] end
                },
                mythicPlusHeader = {
                    name = "Mythic+",
                    order = 3,
                    type = "header"
                },
                disableAllMythicPlus = {
                    name = "Disable bonus rolls in all mythic+",
                    descStyle = "inline",
                    order = 4,
                    width = "full",
                    type = "toggle",
                    set = function(info, val) 
                        BonusRollFilter.db.profile[8] = val

                        if BonusRollFilter.db.profile.disableKeystoneLevelToggle then
                            BonusRollFilter.db.profile.disableKeystoneLevelToggle = false
                        end
                    end,
                    get = function(info) return BonusRollFilter.db.profile[8] end
                },
                disableKeystoneLevelToggle = {
                    name = "Disable bonus rolls if keystone level is lower than: ",
                    order = 5,
                    width = 1.5,
                    type = "toggle",
                    set = function(info, val) 
                        BonusRollFilter.db.profile.disableKeystoneLevelToggle = val 

                        if BonusRollFilter.db.profile[8] then
                            BonusRollFilter.db.profile[8] = false
                        end
                    end,
                    get = function(info) return BonusRollFilter.db.profile.disableKeystoneLevelToggle end
                },
                disableKeystoneLevel = {
                    name = "Keystone level",
                    order = 6,
                    width = 0.8,
                    type = "input",
                    validate = ValidateNumeric,
                    set = function(info, val) 
                        BonusRollFilter.db.profile.disableKeystoneLevel = val
                    end,
                    get = function(info) return BonusRollFilter.db.profile.disableKeystoneLevel end
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

    self:RegisterEvent("LOADING_SCREEN_ENABLED", "LoadingScreen_Enabled")
end

function BonusRollFilter:LoadingScreen_Enabled()
    if BRF_RollFrame ~= nil then
        BRF_RollFrameDifficultyIdBackup = BRF_RollFrame.difficultyID
        BRF_RollFrameEncounterIdBackup = BRF_RollFrame.encounterID
        BRF_RollFrameEndTimeBackup = BRF_RollFrame.endTime
    end
    
end

function BonusRollFilter:RollButton_OnClick()
    BRF_UserAction = true
end

function BonusRollFilter:PassButton_OnClick()
    BRF_UserAction = true
end

function BonusRollFilter:BonusRollFrame_OnShow(frame)
    BRF_UserAction = false

    if (BRF_RollFrame == nil) then
        BRF_RollFrame = frame
    elseif (BRF_RollFrameDifficultyIdBackup ~= nil and BRF_RollFrameEndTimeBackup ~= nil and frame.difficultyID ~= BRF_RollFrameDifficultyIdBackup and time() <= BRF_RollFrameEndTimeBackup) then
        BRF_RollFrame = frame
        BRF_RollFrame.difficultyID = BRF_RollFrameDifficultyIdBackup
    else
        BRF_RollFrame = frame
    end

    if (BRF_RollFrame.difficultyID == 8) then -- Mythic plus
        if (self.db.profile[BRF_RollFrame.difficultyID] == true and BRF_ShowBonusRoll == false) then
            BonusRollFilter:HideRoll()
        elseif (self.db.profile.disableKeystoneLevelToggle == true and BRF_ShowBonusRoll == false) then
            local _, level, _, _, _ = C_ChallengeMode.GetCompletionInfo()

            if (level < tonumber(self.db.profile.disableKeystoneLevel)) then
                BonusRollFilter:HideRoll()
            end
        end
    elseif (BRF_RollFrame.difficultyID == 23) then -- Normal mythics
        if (self.db.profile[BRF_RollFrame.difficultyID] == true and BRF_ShowBonusRoll == false) then
            BonusRollFilter:HideRoll()
        end
    elseif (BRF_RollFrame.difficultyID == 3) or (BRF_RollFrame.difficultyID == 4) then -- 10 or 25 man normal for MoP raids
        if (self.db.profile[14][BRF_RollFrame.spellID] == true and BRF_ShowBonusRoll == false) then
            BonusRollFilter:HideRoll()
        end
    elseif (BRF_RollFrame.difficultyID == 5) or (BRF_RollFrame.difficultyID == 6) then -- 10 or 25 man heroic for MoP raids
        if (self.db.profile[15][BRF_RollFrame.spellID] == true and BRF_ShowBonusRoll == false) then
            BonusRollFilter:HideRoll()
        end
    elseif (self.db.profile[BRF_RollFrame.difficultyID][BRF_RollFrame.encounterID] == true and BRF_ShowBonusRoll == false) or (self.db.profile[BRF_RollFrame.difficultyID][BRF_RollFrame.spellID] == true and BRF_ShowBonusRoll == false) then -- Raids
        BonusRollFilter:HideRoll()
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

function BonusRollFilter:HideRoll()
    self:Print('Bonus roll hidden, type "/brf show" to open it again.')
    BRF_RollFrame:Hide()
    GroupLootContainer_RemoveFrame(GroupLootContainer, BRF_RollFrame);
end

function BonusRollFilter:ShowRoll()
    if BRF_RollFrame ~= nil and (BRF_RollFrame:IsVisible() == false and time() <= BRF_RollFrame.endTime and BRF_UserAction == false) then
        BRF_ShowBonusRoll = true
        GroupLootContainer_AddFrame(GroupLootContainer, BRF_RollFrame);

        -- For some reason if you are using ElvUI the timer bar will be behind the roll frame when you open it again after hiding it
        if IsAddOnLoaded("ElvUI") then
            local FrameLevel = BRF_RollFrame:GetFrameLevel();
            BRF_RollFrame.PromptFrame.Timer:SetFrameLevel(FrameLevel + 1);
            BRF_RollFrame.BlackBackgroundHoist:SetFrameLevel(FrameLevel);
        end

        BRF_RollFrame:Show()
    else
        self:Print("No active bonus roll to show")
    end
end
