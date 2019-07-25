local tableView = false
local calcviewTable = {}
local delay = 2
local lastOccurrence = -delay

local function NormalView(ply, pos, angles, fov)
	//	print("normal view time")
end

function OrbitCamera(p,a1,x)
	local a2=(a1:Forward()*-1):Angle();
    local c=Vector(x,0,0);
    c:Rotate(a1);
    c=c+p;
    return c,a2;
end

function myCalcView(Player, Origin, Angles, FieldOfView)--LookAtPoint is where-ever you want to look at. 1000 is how far away you want the camera to be
	if !Player:GetNWBool("TableView", false) then
		local view = {}
		view.origin = Origin
		view.angles = Angles
		view.fov = FieldOfView
		tableView = false
		return view
	else
		local View = {};
		View.origin = OrbitCamera(Player:GetPos() + Vector(0,0,70), (Angles:Forward()*-1):Angle(),100);
		View.angles = Angles;
		View.fov = FieldOfView;
		View.drawviewer = true
		tableView = true
		return View;
	end
end

hook.Add("CalcView", "CameraView", myCalcView)

// problem here: pressing E makes you sometimes leave the table right when you enter it. the delay needs to be reset upon entering a table
hook.Add("KEY_USE", "ExitTable", function()
	if !LocalPlayer():GetNWBool("TableView") then print("tableview false") return end
	if LocalPlayer():GetNWBool("PlayingTable", false) then print("playingtable true") return end
	local timeElapsed = CurTime() - lastOccurrence
	if timeElapsed < delay then
		print("table leave on cooldown")
		print(timeElapsed .. " < " .. delay)
	elseif (timeElapsed >= delay) then
		lastOccurrence = CurTime()
		net.Start("UpdateTableView")
			net.WriteBool(false)
		net.SendToServer()
		net.Start("RemovePlayer")
			net.WriteEntity(LocalPlayer():GetNWEntity("TableUsing", NULL))
		net.SendToServer()
		hook.Run("PlayerTableExit")
		print("tableview is false, setting nwbool tableview to false")
		// in the future, i should offload the key_use thing to another script or something
	end
end)
