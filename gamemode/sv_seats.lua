// credit to sunabouzu!
ChairOffsets = {
	["models/props/cs_office/sofa.mdl"] = {
		{Pos = Vector(10.289841, 27.048300, 23.795654)},
		{Pos = Vector(10.360985, 0.136587, 23.795654)},
		{Pos = Vector(10.937448, -26.620655, 23.795654)}
	}
}

local function HandleRollercoasterAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_GMOD_SIT_ROLLERCOASTER ) 
end

function CreateSeatAtPos(pos, angle)
	local ent = ents.Create("prop_vehicle_prisoner_pod")
	ent:SetModel("models/nova/airboat_seat.mdl")
	ent:SetKeyValue("vehiclescript","scripts/vehicles/prisoner_pod.txt")
	ent:SetPos(pos)
	ent:SetAngles(angle)
	ent:SetNotSolid(true)
	ent:SetNoDraw(true)

	ent.HandleAnimation = HandleRollercoasterAnimation

	ent:Spawn()
	ent:Activate()

	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end

	ent:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )

	return ent
end

/*hook.Add("InitPostEntity", "TrySpawnSeats", function()
	for k, v in pairs(ents.FindByClass("prop_vehicle_prisoner_pod")) do
		//CreateSeatAtPos(v:LocalToWorld(Vector(4.6150, 36, -4), Angle()) // this would never work im too fuckin tired
		v:SetNotSolid(true)
		v:SetNoDraw(false)
		v.HandleAnimation = HandleRollercoasterAnimation

		local phys = v:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion(false)
		end
		v:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	end
end)*/

hook.Add("KeyRelease", "EnterSeat", function(ply, key)
	if key != IN_USE || ply:InVehicle() || (ply.ExitTime && CurTime() < ply.ExitTime + 1) then return end

	local eye = ply:EyePos()
	local trace = util.TraceLine({start=eye, endpos=eye+ply:GetAimVector()*100, filter=ply})

	if !IsValid(trace.Entity) then return end

	local seat = trace.Entity
	if seat:GetClass() != "prop_dynamic" then return end
	local model = seat:GetModel()

	local offsets = ChairOffsets[model]
	if !offsets then return end

	local usetable = seat.UseTable or {}
	local pos = -1

	if #offsets > 1 then
		local localpos = seat:WorldToLocal(trace.HitPos)
		local bestpos, bestdist = -1

		for k,v in pairs(offsets) do
			local dist = localpos:Distance(v.Pos)
			if !usetable[k] && (bestpos == -1 || dist < bestdist) then
				bestpos, bestdist = k, dist
			end
		end

		if bestpos == -1 then return end
		pos = bestpos
	elseif !usetable[1] then
		pos = 1
	else
		return
	end

	usetable[pos] = true
	seat.UseTable = usetable

	local ang = seat:GetAngles()
	ang:RotateAroundAxis(seat:GetUp(), -90)

	local s = CreateSeatAtPos(trace.Entity:LocalToWorld(offsets[pos].Pos), ang)
	s:SetParent(trace.Entity)
	s:SetOwner(ply)

	s.SeatData = {
		Ent = seat,
		Pos = pos,
		EntryPoint = ply:GetPos(),
		EntryAngles = ply:GetAngles()
	}

	ply:EnterVehicle(s)

	//s:EmitSound( ChairSitSounds[model] or DefaultSitSound, 100, 100 )
end)

hook.Add("CanPlayerEnterVehicle", "EnterSeat", function(ply, vehicle)
	if vehicle:GetClass() != "prop_vehicle_prisoner_pod" then return end

	if vehicle.Removing then return false end
	return (vehicle:GetOwner() == ply)
end)

local airdist = Vector(0,0,48)

function TryPlayerExit(ply, ent)
	local pos = ent:GetPos()
	local trydist = 8
	local yawval = 0
	local yaw = Angle(0, ent:GetAngles().y, 0)

	while trydist <= 64 do
		local telepos = pos + yaw:Forward() * trydist
		local trace = util.TraceEntity({start=telepos, endpos=telepos - airdist}, ply)

		if !trace.StartSolid && trace.Fraction > 0 && trace.Hit then
			ply:SetPos(telepos)
			return
		end

		yaw:RotateAroundAxis(yaw:Up(), 15)
		yawval = yawval + 15
		if yawval > 360 then
			yawval = 0
			trydist = trydist + 8
		end
	end

	print("player", ply, "couldn't get out")
end

local function PlayerLeaveVehicle( vehicle, ply )
	if vehicle:GetClass() != "prop_vehicle_prisoner_pod" then return end
	if vehicle.Removing == true then return end

	local seat = vehicle.SeatData

	if not (istable(seat) and IsValid(seat.Ent)) then
		return true
	end

	if seat.Ent && seat.Ent.UseTable then
		seat.Ent.UseTable[seat.Pos] = false
	end

	if IsValid(ply) and ply:InVehicle() and (CurTime() - (ply.ExitTime or 0)) > 0.001 then
		ply.ExitTime = CurTime()
		ply:ExitVehicle()

		ply:SetEyeAngles(seat.EntryAngles)

		local trace = util.TraceEntity({
			start = seat.EntryPoint,
			endpos = seat.EntryPoint
		}, ply)

		if vehicle:GetPos():Distance(seat.EntryPoint) < 128 && !trace.StartSolid && trace.Fraction > 0 then
			ply:SetPos(seat.EntryPoint)
		else
			TryPlayerExit(ply, vehicle)
		end

		ply:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	end

	if !vehicle.bSlots then
		vehicle.Removing = true
		vehicle:Remove()
	end

	return false
end

hook.Add("CanExitVehicle", "Leave", PlayerLeaveVehicle)

function PlayerExitLeft( ply )
	if ply:IsPlayer() then
		local Vehicle = ply:GetVehicle()
		
		if IsValid( Vehicle ) and Vehicle.IsCinemaSeat then
			PlayerLeaveVehicle( Vehicle, ply )
		end
	end
end

hook.Add("PlayerLeaveVehicle", "VehicleLeft", PlayerExitLeft)
hook.Add("PlayerDeath", "VehicleKilled", PlayerExitLeft)
hook.Add("PlayerSilentDeath", "VehicleKilled", PlayerExitLeft)
hook.Add("EntityRemoved", "VehicleCleanup", PlayerExitLeft)
