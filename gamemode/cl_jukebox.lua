local medialib = include("medialib.lua")
local availableSongs = {}
local frame, play, mediaclip, pause, vol, service, label, selectedSong
local title = " "
local jukeboxOpen = false
local CLIP = nil
local autoplaylistEnabled = GetConVar("rps_autoplayenabled"):GetBool() or false
local vol = GetConVar("rps_jukeboxvolume"):GetFloat() or 0.05
local isFading = false
local roundended = false

local oldPrint = print
local function print(s)
	if s == nil then s = "s is nil" end
	oldPrint("cl_jukebox.lua: " .. s)
end

local function FadeInMusic(volumeTarget, time, clip)
	local volincrement = volumeTarget / (time * 25)
	clip:setVolume(0)
	local newvol = 0
	timer.Create("fadein", 0.01, 0, function()
		newvol = newvol + volincrement
		//print(newvol)
		clip:setVolume(newvol)
		isFading = true
		if newvol >= volumeTarget then 
			timer.Destroy("fadein") 
			print("fadein done") 
			isFading = false
		end
	end)
end

local function FadeOutMusic(volumeTarget, time, clip)
	local volincrement = volumeTarget / (time * 30)
	local newvol = clip:getVolume()
	timer.Create("fadeout", 0.01, 0, function()
		//if newvol < volumeTarget then timer.Destroy("fadeout") end
		newvol = newvol - volincrement
		//print(newvol)
		clip:setVolume(newvol)
	end)
	if newvol <= 0 then timer.Destroy("fadeout") end
end

local function PlayMusic(tab)
	//print("before clip")
	if IsValid(CLIP) then CLIP:stop() end
	//print("after clip")
	local link = tab.song
	title = tab.title
	service = medialib.load("media").guessService(link)
	mediaclip = service:load(link)
	CLIP = mediaclip
	mediaclip:play()
	mediaclip:on("ended", function()
		timer.UnPause("AutoPlaylist")
		if IsValid(CLIP) then CLIP:stop() end
	end)
	mediaclip:on("playing", function()
		timer.Pause("AutoPlaylist")
		FadeInMusic(vol, 5, mediaclip)
	end)
	mediaclip:on("error", function()
		timer.UnPause("AutoPlaylist")
		ErrorNoHalt(errorId, errorDesc)
	end)
end

local function AssembleAvailableSongs()
	table.Empty(availableSongs)
	local luckThreshold = 20
	local plyluck = LocalPlayer():GetNWInt("Luck", 50)

	for k, v in pairs(musicPlaylist) do
		local i = musicPlaylist[k]
		if i then
			if (i.luck >= (plyluck - luckThreshold)) and (i.luck <= (plyluck + luckThreshold)) and i.autoplay then
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
				//PrintTable(i)
				return i
			end
		end
	end
end

local function GetSpecificSong(tit)
	for k, v in pairs(musicPlaylist) do
		local i = musicPlaylist[k]
		if i then
			if i.title == tit then
				return i
			end
		end
	end
end

local function normalize(min, max, val) 
    local delta = max - min
    return (val - min) / delta
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
			if isFading then return end
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
			if isFading then return end
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
		volume:SetMax(100)
		volume:SetValue(GetConVar("rps_jukeboxvolume"):GetFloat() * 100)
		volume:SetDecimals(0)
		volume.OnValueChanged = function(_, val)
			if val > 100 then val = 100 end
			if val < 0 then val = 0 end
			local vald = val / 100
			vol = vald
			GetConVar("rps_jukeboxvolume"):SetFloat(vol)
			if not IsValid(mediaclip) then return end
			mediaclip:setVolume(vol)
		end

		local playlistCheck = vgui.Create("DCheckBoxLabel", frame)
		playlistCheck:SetPos(150, 470)
		playlistCheck:SetValue(GetConVar("rps_autoplayenabled"):GetBool())
		playlistCheck:SetText("Auto Playlist")

		function playlistCheck:OnChange(val)
			if (val) then
				GetConVar("rps_autoplayenabled"):SetBool(true)
				autoplaylistEnabled = true
			else
				GetConVar("rps_autoplayenabled"):SetBool(false)
				autoplaylistEnabled = false
			end
		end

		label = frame:Add("DLabel")
		label:SetPos(200, 25)
		label:SetFont("SongTitle")
		label:SetText(title)
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
			//print(selectedSong)
		end

		frame:MakePopup()
		jukeboxOpen = true
	elseif jukeboxOpen then

		frame:ToggleVisible()
		//PrintTable(availableSongs)
	end
end

local function AutoPlaylist()
	if vol == 0 then print("volume is 0, not doing ap") return end
	if not autoplaylistEnabled then print("ap not enabled") return end
	if IsValid(CLIP) then print("music already playing") return end
	if isFading then print("song already fading") return end
	if roundended then print("round has ended") return end

	local randsong = GetRandomSong()

	//print("ap time")
	PlayMusic(randsong)
	if not label then return end
	label:SetText(randsong.title)
	label:SizeToContents()
	label:SetContentAlignment(5)
end

hook.Add("RoundStarted","JukeboxEnable",function()
	timer.Create("AutoPlaylist", math.random(10, 20), 0, function()
		CLIP = nil
		print("ap getting new song...")
		math.randomseed(os.time())
		AutoPlaylist()
	end)
end)

concommand.Add("jukebox", JukeboxFrame)

hook.Add("RoundEnded","JukeboxRoundEnded",function()
	roundended = true
	//FadeOutMusic(vol, 5, CLIP)

	PlayMusic(GetSpecificSong("Memories"))
end)