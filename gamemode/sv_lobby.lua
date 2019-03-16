local pmeta = FindMetaTable("Player")
local isLobbyStarted = false
print("sv_lobby start")

local function enterLobby()

	if isLobbyStarted then return end
	isLobbyStarted = true
	
	print("enter lobby")
	net.Start("OpenLobby")
	net.Broadcast()
end

local function giveMoney()
	for k, v in pairs(player.GetAll()) do
		if v:GetInfoNum("rps_money", 1000000) >= 1000000 or v:GetInfoNum("rps_money", 1000000) <= 10000000 then
			//print(v:GetInfoNum("rps_money", 1000000))
			v:UpdatePlayerVar("money", v:GetInfoNum("rps_money", 1000000))
			//print(v:ReturnPlayerMoney())
			v:UpdatePlayerVar("debt", v:GetInfoNum("rps_money", 1000000))
			//print(v:ReturnPlayerVar("debt"))
			//print(v:ReturnPlayerMoney())
		else
			print("you're a dirty cheater, aren't you?")
			v:UpdatePlayerVar("money", math.random(1000000, 10000000))
			v:UpdatePlayerVar("debt", math.random(1000000, 10000000))
		end
	end
end

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