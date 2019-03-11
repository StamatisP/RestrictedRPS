local medialib = include("medialib.lua")
local availableSongs = {}

hook.Add("InitPostEntity", "CreateMusicPlaylist", function()

end)

local function PlayMusic(name)
	local link = musicPlaylist[name].song
	local service = medialib.load("media").guessService(link)
	local mediaclip = service:load(link)
	mediaclip:play()
end

local function AssembleAvailableSongs()
	local luckThreshold = 10
	local plyluck = LocalPlayer():GetNWInt("Luck", 50)

	for k, v in pairs(musicPlaylist) do
		local i = getMusic(k)
		if i then
			//print(k .. " k")
			//print(v .. " v") so v is a table value
			//print(i.luck)
			if (i.luck >= plyluck - luckThreshold) and (i.luck <= plyluck + luckThreshold) then
				// if luck of music isn't greater than or equal to player luck minus 10
				// say if song is 40 luck... player has 50 luck. 40 < 50 < 60
				// songluck <= 50 <= songluck
				//print(i.luck .. " >= " .. plyluck - luckThreshold)
				table.insert(availableSongs, i)
			end
		end
	end
end

local function GetRandomSong()
	local musicTable = {}

	AssembleAvailableSongs()
	musicTable = table.Random(availableSongs)
	print(musicTable.title)
	return musicTable.song
end

timer.Simple(2, function()
	local name = GetRandomSong()
end)