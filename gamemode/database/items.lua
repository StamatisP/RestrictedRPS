local items = {}

function getItems(name)
	//print("getItems ran")
	if items[name] then
		//print("items name exists")
		return items[name]
	end
	//print("return false")
	return false
end

items["rockcards"] = {
	name = "Rock Card",
	description = "Rock card.",
	ent = "item_basic",
	model = "models/props_junk/PopCan01a.mdl",
	use = (function(ply, ent)
		if ply:IsValid() then
			//ply:AddHealth
			if ent then
				//ent:Remove()
			end
		end
	end),
	spawn = (function(ply, ent)
		ent:SetItemName("card")
	end),
	skin = 0,
	buttonDist = 32,
}
items["papercards"] = {
	name = "Paper Card",
	description = "Paper card.",
	ent = "item_basic",
	model = "models/props_junk/PopCan01a.mdl",
	use = (function(ply, ent)
		if ply:IsValid() then
			//ply:AddHealth
			if ent then
				//ent:Remove()
			end
		end
	end),
	spawn = (function(ply, ent)
		ent:SetItemName("card")
	end),
	skin = 1,
	buttonDist = 32,
}
items["scissorscards"] = {
	name = "Scissors Card",
	description = "Scissors card.",
	ent = "item_basic",
	model = "models/props_junk/PopCan01a.mdl",
	use = (function(ply, ent)
		if ply:IsValid() then
			//ply:AddHealth
			if ent then
				//ent:Remove()
			end
		end
	end),
	spawn = (function(ply, ent)
		ent:SetItemName("card")
	end),
	skin = 2,
	buttonDist = 32,
}
items["stars"] = {
	name = "Star",
	description = "A velcro star.",
	ent = "item_basic",
	model = "models/props_junk/PopCan01a.mdl",
	use = (function(ply, ent)
		if ply:IsValid() then
			//ply:AddHealth
			if ent then
				//ent:Remove()
			end
		end
	end),
	spawn = (function(ply, ent)
		ent:SetItemName("star")
	end),
	skin = 0,
	buttonDist = 32,
}