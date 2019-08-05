local ply = FindMetaTable("Player")
// i should replace it all with util.tabletojson or somethin
//util.AddNetworkString("inventory_use")
print("sv_database load")

function ply:ShortSteamID()

	local id = self:SteamID()
	local id = tostring(id)
	local id = string.Replace(id,"STEAM_0:0:","")
	local id = string.Replace(id,"STEAM_0:1:","")
	return id
end

local oldPrint = print
local function print(s)
	oldPrint("database.lua: " .. s)
end

net.Receive("InventoryDrop",function(len, ply)
	local name = net.ReadString()
	if ply:ReturnPlayerVar(name) >= 1 then
		ply:TakeAwayFromPlayerVar(name, 1)
		CreateItem(ply, name, itemSpawnPos(ply))
	end
end)

net.Receive("InventoryTrade", function(len, ply)
	local otherPly = net.ReadEntity()
	local item = net.ReadString()
	if not otherPly:IsPlayer() then return end
	if ply:ReturnPlayerVar(item) >= 1 then
		ply:TakeAwayFromPlayerVar(item, 1)
		otherPly:TakeAwayFromPlayerVar(item, -1)
	end
	ply:ChatPrint("You have given " .. otherPly:Nick() .. " a " .. item)
	otherPly:ChatPrint(ply:Nick() .. " has given you a " .. item)
end)

local idd = 0
function CreateItem(ply, name, pos)
	local itemT = getItems(name)
	if itemT then
		idd = idd + 1
		local item = ents.Create(itemT.ent)
		item:SetNWString("name", itemT.name)
		item:SetNWString("itemName", name)
		item:SetNWInt("uID", idd)
		item:SetNWBool("pickup",true)
		item:SetPos(pos)
		item:SetNWEntity("owner", ply)
		item:SetSkin(itemT.skin or 0)
		itemT.spawn(ply, item)

		item:Spawn()
		item:Activate()
	else
		return false
	end
end

function itemSpawnPos(ply)
	local pos = ply:GetShootPos()
	local ang = ply:GetAimVector()

	local td = {}
	td.start = pos
	td.endpos = pos+(ang*80)
	td.filter = ply
	local trace = util.TraceLine(td)
	return trace.HitPos
end

function inventoryPickup(ply)
	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = trace.start + ply:GetAimVector() * 85
	trace.filter = ply
	local tr = util.TraceLine(trace)

	if (tr.HitWorld) then return end
	if !tr.Entity:IsValid() then return end

	if tr.Entity:GetNWBool("pickup") then
		local item = getItems(tr.Entity:GetNWString("itemName"))
		if item.canPickup == nil then
			ply:UpdatePlayerVar(tr.Entity:GetNWString("itemName"), ply:ReturnPlayerVar(tr.Entity:GetNWString("itemName")) + 1)
			tr.Entity:Remove()
		else
			if tr.Entity:GetNWBool("pickup") then
				ply:UpdatePlayerVar(tr.Entity:GetNWString("itemName"), ply:ReturnPlayerVar(tr.Entity:GetNWString("itemName")) + 1)
				tr.Entity:Remove()
			end
		end
	end
end
print("finish sv_database load")

//change this to E
hook.Add("KEY_USE","inventoryPickup", inventoryPickup)