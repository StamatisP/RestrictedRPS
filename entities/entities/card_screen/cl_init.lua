include("shared.lua")

surface.CreateFont( "InfoRUS2", { font = "Enhanced Dot Digital-7", extended = true, size = 90, weight = 800, antialias = true })
surface.CreateFont( "InfoRUS3", { font = "Enhanced Dot Digital-7", extended = true, size = 70, weight = 800, antialias = true })
surface.CreateFont( "InfoRUS4", { font = "Enhanced Dot Digital-7", extended = true, size = 120, weight = 800, antialias = true })

local multiplier = 155
local font = "InfoRUS2"

function ENT:Initialize()
	self.frame = vgui.Create( "DPanel" )
	self.frame:SetSize( 600, 480 )
	self.frame.Text = self:GetText()
	self.frame.col = self:GetTColor()
	self.frame:SetPaintedManually( true )
	self.frame.Paint = DrawText
end

function DrawText(self,w,h)
	surface.DisableClipping( true )
	surface.SetFont(font)
	local ww,hh = surface.GetTextSize(self.Text)	
	draw.DrawText("CARDS",font,0,-200,Color(self.col.x * 100, self.col.y * 100, self.col.z * 100),1)
	draw.DrawText("Rock", "InfoRUS3", -200, -80, Color(255, 0, 0), 1)
	draw.DrawText("4", "InfoRUS4", -199, 1, Color(255, 255, 255), 1)
	draw.DrawText("4", "InfoRUS4", -200, 0, Color(255, 0, 0), 1)
	
	draw.DrawText("Paper", "InfoRUS3", 0, 80, Color(255, 200, 0), 1)
	draw.DrawText("4", "InfoRUS4", 1, 161, Color(255, 255, 255), 1)
	draw.DrawText("4", "InfoRUS4", 0, 160, Color(255, 200, 0), 1)
	
	draw.DrawText("Scissors", "InfoRUS3", 200, -80, Color(0, 100, 255), 1)
	draw.DrawText("4", "InfoRUS4", 201, 1, Color(255, 255, 255), 1)
	draw.DrawText("4", "InfoRUS4", 200, 0, Color(0, 100, 255), 1)
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