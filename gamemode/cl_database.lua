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
	if self:IsHovered() then
		//surface.DrawTexturedRect(0, 0, 205, 300)
		//draw.RoundedBox(8, -10, -10, 191, 270, Color(255, 191, 0, 200))
		surface.DrawTexturedRect(0, 0, 171, 250)
	else
		surface.DrawTexturedRect(0, 0, 171, 250)
	end
end
/*function RockPanel:Think()
	if self:IsHovered() then
		self:SetSize(205, 300)
	else
		self:SetSize(171, 250)
	end
end*/

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

local StarsPanel = {}
function StarsPanel:Init()
	self:SetSize(128, 128)
	self:SetModel("models/star/star.mdl")
	local mn, mx = self.Entity:GetRenderBounds()
	local size = 0
	size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
	size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
	size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )
	self:SetFOV( 45 )
	self:SetCamPos( Vector( size, size, size ) )
	self:SetLookAt( ( mn + mx ) * 0.5 )
	self.DoClick = function()
		local opt = DermaMenu(self)
		opt:AddOption("Trade", function()
			if numstars > 0 then
				inventoryTrade("stars")
				f:Close()
				invOpen = false
			end
		end)
		opt:AddOption("Drop", function()
			if numstars > 0 then
				inventoryDrop("stars")
				f:Close()
				invOpen = false
			end
		end)
		opt:Open()
	end
	function self:LayoutEntity(ent)
		-- Point camera toward the look pos
		local lookAng = ( self.vLookatPos-self.vCamPos ):Angle()
		-- Set camera look angles
		self:SetLookAng( lookAng )
		-- Make entity rotate like normal
		ent:SetAngles( Angle(0, RealTime()*30, 0 ) )
	end
end

vgui.Register("RockPanel", RockPanel, "DButton")
vgui.Register("PaperPanel", PaperPanel, "DButton")
vgui.Register("ScissorsPanel", ScissorsPanel, "DButton")
vgui.Register("StarsPanel", StarsPanel, "DModelPanel")

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
		local numstars = LocalPlayer():ReturnPlayerVar("stars")

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

		/*local plaque_bg = vgui.Create("DImage", f)
		plaque_bg:SetSize((128 * 3) + 16, (128 * 2) + 16)
		plaque_bg:SetPos(ScrW() / 20, ScrH() / 3)
		plaque_bg:SetImage("star_plaque.png")*/

		local star_plaque = vgui.Create("DIconLayout", f)
		star_plaque:SetSize((128 * 3) + 16, (128 * 2) + 16)
		star_plaque:SetPos(ScrW() / 20, ScrH() / 3)
		print(star_plaque:GetSize())
		star_plaque:SetSpaceX(8)
		star_plaque:SetSpaceY(8)
		star_plaque:SetStretchHeight(true)
		star_plaque.Paint = function(s, w, h)
			//draw.RoundedBox(0,0,0,w,h,Color(0, 255, 0,10))
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(Material("star_plaque.png"))
			surface.DrawTexturedRect(0, 0, w, h)
		end
		for i = 1, numstars do
			local _star = star_plaque:Add("StarsPanel")
		end

		/*local star_model = vgui.Create("DModelPanel", f)
		star_model:SetSize(256, 256)
		star_model:SetPos(ScrW() / 8)
		star_model:CenterVertical(0.5)
		star_model:SetModel("models/star/star.mdl")
		local mn, mx = star_model.Entity:GetRenderBounds()
		local size = 0
		size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
		size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
		size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )
		star_model:SetFOV( 45 )
		star_model:SetCamPos( Vector( size, size, size ) )
		star_model:SetLookAt( ( mn + mx ) * 0.5 )
		star_model.DoClick = function()
			local opt = DermaMenu(star_model)
			opt:AddOption("Trade", function()
				if numstars > 0 then
					inventoryTrade("stars")
					f:Close()
					invOpen = false
				end
			end)
			opt:AddOption("Drop", function()
				if numstars > 0 then
					inventoryDrop("stars")
					f:Close()
					invOpen = false
				end
			end)
			opt:Open()
		end
		function star_model:LayoutEntity(ent)
			-- Point camera toward the look pos
			local lookAng = ( self.vLookatPos-self.vCamPos ):Angle()
			-- Set camera look angles
			self:SetLookAng( lookAng )
			-- Make entity rotate like normal
			ent:SetAngles( Angle(0, RealTime()*30, 0 ) )
		end

		local starslabel = vgui.Create("DLabel", star_model)
		starslabel:SetText("")
		starslabel:SetSize(256, 256)
		starslabel:SetContentAlignment(7)
		starslabel:SetFont("CardText")
		starslabel:SetColor(Color(255, 0, 0))
		starslabel.Paint = function(s, w, h)
			draw.SimpleTextOutlined(numstars, "CardText", 0, 0, Color(255, 191, 0, 255),TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 2, Color(255, 255, 255, 255))
		end*/

		invOpen = true
	else
		f:Close()
		invOpen = false
	end
end

concommand.Add("inventory", inventoryMenu)