local medialib = include("medialib.lua")
local availableSongs = {}
local frame, play, mediaclip, pause, volume, service, title
local jukeboxOpen = false
local CLIP 

local function PlayMusic(tab)
	if IsValid(CLIP) then CLIP:stop() end
	local link = tab.song
	title = tab.title
	service = medialib.load("media").guessService(link)
	mediaclip = service:load(link)
	CLIP = mediaclip
	mediaclip:setVolume(0.3)

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
				if not i.autoplay then return end
				table.insert(availableSongs, i)
			end
		end
	end
end

local function GetRandomSong()
	local musicTable = {}

	AssembleAvailableSongs()
	musicTable = table.Random(availableSongs)
	//print(musicTable.title)
	return musicTable
end

local function JukeboxFrame()
	if not jukeboxOpen then 
		frame = vgui.Create("DFrame")
		frame:SetSize(800, 520)
		frame:SetDeleteOnClose(false)
		frame:SetTitle("Jukebox")
		frame:Center()

		play = frame:Add("DButton")
		play:SetPos(10, 483)
		play:SetSize(80, 30)
		play:SetText("Play")
		play.DoClick = function() 
			//mediaclip:play()
			math.randomseed(os.time())
			PlayMusic(GetRandomSong())
		end

		volume = frame:Add("Slider")
		volume:SetPos(550, 483)
		volume:SetWide(250)
		volume:SetMin(0)
		volume:SetMax(1.0)
		volume:SetValue(0.2)
		volume:SetDecimals(2)
		volume.OnValueChanged = function(_, val)
			mediaclip:setVolume(val)	
		end

		frame:MakePopup()
		jukeboxOpen = true
	elseif jukeboxOpen then
		frame:ToggleVisible()
		PrintTable(availableSongs)
	end
end

concommand.Add("jukebox", JukeboxFrame)