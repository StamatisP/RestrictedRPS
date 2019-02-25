net.Receive("UpdateTableView",function(len, ply)
	ply:SetNWBool("TableView", net.ReadBool())
end)