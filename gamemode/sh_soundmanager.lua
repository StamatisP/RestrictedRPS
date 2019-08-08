local LoadedSounds
local songString
math.randomseed(os.time())
util.PrecacheSound("music/littlezawa_loop_by_bass.wav")
util.PrecacheSound("sfx/win1_fate.wav")
util.PrecacheSound("sfx/loss1_trap.wav")
util.PrecacheSound("ambient/zawa1.wav")
util.PrecacheSound("ambient/zawa2.wav")
util.PrecacheSound("ambient/zawa3.wav")
util.PrecacheSound("ambient/zawa4.wav")
util.PrecacheSound("ambient/zawa5.wav")
util.PrecacheSound("ambient/zawa6.wav")
util.PrecacheSound("ambient/zawa7.wav")
util.PrecacheSound("ambient/zawa8.wav")
util.PrecacheSound("ambient/zawa9.wav")
util.PrecacheSound("ambient/zawa10.wav")
util.PrecacheSound("ambient/zawa11.wav") // use some file functions to do this automatically (sandbox stools, zombie survival)
if CLIENT then
	LoadedSounds = {} -- this table caches existing CSoundPatches
	WinSounds = {}
	LoseSounds = {}
	WinSounds[1] = "sfx/win1_fate.wav"
	LoseSounds[1] = "sfx/loss1_trap.wav"
end

function ReadSound( FileName, IsMusic )
	local sound
	local filter
	if SERVER then
		filter = RecipientFilter()
		filter:AddAllPlayers()
	end
	if SERVER or !LoadedSounds[FileName] then
		-- The sound is always re-created serverside because of the RecipientFilter.
		sound = CreateSound( game.GetWorld(), FileName, filter ) -- create the new sound, parented to the worldspawn ( which always exists )
		if sound then
			sound:SetSoundLevel( 0 ) -- play everywhere
			-- warning: this might be a prob later down the line, since itll play for everyone(good for music tho)
			if CLIENT then
				LoadedSounds[FileName] = { sound, filter } -- cache the CSoundPatch
			end
		end
	else
		sound = LoadedSounds[FileName][1]
		filter = LoadedSounds[FileName][2]
	end
	if sound then
		if CLIENT then
			sound:Stop() -- it won't play again otherwise
		end
		if IsMusic then 
			sound:PlayEx(0.5, 100)
			return
		end
		sound:PlayEx(1, math.random(90,105))
	end
	return sound -- useful if you want to stop the sound yourself
end
-- this isn't good for music, since it isn't affected by in-game sound options
-- fuck it, make our own options

-- When we are ready, we play the sound:
-- important to remember: CSoundPatch:FadeOut
function FadeInMusicSndMng(song) 
	if SERVER then 
		print("server running fadein, no no")
		return 
	end
	if song then
		print("fadeinmusic running")
		local mus = CreateSound(LocalPlayer(), song)
	    -- in the future, all sounds should be created initially
	    -- replace strict volumes with options
	    -- wait this shouldn't  be serverside, since clientside options wouldn't work...
		mus:PlayEx(0, 100)
		mus:SetSoundLevel(0)
		mus:ChangeVolume(0, 0)
		mus:ChangeVolume(GAMEMODE.MusicVolume, 5)
		//mus:ChangeVolume(0.4, 5)
		return mus
	else
		print("song is empty, not valid")
	end
end

/*net.Receive("FadeInMusic", function(len)
	songString = net.ReadString()
	FadeInMusicSndMng(songString)
end)*/
-- IDEA: A JUKEBOX LUA SCRIPT
-- IT'S A CLIENTSIDE THING THAT RANDOMLY PICKS SONGS, OR YOU PICK THEM YOURSELF
// oh younger me... if only you knew
hook.Add("PlayerTableWin", "PlayWinSoundFX", function()
	print("hook win!")
	surface.PlaySound(WinSounds[math.random(#WinSounds)])
end)

hook.Add("PlayerTableLoss", "PlayLossSoundFX", function()
	print("hook loss!")
	surface.PlaySound(LoseSounds[math.random(#LoseSounds)])
end)