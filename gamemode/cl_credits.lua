local creditsOpen = false
local frame

local function CreditsMenu()
	if not creditsOpen then
		frame = vgui.Create("DFrame")
		frame:SetSize(500, 500)
		frame:SetDeleteOnClose(false)
		frame:SetTitle("Credits")
		frame:MakePopup()
		frame:Center()

		local text = vgui.Create("RichText", frame)
		text:Dock(FILL)
		text:SetVerticalScrollbarEnabled(false)
		text:SetSize(frame:GetWide(), frame:GetTall())
		text:SetPos(frame:GetWide() / 2, frame:GetTall() / 2)
		text:AppendText("Creator: Mineturtle\n")
		text:AppendText("Help with sound: Bassclefff\n")
		function text:PerformLayout()
			self:SetFontInternal("ChatFont")
			self:SetFGColor(255,255,255,255)
		end

		creditsOpen = true
	else
		frame:ToggleVisible()
	end
end

concommand.Add("rps_credits", CreditsMenu)