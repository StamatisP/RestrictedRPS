local database = {}
local invOpen = false
local f
print("client database load")

local SKINS = {}
SKINS.COLORS = {
	lightgrey = Color(131, 131, 131, 180),
	grey = Color(111,111,111,180),
	lowWhite = Color(243, 243, 243, 180),
	goodblack = Color(41, 41, 41, 230),
}

function SKINS:DrawFrame(w, h)
	topHeight = 24
	local rounded = 4
	draw.RoundedBoxEx(rounded, 0, 0, w, topHeight, SKINS.COLORS.lightgrey, true, true, false, false)
	draw.RoundedBoxEx(rounded, 0, topHeight, w, h - topHeight, SKINS.COLORS.lightgrey, false, false, true, true)
	draw.RoundedBoxEx(rounded, 2, topHeight, w - 4, h - topHeight - 2, SKINS.COLORS.goodblack, false, false, true, true)

	local QuadTable = {}
	QuadTable.texture = surface.GetTextureID("gui/gradient")
	QuadTable.color = Color(10, 10, 10, 120)
	QuadTable.x = 2
	QuadTable.y = topHeight
	QuadTable.w = w - 4
	QuadTable.h = h - topHeight - 2
	draw.TexturedQuad(QuadTable)
end

local function inventoryItemButton(iname, name, amount, description, model, parent, dist, buttons)
	if not dist then dist = 128 end
	local p = vgui.Create("DPanel", parent)
	p:SetPos(4, 4)
	p:SetSize(128, 128)

	local mp = vgui.Create("DModelPanel", p)
	mp:SetSize(p:GetWide(), p:GetTall() )
	mp:SetPos(0, 0)
	mp:SetModel(model)
	mp:SetAnimSpeed(0.1)
	mp:SetAnimated(true)
	mp:SetAmbientLight(Color(50, 50, 50))
	mp:SetDirectionalLight(BOX_TOP,Color(255, 255, 255))
	mp:SetCamPos(Vector(dist, dist, dist))
	mp:SetLookAt(Vector(0, 0, 0))
	mp:SetFOV(20)
	//print("inv item button")

	function mp:LayoutEntity(Entity)
		self:RunAnimation()	
		Entity:SetSkin(getItems(iname).skin or 0)
		Entity:SetAngles(Angle(0, 0, 0))
	end
	
	local b = vgui.Create("DButton", p)
	b:SetPos(4, 4)
	b:SetSize(128, 128)
	b:SetText("")
	b:SetTooltip(name .. ":\n\n" .. description)

	b.DoClick = function()
		local opt = DermaMenu()
		for k, v in pairs(buttons) do
			opt:AddOption(k, v)
		end
		opt:Open()
	end
	
	b.DoRightClick = function()
	end
	
	function b:Paint()
		return true
	end
	
	if amount then
		local l = vgui.Create("DLabel", p)
		l:SetPos(6, 4)
		l:SetFont("default")
		l:SetColor(Color(255, 30, 30, 255))
		l:SetText(amount)
		l:SizeToContents()
	end

	return p
end

local function inventoryDrop(item)
	net.Start("InventoryDrop")
		net.WriteString(tostring(item))
	net.SendToServer()
end

local function inventoryTrade(item)
	local tr = LocalPlayer():GetEyeTrace()
	if not tr.Entity then LocalPlayer():ChatPrint("You need to look at a player!") return end
	if not tr.Entity:IsPlayer() then LocalPlayer():ChatPrint("You need to look at a player!") return end
	net.Start("InventoryTrade")
		net.WriteEntity(tr.Entity)
		net.WriteString(tostring(item))
	net.SendToServer()
end

local RockPanel = {}
function RockPanel:Paint()
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(Material("inv_rock.png"))
	surface.DrawTexturedRect(0, 0, 171, 250)
end
local PaperPanel = {}
function PaperPanel:Paint()
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(Material("inv_paper.png"))
	surface.DrawTexturedRect(0, 0, 171, 250)
end
local ScissorsPanel = {}
function ScissorsPanel:Paint()
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(Material("inv_scissors.png"))
	surface.DrawTexturedRect(0, 0, 171, 250)
end

vgui.Register("RockPanel", RockPanel, "DButton")
vgui.Register("PaperPanel", PaperPanel, "DButton")
vgui.Register("ScissorsPanel", ScissorsPanel, "DButton")

function inventoryMenu()
	if LocalPlayer():Team() == TEAM_SPECTATORS_RRPS then return end
	if not invOpen then
		f = vgui.Create("DFrame")
		f:SetSize(ScrW(), ScrH())
		f:SetBackgroundBlur(true)
		f:SetDraggable(false)
		f:ShowCloseButton(false)
		f:SetDeleteOnClose(true)
		f:SetTitle("")
		f:MakePopup()
		f:SetKeyboardInputEnabled(false)
		f.Init = function(s)
			s.startTime = SysTime()
		end
		f.Paint = function(s, w, h)
			draw.RoundedBox(0,0,0,w,h,Color(0, 0, 0, 0))
			Derma_DrawBackgroundBlur(s, s.startTime)
		end

		local numrocks = LocalPlayer():ReturnPlayerVar("rockcards")
		local numpapers = LocalPlayer():ReturnPlayerVar("papercards")
		local numscissors = LocalPlayer():ReturnPlayerVar("scissorscards")

		local _rocks = vgui.Create("DIconLayout", f)
		_rocks:SetSize((20 * numrocks) + (171 * numrocks), 250)
		_rocks:SetPos(0, ScrH() / 8)
		_rocks:CenterHorizontal(0.5)
		_rocks:SetSpaceX(10)
		_rocks:SetSpaceY(10)
		_rocks.Paint = function(s, w, h)
			draw.RoundedBox(0,0,0,w,h,Color(0, 0, 0,10))
		end
		for i = 1, numrocks do
			local _rckcard = _rocks:Add("RockPanel")
			_rckcard:SetText("")
			_rckcard:SetSize(171, 250)
			_rckcard.DoClick = function()
				local opt = DermaMenu(_rckcard)
				opt:AddOption("Trade", function()
					if numrocks > 0 then
						inventoryTrade("rockcards")
						f:Close()
						invOpen = false
						//in the future this should revalidate the cards so you can keep trading without pressing f1 but im tired
					end
				end)
				opt:Open()
			end
			//_rckcard:SetPos( ( (i * 171) - 171) + 20) // first card is at 10, second card is at 181
		end

		local _papers = vgui.Create("DIconLayout", f)
		_papers:SetSize((20 * numpapers) + (171 * numpapers), 250)
		_papers:Center()
		_papers:SetSpaceX(10)
		_papers:SetSpaceY(10)
		_papers.Paint = function(s, w, h)
			draw.RoundedBox(0,0,0,w,h,Color(0, 0, 0,10))
		end
		for i = 1, numpapers do
			local _pprcard = _papers:Add("PaperPanel")
			_pprcard:SetSize(171, 250)
			_pprcard:SetText("")
			_pprcard.DoClick = function()
				local opt = DermaMenu(_pprcard)
				opt:AddOption("Trade", function()
					if numpapers > 0 then
						inventoryTrade("papercards")
						f:Close()
						invOpen = false
					end
				end)
				opt:Open()
			end
			//_pprcard:SetPos((i * 171) - 171 + 10)
		end

		local _scissors = vgui.Create("DIconLayout", f)
		_scissors:SetSize((20 * numscissors) + (171 * numscissors), 250)
		_scissors:SetPos(0, ScrH() * 0.6435)
		_scissors:CenterHorizontal(0.5)
		_scissors:SetSpaceX(10)
		_scissors:SetSpaceY(10)
		_scissors.Paint = function(s, w, h)
			draw.RoundedBox(0,0,0,w,h,Color(0, 0, 0,10))
		end
		for i = 1, numscissors do
			local _scrscard = _scissors:Add("ScissorsPanel")
			_scrscard:SetSize(171, 250)
			_scrscard:SetText("")
			_scrscard.DoClick = function()
				local opt = DermaMenu(_scrscard)
				opt:AddOption("Trade", function()
					if numscissors > 0 then
						inventoryTrade("scissorscards")
						f:Close()
						invOpen = false
					end
				end)
				opt:Open()
			end
			//_scrscard:SetPos((i * 171) - 171 + 10)
		end


		/*local w = 564
		local h = 210

		f = vgui.Create("DFrame")
		f:SetSize(w, h)
		f:SetPos( (ScrW() / 2) - (w / 2), (ScrH() / 2) - (h / 2) )
		f:SetTitle("Inventory")
		f:SetDraggable(true)
		f:ShowCloseButton(true)
		f:SetDeleteOnClose(true)
		f:MakePopup()
		f.Paint = function()
			SKINS:DrawFrame(f:GetWide(), f:GetTall())
		end
		f:SetKeyboardInputEnabled(false)
		
		local ps = vgui.Create("DPropertySheet", f)
		ps:SetPos(8, 28)
		ps:SetSize(w - 16,h - 36)

		local padding = 4

		local items = vgui.Create("DPanelList", ps)
		items:SetPos(padding, padding)
		items:SetSize(w - 32 - padding * 2, h - 48 - padding * 2)
		items:EnableVerticalScrollbar(true)
		items:EnableHorizontal(true)
		items:SetPadding(padding)
		items:SetSpacing(padding)

		function items:Paint()
			draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(), Color(60, 60, 60))
		end

		//local inventory = inventoryTable()

		local function ItemButtons()
			//print("itembuttons started")
			//PrintTable(LocalPlayer().RRPSvars)
			for k, v in pairs(LocalPlayer().RRPSvars) do
				//print("for loop started")
				if k == debt or k == money then return end

				local i = getItems(k)
				if i and v > 0 then
					//print("i isn't empty")
					//PrintTable(i)
					local buttons = {}

					//buttons["use"] = (function()
					//	//add use function here
					//	f:Close()
					//end)

					if k == "stars" then
						buttons["Drop"] = (function()
							if v > 0 then
								inventoryDrop(k)
								f:Close()
							end
						end)
					end
					//print(k)

					buttons["Trade"] = (function()
						if v > 0 then
							inventoryTrade(k)
							f:Close()
						end
					end)

					local b = inventoryItemButton(k, i.name .. "(" .. v .. ")", v, i.description, i.model, items, i.buttonDist, buttons)
					items:AddItem(b)
				else
					//print(i)
					//ErrorNoHalt("ok what is happen... cl database error")
				end
			end
		end

		ItemButtons()
		ps:AddSheet("Items", items,"icon16/box.png", false, false, "Your items are here...")
		*/

		invOpen = true
	else
		f:Close()
		invOpen = false
	end
	
end
function databaseFinish()
	//print("cl database has finished running")
	return true
end

concommand.Add("inventory", inventoryMenu)