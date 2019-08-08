local tableView = false
local calcviewTable = {}
local delay = 2
local lastOccurrence = -delay
local canExitTable = true

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
	//print(tableView)
	if not tableView then
		local view = {}
		view.origin = Origin
		view.angles = Angles
		view.fov = FieldOfView
		tableView = false
		return view
	elseif Player:GetNWBool("PlayingTable", false) then
		local view = {}
		local tableEnt = tableEnt or Player:GetNWEntity("TableUsing", NULL)
		if not IsValid(tableEnt) then ErrorNoHalt("wtf table is null") return end
		view.origin = tableEnt:LocalToWorld(Vector(-2, -90, 65)) // optimize this
		view.angles = tableEnt:LocalToWorldAngles(Angle(0, 90, 0))
		view.fov = FieldOfView
		view.drawviewer = true
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
hook.Add("KeyRelease", "ExitTable", function(player, key)
	if key != IN_USE or canExitTable == false then return end
	if not LocalPlayer():GetNWBool("TableView") then print("tableview false") return end
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

hook.Add("PlayerTableEnter", "PreventInstantExit", function()
	canExitTable = false
	tableView = true
	timer.Simple(2, function()
		canExitTable = true
		print("can now exit table.")
	end)
end)

hook.Add("PlayerTableExit", "UpdateCameraBack", function()
	tableView = false
	print("is htis even running")
end)