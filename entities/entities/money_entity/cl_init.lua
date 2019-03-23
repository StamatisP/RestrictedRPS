include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	local pos = self:GetPos()
	local ang = self:GetAngles()

	local value = self:GetValue()
	value = math.Round(value, 2)

	//surface.SetFont("HudHintTextSmall")
	surface.SetFont("ChatFont")
	local formattedText = formatMoney(value)
	local valueWidth = surface.GetTextSize(formattedText)

	cam.Start3D2D(pos + ang:Up() * 1.92, ang, 0.15)
		draw.WordBox(2, -valueWidth * 0.6, -7, formattedText, "ChatFont", Color(140, 0, 0, 255), Color(255, 255, 255, 255))
	cam.End3D2D()

	ang:RotateAroundAxis(ang:Right(), 180)

	cam.Start3D2D(pos + ang:Up() * 0.62, ang, 0.15)
		draw.WordBox(2, -valueWidth * 0.6, -7, formattedText, "ChatFont", Color(140, 0, 0, 255), Color(255, 255, 255, 255))
	cam.End3D2D()
end