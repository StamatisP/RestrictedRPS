net.Receive("UpdateTableView",function(len, ply)
	ply:SetNWBool("TableView", net.ReadBool())
end)
// why the hell is this its own file??