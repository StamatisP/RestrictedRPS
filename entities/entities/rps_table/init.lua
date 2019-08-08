AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self.m_bInitialized = true
	self:SetModel("models/table/game_table.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetTableStarted(false)

	local phys = self:GetPhysicsObject()

	phys:EnableMotion(false)

	if phys:IsValid() then
		phys:Wake()
	end
end	

function ENT:Think()
	if (not self.m_bInitialized) then
		self:Initialize()
	end
end

ENT.playersTable = {}
ENT.player1 = nil
ENT.player2 = nil

local data = {
	Rock = {"Scissors"};
	Paper = {"Rock"};
	Scissors = {"Paper"};
}

function ENT:CheckWins(unit, unit2)
	for _, v in pairs(data[unit]) do
		if v == unit2 then
			return true
		end
	end
	return false
end

function ENT:TableStart()
	//print(self, type(self))
	if self:GetTableStarted() then return end
	print("table start!")
	self:SetTableStarted(true)
	self:GetPlayer1():SetNWBool("PlayingTable", true)
	self:GetPlayer2():SetNWBool("PlayingTable", true)
	self:CheckPhase()
end	

--[[-------------------------------------------------------------------------
TableStatus list
0 - Not active
1 - Check phase
2 - Set phase
3 - Open phase
---------------------------------------------------------------------------]]

function ENT:CheckTableStatus()
	if !self:GetTableStarted() then return end
	return self:GetTableStatus()
end

function ENT:CheckPhase()
	if !self:GetTableStarted() then return end
	//players must select their card, do a net send/broadcast or something
	print("check phase")
	net.Start("PlayerTableCheckGUIEnable")
	net.Send(self.playersTable)
	// make timer for 30 seconds
	timer.Create("TimeLimit", 31, 1, function()
		self:CleanSlate()
	end)
end

ENT.player1Name = nil
ENT.player1Ready = nil
ENT.player2Name = nil
ENT.player2Ready = nil

// https://i.imgur.com/weQFbLT.png
net.Receive("ArePlayersReady", function(len, ply)
	if not ply:GetNWBool("TableView") then return end
	print("areplayersready")
	local ent = net.ReadEntity()
	//local name = net.ReadString() // why the fuck do i send the localplayers name if i can just do ply:Nick()???
	local name = ply:Nick()
	local ready = net.ReadBool()
	if ent == nil || name == nil || ready == nil then
		ErrorNoHalt("Entity, name, or ready is nil! Player " .. ply .. " brought this up!")
		// implement a way to make the match end in a tie if this happens
		ent:CleanSlate()
		return
	end
	ent:PlayerReadyCheck(name, ready)
end)

function ENT:PlayerReadyCheck(name, ready)

	print("player ready check")
	if (self.player1Name == nil) then
		self.player1Name = name
		self.player1Ready = ready
	elseif (self.player2Name == nil) then
		self.player2Name = name
		self.player2Ready = ready
	end
	
	if self.player1Ready && self.player2Ready then // make these network vars
		self:SetPhase()
	end

	if player.GetCount() == 1 and ready then
		self:SetPhase()
		return
	end

end

function ENT:SetPhase()
	if !self:GetTableStarted() then return end
	//card is placed down on table upside down
	// you could bet here i guess, but thats for later
	print("set phase!")
	timer.Destroy("TimeLimit")
	local setPhaseDelay = 3
	net.Start("TableSetPhase")
		net.WriteUInt(5, setPhaseDelay)
	net.Send(self.playersTable)
	timer.Simple(setPhaseDelay + 0.1, function()
		self:OpenPhase()
	end)
	//self:OpenPhase()
end

function ENT:OpenPhase()
	if !self:GetTableStarted() then return end
	print("open phase")
	if not self:GetPlayer1() || not self:GetPlayer2() then ErrorNoHalt("did someone disconnect? fuck em") return end
	//cards are revealed, winner is decided
	local _player1 = self:GetPlayer1()
	local _player2 = self:GetPlayer2()
	local player1Choice = _player1:GetInfo("rps_selection")
	local player2Choice = _player2:GetInfo("rps_selection")
	//print(self:GetPlayer1():ReturnPlayerVar("papercards"))

	if player1Choice == "Rock" then
		if not (_player1:ReturnPlayerVar("rockcards") >= 1) then ErrorNoHalt("Player does not have required rock cards!!! exploit?") end
		_player1:TakeAwayFromPlayerVar("rockcards", 1)
	elseif player1Choice == "Paper" then 
		if not (_player1:ReturnPlayerVar("papercards") >= 1) then ErrorNoHalt("Player does not have required paper cards!!! exploit?") end
		_player1:TakeAwayFromPlayerVar("papercards", 1)
	elseif player1Choice == "Scissors" then
		if not (_player1:ReturnPlayerVar("scissorscards") >= 1) then ErrorNoHalt("Player does not have required scissors cards!!! exploit?") end	 
		_player1:TakeAwayFromPlayerVar("scissorscards", 1)
	else 
		ErrorNoHalt("player1choice is not rock, paper, or scissors... " .. player1Choice)
	end
	//wheres my fucking switch statement, lua
	if player2Choice == "Rock" then _player2:TakeAwayFromPlayerVar("rockcards", 1)
	elseif player2Choice == "Paper" then _player2:TakeAwayFromPlayerVar("papercards", 1)
	elseif player2Choice == "Scissors" then _player2:TakeAwayFromPlayerVar("scissorscards", 1) // just realized that theres no checks for cards here
	else ErrorNoHalt("player2choice is not rock, paper, or scissors... " .. player2Choice)
	end
	
	if player1Choice == player2Choice then
		
		net.Start("AnnounceWinnerOfMatch")
				net.WriteString(_player1:GetName())
				net.WriteString(_player2:GetName())
				net.WriteString(player1Choice)
				net.WriteString(player2Choice)
				net.WriteBool(true)
			net.Send(self:GetNearbyPlayers())
		print("this ends in a tie.")
	else

		if (self:CheckWins(player1Choice, player2Choice)) then

			// for v in pairs(data[player1choice]) do
			// if v == player2choice then return true. at the end, return false
			// player 1 wins
			_player2:TakeAwayFromPlayerVar("stars", 1)
			_player1:TakeAwayFromPlayerVar("stars", -1)
			net.Start("AnnounceWinnerOfMatch")
				net.WriteString(_player1:GetName())
				net.WriteString(_player2:GetName())
				net.WriteString(player1Choice)
				net.WriteString(player2Choice)
				net.WriteBool(false)
			net.Send(self:GetNearbyPlayers())
			net.Start("PlayerTableUpdate")
				net.WriteBool(true)
			net.Send(_player1)
			net.Start("PlayerTableUpdate")
				net.WriteBool(false)
			net.Send(_player2) // is this a terrible practice?
			// dont need to broadcast, could just send to both players 
			_player1:SetNWInt("TableWins", _player1:GetNWInt("TableWins", 0) + 1)
			print(_player1:GetName() .. " beats " .. _player2:GetName() .. "!")
			print(player1Choice .. " beats " .. player2Choice .. "!")
			// net.send a chat.AddText notifying when someone wins, and with what cards

		elseif (self:CheckWins(player2Choice, player1Choice)) then

			// player 2 wins
			_player1:TakeAwayFromPlayerVar("stars", 1)
			_player2:TakeAwayFromPlayerVar("stars", -1)
			net.Start("AnnounceWinnerOfMatch")
				net.WriteString(_player2:GetName())
				net.WriteString(_player1:GetName())
				net.WriteString(player2Choice)
				net.WriteString(player1Choice)
				net.WriteBool(false)
			net.Send(self:GetNearbyPlayers())
			net.Start("PlayerTableUpdate")
				net.WriteBool(false)
			net.Send(_player1)
			net.Start("PlayerTableUpdate")
				net.WriteBool(true)
			net.Send(_player2)
			_player2:SetNWInt("TableWins", _player2:GetNWInt("TableWins", 0) + 1)
			print(player2Choice .. " beats " .. player1Choice .. "!")
			print(_player2:GetName() .. " beats " .. _player1:GetName() .. "!")

		elseif (player1Choice == "Broken" || player2Choice == "Broken") then
			// choice broke
			print(player1Choice .. " or " .. player2Choice .. " is broken")
		end
	end

	self:CleanSlate()
	// put this all in a function like CleanState() shit like that 
end

function ENT:GetNearbyPlayers()
	return ents.FindInSphere(self:GetPos(), 250)
end

function ENT:CleanSlate()
	self:SetTableStarted(false)
	self:GetPlayer1():SetNWBool("TableView", false)
	self:GetPlayer2():SetNWBool("TableView", false)
	self:GetPlayer1():SetNWBool("PlayingTable", false)
	self:GetPlayer2():SetNWBool("PlayingTable", false)
	self:SetPlayer1(nil)
	self:SetPlayer2(nil)
	//table.Empty(self.players)
	table.Empty(self.playersTable)
	self.player1Name = nil
	self.player2Name = nil
	self.player1Ready = nil
	self.player2Ready = nil
end

function ENT:Use(activator, caller)

	//if !activator:inventoryHasItem("stars", 1) then print(activator:GetName() .. " has no stars") return end
	if activator:ReturnPlayerVar("stars") < 1 then return end

	if (table.Count(self.playersTable) >= 2) then 
		print("full table :(")
		return
	end

	if (table.Count(self.playersTable) == 0) then
		
		if player.GetCount() == 1 then
			self:SetPlayer1(activator)
			self:SetPlayer2(activator)
			table.insert(self.playersTable, activator)
			print("dev path")
			activator:SetNWBool("TableView", true)
			net.Start("PlayerTableStatusUpdate")
			net.Send(activator)
			self:TableStart()
			return
		end
		self:SetPlayer1(activator)
		//table.insert(self.players, activator:GetName()) // why do we have two player tables...
		table.insert(self.playersTable, activator)
		print("you are first player")
		activator:SetNWBool("TableView", true)
		net.Start("PlayerTableStatusUpdate")
		net.Send(activator)
		//print(self.player1 .. " player 1")
		return
	end

	if (table.Count(self.playersTable) == 1) then
		//print("one player in table")
		//print(activator:GetName() .. " activator")
		//print(player1:GetName() .. " player1")
		if (activator:GetName() == self:GetPlayer1():GetName()) then
			print("you're already in")
			return
		end
		self:SetPlayer2(activator)
		//table.insert(self.players, activator:GetName())
		table.insert(self.playersTable, activator)
		print("you are second player")
		activator:SetNWBool("TableView", true)
		net.Start("PlayerTableStatusUpdate")
		net.Send(activator)
	end

	self.player2 = self:GetPlayer2()

	if (table.Count(self.playersTable) == 2) then
		print("table start time")
		if self:GetTableStarted() then return end
		// table start!
		self:TableStart()
	end

	//activator:Freeze(true)
	//activator:Spectate(OBS_MODE_CHASE)
	//activator:SpectateEntity(self)
	// i want orbitcamera to start on the player when they are in the table
	// i want the table to start (a function probably) when 2 players are in
	// i want players to be able to leave the table

	PrintTable(self.playersTable)
end

net.Receive("RemovePlayer", function(len, ply)
	local ent = net.ReadEntity()
	local _player1 = ent:GetPlayer1()
	local _player2 = ent:GetPlayer2()
	//table.RemoveByValue(ent.players, ply:GetName())
	table.RemoveByValue(ent.playersTable, ply) // experiment
	print("is this even running")

	if IsValid(_player1) or IsValid(_player2) then
		if _player1:GetName() == ply:GetName() then
			print("player1 is player")
			ent:SetPlayer1(nil)
		elseif _player2:GetName() == ply:GetName() then
			print("player 2 is player")
			ent:SetPlayer2(nil)
		else
			print(_player1:GetName() .. " is not " .. ply:GetName())
		end
	else
		print("player1: " .. tostring(IsValid(_player1)) .. " ; " .. "player2: " .. tostring(IsValid(_player2)))
		print("player 1 or 2 is not in ent.player1 or 2.")
	end
	
	print("removing " .. ply:GetName() .. " from table players")
end)