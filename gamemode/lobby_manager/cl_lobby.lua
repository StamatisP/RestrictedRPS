//local ply = FindMetaTable("Player")
print("cl_lobby load")
local lobbyOpened = false
local playerList = nil
local lobbysound = nil
// YO DUDE PUT A MUSIC PLAYER HERE

local function openLobby() 

	if lobbyOpened then return end // this is to prevent the lobby opening on players joining in after it opened
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
		draw.RoundedBox(0,0,0,w,h,Color(12, 78, 125,255))

	end
	frame:MakePopup()

	local moneyEntry = vgui.Create("DNumSlider",frame)
	moneyEntry:SetSize(600, 50)
	moneyEntry:SetPos(ScrW() / 2 - (600/2), ScrH() / 2 + 50)
	moneyEntry:SetText("Enter your desired loan of money.")
	moneyEntry:SetMin(1000000)
	moneyEntry:SetMax(10000000)
	moneyEntry:SetDecimals(0)
	moneyEntry:SetDefaultValue(1000000)
	/*if (type(ply:databaseSetValue)=="function") then
		print("money set")
		ply:databaseSetValue("money", moneyEntry:GetValue())
	else
		print("wtf why")
	end*/
	moneyEntry:SetConVar("rps_money")

	// make this also dependant on scrw/scrh
	local width = ScrW()
	local height = ScrH()

	local PlayerScrollPanel = vgui.Create("DScrollPanel", frame)
	PlayerScrollPanel:SetSize(frame:GetWide() / 2, frame:GetTall() / 4 + 50)
	PlayerScrollPanel:SetPos(width / 3.885, height / 1.536)
	// all relative sizes were based on 1360 x 768

	local PlayerList = vgui.Create("DListLayout", PlayerScrollPanel)
	PlayerList:SetSize(PlayerScrollPanel:GetWide(), PlayerScrollPanel:GetTall())
	PlayerList:SetPos(0, 0)

	local disconnectButton = vgui.Create("DButton", frame)
	disconnectButton:SetSize(100, 50)
	disconnectButton:SetPos(ScrW() / 1.1, ScrH() / 1.1)
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
				draw.RoundedBox(0,0,0,PlayerPanel:GetWide(),PlayerPanel:GetTall(),Color(50, 50, 50, 255))
				draw.RoundedBox(0,0,49,PlayerPanel:GetWide(),1,Color(255, 255, 255, 255))

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

	//local musicVolumeSlider = vgui.Create("DNumSlider", frame)

	if (!IsValid(LocalPlayer()) || !LocalPlayer():IsAdmin()) then print("either localplayer isnt valid or you arent admin, "..tostring(LocalPlayer())) return end -- If not admin, dont execute code below in this function
	print("dbutton create, " ..tostring(LocalPlayer()))
	local startButton = vgui.Create("DButton", frame)
	startButton:SetSize(200,75)
	startButton:SetPos(ScrW()/2 - 100, ScrH()/2 - (75/2))
	startButton:SetText("Start Game")
	startButton.DoClick = function() 

		net.Start("StartGame")
		net.SendToServer()

		//net.Start("moneyUpdate")
		//	net.WriteInt(moneyEntry:GetValue(), 28)
		//net.SendToServer()
		//ply:databaseSetValue("money", moneyEntry:GetValue())
		//self:SetNWInt("money", moneyEntry:GetValue())

		//closeFrame()
	end

	--LocalPlayer():EmitSound("little_zawa")
	

	timer.Create("ScoreboardUpdate", 1, 0, scoreboardUpdate)
end

net.Receive("CloseLobby", function(len, ply)
	print("closelobby received")
	--LocalPlayer():StopSound("little_zawa")
	if !(lobbysound == nil) then
		lobbysound:FadeOut(2)
	end
	closeFrame()
end)

print("cl lobby load end")

net.Receive("OpenLobby", timer.Simple(0.95, openLobby))

hook.Add("InitPostEntity", "stupid_music", function()
	if MySelf:IsValid() then

		timer.Simple(1.5, function() 
			lobbysound = FadeInMusic("music/littlezawa_loop_by_bass.wav")	
		end)
	end
end)