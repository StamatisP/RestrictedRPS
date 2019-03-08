local round_status = 0
-- todo: replace round_status to a bool

net.Receive("UpdateRoundStatus",function(len)

	round_status = net.ReadInt(4);
	RoundStarted = true
end)

function getRoundStatus(  )
	-- body
	return round_status
end