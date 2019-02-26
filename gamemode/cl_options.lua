GM.MusicVolume = math.Clamp(CreateClientConVar("rrps_musicvolume", 20, true, false):GetInt(), 0, 100) / 100
cvars.AddChangeCallback("rrps_musicvolume", function(cvar, oldvalue, newvalue)
	GAMEMODE.MusicVolume = math.Clamp(tonumber(newvalue) or 0, 0, 100) / 100
end)