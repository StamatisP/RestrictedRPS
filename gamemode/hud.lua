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
	draw.RoundedBox(5, ScrW() * 0.01, ScrH() * 0.925, width / 3.885, height / 15.36, Color(50, 50, 50, 240))
	draw.RoundedBox(5, ScrW() * 0.33, ScrH() * 0.925, width / 9.066, height / 15.36, Color(50, 50, 50, 240))
	draw.RoundedBox(5, ScrW() * 0.53, ScrH() * 0.925, width / 9.066, height / 15.36, Color(50, 50, 50, 240))
	draw.RoundedBox(5, ScrW() * 0.73, ScrH() * 0.925, width / 9.066, height / 15.36, Color(50, 50, 50, 240))

	local roundedMoney = math.Round(databaseGetValue("money"), 2)
	local moneyAfterFormat = formatMoney(roundedMoney)
	//print(moneyAfterFormat)

	

	//local inv = inventoryTable()
	//rockcards = table.ToString(inv["rockcards"])
	//print(string.match(rockcards, "%d+"))
	//if !IsValid(inventoryGetItem) then return end
	local rockcards = inventoryGetItem("rockcards")
	local papercards = inventoryGetItem("papercards")
	local scissorscards = inventoryGetItem("scissorscards")

	// in the future, if scrw > 1920, switch to a different, bigger font
	draw.SimpleText("Rock: " ..rockcards, "CardText", ScrW() * 0.35, ScrH() * 0.935, Color(255, 162, 228, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	draw.SimpleText("Paper: " ..papercards, "CardText", ScrW() * 0.55, ScrH() * 0.935, Color(114, 189, 208, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	draw.SimpleText("Scissors: " ..scissorscards, "CardText", ScrW() * 0.74, ScrH() * 0.935, Color(161, 193, 36, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	draw.SimpleText(moneyAfterFormat, "NormalText", ScrW() * 0.02, ScrH() * 0.932, Color(48, 221, 55, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end)

local function CardChoiceGUI(enabled)
	if enabled then
		local frame = vgui.Create("DFrame")
		frame:SetSize(300, 250)
		frame:Center()
		frame:SetVisible(true)
		frame:ShowCloseButton(true)
		frame:SetDraggable(true)
		frame:MakePopup()

		local dButtonRock = vgui.Create("DButton", frame)
		dButtonRock:SetText("Rock")
		dButtonRock:SetPos(25, 50)
		dButtonRock:SetSize(250, 30)
		dButtonRock.DoClick = function()
			RunConsoleCommand("rps_selection", "Rock")
		end

		local dButtonPaper = vgui.Create("DButton", frame)
		dButtonPaper:SetText("Paper")
		dButtonPaper:SetPos(25, 100)
		dButtonPaper:SetSize(250, 30)
		dButtonPaper.DoClick = function()
			RunConsoleCommand("rps_selection", "Paper")
		end

		local dButtonScissors = vgui.Create("DButton", frame)
		dButtonScissors:SetText("Scissors")
		dButtonScissors:SetPos(25, 150)
		dButtonScissors:SetSize(250, 30)
		dButtonScissors.DoClick = function()
			RunConsoleCommand("rps_selection", "Scissors")
		end

		local dButtonReady = vgui.Create("DButton", frame)
		dButtonReady:SetText("Confirm Choice")
		dButtonReady:SetPos(25, 200)
		dButtonReady:SetSize(100, 30)
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
		
	elseif !enabled then
		//close all frames
	end
end

net.Receive("PlayerTableCheckGUIEnable", function(len, ply)
	//cardChoice = true
	print("playertablecheckguienable has been received")
	CardChoiceGUI(true)
end)