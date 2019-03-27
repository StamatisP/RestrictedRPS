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
		draw.RoundedBox(0,0,0,w,h,Color(0, 0, 0,40))

	end
	frame:MakePopup()
	frame:SetKeyboardInputEnabled(false)
	frame:SetMouseInputEnabled(false)

	local roundText = vgui.Create("DLabel", frame)
	roundText:SetText("Round over!")
	roundText:SetColor(Color(255, 0, 0, 255))
	roundText:SetPos(width / 2.2, height / 100)
	roundText:SetSize(width / 1.5, height / 1.5)
	roundText:SetFont("NormalText")

	local formattedmoney = formatMoney(math.Round(LocalPlayer():ReturnPlayerVar("money"), 2))

	local moneyText = vgui.Create("DLabel", frame)
	moneyText:SetText(string.format("Your final money:\n%s", formattedmoney)) // so messy....
	moneyText:SetFont("RoundLobbyFont")
	moneyText:SetSize(width / 2, height / 2)
	//moneyText:SetContentAlignment(5)
	moneyText:SetPos(width / 4, height / 4)
	moneyText:SetColor(Color(0, 255, 0, 255))

	local formattedDebt = formatMoney(math.Round(LocalPlayer():ReturnPlayerVar("debt"), 2))

	local debtText = vgui.Create("DLabel", frame)
	debtText:SetText(string.format("Your final debt:\n%s", formattedDebt))
	debtText:SetFont("RoundLobbyFont")
	debtText:SetSize(width / 2, height / 2)
	debtText:SetPos(width / 1.5, height / 4)
	debtText:SetColor(Color(255, 0, 0, 255))

	local finalTotal = LocalPlayer():ReturnPlayerVar("money") - LocalPlayer():ReturnPlayerVar("debt")
	local formattedTotal = formatMoney(math.Round(finalTotal, 2))

	local totalText = vgui.Create("DLabel", frame)
	totalText:SetText(string.format("Final total:\n%s", formattedTotal))
	totalText:SetFont("RoundLobbyFont")
	totalText:SetSize(width / 2, height / 2)
	totalText:SetPos(width / 2.1, height / 3)
	if finalTotal < 0 then 
		totalText:SetColor(Color(255, 0, 0, 255))
	else
		totalText:SetColor(Color(0, 255, 0, 255))
	end
end

hook.Add("RoundEnded","Round End", EndRoundLobby)