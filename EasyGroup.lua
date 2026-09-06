-- Initialisation DB
easyGroupDB = easyGroupDB or {
    enabled = true,
    keyword = "Iloveshinou",
    channels = {
        ["1"] = true,
		["2"] = true,
		["3"] = true,
		["4"] = true,
		["5"] = true,
		["6"] = true,
		["7"] = true,
		["8"] = true,
		["9"] = true,
		["World"] = true,
		["Trade"] = true,
		["LocalDefense"] = true,
		["General"] = true,
		["LookingForGroup"] = true,
		["GuildRecruitment"] = true,
		["Guild"] = true,
		["Officer"] = true,
		["Party"] = true,
		["Raid"] = true,
		["Battleground"] = true,
		["Whisper"] = true,
		["Say"] = true,
		["Yell"] = true
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
	["CHAT_MSG_PARTY"] = "Party",
	["CHAT_MSG_PARTY_LEADER"] = "Party Leader",
	["CHAT_MSG_RAID"] = "Raid",
	["CHAT_MSG_RAID_LEADER"] = "Raid Leader",
	["CHAT_MSG_BATTLEGROUND"] = "Battleground"

}

for eventName in pairs(extraEvents) do
	frame:RegisterEvent(eventName)
end

local function ShouldInvite(msg, sender)
	if not easyGroupDB.enabled then
		return false
	end

	if not EasyGroupDB.keyword or EasyGroupDB.keyword == "" then
		return false
	end

	local keyword = EasyGroupDB.keyword:lower()
	if msg:lower():find(keyword) then
		return true
	end
-- Vérif si le groupe ou raid est full 
	if GetNumGroupMembers() >= 4 or GetNumRaidMembers() >= 39 then
		return false
	end

	return true
end

frame:SetScript("OnEvent", function(self, event, ...)
	local msg, sender, _, _, _, _, _, channelName = ...

	if event == "ADDON_LOADED" and ... == "EasyGroup" then
		DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00EasyGroup chargé! Tapez |cFFFFD100/eg pour ouvrir l'interface|r")
		return
	end

	if event =="CHAT_MSG_CHANNEL" then
		if easyGroupDB.channels[channelName] and ShouldInvite(msg, sender) then
			InviteUnit(sender)
			SendChatMessage("Invitation envoyée à " .. sender .. " !", "WHISPER", nil, sender)
		end

