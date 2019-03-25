GM.round_status = 0 -- 0 equals end, 1 = active
local ply = FindMetaTable("Player")

function GM:BeginRound()
	if GetGlobalBool("IsRoundStarted", false) then return end
	gamemode.Call("RoundStarted")
	//PrintTable(players)
	local convar = GetConVar("rps_interestrepeat")
	//print(convar:GetFloat() .. ": interest repeat rate")
	self.round_status = 1
	self:UpdateClientRoundStatus()
	SetGlobalFloat("interestrepeat", GetConVar("rps_interestrepeat"):GetFloat())
	timer.Create("CompoundInterestTime", GetConVar("rps_interestrepeat"):GetFloat(), 0, function()
		//print("interest time!")
		CompoundInterest()
	end)
	local players = player.GetAll()
	self.roundstart = CurTime()
	SetGlobalFloat("roundstart", self.roundstart)
	SetGlobalFloat("RoundTime", GetConVar("rps_roundtime"):GetFloat())
	SetGlobalBool("IsRoundStarted", true)
	print("beginning round!")
	for k, v in pairs(players) do
		// no more nwvars, they exponentially scale data
		v:UpdatePlayerVar("rockcards", 4)
		v:UpdatePlayerVar("papercards", 4)
		v:UpdatePlayerVar("scissorscards", 4)
		v:UpdatePlayerVar("stars", 3)
		v:SetNWInt("Luck", 50)
		// luck will be used for determining what songs auto play
	end
	// update money here
end

function GM:Think()
	if self.round_status == 1 and self.roundstart <= CurTime() then
		self.endroundtime = CurTime() + self:GetRoundTime()
		SetGlobalFloat("endroundtime", self.endroundtime) // returning 0>???
		//print("is this even running")
		self.roundstart = math.huge
	elseif self.endroundtime <= CurTime() then
		if not (GetGlobalBool("IsRoundStarted", false)) then return end
		SetGlobalBool("IsRoundStarted", false)
		self:EndRound()
		print("end round time")
	end
end

function CompoundInterest()
	//print("ok in function")
	//PrintTable(players)
	local body = 1 + GetConVar("rps_interestrate"):GetFloat()
	for k, v in pairs(player.GetAll()) do// it don't gotta check all players...  ; edit from future: what the hell do you mean you don't have to
		//print(body)
		local money = v:ReturnPlayerVar("debt")
		//print(money)
		local moneyAfter = money * math.pow(body,1)
		//print(moneyAfter)
		v:UpdatePlayerVar("debt", moneyAfter)
		//print(v:databaseGetValue("money"))
	end
end

function GM:EndRound()
	// do SQL stuff here to save to a database, use darkrp as reference
	self.round_status = 0
	self:UpdateClientRoundStatus()
	timer.Destroy("CompoundInterestTime")
	sql.Begin()
	for k, v in pairs(player.GetAll()) do
		if not v then ErrorNoHalt("what???") return end

		local playerMoney = v:ReturnPlayerVar("money")
		local playerMoneySQL = ReturnPlayerVarSQL(v, "money")
		local playerDebt = v:ReturnPlayerVar("debt")
		local playerDebtSQL = ReturnPlayerVarSQL(v, "debt")

		if (playerMoney > 0) then
			local newdebt = playerMoney - playerDebt
			if newdebt > 0 then 
				UpdatePlayerVarSQL(v, newdebt + playerMoneySQL, "money") 
				//UpdatePlayerVarSQL(v, playerDebt - newdebt, "debt")
				UpdatePlayerVarSQL(v, playerDebtSQL - newdebt, "debt")
			end
			if newdebt < 0 then 
				UpdatePlayerVarSQL(v, 0, "money")
				UpdatePlayerVarSQL(v, (math.abs(newdebt) + playerDebtSQL), "debt")  
			end
			if newdebt == 0 then 
				//UpdatePlayerVarSQL(v, 0, "money")
				//UpdatePlayerVarSQL(v, 0, "debt") no need to update any vars, if newdebt is 0, that means they can pay off their debt.
			end
		end

	end
	sql.Commit()
	timer.Simple(25, function()
		print("reloading map!")
		RunConsoleCommand("changelevel", game.GetMap())
	end)
end

function GM:GetRoundStatus()
	-- body
	return self.round_status
end

function GM:UpdateClientRoundStatus()
	-- body
	net.Start("UpdateRoundStatus")
		net.WriteInt(self.round_status, 4)
	net.Broadcast()
end

// place compound stuff here
//timer.Create("CompoundInterest",75,0,compoundInterest)