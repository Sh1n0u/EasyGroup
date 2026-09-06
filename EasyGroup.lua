-- Initialisation DB
EasyGroupDB = EasyGroupDB or {
    enabled = true,
    keyword = "Iloveshinou",
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

	if not EasyGroupDB.keyword or EasyGroupDB.keyword == "" then
		return false
	end

-- Ignore ses propres messages
	if sender == UnitName("player") then
		return false
	end

-- Vérif du mot clef	
	local keyword = EasyGroupDB.keyword:lower()
	if msg:lower():find(keyword, 1, true) then
		return true
	end

-- Vérif si le groupe ou raid est full 
	if GetNumPartyMembers() >= 4 or GetNumRaidMembers() >= 39 then
		return false
	end

	return true
end

frame:SetScript("OnEvent", function(self, event, ...)
	local msg, sender, _, _, _, _, _, channelNumber, channelName = ...

	if event == "ADDON_LOADED" and ... == "EasyGroup" then
		DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00EasyGroup chargé! Tapez |cFFFFD100/eg pour ouvrir l'interface|r")
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
		local chanNameKey = channelName and type(channelName) == "string" and channelName:match("^(%a+)%s*%d*$")
		local isAllowed = EasyGroupDB.channels[chanNumKey] 
			or (chanNameKey and EasyGroupDB.channels[chanNameKey])

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
			EasyGroupUI:Show()
		end
	end
end
