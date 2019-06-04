//local ply = FindMetaTable("Player")
print("cl_lobby load")
local lobbyOpened = false
local playerList = nil
local lobbysound = nil
local _roundstart = false
local leaderboard
// YO DUDE PUT A MUSIC PLAYER HERE

local function openLobby() 

	if lobbyOpened then return end // this is to prevent the lobby opening on players joining in after it opened
	if _roundstart then return end
	if LocalPlayer():Team() == TEAM_SPECTATOR then return end
	lobbyOpened = true
	print("openlobby call")
	local frame = vgui.Create("DFrame")
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

	local tutPanel = vgui.Create("DPanel", frame)
	tutPanel:SetSize(width / 4.2, height / 4.5) //1.2 / 426.6, 201
	tutPanel:SetPos(width / 96, height / 54) // 20, 11.5
	tutPanel:SetBackgroundColor(Color(70, 70, 70, 200))

	local tutText = vgui.Create("RichText", tutPanel)
	tutText:SetText([[
  To win in this game, you must:
  1. Get rid of all your cards.
  2. Have 3 or more Stars.

  Press F1 to open your Inventory.
  Press F2 to open the Jukebox.
  Press F3 to open the Buy Out menu.
  Press F4 to open the Credits.

  Type /cards in chat to check how many cards remain.
  Type /dropmoney (number) to drop money.
  Type /givemoney (number) to give money directly.
  Type /pm to privately message someone. 
  Usage: /pm (name) (message)]])
	tutText:Dock(FILL)
	tutText:SetVerticalScrollbarEnabled(true)
	tutText:SetSize(width / 4, height / 4.5)
	function tutText:PerformLayout()
		self:SetFontInternal("ChatFont")
		self:SetFGColor(255,255,255,255)
	end

	local leaderboardPanel = vgui.Create("DPanel",frame)
	leaderboardPanel:SetSize(width / 4.5, height / 1.5)
	leaderboardPanel:SetPos(width / 96, height / 3.5)
	leaderboardPanel:SetBackgroundColor(Color(70, 70, 70, 220)) // todo: implement leaderboard...

	local leaderboardScroll = vgui.Create("DScrollPanel", leaderboardPanel)
	leaderboardScroll:SetSize(width, height)

	local leaderboardList = vgui.Create("DListLayout", leaderboardScroll)
	leaderboardList:SetSize(leaderboardScroll:GetWide(),leaderboardScroll:GetTall())

	function leaderboardUpdate()
		if !IsValid(frame) then return end
		
		leaderboardList:Clear()

		for k, v in pairs(leaderboard) do
			local PlayerPanel = vgui.Create("DPanel",leaderboardList)
			PlayerPanel:SetSize(leaderboardList:GetWide(), 50)
			PlayerPanel:SetPos(0, 0)
			PlayerPanel.Paint = function()
				draw.RoundedBox(0, 0, 0, PlayerPanel:GetWide(), PlayerPanel:GetTall(), Color(50, 50, 50, 255))
				draw.RoundedBox(0, 0, 49, PlayerPanel:GetWide(), 1, Color(255, 255, 255, 255))

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

	timer.Create("leaderboardhh", 5, 1, leaderboardUpdate)

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

	function closeFrame()
		print("frame closed")
		frame:Close()
	end

	function scoreboardUpdate()
		if !IsValid(frame) then return end
		//print("update")
		PlayerList:Clear()

		for k, v in pairs(player.GetAll()) do
			local PlayerPanel = vgui.Create("DPanel", PlayerList)
			PlayerPanel:SetSize(PlayerList:GetWide(), 50)
			PlayerPanel:SetPos(0, 0)
			PlayerPanel.Paint = function()
				if v:GetNWBool("rps_ready", false) then
					draw.RoundedBox(0, 0, 0, PlayerPanel:GetWide(), PlayerPanel:GetTall(), Color(50, 100, 50, 255))
				else
					draw.RoundedBox(0, 0, 0, PlayerPanel:GetWide(), PlayerPanel:GetTall(), Color(50, 50, 50, 255))
				end
				draw.RoundedBox(0, 0, 49, PlayerPanel:GetWide(), 1, Color(255, 255, 255, 255))

				// put a check here if they even have a name
				draw.SimpleText(v:GetName(), "DermaDefault", 50, 15, Color(255, 255, 255))
				draw.SimpleText("Ping: " .. v:Ping(), "DermaDefault", PlayerList:GetWide() - 20, 10, Color(140, 255, 140), TEXT_ALIGN_RIGHT)
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
		chromiumWarn:SetSize(200, 100)
		chromiumWarm:SetPos(frame:GetWide() / 4, frame:GetTall() / 4)
		chromiumWarn:SetText("You don't have Chromium! Make sure to switch to the Chromium branch for the best experience.")
	end
	

	//local musicVolumeSlider = vgui.Create("DNumSlider", frame)
	timer.Create("ScoreboardUpdate", 1, 0, scoreboardUpdate)
	timer.Simple(1.5, function() 
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

net.Receive("CloseLobby", function(len, ply)
	print("closelobby received")
	--LocalPlayer():StopSound("little_zawa")
	if !(lobbysound == nil) then
		lobbysound:FadeOut(2)
	end
	timer.Destroy("ScoreboardUpdate")
	timer.Destroy("ReadyButton")
	timer.Destroy("AdminButton")
	closeFrame()
end)

print("cl lobby load end")

//net.Receive("OpenLobby", timer.Simple(2, openLobby))

hook.Add("InitPostEntity", "stupid_music", function()
	if MySelf:IsValid() then
		openLobby()
	end
end)

hook.Add("RoundStarted","LobbyStart", function()
	_roundstart = true
end)

net.Receive("SendLeaderboardInfo", function()
	local len = net.ReadUInt(16)
	local data = net.ReadData(len)
	if not data then ErrorNoHalt("why is data nil") end
	local json = util.Decompress(data)
	if not json then ErrorNoHalt("why is json nil???") end
	//print(json)
	leaderboard = util.JSONToTable(json)
	//PrintTable(leaderboard)
end)