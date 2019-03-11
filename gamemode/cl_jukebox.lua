surface.CreateFont( "SongTitle", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 25,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

local medialib = include("medialib.lua")
local availableSongs = {}
local frame, play, mediaclip, pause, vol, service, title, label
local jukeboxOpen = false
local CLIP
local autoplaylistEnabled = true
local vol = 0.1

local function PlayMusic(tab)
	if IsValid(CLIP) then CLIP:stop() end
	local link = tab.song
	title = tab.title
	service = medialib.load("media").guessService(link)
	mediaclip = service:load(link)
	CLIP = mediaclip
	mediaclip:play()
	if not mediaclip:isPlaying() then 
		timer.Simple(0.1, function()
			mediaclip:setVolume(vol)
		end)
	elseif mediaclip:isPlaying() then
		mediaclip:setVolume(vol)
	end
end

local function AssembleAvailableSongs()
	table.Empty(availableSongs)
	local luckThreshold = 20
	local plyluck = LocalPlayer():GetNWInt("Luck", 50)

	for k, v in pairs(musicPlaylist) do
		//print(k)
		//local i = getMusic(k)
		local i = musicPlaylist[k]
		//PrintTable(i)
		if i then
			//print(k .. " k")
			//print(v .. " v") so v is a table value
			//print(i.luck)
			// if i.luck (50) >= 30 and 50 <= 70
			if (i.luck >= (plyluck - luckThreshold)) and (i.luck <= (plyluck + luckThreshold)) and i.autoplay then
				// if luck of music isn't greater than or equal to player luck minus 10
				// say if song is 40 luck... player has 50 luck. 40 < 50 < 60
				// songluck <= 50 <= songluck
				//print(i.luck .. " >= " .. plyluck - luckThreshold)
				table.insert(availableSongs, i)
			else
				//print("song " .. i.title .. " has been excluded, with autoplay " .. tostring(i.autoplay) .. " and luck " .. i.luck)
			end
		end
	end
end

local function GetRandomSong()
	local musicTable = {}
	// this is for autoplaylist only, not a shuffle
	AssembleAvailableSongs()
	musicTable = table.Random(availableSongs)
	//print(musicTable.title)
	return musicTable
end

local function JukeboxFrame()
	if not jukeboxOpen then 
		frame = vgui.Create("DFrame")
		frame:SetSize(500, 500)
		frame:SetDeleteOnClose(false)
		frame:SetTitle("Jukebox")
		frame:Center()

		play = frame:Add("DButton")
		play:SetPos(10, 460)
		play:SetSize(80, 30)
		play:SetText("Play")
		play.DoClick = function() 
			//mediaclip:play()
			math.randomseed(os.time())
			local randsong = GetRandomSong()
			PlayMusic(randsong)
			label:SetText(randsong.title)
			label:SizeToContents()
		end

		volume = frame:Add("Slider")
		volume:SetPos(250, 460)
		volume:SetWide(250)
		volume:SetMin(0)
		volume:SetMax(1.0)
		volume:SetValue(0.1)
		volume:SetDecimals(2)
		volume.OnValueChanged = function(_, val)
			vol = val
			if not IsValid(mediaclip) then return end
			mediaclip:setVolume(val)
		end

		local playlistCheck = vgui.Create("DCheckBoxLabel", frame)
		playlistCheck:SetPos(100, 470)
		playlistCheck:SetValue(1)
		playlistCheck:SetText("Auto Playlist")

		function playlistCheck:OnChange(val)
			if (val) then
				autoplaylistEnabled = true
			else
				autoplaylistEnabled = false
			end
		end

		label = frame:Add("DLabel")
		label:SetPos(220, 50)
		label:SetFont("SongTitle")
		label:SetText("No song currently playing...")
		label:SizeToContents()

		frame:MakePopup()
		jukeboxOpen = true
	elseif jukeboxOpen then

		frame:ToggleVisible()
		PrintTable(availableSongs)

	end
end

local function AutoPlaylist()
	if not autoplaylistEnabled then return end
	if IsValid(CLIP) then return end
	if not GetGlobalBool("IsRoundStarted", false) then return end

	local randsong = GetRandomSong()

	PlayMusic(randsong)
	if not label then return end
	label:SetText(randsong.title)
	label:SizeToContents()
end


timer.Create("AutoPlaylist", math.random(5, 10), 0, function()
	math.randomseed(os.time())
	AutoPlaylist()
end)
concommand.Add("jukebox", JukeboxFrame)