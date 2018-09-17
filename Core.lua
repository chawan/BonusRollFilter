local BonusRollFilter = LibStub("AceAddon-3.0"):NewAddon("BonusRollFilter", "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
local BRF_ShowBonusRoll = false
local BRF_RollFrame = nil
local BRF_RollFrameDifficultyIdBackup = nil
local BRF_RollFrameEncounterIdBackup = nil
local BRF_RollFrameEndTimeBackup = nil
local BRF_UserAction = false

local BRF_OptionsOrder = 1

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

function BonusRollFilter:GenerateRaidSettings(name, encounters)
    local tempTable = {}

    tempTable.name = name
    tempTable.type = "group"
    tempTable.order = BRF_OptionsOrder
    tempTable.args = {
            AllLFROn = {
                name = "Hide all rolls in LFR",
                desc = "Hide bonus rolls for all "..name.." bosses in LFR",
                order = 1,
                type = "execute",
                func = function(info, val)
                    for key, value in pairs(encounters) do
                        BonusRollFilter.db.profile[17][key] = true
                    end
                end,
            },
            AllLFROff = {
                name = "Show all rolls in LFR",
                desc = "Show bonus rolls for all "..name.." bosses in LFR",
                order = 1,
                type = "execute",
                func = function(info, val)
                    for key, value in pairs(encounters) do
                        BonusRollFilter.db.profile[17][key] = false
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
                values = encounters
            },
            AllNormalOn = {
                name = "Hide all rolls on normal",
                desc = "Hide bonus rolls for all "..name.." bosses on normal",
                order = 4,
                type = "execute",
                func = function(info, val)
                    for key, value in pairs(encounters) do
                        BonusRollFilter.db.profile[14][key] = true
                    end
                end,
            },
            AllNormalOff = {
                name = "Show all rolls on normal",
                desc = "Show bonus rolls for all "..name.." bosses on normal",
                order = 5,
                type = "execute",
                func = function(info, val)
                    for key, value in pairs(encounters) do
                        BonusRollFilter.db.profile[14][key] = false
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
                values = encounters
            },
            AllHeroicOn = {
                name = "Hide all rolls on heroic",
                desc = "Hide bonus rolls for all "..name.." bosses on heroic",
                order = 7,
                type = "execute",
                func = function(info, val)
                    for key, value in pairs(encounters) do
                        BonusRollFilter.db.profile[15][key] = true
                    end
                end,
            },
            AllHeroicOff = {
                name = "Show all rolls on heroic",
                desc = "Show bonus rolls for all "..name.." bosses on heroic",
                order = 8,
                type = "execute",
                func = function(info, val)
                    for key, value in pairs(encounters) do
                        BonusRollFilter.db.profile[15][key] = false
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
                values = encounters
            },
            AllMythicOn = {
                name = "Hide all rolls on mythic",
                desc = "Hides bonus rolls for all "..name.." bosses on mythic",
                order = 10,
                type = "execute",
                func = function(info, val)
                    for key, value in pairs(encounters) do
                        BonusRollFilter.db.profile[16][key] = true
                    end
                end,
            },
            AllMythicOff = {
                name = "Show all rolls on mythic",
                desc = "Show bonus rolls for all "..name.." bosses on mythic",
                order = 11,
                type = "execute",
                func = function(info, val)
                    for key, value in pairs(encounters) do
                        BonusRollFilter.db.profile[16][key] = false
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
                values = encounters
            }
        }

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
                uldir          = BonusRollFilter:GenerateRaidSettings("Uldir", BRF_UldirEncounters),
                worldBossesBFA = BonusRollFilter:GenerateWorldbossSettings("World Bosses", BRF_BFAWorldBosses)
            }
        },
        legionCategory = {
            name = "Legion",
            order = 2,
            type = "group",
            args = {
                antorus           = BonusRollFilter:GenerateRaidSettings("Antorus, the Burning Throne", BRF_AntorusEncounters),
                tombOfSargeras    = BonusRollFilter:GenerateRaidSettings("Tomb of Sargeras", BRF_TombOfSargerasEncounters),
                nighthold         = BonusRollFilter:GenerateRaidSettings("The Nighthold", BRF_NightholdEncounters),
                trialOfValor      = BonusRollFilter:GenerateRaidSettings("Trial of Valor", BRF_TrialOfValorEncounters),
                emeraldNightmare  = BonusRollFilter:GenerateRaidSettings("Emerald Nightmare", BRF_NightmareEncounters),
                argusInvasions    = BonusRollFilter:GenerateWorldbossSettings("Argus Invasion Points", BRF_ArugsInvasionEncounters),
                worldBossesLegion = BonusRollFilter:GenerateWorldbossSettings("World Bosses", BRF_WorldBossEncountersLegion),
            }
        },
        dungeons={
            name = "Mythic Dungeons",
            type = "group",
            order = 3,
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
    elseif (frame.difficultyID ~= BRF_RollFrameDifficultyIdBackup and time() <= BRF_RollFrameEndTimeBackup) then
        BRF_RollFrame = frame
        BRF_RollFrame.difficultyID = BRF_RollFrameDifficultyIdBackup
    else
        BRF_RollFrame = frame
    end

    if (BRF_RollFrame.difficultyID == 8) then
        if (self.db.profile[BRF_RollFrame.difficultyID] == true and BRF_ShowBonusRoll == false) then
            BonusRollFilter:HideRoll()
        elseif (self.db.profile.disableKeystoneLevelToggle == true and BRF_ShowBonusRoll == false) then
            local _, level, _, _, _ = C_ChallengeMode.GetCompletionInfo()

            if (level < tonumber(self.db.profile.disableKeystoneLevel)) then
                BonusRollFilter:HideRoll()
            end
        end
    elseif (BRF_RollFrame.difficultyID == 23) then
        if (self.db.profile[BRF_RollFrame.difficultyID] == true and BRF_ShowBonusRoll == false) then
            BonusRollFilter:HideRoll()
        end
    elseif(self.db.profile[BRF_RollFrame.difficultyID][BRF_RollFrame.encounterID] == true and BRF_ShowBonusRoll == false) then
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
