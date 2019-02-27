//include("database/cl_database.lua")

surface.CreateFont("NormalText", {
	font = "Arial",
	size = 40,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})
surface.CreateFont("CardText", {
	font = "Arial",
	size = 35,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true
}

local ply = LocalPlayer()
local cardChoice = false;

hook.Add("HUDShouldDraw","hideHud",function(name)
	if (hide[name]) then return false end
end)

print("hud paint")

function attachCurrency(str)
	return "¥" .. str 
end

// look man this stuff is hard, i miss my c# string format
function formatMoney(n)
	if not n then return attachCurrency("0") end

	if n >= 1e14 then return attachCurrency(tostring(n)) end
    if n <= -1e14 then return "-" .. attachCurrency(tostring(math.abs(n))) end

    local negative = n < 0

    n = tostring(math.abs(n))
    local sep = sep or ","
    local dp = string.find(n, "%.") or #n + 1

    for i = dp - 4, 1, -3 do
        n = n:sub(1, i) .. sep .. n:sub(i + 1)
    end

    return (negative and "-" or "") .. attachCurrency(n)
end

local width = ScrW()
local height = ScrH()

hook.Add("HUDPaint","HudPaint_DrawMoney",function()

	if !hook.Run("ClDatabaseFinish") then return end
	if RoundStarted == false then return end
	draw.RoundedBox(5, ScrW() * 0.01, ScrH() * 0.925, width / 3.885, height / 15.36, Color(50, 50, 50, 240))
	draw.RoundedBox(5, ScrW() * 0.28, ScrH() * 0.925, width / 9.066, height / 15.36, Color(50, 50, 50, 240))
	draw.RoundedBox(5, ScrW() * 0.48, ScrH() * 0.925, width / 9.066, height / 15.36, Color(50, 50, 50, 240))
	draw.RoundedBox(5, ScrW() * 0.68, ScrH() * 0.925, width / 9.066, height / 15.36, Color(50, 50, 50, 240))
	draw.RoundedBox(5, ScrW() * 0.88, ScrH() * 0.925, width / 9.066, height / 15.36, Color(50, 50, 50, 240))

	if (inventoryGetValue("money") == nil) then return end
	local roundedMoney = math.Round(databaseGetValue("money"), 2)
	// somehow add a lerp?
	local moneyAfterFormat = formatMoney(roundedMoney)
	//print(moneyAfterFormat)

	

	//local inv = inventoryTable()
	//rockcards = table.ToString(inv["rockcards"])
	//print(string.match(rockcards, "%d+"))
	//if !IsValid(inventoryGetItem) then return end
	local rockcards = nil
	local papercards = nil
	local scissorscard = nil
	local stars = nil
	if (inventoryHasItem("rockcards")) then
		rockcards = inventoryGetItem("rockcards")
	else
		rockcards = "0"
	end
	if (inventoryHasItem("papercards")) then
		papercards = inventoryGetItem("papercards")
	else
		papercards = "0"
	end
	if (inventoryHasItem("scissorscards")) then
		scissorscards = inventoryGetItem("scissorscards")
	else
		scissorscards = "0"
	end
	if (inventoryHasItem("stars")) then
		stars = inventoryGetItem("stars")
	else
		stars = "0"
	end

	// in the future, if scrw > 1920, switch to a different, bigger font
	draw.SimpleText("Rock: " ..rockcards, "CardText", ScrW() * 0.30, ScrH() * 0.935, Color(255, 162, 228, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	draw.SimpleText("Paper: " ..papercards, "CardText", ScrW() * 0.50, ScrH() * 0.935, Color(114, 189, 208, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	draw.SimpleText("Scissors: " ..scissorscards, "CardText", ScrW() * 0.70, ScrH() * 0.935, Color(161, 193, 36, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	draw.SimpleText(moneyAfterFormat, "NormalText", ScrW() * 0.02, ScrH() * 0.935, Color(48, 221, 55, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	draw.SimpleText("Stars: " ..stars, "CardText", ScrW() * 0.90, ScrH() * 0.935, Color(255, 191, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end)

local function CardChoiceGUI(enabled)
	if enabled then
		local choice = nil
		local confirmColor = Color(71, 158, 215, 255)
		local defaultColor = Color(225, 228, 227, 255)
		local frame = vgui.Create("DFrame")
		frame:SetSize(300, 250)
		frame:Center()
		frame:SetVisible(true)
		frame:ShowCloseButton(true)
		frame:SetDraggable(true)
		frame:MakePopup()

		local dButtonReady = vgui.Create("DButton", frame)
		dButtonReady:SetText("Confirm Choice")
		dButtonReady:SetPos(25, 200)
		dButtonReady:SetSize(100, 30)
		dButtonReady:SetEnabled(false)
		dButtonReady.DoClick = function()
			frame:Close()
			// i need to write the entity that the player is looking at...
			local ent = TablePlayerIsUsing
			net.Start("ArePlayersReady")
			net.WriteEntity(ent)
			net.WriteString(LocalPlayer():GetName())
			net.WriteBool(true)
			net.SendToServer()
		end

		local dButtonRock = vgui.Create("DButton", frame)
		dButtonRock:SetText("Rock")
		dButtonRock:SetPos(25, 50)
		dButtonRock:SetSize(250, 30)
		dButtonRock.Paint = function (self, w, h)
			if choice == "Rock" then
				//dButtonRock:SetColor(confirmColor)
				draw.RoundedBox(0,0,0,w,h,confirmColor)
			elseif choice != "Rock" then
				draw.RoundedBox(0,0,0,w,h,defaultColor)
			end
		end
		dButtonRock.DoClick = function()
			RunConsoleCommand("rps_selection", "Rock")
			choice = "Rock"
			dButtonReady:SetEnabled(true)
		end

		local dButtonPaper = vgui.Create("DButton", frame)
		dButtonPaper:SetText("Paper")
		dButtonPaper:SetPos(25, 100)
		dButtonPaper:SetSize(250, 30)
		dButtonPaper.Paint = function(self, w, h)
			if choice == "Paper" then
				draw.RoundedBox(0,0,0,w,h,confirmColor)
			elseif choice != "Paper" then
				draw.RoundedBox(0,0,0,w,h,defaultColor)
			end
		end
		dButtonPaper.DoClick = function()
			RunConsoleCommand("rps_selection", "Paper")
			choice = "Paper"
			dButtonReady:SetEnabled(true)
			// couldn't i just like... dButtonPaper:SetColor(confirmcolor) dButtonRock:SetColor(defaultcolor) etc with scissors
		end

		local dButtonScissors = vgui.Create("DButton", frame)
		dButtonScissors:SetText("Scissors")
		dButtonScissors:SetPos(25, 150)
		dButtonScissors:SetSize(250, 30)
		dButtonScissors.Paint = function(self, w, h)
			if choice == "Scissors" then
				draw.RoundedBox(0,0,0,w,h,confirmColor)
			elseif choice != "Scissors" then
				draw.RoundedBox(0,0,0,w,h,defaultColor)
			end
		end
		dButtonScissors.DoClick = function()
			RunConsoleCommand("rps_selection", "Scissors")
			choice = "Scissors"
			dButtonReady:SetEnabled(true)
		end

		if (!inventoryHasItem("rockcards")) then
			dButtonRock:SetEnabled(false)
		end
		if (!inventoryHasItem("papercards")) then
			dButtonPaper:SetEnabled(false)
		end
		if (!inventoryHasItem("scissorscards")) then
			dButtonScissors:SetEnabled(false)
		end
		
	elseif !enabled then
		//close all frames
	end
end

net.Receive("PlayerTableCheckGUIEnable", function(len, ply)
	//cardChoice = true
	print("playertablecheckguienable has been received")
	CardChoiceGUI(true)
end)