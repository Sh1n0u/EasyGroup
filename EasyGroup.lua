-- Initialisation DB
EasyGroupDB = EasyGroupDB or {
    enabled = true,
    keyword = "Ex : Iloveshinou",
    channels = {
        ["1"] = false,
        ["2"] = false,
        ["3"] = false,
        ["4"] = false,
        ["5"] = false,
        ["6"] = false,
        ["7"] = false,
        ["8"] = false,
        ["9"] = false,
        ["World"] = false,
        ["Trade"] = false,
        ["LocalDefense"] = false,
        ["General"] = false,
        ["LookingForGroup"] = false,
        ["GuildRecruitment"] = false,
        ["Guild"] = false,
        ["Officer"] = false,
        ["Battleground"] = false,
        ["Whisper"] = false,
        ["Say"] = false,
        ["Yell"] = false
    }
}

local frame = CreateFrame("Frame", "EasyGroupFrame")

frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("CHAT_MSG_CHANNEL")

local extraEvents = {
    ["CHAT_MSG_WHISPER"] = "Whisper",
    ["CHAT_MSG_SAY"] = "Say",
    ["CHAT_MSG_YELL"] = "Yell",
    ["CHAT_MSG_GUILD"] = "Guild",
    ["CHAT_MSG_OFFICER"] = "Officer",
    ["CHAT_MSG_RAID"] = "Raid",
    ["CHAT_MSG_RAID_LEADER"] = "Raid Leader",
    ["CHAT_MSG_BATTLEGROUND"] = "Battleground"
}

for eventName in pairs(extraEvents) do
    frame:RegisterEvent(eventName)
end

local function ShouldInvite(msg, sender)
    if not EasyGroupDB.enabled then
        return false
    end

    -- Blocage d'invitation si le mot-clé est vide ou ne contient que des espaces
    if not EasyGroupDB.keyword or EasyGroupDB.keyword:gsub("%s+", "") == "" then
        return false
    end

    -- Ignore ses propres messages
    if sender == UnitName("player") then
        return false
    end

    -- Vérif si le groupe ou le raid est plein
    if GetNumRaidMembers() > 0 then
		if GetNumRaidMembers() >= 39 then
			return false
		end
	else
		if GetNumPartyMembers() >= 4 then
			return false
		end
	end

	-- Découpage et vérif de chaque mot clé séparé par un point virgule
	local msgLower = msg:lower()

    for keyworld in string.gmatch(EasyGroupDB.keyword, "[^;]") do
        -- Suppression des espaces inutiles avant et après le mot clé
        local cleanKeyword = keyword:match("^%s*(.-)%s*$"):lower()

        if cleahnKeyword ~= "" then
            if msgLower:find(cleanKeyword, 1, true) then
                return true
            end
        end
    end
            
    return false
end

frame:SetScript("OnEvent", function(self, event, ...)
    local msg, sender, _, _, _, _, _, channelNumber, channelName = ...

    if event == "ADDON_LOADED" and msg == "EasyGroup" then
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00EasyGroup chargé! Tapez |cFFFFD100/eg|r pour ouvrir l'interface.")
        return
    end

    -- Gestion EventChannel
    local key = extraEvents[event]
    if key then
        if EasyGroupDB.channels[key] and ShouldInvite(msg, sender) then
            InviteUnit(sender)
        end
        return
    end

    -- Gestion EventChannel numéroté
    if event == "CHAT_MSG_CHANNEL" then
        local chanNumKey = tostring(channelNumber)
        local chanNameClean = channelName and tostring(channelName):lower():gsub("%s+", "") or ""
        
        local isAllowed = false

        if EasyGroupDB.channels[chanNumKey] then
            isAllowed = true
        end

        if not isAllowed and EasyGroupDB.channels then
            for dbChanKey, enabled in pairs(EasyGroupDB.channels) do
                if enabled and type(dbChanKey) == "string" then
                    if dbChanKey:lower():gsub("%s+", "") == chanNameClean then
                        isAllowed = true
                        break
                    end
                end
            end
        end

        if isAllowed and ShouldInvite(msg, sender) then
            InviteUnit(sender)
        end
    end
end)

-- Commande Slash
SLASH_EASYGROUP1 = "/eg"
SLASH_EASYGROUP2 = "/easygroup"
SlashCmdList["EASYGROUP"] = function()
    if EasyGroupUI then
        if EasyGroupUI:IsShown() then
            EasyGroupUI:Hide()
        else
            if EasyGroup_UpdateUI then EasyGroup_UpdateUI() end
            EasyGroupUI:Show()
        end
    end
end