local music = {}

function getMusic(name)
	if music[name] then
		return music[name]
	end
	return false
end

music["ThisWorld"] = {
	song = "https://www.youtube.com/watch?v=Oog3m3LrA8A",
	title = "This World",
	luck = 40,
	autoplay = true
}

music["Lot"] = {
	song = "https://www.youtube.com/watch?v=U0pp0WeMqhs",
	title = "Lot",
	luck = 20,
	autoplay = true
}

// is this too high energy for the mode? maybe exclude it from autoplay
music["KaijiTheme"] = {
	song = "https://www.youtube.com/watch?v=eHRes2_wZE4",
	title = "Kaiji",
	luck = 50,
	autoplay = false
}

music["HumanDerby"] = {
	song = "https://www.youtube.com/watch?v=ptA3_Vh2WMw",
	title = "Human Derby (Man Racetrack)",
	luck = 15,
	autoplay = true
}

music["Green"] = {
	song = "https://www.youtube.com/watch?v=VWfTSl07jO4",
	title = "Green",
	luck = 60,
	autoplay = true
}

music["Wish"] = {
	song = "https://www.youtube.com/watch?v=1vv_u00Yk6w",
	title = "Wish",
	luck = 70,
	autoplay = false // i have to reevaluate all of this later on
}

music["LineOfLight"] = {
	song = "https://www.youtube.com/watch?v=OK0OmKLSgN0",
	title = "Line of Light",
	luck = 80,
	autoplay = false
}

music["StringOfLight"] = {
	song = "https://www.youtube.com/watch?v=soUBJC26690",
	title = "String of Light",
	luck = 60,
	autoplay = true
}

music["Memories"] = {
	song = "https://www.youtube.com/watch?v=vwzNLYbkcFM",
	title = "Memories",
	luck = 60,
	autoplay = true
}

music["ThisWorld2"] = {
	song = "https://www.youtube.com/watch?v=jDFG4Mj3r4Y",
	title = "This World II",
	luck = 40,
	autoplay = true
}

music["Predicament"] = {
	song = "https://www.youtube.com/watch?v=hgVb8-D25nc",
	title = "Predicament",
	luck = 40,
	autoplay = false
}

music["Espoir"] = {
	song = "https://www.youtube.com/watch?v=iYUrU1Bgz00",
	title = "Espoir",
	luck = 30,
	autoplay = true //reevaluate
}

music["Despair"] = {
	song = "https://www.youtube.com/watch?v=x0bGK9YlKRk",
	title = "Despair",
	luck = 50,
	autoplay = false
}

music["ShipOfHope"] = {
	song = "https://www.youtube.com/watch?v=ISVRw7ohwM0",
	title = "Ship of Hope",
	luck = 30, 
	autoplay = true
}

music["Regret"] = {
	song = "https://www.youtube.com/watch?v=o8aLBhyWU_k",
	title = "Regret",
	luck = 0,
	autoplay = false // may manually trigger
}

music["Chest"] = {
	song = "https://www.youtube.com/watch?v=lO8gPwwlms0",
	title = "Chest",
	luck = 20,
	autoplay = true
}

music["ChildsMind"] = {
	song = "https://www.youtube.com/watch?v=WUGQ58Su6u0",
	title = "Child's Mind",
	luck = 30, 
	autoplay = true
}

music["ThisWorld3"] = {
	song = "https://www.youtube.com/watch?v=YSpBMaT25Vg",
	title = "This World III",
	luck = 30,
	autoplay = true
}

music["Beginning"] = {
	song = "https://www.youtube.com/watch?v=QmZx5PmidKU",
	title = "Beginning",
	luck = 20,
	autoplay = true 
}

music["KoZawa1"] = {
	song = "https://www.youtube.com/watch?v=vaNL2ZSlnM0",
	title = "Ko Zawazawa 1",
	luck = 40,
	autoplay = true
}

music["ChuuZawa1"] = {
	song = "https://www.youtube.com/watch?v=odorjWD1exw",
	title = "Chuu Zawazawa 1",
	luck = 30,
	autoplay = true
}

music["DaiZawa1"] = {
	song = "https://www.youtube.com/watch?v=8q-P-bcKQiM",
	title = "Dai Zawazawa 1",
	luck = 20,
	autoplay = true
}

music["DaiZawa2"] = {
	song = "https://www.youtube.com/watch?v=P2esT0IlghE",
	title = "Dai Zawazawa 2",
	luck = 20,
	autoplay = true // played during intro to rrps in show
}

music["DaiDaiZawa"] = {
	song = "https://www.youtube.com/watch?v=yDQZv_FwFio",
	title = "Dai Dai Zawazawa",
	luck = 10,
	autoplay = true
}

music["Strategy"] = {
	song = "https://www.youtube.com/watch?v=D4wKGQpL12w",
	title = "Strategy",
	luck = 50,
	autoplay = true
}

music["Chaos"] = {
	song = "https://www.youtube.com/watch?v=KWnEfJGB9k0",
	title = "Chaos",
	luck = 10,
	autoplay = false
}

music["Confusion"] = {
	song = "https://www.youtube.com/watch?v=OANsUz_dCfs",
	title = "Confusion",
	luck = 30,
	autoplay = true
}

music["Defeat"] = {
	song = "https://www.youtube.com/watch?v=su63vn7sSrs",
	title = "Defeat",
	luck = 0,
	autoplay = false //its defeat music, like regret. ramps up really hard in the middle
}

music["Shadow"] = {
	song = "https://www.youtube.com/watch?v=Cb5-uoNqKcs",
	title = "Shadow",
	luck = 70,
	autoplay = true
}

music["Chorus"] = {
	song = "https://www.youtube.com/watch?v=8kJXwCuBCDI",
	title = "Chorus",
	luck = 20, 
	autoplay = true
}

music["Rest"] = {
	song = "https://www.youtube.com/watch?v=47YLPfSgKN0",
	title = "Rest",
	luck = 40, 
	autoplay = true
}

music["Stagnation"] = {
	song = "https://www.youtube.com/watch?v=CskUY47jupc",
	title = "Stagnation",
	luck = 30,
	autoplay = true
}

music["KoZawaInst2"] = {
	song = "https://www.youtube.com/watch?v=qeUxc-1ctt4",
	title = "Ko Zawa Inst 2",
	luck = 30,
	autoplay = true
}