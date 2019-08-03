include("shared.lua")
local tableView = false

function ENT:Draw()
	self:DrawModel()
	self:DrawShadow(true)

	//render.SetColorMaterial()
	//render.DrawWireframeSphere(self:GetPos(), 250, 50, 50, Color(255, 0, 0))

	//render.SetColorMaterial()
	//render.DrawWireframeSphere(self:GetPos(), -150, 50, 50, Color(255, 0, 0))
end

/*local function NormalView(ply, pos, angles, fov)
	local view = {}

	view.origin = pos
	view.angles = angles
	view.fov = fov
	return view
end

function OrbitCamera(p,a1,x)
	local a2=(a1:Forward()*-1):Angle();
    local c=Vector(x,0,0);
    c:Rotate(a1);
    c=c+p;
    return c,a2;
end

function CalcView(Player, Origin, Angles, FieldOfView)--LookAtPoint is where-ever you want to look at. 1000 is how far away you want the camera to be
	local View = {};
	View.origin = OrbitCamera(Player:GetPos(), (Angles:Forward()*-1):Angle(),1000);
	View.angles = Angles;
	View.fov = FieldOfView;
	View.drawviewer = true	
	return View;
end

if tableView then
	hook.Add("CalcView", "CameraTableView", CalcView)
else
	hook.Add("CalcView", "CameraNormalView", NormalView)
end

hook.Add("Think","ThinkView",function()
	tableView = self:GetNWBool("TableView", false)
end)*/