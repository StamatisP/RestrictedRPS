GM.Name = "Restricted Rock Paper Scissors"
GM.Author = "Mineturtle"
GM.Email = "no"
GM.Website = "nah"

DeriveGamemode("base")

function GM:Initialize()
	-- Do stuff
	self.BaseClass.Initialize(self)
end

CreateConVar("rps_maxtime", 20, FCVAR_REPLICATED,"Max time for the round.")
CreateConVar("rps_interestrate", 0.015, FCVAR_REPLICATED,"Interest rate.")
CreateConVar("rps_interestrepeat", 3, FCVAR_REPLICATED,"Number of seconds until interest is done.") //75 in a 20 min game

hook.Add("StartCommand", "NullControl", function(ply, cmd)
	if ply:GetNWBool("TableView") then
		//print(ply:GetNWBool("TableView"))
		cmd:ClearMovement();
        cmd:RemoveKey( IN_ATTACK ); --See: https://wiki.garrysmod.com/page/Enums/IN
        cmd:RemoveKey( IN_JUMP );
        cmd:RemoveKey( IN_DUCK );
	end
end)