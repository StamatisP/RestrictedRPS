local round_status = 0
-- todo: replace round_status to a bool

net.Receive("UpdateRoundStatus",function(len)

	round_status = net.ReadInt(4);
	if round_status == 1 then 
		RoundStarted = true
		hook.Run("RoundStarted")
		return 
	end
	if round_status == 0 then 
		RoundStarted = false
		hook.Run("RoundEnded")
		return 
	end
end)

function getRoundStatus(  )
	-- body
	return round_status
end

local function EndRoundLobby()
	local width = ScrW()
	local height = ScrH()
	local frame = vgui.Create("DFrame")
	frame:SetSize(width, height)
	frame:Center()
	frame:SetVisible(true)
	frame:ShowCloseButton(false)
	frame:SetDraggable(false)
	frame:SetTitle("")
	frame.Paint = function(s, w, h)

		//draw.RoundedBox(0,0,0,w,h,Color(100,100,100,255))
		draw.RoundedBox(0,0,0,w,h,Color(0, 0, 0,255))

	end
	frame:MakePopup()
	frame:SetKeyboardInputEnabled(false)

	local text = vgui.Create("DLabel", frame)
	text:SetText("You win or something idk")
	text:SetFont("RoundLobbyFont")
	text:SetSize(width / 2, height / 2)
	text:Center()
	text:SetContentAlignment(5)
	//text:SetPos(width / 2, height / 2)

end

hook.Add("RoundEnded","Round End", EndRoundLobby)