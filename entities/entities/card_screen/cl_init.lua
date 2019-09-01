include("shared.lua")

surface.CreateFont( "InfoRUS2", { font = "Enhanced Dot Digital-7", extended = true, size = 90, weight = 800, antialias = true })
surface.CreateFont( "InfoRUS3", { font = "Enhanced Dot Digital-7", extended = true, size = 70, weight = 800, antialias = true })
surface.CreateFont( "InfoRUS4", { font = "Enhanced Dot Digital-7", extended = true, size = 120, weight = 800, antialias = true })

local multiplier = 155
local font = "InfoRUS2"
local rockCards, paperCards, scissorsCards
local roundtime = 0

function ENT:Initialize()
	self.frame = vgui.Create( "DPanel" )
	self.frame:SetSize( 600, 480 )
	self.frame.Text = self:GetText()
	self.frame.col = self:GetTColor()
	self.frame:SetPaintedManually( true )
	self.frame.Paint = DrawText
	rockCards, paperCards, scissorsCards = 4, 4, 4
end

function DrawText(self,w,h)
	surface.DisableClipping( true )
	surface.SetFont(font)
	local ww,hh = surface.GetTextSize(self.Text)	
	draw.DrawText("TIME","InfoRUS2",0,-200,Color(255, 200, 0),1)
	draw.DrawText(string.ToMinutesSeconds(roundtime), "InfoRUS4", 0, -100, Color(200, 200, 0), 1)
	surface.SetDrawColor(Color(255, 200, 0))
	surface.DrawRect(-350, 50, 350 * 2, 5)
	surface.DrawRect(-100, 50, 5, 350)
	surface.DrawRect(100, 50, 5, 350)
	surface.DrawRect(-350, 130, 350 * 2, 5)

	draw.DrawText("R", "InfoRUS3", -200, 60, Color(255, 0, 0), 1)
	draw.DrawText(rockCards, "InfoRUS4", -199, 161, Color(255, 255, 255), 1)
	draw.DrawText(rockCards, "InfoRUS4", -200, 160, Color(255, 0, 0), 1)
	
	draw.DrawText("P", "InfoRUS3", 0, 60, Color(0, 100, 255), 1)
	draw.DrawText(paperCards, "InfoRUS4", 1, 161, Color(255, 255, 255), 1)
	draw.DrawText(paperCards, "InfoRUS4", 0, 160, Color(0, 100, 255), 1)
	
	draw.DrawText("S", "InfoRUS3", 200, 60, Color(255, 200, 0), 1)
	draw.DrawText(scissorsCards, "InfoRUS4", 201, 161, Color(255, 255, 255), 1)
	draw.DrawText(scissorsCards, "InfoRUS4", 200, 160, Color(255, 200, 0), 1)
end
	
function ENT:Draw()
	self:DrawModel()
	
	if self.frame then
		self.frame.Text = self:GetText()
		self.frame.col = self:GetTColor()
	end
	
	local Pos = self:GetPos()
	local Ang = Angle(0, 180, 90)

	cam.Start3D2D(Pos + Ang:Up() * 2.1 - Ang:Right() * 12 + Ang:Forward() * 0.5, Ang, 0.4)
		self.frame:PaintManual()
	cam.End3D2D()
end

net.Receive("UpdateCardScreen", function()
	rockCards = net.ReadUInt(9)
	paperCards = net.ReadUInt(9)
	scissorsCards = net.ReadUInt(9)
end)

hook.Add("RoundStarted", "UpdateRoundTimeScreen", function()
	roundtime = GetConVar("rps_roundtime"):GetFloat()
	timer.Create("CardScreenTick", 1, 0, function()
		if roundtime == 0 then return end
		roundtime = roundtime - 1	
	end)
end)