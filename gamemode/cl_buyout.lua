local menuOpen = false
local frame

local function BuyOutMenu()
	local width = ScrW()
	local height = ScrH()

	if not menuOpen then
		frame = vgui.Create("DFrame")
		frame:SetSize(500, 500)
		frame:SetDeleteOnClose(false)
		frame:SetTitle("Buy Out")
		frame:MakePopup()
		frame:Center()
		frame:SetKeyboardInputEnabled(false)

		local PlayerScrollPanel = vgui.Create("DScrollPanel", frame)
		PlayerScrollPanel:SetSize(frame:GetWide() - 10, frame:GetTall() - 60)
		PlayerScrollPanel:SetPos(5, 30)

		local PlayerList = vgui.Create("DListLayout", PlayerScrollPanel)
		PlayerList:SetSize(PlayerScrollPanel:GetWide(), PlayerScrollPanel:GetTall())
		PlayerList:SetPos(0, 0)

		function UpdateMenu()
			if !IsValid(frame) then return end
			//print("update")
			PlayerList:Clear()

			for k, v in pairs(player.GetAll()) do
				//print("fuuuuck")
				local isDefeated = v:GetNWBool("Defeated", false)
				local PlayerPanel = vgui.Create("DPanel", PlayerList)
				PlayerPanel:SetSize(PlayerList:GetWide(), 50)
				PlayerPanel:SetPos(0, 0)
				PlayerPanel.Paint = function()
					if (isDefeated) then
						draw.RoundedBox(0, 0, 0, PlayerPanel:GetWide(), PlayerPanel:GetTall(), Color(50, 100, 50, 255))
					else
						draw.RoundedBox(0, 0, 0, PlayerPanel:GetWide(), PlayerPanel:GetTall(), Color(100, 50, 50, 255))
					end

					draw.RoundedBox(0, 0, 49, PlayerPanel:GetWide(), 1, Color(255, 255, 255, 255))

					// put a check here if they even have a name
					draw.SimpleText(v:GetName(), "DermaDefault", 50, 15, Color(255, 255, 255))
				end

				local playerAvatar = vgui.Create("AvatarImage", PlayerPanel)
				playerAvatar:SetSize(32, 32)
				playerAvatar:SetPos(4, (PlayerPanel:GetTall() / 2) - 16)
				playerAvatar:SetPlayer(v, 32)

				if not (isDefeated) then return end
				local buyoutButton = vgui.Create("DButton", PlayerPanel)
				buyoutButton:SetSize(40, 30)
				buyoutButton:SetPos(420, 10)
				buyoutButton:SetText("Buyout")
				buyoutButton.DoClick = function()
					if LocalPlayer():ReturnPlayerVar("stars") < 3 then
						chat.AddText("You cannot buyout a player without at least 3 stars!")
						return
					end
					
					net.Start("BuyoutPlayer")
						net.WriteEntity(v)
					net.SendToServer()
				end
			end
		end

		timer.Create("MenuUpdate", 2, 0, UpdateMenu)
		menuOpen = true
		print("fuck")
		UpdateMenu()
	else
		frame:ToggleVisible()
	end
end

concommand.Add("rps_buyout", BuyOutMenu)