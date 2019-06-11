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
		frame:SetKeyboardInputEnabled(false)

		local text = vgui.Create("RichText", frame)
		text:Dock(FILL)
		text:SetVerticalScrollbarEnabled(true)
		text:SetSize(frame:GetWide(), frame:GetTall())
		text:SetPos(frame:GetWide() / 2, frame:GetTall() / 2)

		text:InsertColorChange(255, 255, 255, 255)
		text:InsertClickableTextStart("OpenKaiji")
		text:AppendText("Inspired by: Kaiji Ultimate Survivor (Watch it!!!)\n")
		text:InsertClickableTextEnd()

		text:InsertClickableTextStart("OpenTurtle")
		text:AppendText("Gamemode code: Mineturtle\n")
		text:InsertClickableTextEnd()

		text:InsertClickableTextStart("OpenBass")
		text:AppendText("Help with sound: Bassclefff\n")
		text:InsertClickableTextEnd()

		text:InsertClickableTextStart("OpenNanner")
		text:AppendText("Table model and textures: NannerCoco\n")
		text:InsertClickableTextEnd()

		text:AppendText("Music: Hideki Taniuchi\n")
		text:AppendText("Fonts: DS Marker Felt by Typographer Mediengestaltung\n")
		text:AppendText("Card Letter Design: Tambur\n")
		text:AppendText("UI Design: GenerousGuy\n")
		text:AppendText("Empty hands SWEP: Tatrabbit\n")
		text:AppendText("Kidnap SWEP: NauticalCoding\n")
		text:AppendText("Circles library: SneakySquid\n")


		function text:PerformLayout()
			self:SetFontInternal("ChatFont")
			self:SetFGColor(255,255,255,255)
			self:SetBGColor( Color( 32, 32, 46 ) )
		end

		function text:ActionSignal(signalName, signalValue)
			if (signalName == "TextClicked") then
				if (signalValue == "OpenKaiji") then
					gui.OpenURL("https://en.wikipedia.org/wiki/Kaiji_(manga)")
				elseif (signalValue == "OpenTurtle") then
					gui.OpenURL("https://twitter.com/Stamosxd")
				elseif (signalValue == "OpenBass") then
					gui.OpenURL("https://twitter.com/bassclef_map3")
				elseif (signalValue == "OpenNanner") then
					gui.OpenURL("https://twitter.com/NannerCoco")
				end
			end
		end

		creditsOpen = true
	else
		frame:ToggleVisible()
	end
end

concommand.Add("rps_credits", CreditsMenu)