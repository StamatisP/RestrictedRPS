local cardChoice = false;
local moneyAfterFormat = 0
local debtAfterFormat = 0
local compoundTimeLeft = 0
local compoundTimeRate = nil
local pmeta = FindMetaTable("Player")
local rockcards = 0
local papercards = 0
local scissorscards = 0
local stars = 0
local _roundstart = false
local rockmat, papermat, scissorsmat
local _curtimesubtract = nil
local compoundtimer = nil
local roundtimer = nil
include("circles.lua")

function GM:HUDShouldDraw(name)
	if name == "CHudBattery" or
		name == "CHudHealth" or 
		name == "CHudSuitPower" then
			return false
	else
		return true
	end
end

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

local function normalize(min, max, val) 
    local delta = max - min
    return (val - min) / delta
end

local roundTimerCircle = draw.CreateCircle(CIRCLE_FILLED)
roundTimerCircle:SetRadius(35)
roundTimerCircle:SetPos(width * 0.55, height * 0.045)
roundTimerCircle:SetAngles(0, 360)
roundTimerCircle:SetRotation(270)

local compoundTimerCircle = draw.CreateCircle(CIRCLE_FILLED)
compoundTimerCircle:SetRadius(25)
compoundTimerCircle:SetPos(width * 0.55, height * 0.045)
compoundTimerCircle:SetAngles(0, 360)
compoundTimerCircle:SetRotation(270)

local circleDivider = draw.CreateCircle(CIRCLE_FILLED)
circleDivider:SetRadius(15)
circleDivider:SetPos(width * 0.55, height * 0.045)
circleDivider:SetAngles(0, 360)

local function DrawInfo()
	if not _roundstart then return end

	surface.SetDrawColor(255, 255, 255, 210)
	surface.SetMaterial(rockmat)
	surface.DrawTexturedRect(width * 0.15, height * 0.86, width / 6, height / 6)

	surface.SetMaterial(papermat)
	surface.DrawTexturedRect(width * 0.40, height * 0.86, width / 6, height / 6)

	surface.SetMaterial(scissorsmat)
	surface.DrawTexturedRect(width * 0.65, height * 0.86, width / 6, height / 6)

	draw.RoundedBox(8, 300, 0, 400, 80, Color(102, 0, 16, 230)) // compound debt
	surface.SetDrawColor(120, 60, 0, 255)
	surface.DrawRect(310, 10, 380, 60)

	draw.RoundedBox(8, 700, 0, 500, 100, Color(0, 0, 0, 230)) // middle timer/stars
	surface.SetDrawColor(50, 50, 50, 255)
	surface.DrawRect(710, 10, 480, 80)

	draw.RoundedBox(8, 1200, 0, 400, 80, Color(0, 70, 0, 230)) // actual money
	surface.SetDrawColor(0, 120, 60, 255)
	surface.DrawRect(1210, 10, 380, 60)	

	local roundColor
	local compoundColor
	local timeLeft = math.max(0, GetGlobalFloat("endroundtime", 0) - CurTime())
	local compoundTxt
	local txt
	//roundTimerCircle:SetAngles(0, normalize(0, compoundtimer, timeLeft))
	//print(normalize(0, compoundtimer, timeLeft))
	//print(compoundtimer, timeLeft)
	roundTimerCircle:SetAngles(0, normalize(0, roundtimer, timeLeft) * 360)
	compoundTimerCircle:SetAngles(0, normalize(0, compoundtimer, compoundTimeLeft) * 360)
	//print(normalize(0, roundtimer, timeLeft))

	draw.NoTexture()
	surface.SetDrawColor(48, 221, 55, 255)
	roundTimerCircle:Draw()
	draw.NoTexture()
	surface.SetDrawColor(255, 80, 80, 255)
	compoundTimerCircle:Draw()
	draw.NoTexture()
	surface.SetDrawColor(120, 120, 120, 255)
	circleDivider:Draw()

	if not txt then txt = string.ToMinutesSeconds(timeLeft) end
	if not compoundTxt then compoundTxt = string.ToMinutesSeconds(compoundTimeLeft) end

	rockcards = LocalPlayer():ReturnPlayerVar("rockcards")
	papercards = LocalPlayer():ReturnPlayerVar("papercards")
	scissorscards = LocalPlayer():ReturnPlayerVar("scissorscards")
	stars = LocalPlayer():ReturnPlayerVar("stars")
	if not rockcards or not papercards or not scissorscards then
		rockcards = 0
		papercards = 0
		scissorscards = 0
	end

	roundColor = InterpolateColor(Color(10, 210, 10), Color(255, 0, 0), GetGlobalFloat("rps_roundtime"), timeLeft)
	compoundColor = InterpolateColor(Color(10, 210, 10), Color(255, 0, 0), GetGlobalFloat("interestrepeat", 0), compoundTimeLeft)

	// in the future, if scrw > 1920, switch to a different, bigger font
	draw.SimpleTextOutlined(rockcards, 			"CardText", 	width * 0.27, 	height * 0.929, 	Color(114, 6, 6, 255), 	TEXT_ALIGN_CENTER, 	TEXT_ALIGN_TOP, 3, Color(255, 255, 255, 255))
	draw.SimpleTextOutlined(papercards, 		"CardText", 	width * 0.52, 	height * 0.929, 	Color(114, 6, 6, 255), 	TEXT_ALIGN_CENTER, 	TEXT_ALIGN_TOP, 3, Color(255, 255, 255, 255))
	draw.SimpleTextOutlined(scissorscards, 		"CardText", 	width * 0.77, 	height * 0.929, 	Color(114, 6, 6, 255), 	TEXT_ALIGN_CENTER, 	TEXT_ALIGN_TOP, 3, Color(255, 255, 255, 255))
	draw.SimpleTextOutlined(moneyAfterFormat, 	"NormalText", 	width / 1.58, 	height * 0.015, 	Color(48, 221, 55, 255),TEXT_ALIGN_LEFT, 	TEXT_ALIGN_TOP, 2, Color(0, 0, 0, 255))
	draw.SimpleTextOutlined(debtAfterFormat, 	"NormalText", 	width / 6.1, 	height * 0.015, 	Color(255, 80, 80, 255),TEXT_ALIGN_LEFT, 	TEXT_ALIGN_TOP, 2, Color(0, 0, 0, 255))
	draw.SimpleTextOutlined(txt, 				"NormalText", 	width / 1.76, 	height * 0.01, 	roundColor, 			TEXT_ALIGN_LEFT, 	TEXT_ALIGN_TOP, 2, Color(0, 0, 0, 255))
	draw.SimpleTextOutlined(compoundTxt,		"NormalText", 	width / 1.76, 	height * 0.05, 	compoundColor, 			TEXT_ALIGN_LEFT, 	TEXT_ALIGN_TOP, 2, Color(0, 0, 0, 255))
	draw.SimpleTextOutlined("Stars: " .. stars, "CardText", 	width * 0.41, 	height * 0.016, 	Color(255, 191, 0, 255),TEXT_ALIGN_CENTER, 	TEXT_ALIGN_TOP, 2, Color(0, 0, 0, 255))
end

function InterpolateColor(startcolor, finishcolor, maxvalue, currentvalue)
	local hsvStart = ColorToHSV(finishcolor)
	local hsvFinish = ColorToHSV(startcolor)
	local hueLerp = Lerp(normalize(0, maxvalue, currentvalue), hsvStart, hsvFinish)
	local finalHsv = HSVToColor(hueLerp, 1, 1)
	return finalHsv
end

local function UpdateDebt()
	if not _roundstart then return end
	if (LocalPlayer():ReturnPlayerVar("debt") == nil) then ErrorNoHalt("debt shouldnt be nil") return end
	local roundedDebt = math.Round(LocalPlayer():ReturnPlayerVar("debt"), 2)
	debtAfterFormat = formatMoney(roundedDebt)
end

local function UpdateMoney()
	if not _roundstart then return end
	if (LocalPlayer():ReturnPlayerVar("money") == nil) then ErrorNoHalt("how in the world is money nil??") return end
	local roundedMoney = math.Round(LocalPlayer():ReturnPlayerVar("money"), 2)
	// somehow add a lerp?
	moneyAfterFormat = formatMoney(roundedMoney)
end

local function UpdateCompoundTime()
	compoundTimeRate = 75 + CurTime()
	//print(compoundTimeRate) // time to take a break
end

function GM:Think()
	if not _roundstart then return end
	compoundTimeLeft = compoundTimeRate - CurTime()
end

local function CardChoiceGUI(enabled)
	if enabled then
		local choice = nil
		local confirmColor = Color(185, 22, 22, 255)
		local defaultColor = Color(225, 228, 227, 255)
		local frame = vgui.Create("DFrame")
		frame:SetSize(300, 250)
		frame:Center()
		frame:SetVisible(true)
		frame:ShowCloseButton(false)
		frame:SetDraggable(true)
		frame:SetTitle("Check")
		frame:MakePopup()

		local dButtonReady = vgui.Create("DButton", frame)
		dButtonReady:SetText("Confirm Choice")
		dButtonReady:SetPos(25, 200)
		dButtonReady:SetSize(100, 30)
		dButtonReady:SetEnabled(false)
		dButtonReady.DoClick = function()
			frame:Close()
			// i need to write the entity that the player is looking at...
			local ent = LocalPlayer():GetNWEntity("TableUsing", NULL)
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
			frame:SetTitle("Set")
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
			frame:SetTitle("Set")
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
			frame:SetTitle("Set")
			RunConsoleCommand("rps_selection", "Scissors")
			choice = "Scissors"
			dButtonReady:SetEnabled(true)
		end

		if not (LocalPlayer():ReturnPlayerVar("rockcards") >= 1) then
			dButtonRock:SetEnabled(false)
		end
		if not (LocalPlayer():ReturnPlayerVar("papercards") >= 1) then
			dButtonPaper:SetEnabled(false)
		end
		if not (LocalPlayer():ReturnPlayerVar("scissorscards") >= 1) then
			dButtonScissors:SetEnabled(false)
		end
		
	elseif not enabled then
		//close all frames
	end
end

net.Receive("PlayerTableCheckGUIEnable", function(len, ply)
	//cardChoice = true
	print("playertablecheckguienable has been received")
	CardChoiceGUI(true)
end)

/*hook.Add( "HUDPaint", "PaintName", function()  
    for k, ent in ipairs(player.GetAll()) do  
        if ent != LocalPlayer() then
               local dist = LocalPlayer():GetPos():Distance(ent:GetPos())  
               local BoneIndx = ent:LookupBone("ValveBiped.Bip01_Head1")  
               local pos = ent:GetBonePosition( BoneIndx )  
               pos.z = pos.z + 10 + (dist * 0.0325) --Makes it move up the further away you are..  
               local ScrnPos = pos:ToScreen()  
               draw.SimpleText( ent:Nick() .. "\n" .. inventoryGetItem("stars"), "ScoreboardDefault", ScrnPos.x, ScrnPos.y, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
        end 
    end  
end)  */
// hoo yeah its darkrp referencing time

local function safeText(text)
	return string.match(text, "^#([a-zA-Z_]+)$") and text .. " " or text
end

pmeta.drawPlayerInfo = pmeta.drawPlayerInfo or function(self)
	if not _roundstart then return end
	local pos = self:EyePos()

	pos.z = pos.z + 10
	pos = pos:ToScreen()

	draw.SimpleText(safeText(self:Nick()), "ScoreboardDefault", pos.x + 1, pos.y + 1, Color(0, 0, 0, 255), 1)
	draw.SimpleText(safeText(self:Nick()), "ScoreboardDefault", pos.x, pos.y, Color(255, 255, 255, 255), 1)

	draw.SimpleText(self:ReturnPlayerVar("stars") .. " Stars", "ScoreboardDefault", pos.x + 1, pos.y + 21, Color(0, 0, 0, 255), 1)
	draw.SimpleText(self:ReturnPlayerVar("stars") .. " Stars", "ScoreboardDefault", pos.x, pos.y + 20, Color(255, 191, 0, 255), 1)
end

local function DrawEntityDisplay()
    local shootPos = localplayer:GetShootPos()
    local aimVec = localplayer:GetAimVector()

    for _, ply in pairs(players or player.GetAll()) do
        if not IsValid(ply) or ply == localplayer or not ply:Alive() or ply:GetNoDraw() or ply:IsDormant() then continue end
        local hisPos = ply:GetShootPos()

        if hisPos:DistToSqr(shootPos) < 80000 then
            local pos = hisPos - shootPos
            local unitPos = pos:GetNormalized()
            if unitPos:Dot(aimVec) > 0.95 then
                local trace = util.QuickTrace(shootPos, pos, localplayer)
                if trace.Hit and trace.Entity ~= ply then break end
                ply:drawPlayerInfo()
            end
        end
    end
end

hook.Add("RoundStarted", "roundstarthud", function()
	rockmat = Material("hud_rock.png")
	papermat = Material("hud_paper.png")
	scissorsmat = Material("hud_scissors.png")
	timemat = Material("time_bg.png")
	timer.Create("UpdateMoney", 0.5, 0, UpdateMoney)
	timer.Create("UpdateDebt", 0.5, 0, UpdateDebt)

	compoundTimeRate = GetGlobalInt("interestrepeat", 75) + CurTime()
	compoundtimer = GetGlobalInt("interestrepeat", 75)
	roundtimer = GetGlobalInt("endroundtime", 1200)
	_curtimesubtract = CurTime()
	_roundstart = true
	timer.Create("CompoundTimeHUD", GetGlobalInt("interestrepeat", 75), 0, UpdateCompoundTime)
end)

function GM:HUDPaint()
	localplayer = localplayer and IsValid(localplayer) and localplayer or LocalPlayer()
    if not IsValid(localplayer) then return end

    DrawInfo()
    DrawEntityDisplay()
end