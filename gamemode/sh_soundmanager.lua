local LoadedSounds
local songString
math.randomseed(os.time())
if CLIENT then
	LoadedSounds = {} -- this table caches existing CSoundPatches
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

net.Receive("FadeInMusic", function(len)
	songString = net.ReadString()
	FadeInMusicSndMng(songString)
end)
-- IDEA: A JUKEBOX LUA SCRIPT
-- IT'S A CLIENTSIDE THING THAT RANDOMLY PICKS SONGS, OR YOU PICK THEM YOURSELF