local round_status = 0 -- 0 equals end, 1 = active
local players = player.GetAll()
local ply = FindMetaTable("Player")

function beginRound()
	gamemode.Call("RoundStarted")
	PrintTable(players)
	local convar = GetConVar("rps_interestrepeat")
	print(convar:GetFloat() .. ": interest repeat rate")
	round_status = 1
	updateClientRoundStatus()
	timer.Create("CompoundInterestTime", GetConVar("rps_interestrepeat"):GetFloat(), 0, function()
		//print("interest time!")
		CompoundInterest()
	end)
	// update money here
end

function CompoundInterest()
	//print("ok in function")
	//PrintTable(players)
	for k, v in pairs(player.GetAll()) do// it don't gotta check all players...
		local body = 1 + GetConVar("rps_interestrate"):GetFloat()
		//print(body)
		local money = v:databaseGetValue("money")
		//print(money)
		local moneyAfter = money * math.pow(body,1)
		//print(moneyAfter)
		v:databaseSetValue("money", moneyAfter)
		//print(v:databaseGetValue("money"))
	end
end

function endRound(  )
	-- body
	round_status = 0
	updateClientRoundStatus()
	timer.Destroy("CompoundInterestTime")
end

function getRoundStatus( )
	-- body
	return round_status
end

function updateClientRoundStatus()
	-- body
	net.Start("UpdateRoundStatus")
		net.WriteInt(round_status, 4)
	net.Broadcast()
end

// place compound stuff here
//timer.Create("CompoundInterest",75,0,compoundInterest)