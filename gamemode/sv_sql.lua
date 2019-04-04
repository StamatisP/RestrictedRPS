local oldPrint = print
local function print(s)
	if s == nil then s = "s is nil" end
	oldPrint("sv_sql.lua: " .. s)
end

local function TableExist()
 	if (sql.TableExists("rrps_player_info")) then
 		print("Table exists.")
 	else
 		if not (sql.TableExists("rrps_player_info")) then
 			local query = "CREATE TABLE rrps_player_info ( unique_id varchar(255), money DECIMAL(20, 2), debt DECIMAL(20, 2) )"
 			local result = sql.Query(query)
 			if (sql.TableExists("rrps_player_info")) then
 				print("Table created.")
 			else
 				ErrorNoHalt("Something messed up. ")
 				print(sql.LastError(result))
 			end
 		end
 	end
end

local function InitSql()
	TableExist()
end

function UpdatePlayerVarSQL(ply, amount, var)
	if not isnumber(amount) or amount < 0 or amount >= 1 / 0 then return end
	if not var then ErrorNoHalt("Forgot to specify var!") return end

	local roundedamount = math.Round(amount, 2)
	local query = ("UPDATE rrps_player_info SET "..var.." = '"..roundedamount.."' WHERE unique_id = '"..ply:SteamID().."'")
	//print(query)
	sql.Query(query)
	local result = sql.Query("SELECT unique_id, "..var.." FROM rrps_player_info WHERE unique_id = '"..ply:SteamID().."'")
	if (result) then
		print("Player "..var.." has been updated successfully. ", PrintTable(result))
	else
		ErrorNoHalt("Player "..var.." NOT successful, ", sql.LastError(result))
	end
end

local function GetValueFromResult(tbl, key)
	for k, v in pairs(tbl[1]) do
		if (k == key) then return v end
		ErrorNoHalt("key "..key.." not found in table", PrintTable(tbl))
		print(v)
	end
end

function ReturnPlayerVarSQL(ply, var)
	if not ply then ErrorNoHalt("ply is not defined!") return end
	if not var then ErrorNoHalt("var is not defined!") return end

	local query = ("SELECT "..var.." FROM rrps_player_info WHERE unique_id = '"..ply:SteamID().."'")
	local result = sql.Query(query)
	if (result) then
		print("Player "..ply:Nick().." "..var.." received, is "..GetValueFromResult(result, var))
		return GetValueFromResult(result, var)
		//PrintTable(result)
	else
		ErrorNoHalt("Player "..var.." failed to get! ")
		print(sql.LastError(result))
	end
end

/*function ReturnLeaderboard(ply)
	local query = ("SELECT * FROM rrps_player_info") // to create this, i need a new var in the table for the player name
	local result = sql.Query(query)
	if (result) then
		print("Leaderboard returned.")
		local json = util.TableToJSON(result)
		//PrintTable(result)
		//print(json)
		local data = util.Compress(json)
		if not data then ErrorNoHalt("data is nil!") return end
		print(data)
		net.Start("SendLeaderboardInfo")
			net.WriteData(data, 60)
		net.Send(ply)
		//return result
	else
		ErrorNoHalt("Leaderboard return error!")
	end
end*/

local function CreateNewPlayer(steamID, ply)
	sql.Query("INSERT INTO rrps_player_info ('unique_id', 'money', 'debt') VALUES ('"..steamID.."', '0', '0')")
	local result = sql.Query("SELECT unique_id, money, debt FROM rrps_player_info WHERE unique_id = '"..steamID.."'")
	if (result) then
		print("Player entry in database created!")
	else
		ErrorNoHalt("Error in CreateNewPlayer, " .. sql.LastError(result))
	end
end

local function PlayerExists(ply)
	local result = sql.Query("SELECT unique_id, money, debt FROM rrps_player_info WHERE unique_id = '"..ply:SteamID().."'")
	if (result) then
		// retrieve stats
	else
		CreateNewPlayer(ply:SteamID(), ply)
	end
end

local function PlayerInitSpawn(ply)
	timer.Create("SteamID_Delay", 1, 1, function()
		timer.Create("SaveStat"..ply:SteamID(), 10, 0, function()
			//saveStat(ply)
		end)
		PlayerExists(ply)
	end)
end

hook.Add("Initialize","InitSql", InitSql)
hook.Add("PlayerInitialSpawn", "PlayerInitSpawnSql", PlayerInitSpawn)