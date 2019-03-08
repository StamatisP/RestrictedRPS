local pmeta = FindMetaTable("Player")
local isLobbyStarted = false
print("sv_lobby start")

local function enterLobby()

	if isLobbyStarted == true then return end
	//isLobbyStarted = true
	
	print("enter lobby")
	net.Start("OpenLobby")
	net.Broadcast()
end

/*function giveMoneyold()

	for k, v in pairs(player.GetAll()) do
		if v:GetInfoNum("rps_money", 1000000) >= 1000000 or v:GetInfoNum("rps_money", 1000000) <= 10000000 then
			v:GetInfoNum("rps_money", 1000000)
			print(v:GetInfoNum("rps_money", 1000000)) // don't trust the console command, use net.readint for the amount instead
		else
			net.Receive("moneyUpdate", function(len, ply) //may have to secure this // ok this is fucked 
				local money = net.ReadInt(28)
				if money < 1000000 then
					print("dirty cheater")
					money = math.random(1000000, 10000000)
				elseif money > 10000000 then
					print("dirty cheater")
					money = math.random(1000000, 10000000)
				else
				print(money .. " yeet")
				ply:databaseSetValue("money", money)
				end
			end)
			//setnwint maybe??
		end
	end

end*/

local function giveMoney()
	//print("moved")
	for k, v in pairs(player.GetAll()) do
		if v:GetInfoNum("rps_money", 1000000) >= 1000000 or v:GetInfoNum("rps_money", 1000000) <= 10000000 then
			print(v:GetInfoNum("rps_money", 1000000))
			v:databaseSetValue("money", v:GetInfoNum("rps_money", 1000000))
			v:databaseSetValue("debt", v:GetInfoNum("rps_money", 1000000))
		else
			print("you're a dirty cheater, aren't you?")
			v:databaseSetValue("money", math.random(1000000, 10000000))
			v:databaseSetValue("debt", math.random(1000000, 10000000))
		end
	end
end

/*net.Receive("moneyUpdate", function(len, ply)
		local money = net.ReadInt(28)
		if money < 1000000 or money > 10000000 then
			print("you dumb cheater big dumb head dumb")
			money = math.random(1000000, 10000000)
			print(money .. " yeet")
			ply:databaseSetValue("money", money)
		else
			print(money .. " is your current balance")
			ply:databaseSetValue("money", money)
		end
end)*/

net.Receive("StartGame", function(len, ply) 
	if !ply:IsSuperAdmin() then return end
	gmod.GetGamemode():BeginRound()
	//ply:GiveLoadout()
	giveMoney()
	isLobbyStarted = true
	net.Start("CloseLobby")
	net.Broadcast()
	print("game start")
end)

/*net.Receive("closeLobby", function(len, ply)
	closeFrame()
end)*/

hook.Add("PlayerSpawn","OpenPlayerLobby",enterLobby)
// so basically, i have to check if the lobby is started, and if it isn't, send openLobby

//hook.Add("PlayerSpawn", "OpenLobby", enterLobby)