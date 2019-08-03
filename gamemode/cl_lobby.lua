//local ply = FindMetaTable("Player")
print("cl_lobby load")
local lobbyOpened = false
local playerList = nil
local lobbysound = nil
local _roundstart = false
local leaderboard
local frame = nil
// YO DUDE PUT A MUSIC PLAYER HERE

local function openLobby() 

	if lobbyOpened then return end // this is to prevent the lobby opening on players joining in after it opened
	if _roundstart then return end
	//if LocalPlayer():Team() == 3 then return end
	lobbyOpened = true
	print("openlobby call")
	frame = vgui.Create("DFrame")
	frame:SetSize(ScrW(),ScrH())
	frame:Center()
	frame:SetVisible(true)
	frame:ShowCloseButton(false)
	frame:SetDraggable(false)
	frame:SetTitle("")
	frame.Paint = function(s, w, h)

		//draw.RoundedBox(0,0,0,w,h,Color(100,100,100,255))
		draw.RoundedBox(0,0,0,w,h,Color(0, 0, 0,210))

	end
	frame:MakePopup()
	frame:SetKeyboardInputEnabled(false)

	local width = ScrW()
	local height = ScrH()

	local tutCallout = vgui.Create("DImage", frame)
	local tutImg = Material("tutcallout.png", "alphatest nocull")
	tutCallout:SetKeepAspect(true)
	tutCallout:SetMaterial(tutImg)
	tutCallout:SetPos(width / 1.25, height / -54)
	tutCallout:SetSize(256, 256)

	local tutPanel = vgui.Create("DPanel", frame)
	tutPanel:SetSize(width / 4.5, height / 3) //1.2 / 426.6, 201
	tutPanel:SetPos(width / 1.3, height / 5) // 20, 11.5
	tutPanel:SetBackgroundColor(Color(244, 66, 101, 200))

	local tutText = vgui.Create("RichText", tutPanel)
	tutText:SetText([[
  To win in this game, you must:
  	1. Get rid of all your cards.
  	2. Have 3 or more Stars.

  Press F1 to open your Inventory.
  Press F2 to open the Jukebox.
  Press F3 to open the Buy Out menu.
  Press F4 to open the Credits.

  Type /cards to check how many cards remain.
  Type /dropmoney (number) to drop money.
  Type /givemoney (number) to give money to who you are looking at.
  Type /pm to privately message someone. 
  Usage: /pm (name) (message)
  Type /help to see this message again.]])
	tutText:Dock(FILL)
	tutText:SetVerticalScrollbarEnabled(true)
	tutText:SetSize(width / 4, height / 4.5)
	function tutText:PerformLayout()
		self:SetFontInternal("ChatFont")
		self:SetFGColor(255,255,255,255)
	end

	local leaderboardPanel = vgui.Create("DPanel",frame)
	local leaderboardConst = height / 2.16
	leaderboardPanel:SetSize(width / 4.5, leaderboardConst)
	// 720... the panel should be 10playersx50px, so 500. 1080 / 2.16 = 500
	leaderboardPanel:SetPos(width / 96, height / 2.05)
	leaderboardPanel:SetBackgroundColor(Color(70, 70, 70, 220)) // todo: implement leaderboard...

	local leaderboardScroll = vgui.Create("DScrollPanel", leaderboardPanel)
	leaderboardScroll:SetSize(leaderboardPanel:GetWide(), leaderboardPanel:GetTall())

	local leaderboardList = vgui.Create("DListLayout", leaderboardScroll)
	leaderboardList:SetSize(leaderboardScroll:GetWide(),leaderboardScroll:GetTall())

	function leaderboardUpdate()
		if !IsValid(frame) then print ("frame not valid") return end
		
		leaderboardList:Clear()

		if not leaderboard then print("leaderboard not valid") return end

		for k, v in pairs(leaderboard) do
			local PlayerPanel = vgui.Create("DPanel",leaderboardList)
			PlayerPanel:SetSize(leaderboardList:GetWide(), leaderboardConst / 10)
			PlayerPanel:SetPos(0, 0)
			PlayerPanel.Paint = function()
				draw.RoundedBox(0, 0, 0, PlayerPanel:GetWide(), PlayerPanel:GetTall(), Color(50, 50, 50, 255))
				draw.RoundedBox(0, 0, (leaderboardConst / 10) - 1, PlayerPanel:GetWide(), 1, Color(255, 255, 255, 255))

				// put a check here if they even have a name
				draw.SimpleText(v.name, "DermaDefault", 60, 5, Color(255, 255, 255))
				//draw.SimpleText("Ping: " .. v:Ping(), "DermaDefault", leaderboardList:GetWide() - 20, 10, Color(140, 255, 140), TEXT_ALIGN_RIGHT)
				draw.SimpleText(formatMoney(tonumber(v.money)), "DermaDefault", 70, 20, Color(60, 255, 50))
				draw.SimpleText(formatMoney(tonumber(v.debt)), "DermaDefault", 70, 30, Color(255, 50, 50))
			end

			local playerAvatar = vgui.Create("AvatarImage", PlayerPanel)
			playerAvatar:SetSize(32, 32)
			playerAvatar:SetPos(8, 8)
			playerAvatar:SetSteamID(util.SteamIDTo64(v.unique_id), 32)
		end
	end

	timer.Create("leaderboardhh", 2, 1, leaderboardUpdate)

	local panelBg = vgui.Create("DPanel", frame)
	panelBg:SetSize(width / 2, height / 2.45)
	panelBg:SetPos(width / 3.885, height / 1.85)
	panelBg:SetBackgroundColor(Color(70, 70, 70, 230))

	local logoImage = vgui.Create("DImage", frame)
	local img = Material("logo.png", "alphatest nocull") // todo: make this an actual material in the future
	logoImage:SetKeepAspect(true)
	logoImage:SetMaterial(img)
	logoImage:SetPos(width / 4, height / 6)
	logoImage:SetSize(1024, 128)

	local moneyEntry = vgui.Create("DNumSlider",frame)
	moneyEntry:SetSize(600, 50)
	moneyEntry:SetPos(ScrW() / 2 - (600/2), ScrH() / 2 + 50)
	moneyEntry:SetText("Enter your desired loan of money.")
	moneyEntry:SetMin(1000000)
	moneyEntry:SetMax(10000000)
	moneyEntry:SetDecimals(0)
	moneyEntry:SetDefaultValue(1000000)
	moneyEntry:SetConVar("rps_money")

	// make this also dependant on scrw/scrh
	local PlayerScrollPanel = vgui.Create("DScrollPanel", frame)
	PlayerScrollPanel:SetSize(frame:GetWide() / 2, frame:GetTall() / 4 + 50)
	PlayerScrollPanel:SetPos(width / 3.885, height / 1.536)
	// all relative sizes were based on 1360 x 768

	local PlayerList = vgui.Create("DListLayout", PlayerScrollPanel)
	PlayerList:SetSize(PlayerScrollPanel:GetWide(), PlayerScrollPanel:GetTall())
	PlayerList:SetPos(0, 0)

	local disconnectButton = vgui.Create("DButton", frame)
	disconnectButton:SetSize(100, 50)
	disconnectButton:SetPos(width / 1.1, height / 1.1)
	disconnectButton:SetText("Disconnect")
	disconnectButton.DoClick = function()
		LocalPlayer():ConCommand("disconnect")
	end

	function scoreboardUpdate()
		if !IsValid(frame) then return end
		//print("update")
		PlayerList:Clear()

		for k, v in pairs(player.GetAll()) do
			local PlayerPanel = vgui.Create("DPanel", PlayerList)
			PlayerPanel:SetSize(PlayerList:GetWide(), 50)
			PlayerPanel:SetPos(0, 0)
			local pname = v:Nick()
			local pping = v:Ping()	
			PlayerPanel.Paint = function()
				if v:GetNWBool("rps_ready", false) then
					draw.RoundedBox(0, 0, 0, PlayerPanel:GetWide(), PlayerPanel:GetTall(), Color(50, 100, 50, 255))
				elseif v:IsAdmin() then
					draw.RoundedBox(0, 0, 0, PlayerPanel:GetWide(), PlayerPanel:GetTall(), Color(133, 50, 168, 255))
				else
					draw.RoundedBox(0, 0, 0, PlayerPanel:GetWide(), PlayerPanel:GetTall(), Color(50, 50, 50, 255))
				end
				draw.RoundedBox(0, 0, 49, PlayerPanel:GetWide(), 1, Color(255, 255, 255, 255))
				
				// put a check here if they even have a name
				//if not v then return end
				draw.SimpleText(pname, "DermaDefault", 50, 15, Color(255, 255, 255))
				draw.SimpleText("Ping: " .. pping, "DermaDefault", PlayerList:GetWide() - 20, 10, Color(140, 255, 140), TEXT_ALIGN_RIGHT)
			end
			local playerAvatar = vgui.Create("AvatarImage", PlayerPanel)
			playerAvatar:SetSize(32, 32)
			playerAvatar:SetPos(4, (PlayerPanel:GetTall() / 2) - 16)
			playerAvatar:SetPlayer(v, 32)
		end
	end
	
	local moneyEntryText = moneyEntry:GetTextArea()
	moneyEntryText:SetSize(100, 50)

	if (BRANCH != "chromium") then
		local chromiumWarn = vgui.Create("DLabel", frame)
		chromiumWarn:SetSize(900, 900)
		chromiumWarn:SetFont("CardText")
		chromiumWarn:SetColor(Color(255, 0, 0))
		chromiumWarn:SetPos(frame:GetWide() / 4, frame:GetTall() / 4)
		chromiumWarn:SetText("You don't have Chromium! Make sure to switch to the Chromium branch for the best experience.")
	end

	local discordButton = vgui.Create("DImageButton", frame)
	discordButton:SetPos(width / 96, 0)
	// width / 1.28, 0
	discordButton:SetImage("discord_shoutout.png")
	discordButton:SetSize(400, 300)
	discordButton.DoClick = function()
		gui.OpenURL("https://discord.gg/AsUzGwu")
	end
	

	//local musicVolumeSlider = vgui.Create("DNumSlider", frame)
	timer.Create("ScoreboardUpdate", 1, 0, scoreboardUpdate)
	timer.Simple(4, function()
		if _roundstart then return end
		if not IsValid(LocalPlayer()) then return end
		lobbysound = FadeInMusicSndMng("music/littlezawa_loop_by_bass.wav")	
	end)

	timer.Create("AdminButton", 1, 0, function()
		if not IsValid(LocalPlayer()) then return end
		if not LocalPlayer():IsAdmin() then timer.Destroy("AdminButton") return end

		print("dbutton create, " ..tostring(LocalPlayer()))
		local startButton = vgui.Create("DButton", frame)
		startButton:SetSize(ScrW() / 9.6, ScrH() / 14.4)
		startButton:SetPos(ScrW() / 2.232, ScrH() / 2.149)
		startButton:SetText("Start Game")
		startButton.DoClick = function() 
			net.Start("StartGame")
			net.SendToServer()
		end
		timer.Destroy("AdminButton")
	end)
	timer.Create("ReadyButton", 1, 0, function()
		if not IsValid(LocalPlayer()) then return end
		if LocalPlayer():IsAdmin() then timer.Destroy("ReadyButton") return end

		local readyButton = vgui.Create("DButton", frame)
		readyButton:SetSize(ScrW() / 9.6, ScrH() / 14.4)
		readyButton:SetPos(ScrW() / 2.232, ScrH() / 2.149)
		readyButton:SetText("Ready Up")
		readyButton.DoClick = function()
			if LocalPlayer():GetNWBool("rps_ready", false) then 
				net.Start("PlayerReady")
					net.WriteBool(false)
				net.SendToServer()
			else
				net.Start("PlayerReady")
					net.WriteBool(true)
				net.SendToServer()
			end
		end
	end)
end

local function closeFrame()
	if not IsValid(frame) then return end
	print("frame closed")
	print(frame)
	frame:Close()
end

net.Receive("CloseLobby", function(len, ply)
	print("closelobby received")
	--LocalPlayer():StopSound("little_zawa")
	if (lobbysound ~= nil) then
		lobbysound:FadeOut(2)
	end
	timer.Destroy("ScoreboardUpdate")
	timer.Destroy("ReadyButton")
	timer.Destroy("AdminButton")
	closeFrame()
end)

print("cl lobby load end")

//net.Receive("OpenLobby", timer.Simple(2, openLobby))

/*hook.Add("InitPostEntity", "stupid_music", function()
	if MySelf:IsValid() then
		if GetGlobalBool("RoundStarted", false) then
			return
		end
		openLobby()
	end
end)*/

net.Receive("OpenLobby", function()
	openLobby()
end)

hook.Add("RoundStarted","LobbyStart", function()
	_roundstart = true
end)

/*timer.Create("CheckRoundStart", 1, 0, function()
	if _roundstart and not frame then 
		closeFrame() 
		timer.Destroy("CheckRoundStart")
	end
end)*/

net.Receive("SendLeaderboardInfo", function()
	local len = net.ReadUInt(16)
	local data = net.ReadData(len)
	if not data then ErrorNoHalt("why is data nil") end
	local json = util.Decompress(data)
	if not json then ErrorNoHalt("why is json nil???") end
	print("leaderboard info sent")
	leaderboard = util.JSONToTable(json)
	//PrintTable(leaderboard)
end)