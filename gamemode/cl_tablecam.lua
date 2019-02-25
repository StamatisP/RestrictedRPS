local tableView = false
local calcviewTable = {}
local delay = 2
local lastOccurrence = -delay
TablePlayerIsUsing = nil

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
	local eyetrace = LocalPlayer():GetEyeTrace()
	// check if eyetrace hit sky or world
	if eyetrace.HitSky == false then
		if eyetrace.HitWorld == false then
			TablePlayerIsUsing = eyetrace.Entity			
		end
	end
	if !Player:GetNWBool("TableView", false) then
		//print(LocalPlayer():GetNWBool("TableView"))
		//print("normal view time")
		local view = {}
		view.origin = Origin
		view.angles = Angles
		view.fov = FieldOfView
		tableView = false
		return view
	else
		//print(LocalPlayer():GetNWBool("TableView"))
		//print("calcview time")
		local View = {};
		View.origin = OrbitCamera(Player:GetPos() + Vector(0,0,70), (Angles:Forward()*-1):Angle(),100);
		//print(Player:GetPos())
		View.angles = Angles;
		View.fov = FieldOfView;
		View.drawviewer = true
		//Player:SetVelocity(Vector(0,0,0))
		tableView = true
		return View;
	end
end


/*hook.Add("Think","ThinkView",function()

	//tableView = LocalPlayer():GetNWBool("TableView", false)
	//tableView = LocalPlayer():GetNWBool("TableView", false)
	if tableView then
		hook.Add("CalcView", "CameraTableView", myCalcView)
	else
		hook.Add("CalcView", "CameraNormalView", NormalView)
	end
	//if tableView then
		//LocalPlayer():SetLocalVelocity(Vector(0,0,0))
	//end
	//print(tableView)
end)*/
hook.Add("CalcView", "CameraView", myCalcView)

// problem here: pressing E makes you sometimes leave the table right when you enter it. the delay needs to be reset upon entering a table
hook.Add("KEY_USE", "ExitTable", function()
	if !LocalPlayer():GetNWBool("TableView") then return end
	if LocalPlayer():GetNWBool("PlayingTable", false) then return end
	local timeElapsed = CurTime() - lastOccurrence
	//print(timeElapsed .. " time elapsed")
	//print(lastOccurrence .. " last occurrence")
	if timeElapsed < delay then
		print("table leave on cooldown")
		print(timeElapsed .. " < " .. delay)
	elseif (timeElapsed >= delay) then
		//print("time elapsed is greater than delay")
		lastOccurrence = CurTime()
		//print(timeElapsed .. " > " .. delay)
		//print(tableView)	
		//print(tostring(tableView) .. " table view")
		//LocalPlayer():SetNWBool("TableView", false)
		net.Start("UpdateTableView")
			net.WriteBool(false)
		net.SendToServer()
		net.Start("RemovePlayer")
			net.WriteEntity(TablePlayerIsUsing)
		net.SendToServer()
		print("tableview is false, setting nwbool tableview to false")
		// in the future, i should offload the key_use thing to another script or something
	end
end)

/*hook.Add("PlayerEnteredTable", "PlayerEnteredTable", function()
	lastOccurence = CurTime()
end)*/