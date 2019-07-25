musicPlaylist = {}

function getMusic(name)
	if musicPlaylist[name] then
		return musicPlaylist[name]
	end
	return false
end

musicPlaylist[1] = {
	song = "https://www.youtube.com/watch?v=Oog3m3LrA8A",
	title = "This World",
	luck = 40,
	autoplay = true
}

musicPlaylist[2] = {
	song = "https://www.youtube.com/watch?v=U0pp0WeMqhs",
	title = "Lot",
	luck = 20,
	autoplay = true
}

// is this too high energy for the mode? maybe exclude it from autoplay
musicPlaylist[3] = {
	song = "https://www.youtube.com/watch?v=eHRes2_wZE4",
	title = "Kaiji",
	luck = 50,
	autoplay = false
}

musicPlaylist[4] = {
	song = "https://www.youtube.com/watch?v=ptA3_Vh2WMw",
	title = "Human Derby (Man Racetrack)",
	luck = 10,
	autoplay = true
}

musicPlaylist[5] = {
	song = "https://www.youtube.com/watch?v=VWfTSl07jO4",
	title = "Green",
	luck = 60,
	autoplay = true
}

musicPlaylist[6] = {
	song = "https://www.youtube.com/watch?v=1vv_u00Yk6w",
	title = "Wish",
	luck = 70,
	autoplay = false // i have to reevaluate all of this later on
}

musicPlaylist[7] = {
	song = "https://www.youtube.com/watch?v=OK0OmKLSgN0",
	title = "Line of Light",
	luck = 80,
	autoplay = false
}

musicPlaylist[8] = {
	song = "https://www.youtube.com/watch?v=soUBJC26690",
	title = "String of Light",
	luck = 60,
	autoplay = true
}

musicPlaylist[9] = {
	song = "https://www.youtube.com/watch?v=vwzNLYbkcFM",
	title = "Memories",
	luck = 60,
	autoplay = true
}

musicPlaylist[10] = {
	song = "https://www.youtube.com/watch?v=jDFG4Mj3r4Y",
	title = "This World II",
	luck = 40,
	autoplay = true
}

musicPlaylist[11] = {
	song = "https://www.youtube.com/watch?v=hgVb8-D25nc",
	title = "Predicament",
	luck = 40,
	autoplay = false
}

musicPlaylist[12] = {
	song = "https://www.youtube.com/watch?v=iYUrU1Bgz00",
	title = "Espoir",
	luck = 30,
	autoplay = true //reevaluate
}

musicPlaylist[13] = {
	song = "https://www.youtube.com/watch?v=Tts7Nv_hNhk",
	title = "Despair",
	luck = 50,
	autoplay = false
}

musicPlaylist[14] = {
	song = "https://www.youtube.com/watch?v=ISVRw7ohwM0",
	title = "Ship of Hope",
	luck = 30, 
	autoplay = true
}

musicPlaylist[15] = {
	song = "https://www.youtube.com/watch?v=o8aLBhyWU_k",
	title = "Regret",
	luck = 0,
	autoplay = false // may manually trigger
}

musicPlaylist[16] = {
	song = "https://www.youtube.com/watch?v=lO8gPwwlms0",
	title = "Chest",
	luck = 20,
	autoplay = true
}

musicPlaylist[17] = {
	song = "https://www.youtube.com/watch?v=WUGQ58Su6u0",
	title = "Child's Mind",
	luck = 30, 
	autoplay = true
}

musicPlaylist[18] = {
	song = "https://www.youtube.com/watch?v=YSpBMaT25Vg",
	title = "This World III",
	luck = 30,
	autoplay = true
}

musicPlaylist[19] = {
	song = "https://www.youtube.com/watch?v=QmZx5PmidKU",
	title = "Beginning",
	luck = 20,
	autoplay = true 
}

musicPlaylist[20] = {
	song = "https://www.youtube.com/watch?v=vaNL2ZSlnM0",
	title = "Ko Zawazawa 1",
	luck = 40,
	autoplay = true
}

musicPlaylist[21] = {
	song = "https://www.youtube.com/watch?v=odorjWD1exw",
	title = "Chuu Zawazawa 1",
	luck = 30,
	autoplay = true
}

musicPlaylist[22] = {
	song = "https://www.youtube.com/watch?v=8q-P-bcKQiM",
	title = "Dai Zawazawa 1",
	luck = 20,
	autoplay = true
}

musicPlaylist[23] = {
	song = "https://www.youtube.com/watch?v=P2esT0IlghE",
	title = "Dai Zawazawa 2",
	luck = 20,
	autoplay = true // played during intro to rrps in show
}

musicPlaylist[24] = {
	song = "https://www.youtube.com/watch?v=yDQZv_FwFio",
	title = "Dai Dai Zawazawa",
	luck = 10,
	autoplay = true
}

musicPlaylist[25] = {
	song = "https://www.youtube.com/watch?v=D4wKGQpL12w",
	title = "Strategy",
	luck = 50,
	autoplay = true
}

musicPlaylist[26] = {
	song = "https://www.youtube.com/watch?v=KWnEfJGB9k0",
	title = "Chaos",
	luck = 10,
	autoplay = false
}

musicPlaylist[27] = {
	song = "https://www.youtube.com/watch?v=OANsUz_dCfs",
	title = "Confusion",
	luck = 30,
	autoplay = true
}

/*musicPlaylist[28] = {
	song = "https://www.youtube.com/watch?v=su63vn7sSrs",
	title = "Defeat",
	luck = 0,
	autoplay = false //its defeat musicPlaylist, like regret. ramps up really hard in the middle. also broken
}*/

musicPlaylist[29] = {
	song = "https://www.youtube.com/watch?v=Cb5-uoNqKcs",
	title = "Shadow",
	luck = 70,
	autoplay = true
}

musicPlaylist[30] = {
	song = "https://www.youtube.com/watch?v=8kJXwCuBCDI",
	title = "Chorus",
	luck = 20, 
	autoplay = true
}

musicPlaylist[31] = {
	song = "https://www.youtube.com/watch?v=47YLPfSgKN0",
	title = "Rest",
	luck = 40, 
	autoplay = true
}

musicPlaylist[32] = {
	song = "https://www.youtube.com/watch?v=CskUY47jupc",
	title = "Stagnation",
	luck = 30,
	autoplay = true
}

musicPlaylist[33] = {
	song = "https://www.youtube.com/watch?v=qeUxc-1ctt4",
	title = "Ko Zawa Inst 2",
	luck = 30,
	autoplay = true
}

musicPlaylist[34] = {
	song = "https://www.youtube.com/watch?v=-0MjinrXgnk",
	title = "White Light Moment",
	luck = 90,
	autoplay = true
}// top ten bruh moments

musicPlaylist[35] = {
	song = "https://www.youtube.com/watch?v=9J3SE1bdvMs",
	title = "Montage",
	luck = 40,
	autoplay = true
}

musicPlaylist[36] = {
	song = "https://www.youtube.com/watch?v=kL4442pWijE",
	title = "Phoenix",
	luck = 60,
	autoplay = false //reevaluate??
}

musicPlaylist[37] = {
	song = "https://www.youtube.com/watch?v=5F46YiqU1js",
	title = "Transparent",
	luck = 50,
	autoplay = false //really long, maybe reevaluate
}

musicPlaylist[38] = {
	song = "https://www.youtube.com/watch?v=i-23BEz5Pf4",
	title = "More",
	luck = 50,
	autoplay = true //reevaluate, this song crazy
}

musicPlaylist[39] = {
	song = "https://www.youtube.com/watch?v=4i2p5rUoWuY",
	title = "Led",
	luck = 40, 
	autoplay = true // reevaluate luck, this is a good song, it should play at any point tbh
}

/*musicPlaylist[40] = {
	song = "https://www.youtube.com/watch?v=7G0ro9uAYqg", // bugged
	title = "Dice",
	luck = 30,
	autoplay = true
}

musicPlaylist[41] = {
	song = "https://www.youtube.com/watch?v=R-o17U7fGFw",
	title = "Black Sun", // bugged
	luck = 30,
	autoplay = true
}*/

musicPlaylist[42] = {
	song = "https://www.youtube.com/watch?v=3yoWcXOFb7I",
	title = "Quest",
	luck = 20,
	autoplay = true
}

musicPlaylist[43] = {
	song = "https://www.youtube.com/watch?v=YZDfOo5qEsg",
	title = "Bassment",
	luck = 30,
	autoplay = true
}

musicPlaylist[44] = {
	song = "https://www.youtube.com/watch?v=PmSLmYj0CQY",
	title = "Elegie",
	luck = 10,
	autoplay = true
}

musicPlaylist[45] = {
	song = "https://www.youtube.com/watch?v=_i15Ns1geJg",
	title = "Fate",
	luck = 90,
	autoplay = true // really long so idk, reevaluate
}

musicPlaylist[46] = {
	song = "https://www.youtube.com/watch?v=uCb7TInc_RE",
	title = "Golden Light",
	luck = 70,
	autoplay = true
}

musicPlaylist[47] = {
	song = "https://www.youtube.com/watch?v=m3aFFSBl7Tc",
	title = "White Heat",
	luck = 80,
	autoplay = true
}

musicPlaylist[48] = {
	song = "https://www.youtube.com/watch?v=Ev4QL1KFd8w",
	title = "Broken",
	luck = 30,
	autoplay = true
}

musicPlaylist[49] = {
	song = "https://www.youtube.com/watch?v=cfnYoQzccY8",
	title = "Little Zawa",
	luck = 30,
	autoplay = false //this plays in lobby so itd be boring to hear it again
}

musicPlaylist[50] = {
	song = "https://www.youtube.com/watch?v=VkucGLA08Iw",
	title = "Middle Zawa",
	luck = 40,
	autoplay = true
}

musicPlaylist[51] = {
	song = "https://www.youtube.com/watch?v=S3BY5w-wyOY",
	title = "Epic Zawa",
	luck = 30,
	autoplay = true
}

musicPlaylist[52] = {
	song = "https://www.youtube.com/watch?v=BbSLyeurl9E",
	title = "Hyper Zawa",
	luck = 20,
	autoplay = true
}

musicPlaylist[53] = {
	song = "https://www.youtube.com/watch?v=ezaQUbMKqGY",
	title = "Max Zawa",
	luck = 20,
	autoplay = false //this song is really crazy
}

musicPlaylist[54] = {
	song = "https://www.youtube.com/watch?v=jilCFoCUhBM",
	title = "High Max",
	luck = 50,
	autoplay = false //this song is long and also crazy
}

musicPlaylist[55] = {
	song = "https://www.youtube.com/watch?v=0UCny8EnyJ4",
	title = "Inside",
	luck = 30,
	autoplay = true
}

musicPlaylist[56] = {
	song = "https://www.youtube.com/watch?v=eMjX06cqi1A",
	title = "Golden Sight",
	luck = 10,
	autoplay = true
}

musicPlaylist[57] = {
	song = "https://www.youtube.com/watch?v=PNpvM0ZJL60",
	title = "Phoenix Star",
	luck = 30,
	autoplay = true
}

musicPlaylist[58] = {
	song = "https://www.youtube.com/watch?v=EIIK9E72aIc",
	title = "Hyper",
	luck = 40,
	autoplay = false //kinda long? reevaluate
}

musicPlaylist[59] = {
	song = "https://www.youtube.com/watch?v=WroYXO1vOCM",
	title = "Transparent II",
	luck = 50,
	autoplay = true
}

musicPlaylist[60] = {
	song = "https://www.youtube.com/watch?v=vdXwIeiDUYM",
	title = "Miracle",
	luck = 60,
	autoplay = false //idk man im tired, reevaluate
}

musicPlaylist[61] = {
	song = "https://www.youtube.com/watch?v=2laf_EQqdYA",
	title = "Hakairoku Theme",
	luck = 40,
	autoplay = true
}

musicPlaylist[62] = {
	song = "https://www.youtube.com/watch?v=Qh0MrJQs-kE",
	title = "Inferior",
	luck = 30,
	autoplay = true
}

musicPlaylist[63] = {
	song = "https://www.youtube.com/watch?v=ZGdSqSaEb5E",
	title = "Dusk",
	luck = 40,
	autoplay = true
}

musicPlaylist[64] = {
	song = "https://www.youtube.com/watch?v=JKMjnUwkgjk",
	title = "White Light",
	luck = 60,
	autoplay = true
}

musicPlaylist[65] = {
	song = "https://www.youtube.com/watch?v=nk0Yu5gihPg",
	title = "Trap",
	luck = 20,
	autoplay = true
}

musicPlaylist[66] = {
	song = "https://www.youtube.com/watch?v=DlbKOfbvliY",
	title = "Prologue",
	luck = 30,
	autoplay = true
}

musicPlaylist[67] = {
	song = "https://www.youtube.com/watch?v=DbNSX-6qHfQ",
	title = "Enemy",
	luck = 30,
	autoplay = true
}

musicPlaylist[68] = {
	song = "https://www.youtube.com/watch?v=KAx956Rph8I",
	title = "Law Breaking Theme",
	luck = 30,
	autoplay = false //no idea man... its hard
}

musicPlaylist[69] = {
	song = "https://www.youtube.com/watch?v=fECtYLuuF0k",
	title = "Hakairoku",
	luck = 70,
	autoplay = true
}

musicPlaylist[70] = {
	song = "https://www.youtube.com/watch?v=UMztjxYKSDw",
	title = "Numa",
	luck = 30,
	autoplay = true
}

musicPlaylist[71] = {
	song = "https://www.youtube.com/watch?v=6en52MdbTyQ",
	title = "Law Breaking",
	luck = 60,
	autoplay = true
}

musicPlaylist[72] = {
	song = "https://www.youtube.com/watch?v=XjLNSHh0vnU",
	title = "Don't Give Up",
	luck = 30,
	autoplay = true
}

musicPlaylist[73] = {
	song = "https://www.youtube.com/watch?v=m8wU-SfNsjw",
	title = "Evil",
	luck = 30,
	autoplay = true //idk... reevaluate
}

musicPlaylist[74] = {
	song = "https://www.youtube.com/watch?v=qa-n1ygFtuc",
	title = "Numa March",
	luck = 50,
	autoplay = false //ehhh.....
}

musicPlaylist[75] = {
	song = "https://www.youtube.com/watch?v=shjmP3ke-gA",
	title = "Big Zawa",
	luck = 20,
	autoplay = false //REALLY CRAZY
}

musicPlaylist[76] = {
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