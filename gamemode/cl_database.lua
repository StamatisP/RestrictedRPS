local database = {}
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
	p:SetSize(64, 64)

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
	b:SetSize(64, 64)
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


function inventoryMenu()
	local w = 506
	local h = 512

	local f = vgui.Create("DFrame")
	f:SetSize(w, h)
	f:SetPos( (ScrW() / 2) - (w / 2), (ScrH() / 2) - (h / 2) )
	f:SetTitle("Inventory")
	f:SetDraggable(true)
	f:ShowCloseButton(true)
	f:MakePopup()
	f.Paint = function()
		SKINS:DrawFrame(f:GetWide(), f:GetTall())
	end
	
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

				/*buttons["use"] = (function()
					//add use function here
					f:Close()
				end)*/

				buttons["Drop"] = (function()
					inventoryDrop(k)
					f:Close()
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
end
function databaseFinish()
	//print("cl database has finished running")
	return true
end

concommand.Add("inventory", inventoryMenu)