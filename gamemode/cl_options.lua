GM.MusicVolume = math.Clamp(CreateClientConVar("rps_musicvolume", 10, true, false):GetInt(), 0, 100) / 100
cvars.AddChangeCallback("rps_musicvolume", function(cvar, oldvalue, newvalue)
	GAMEMODE.MusicVolume = math.Clamp(tonumber(newvalue) or 0, 0, 100) / 100
end)