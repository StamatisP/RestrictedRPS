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
local frame, play, mediaclip, pause, vol, service, title, label, selectedSong
local jukeboxOpen = false
local CLIP
local autoplaylistEnabled = true
local vol = 0.05

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
	mediaclip:on("ended", function()
		timer.UnPause("AutoPlaylist")
	end)
	mediaclip:on("playing", function()
		timer.Pause("AutoPlaylist")
	end)
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

local function GetSelectedSong()
	if not selectedSong then return end
	for k, v in pairs(musicPlaylist) do
		local i = musicPlaylist[k]
		if i then
			if i.title == selectedSong then
				return i
			end
		end
	end
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
		play:SetSize(30, 30)
		play:SetText("Play")
		play.DoClick = function()
			if not GetSelectedSong() then return end
			PlayMusic(GetSelectedSong())
			label:SetText(selectedSong)
			label:SizeToContents()
			label:SetContentAlignment(5)
		end

		local stop = frame:Add("DButton")
		stop:SetPos(50, 460)
		stop:SetSize(30, 30)
		stop:SetText("Stop")
		stop.DoClick = function()
			if not IsValid(CLIP) then return end
			CLIP:stop()
			label:SetText("Stopped.")
			label:SizeToContents() // make this a function
		end

		local shuffle = frame:Add("DButton")
		shuffle:SetPos(90, 460)
		shuffle:SetSize(50, 30)
		shuffle:SetText("Shuffle")
		shuffle.DoClick = function()
			local randsong = GetRandomSong()
			PlayMusic(randsong)
			if not label then return end
			label:SetText(randsong.title)
			label:SizeToContents()
		end

		volume = frame:Add("Slider")
		volume:SetPos(250, 460)
		volume:SetWide(250)
		volume:SetMin(0)
		volume:SetMax(1.0)
		volume:SetValue(0.05)
		volume:SetDecimals(2)
		volume.OnValueChanged = function(_, val)
			vol = val
			if not IsValid(mediaclip) then return end
			mediaclip:setVolume(val)
		end

		local playlistCheck = vgui.Create("DCheckBoxLabel", frame)
		playlistCheck:SetPos(150, 470)
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
		label:SetPos(200, 25)
		label:SetFont("SongTitle")
		label:SetText("No song currently playing.")
		label:SetContentAlignment(5)
		label:SizeToContents()
		label:SetTextColor(Color(255, 255, 255))

		local f = frame:Add("DPanel")
		f:SetSize(400, 400)
		f:SetPos(50, 50)

		local songList = f:Add("DListView")
		songList:Dock(FILL)
		songList:SetMultiSelect(false)
		songList:AddColumn("Song Title")
		for k, v in pairs(musicPlaylist) do
			local i = musicPlaylist[k]

			if i then
				songList:AddLine(i.title)
			end
		end
		songList:SortByColumn(1, false)
		songList.OnRowSelected = function(list, index, panel)
			selectedSong = panel:GetColumnText(1)
			print(selectedSong)
		end

		frame:MakePopup()
		jukeboxOpen = true
	elseif jukeboxOpen then

		frame:ToggleVisible()
		//PrintTable(availableSongs)

	end
end

local function AutoPlaylist()
	if not autoplaylistEnabled then print("ap not enabled") return end
	if IsValid(CLIP) then print("music already playing") return end
	if not GetGlobalBool("IsRoundStarted", false) then print("round not started") return end

	local randsong = GetRandomSong()

	PlayMusic(randsong)
	if not label then return end
	label:SetText(randsong.title)
	label:SizeToContents()
	label:SetContentAlignment(5)
end


timer.Create("AutoPlaylist", math.random(30, 60), 0, function()
	math.randomseed(os.time())
	AutoPlaylist()
end)
concommand.Add("jukebox", JukeboxFrame)