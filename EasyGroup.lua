-- Initialisation DB
easyGroupDB = easyGroupDB or {
    enabled = true,
    keyword = "+lga",
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
frame:RegisterEvent("CHAT_MSG_WHISPER")

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
