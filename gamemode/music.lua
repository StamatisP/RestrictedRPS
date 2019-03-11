musicPlaylist = {}

function getMusic(name)
	if musicPlaylist[name] then
		return musicPlaylist[name]
	end
	return false
end

musicPlaylist["ThisWorld"] = {
	song = "https://www.youtube.com/watch?v=Oog3m3LrA8A",
	title = "This World",
	luck = 40,
	autoplay = true
}

musicPlaylist["Lot"] = {
	song = "https://www.youtube.com/watch?v=U0pp0WeMqhs",
	title = "Lot",
	luck = 20,
	autoplay = true
}

// is this too high energy for the mode? maybe exclude it from autoplay
musicPlaylist["KaijiTheme"] = {
	song = "https://www.youtube.com/watch?v=eHRes2_wZE4",
	title = "Kaiji",
	luck = 50,
	autoplay = false
}

musicPlaylist["HumanDerby"] = {
	song = "https://www.youtube.com/watch?v=ptA3_Vh2WMw",
	title = "Human Derby (Man Racetrack)",
	luck = 15,
	autoplay = true
}

musicPlaylist["Green"] = {
	song = "https://www.youtube.com/watch?v=VWfTSl07jO4",
	title = "Green",
	luck = 60,
	autoplay = true
}

musicPlaylist["Wish"] = {
	song = "https://www.youtube.com/watch?v=1vv_u00Yk6w",
	title = "Wish",
	luck = 70,
	autoplay = false // i have to reevaluate all of this later on
}

musicPlaylist["LineOfLight"] = {
	song = "https://www.youtube.com/watch?v=OK0OmKLSgN0",
	title = "Line of Light",
	luck = 80,
	autoplay = false
}

musicPlaylist["StringOfLight"] = {
	song = "https://www.youtube.com/watch?v=soUBJC26690",
	title = "String of Light",
	luck = 60,
	autoplay = true
}

musicPlaylist["Memories"] = {
	song = "https://www.youtube.com/watch?v=vwzNLYbkcFM",
	title = "Memories",
	luck = 60,
	autoplay = true
}

musicPlaylist["ThisWorld2"] = {
	song = "https://www.youtube.com/watch?v=jDFG4Mj3r4Y",
	title = "This World II",
	luck = 40,
	autoplay = true
}

musicPlaylist["Predicament"] = {
	song = "https://www.youtube.com/watch?v=hgVb8-D25nc",
	title = "Predicament",
	luck = 40,
	autoplay = false
}

musicPlaylist["Espoir"] = {
	song = "https://www.youtube.com/watch?v=iYUrU1Bgz00",
	title = "Espoir",
	luck = 30,
	autoplay = true //reevaluate
}

musicPlaylist["Despair"] = {
	song = "https://www.youtube.com/watch?v=x0bGK9YlKRk",
	title = "Despair",
	luck = 50,
	autoplay = false
}

musicPlaylist["ShipOfHope"] = {
	song = "https://www.youtube.com/watch?v=ISVRw7ohwM0",
	title = "Ship of Hope",
	luck = 30, 
	autoplay = true
}

musicPlaylist["Regret"] = {
	song = "https://www.youtube.com/watch?v=o8aLBhyWU_k",
	title = "Regret",
	luck = 0,
	autoplay = false // may manually trigger
}

musicPlaylist["Chest"] = {
	song = "https://www.youtube.com/watch?v=lO8gPwwlms0",
	title = "Chest",
	luck = 20,
	autoplay = true
}

musicPlaylist["ChildsMind"] = {
	song = "https://www.youtube.com/watch?v=WUGQ58Su6u0",
	title = "Child's Mind",
	luck = 30, 
	autoplay = true
}

musicPlaylist["ThisWorld3"] = {
	song = "https://www.youtube.com/watch?v=YSpBMaT25Vg",
	title = "This World III",
	luck = 30,
	autoplay = true
}

musicPlaylist["Beginning"] = {
	song = "https://www.youtube.com/watch?v=QmZx5PmidKU",
	title = "Beginning",
	luck = 20,
	autoplay = true 
}

musicPlaylist["KoZawa1"] = {
	song = "https://www.youtube.com/watch?v=vaNL2ZSlnM0",
	title = "Ko Zawazawa 1",
	luck = 40,
	autoplay = true
}

musicPlaylist["ChuuZawa1"] = {
	song = "https://www.youtube.com/watch?v=odorjWD1exw",
	title = "Chuu Zawazawa 1",
	luck = 30,
	autoplay = true
}

musicPlaylist["DaiZawa1"] = {
	song = "https://www.youtube.com/watch?v=8q-P-bcKQiM",
	title = "Dai Zawazawa 1",
	luck = 20,
	autoplay = true
}

musicPlaylist["DaiZawa2"] = {
	song = "https://www.youtube.com/watch?v=P2esT0IlghE",
	title = "Dai Zawazawa 2",
	luck = 20,
	autoplay = true // played during intro to rrps in show
}

musicPlaylist["DaiDaiZawa"] = {
	song = "https://www.youtube.com/watch?v=yDQZv_FwFio",
	title = "Dai Dai Zawazawa",
	luck = 10,
	autoplay = true
}

musicPlaylist["Strategy"] = {
	song = "https://www.youtube.com/watch?v=D4wKGQpL12w",
	title = "Strategy",
	luck = 50,
	autoplay = true
}

musicPlaylist["Chaos"] = {
	song = "https://www.youtube.com/watch?v=KWnEfJGB9k0",
	title = "Chaos",
	luck = 10,
	autoplay = false
}

musicPlaylist["Confusion"] = {
	song = "https://www.youtube.com/watch?v=OANsUz_dCfs",
	title = "Confusion",
	luck = 30,
	autoplay = true
}

musicPlaylist["Defeat"] = {
	song = "https://www.youtube.com/watch?v=su63vn7sSrs",
	title = "Defeat",
	luck = 0,
	autoplay = false //its defeat musicPlaylist, like regret. ramps up really hard in the middle
}

musicPlaylist["Shadow"] = {
	song = "https://www.youtube.com/watch?v=Cb5-uoNqKcs",
	title = "Shadow",
	luck = 70,
	autoplay = true
}

musicPlaylist["Chorus"] = {
	song = "https://www.youtube.com/watch?v=8kJXwCuBCDI",
	title = "Chorus",
	luck = 20, 
	autoplay = true
}

musicPlaylist["Rest"] = {
	song = "https://www.youtube.com/watch?v=47YLPfSgKN0",
	title = "Rest",
	luck = 40, 
	autoplay = true
}

musicPlaylist["Stagnation"] = {
	song = "https://www.youtube.com/watch?v=CskUY47jupc",
	title = "Stagnation",
	luck = 30,
	autoplay = true
}

musicPlaylist["KoZawaInst2"] = {
	song = "https://www.youtube.com/watch?v=qeUxc-1ctt4",
	title = "Ko Zawa Inst 2",
	luck = 30,
	autoplay = true
}

musicPlaylist["WhiteLightMoment"] = {
	song = "https://www.youtube.com/watch?v=-0MjinrXgnk",
	title = "White Light Moment",
	luck = 90,
	autoplay = true
}// top ten bruh moments

musicPlaylist["Montage"] = {
	song = "https://www.youtube.com/watch?v=9J3SE1bdvMs",
	title = "Montage",
	luck = 40,
	autoplay = true
}

musicPlaylist["Phoenix"] = {
	song = "https://www.youtube.com/watch?v=kL4442pWijE",
	title = "Phoenix",
	luck = 60,
	autoplay = false //reevaluate??
}

musicPlaylist["Transparent"] = {
	song = "https://www.youtube.com/watch?v=5F46YiqU1js",
	title = "Transparent",
	luck = 50,
	autoplay = false //really long, maybe reevaluate
}

musicPlaylist["More"] = {
	song = "https://www.youtube.com/watch?v=i-23BEz5Pf4",
	title = "More",
	luck = 50,
	autoplay = true //reevaluate, this song crazy
}

musicPlaylist["Led"] = {
	song = "https://www.youtube.com/watch?v=4i2p5rUoWuY",
	title = "Led",
	luck = 40, 
	autoplay = true // reevaluate luck, this is a good song, it should play at any point tbh
}

musicPlaylist["Dice"] = {
	song = "https://www.youtube.com/watch?v=7G0ro9uAYqg",
	title = "Dice",
	luck = 30,
	autoplay = true
}

musicPlaylist["BlackSun"] = {
	song = "https://www.youtube.com/watch?v=R-o17U7fGFw",
	title = "Black Sun",
	luck = 30,
	autoplay = true
}

musicPlaylist["Quest"] = {
	song = "https://www.youtube.com/watch?v=3yoWcXOFb7I",
	title = "Quest",
	luck = 20,
	autoplay = true
}

/*musicPlaylist["Template"] = {
	song = "t",
	title = "t",
	luck = 50,
	autoplay = true
}*/

musicPlaylist["Bassment"] = {
	song = "https://www.youtube.com/watch?v=YZDfOo5qEsg",
	title = "Bassment[sic]",
	luck = 30,
	autoplay = true
}

musicPlaylist["Elegie"] = {
	song = "https://www.youtube.com/watch?v=PmSLmYj0CQY",
	title = "Elegie",
	luck = 10,
	autoplay = true
}

musicPlaylist["Fate"] = {
	song = "https://www.youtube.com/watch?v=_i15Ns1geJg",
	title = "Fate",
	luck = 90,
	autoplay = true // really long so idk, reevaluate
}

musicPlaylist["GoldenLight"] = {
	song = "https://www.youtube.com/watch?v=uCb7TInc_RE",
	title = "Golden Light",
	luck = 70,
	autoplay = true
}

musicPlaylist["WhiteHeat"] = {
	song = "https://www.youtube.com/watch?v=m3aFFSBl7Tc",
	title = "White Heat",
	luck = 80,
	autoplay = true
}

musicPlaylist["Broken"] = {
	song = "https://www.youtube.com/watch?v=Ev4QL1KFd8w",
	title = "Broken",
	luck = 30,
	autoplay = true
}

musicPlaylist["LittleZawa"] = {
	song = "https://www.youtube.com/watch?v=cfnYoQzccY8",
	title = "Little Zawa",
	luck = 30,
	autoplay = false //this plays in lobby so itd be boring to hear it again
}

musicPlaylist["MiddleZawa"] = {
	song = "https://www.youtube.com/watch?v=VkucGLA08Iw",
	title = "Middle Zawa",
	luck = 40,
	autoplay = true
}

musicPlaylist["EpicZawa"] = {
	song = "https://www.youtube.com/watch?v=S3BY5w-wyOY",
	title = "Epic Zawa",
	luck = 30,
	autoplay = true
}

musicPlaylist["HyperZawa"] = {
	song = "https://www.youtube.com/watch?v=BbSLyeurl9E",
	title = "Hyper Zawa",
	luck = 20,
	autoplay = true
}

musicPlaylist["MaxZawa"] = {
	song = "https://www.youtube.com/watch?v=ezaQUbMKqGY",
	title = "Max Zawa",
	luck = 20,
	autoplay = false //this song is really crazy
}

musicPlaylist["HighMax"] = {
	song = "https://www.youtube.com/watch?v=jilCFoCUhBM",
	title = "High Max",
	luck = 50,
	autoplay = false //this song is long and also crazy
}

musicPlaylist["Inside"] = {
	song = "https://www.youtube.com/watch?v=0UCny8EnyJ4",
	title = "Inside",
	luck = 30,
	autoplay = true
}

musicPlaylist["GoldenSight"] = {
	song = "https://www.youtube.com/watch?v=eMjX06cqi1A",
	title = "Golden Sight",
	luck = 10,
	autoplay = true
}

musicPlaylist["PhoenixStar"] = {
	song = "https://www.youtube.com/watch?v=PNpvM0ZJL60",
	title = "Phoenix Star",
	luck = 30,
	autoplay = true
}

musicPlaylist["Hyper"] = {
	song = "https://www.youtube.com/watch?v=EIIK9E72aIc",
	title = "Hyper",
	luck = 40,
	autoplay = false //kinda long? reevaluate
}

musicPlaylist["Transparent2"] = {
	song = "https://www.youtube.com/watch?v=WroYXO1vOCM",
	title = "Transparent II",
	luck = 50,
	autoplay = true
}

musicPlaylist["Miracle"] = {
	song = "https://www.youtube.com/watch?v=vdXwIeiDUYM",
	title = "Miracle",
	luck = 60,
	autoplay = false //idk man im tired, reevaluate
}

musicPlaylist["HakairokuTheme"] = {
	song = "https://www.youtube.com/watch?v=2laf_EQqdYA",
	title = "Hakairoku Theme",
	luck = 40,
	autoplay = true
}

musicPlaylist["Inferior"] = {
	song = "https://www.youtube.com/watch?v=Qh0MrJQs-kE",
	title = "Inferior",
	luck = 30,
	autoplay = true
}

musicPlaylist["Dusk"] = {
	song = "https://www.youtube.com/watch?v=ZGdSqSaEb5E",
	title = "Dusk",
	luck = 40,
	autoplay = true
}

musicPlaylist["WhiteLight"] = {
	song = "https://www.youtube.com/watch?v=JKMjnUwkgjk",
	title = "White Light",
	luck = 60,
	autoplay = true
}

musicPlaylist["Trap"] = {
	song = "https://www.youtube.com/watch?v=nk0Yu5gihPg",
	title = "Trap",
	luck = 20,
	autoplay = true
}

musicPlaylist["Prologue"] = {
	song = "https://www.youtube.com/watch?v=DlbKOfbvliY",
	title = "Prologue",
	luck = 30,
	autoplay = true
}

musicPlaylist["Enemy"] = {
	song = "https://www.youtube.com/watch?v=DbNSX-6qHfQ",
	title = "Enemy",
	luck = 30,
	autoplay = true
}

musicPlaylist["LawBreakingTheme"] = {
	song = "https://www.youtube.com/watch?v=KAx956Rph8I",
	title = "Law Breaking Theme",
	luck = 30,
	autoplay = false //no idea man... its hard
}

musicPlaylist["Hakairoku"] = {
	song = "https://www.youtube.com/watch?v=fECtYLuuF0k",
	title = "Hakairoku",
	luck = 70,
	autoplay = true
}

musicPlaylist["Numa"] = {
	song = "https://www.youtube.com/watch?v=UMztjxYKSDw",
	title = "Numa",
	luck = 30,
	autoplay = true
}

musicPlaylist["LawBreaking"] = {
	song = "https://www.youtube.com/watch?v=6en52MdbTyQ",
	title = "Law Breaking",
	luck = 60,
	autoplay = true
}

musicPlaylist["DontGiveUp"] = {
	song = "https://www.youtube.com/watch?v=XjLNSHh0vnU",
	title = "Don't Give Up",
	luck = 30,
	autoplay = true
}

musicPlaylist["Evil"] = {
	song = "https://www.youtube.com/watch?v=m8wU-SfNsjw",
	title = "Evil",
	luck = 30,
	autoplay = true //idk... reevaluate
}

musicPlaylist["NumaMarch"] = {
	song = "https://www.youtube.com/watch?v=qa-n1ygFtuc",
	title = "Numa March",
	luck = 50,
	autoplay = false //ehhh.....
}

musicPlaylist["BigZawa"] = {
	song = "https://www.youtube.com/watch?v=shjmP3ke-gA",
	title = "Big Zawa",
	luck = 20,
	autoplay = false //REALLY CRAZY
}

musicPlaylist["PhoenixStar2"] = {
	song = "https://www.youtube.com/watch?v=X5p0YSU7TxQ",
	title = "Phoenix Star II",
	luck = 20,
	autoplay = true
}

//PrintTable(musicPlaylist)
/*function getmusicPlaylistPlaylist()
	if not musicPlaylist then ErrorNoHalt("why is musicPlaylist not there") return end
	return musicPlaylist
end*/