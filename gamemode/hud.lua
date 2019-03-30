local cardChoice = false;
local moneyAfterFormat = 0
local debtAfterFormat = 0
local compoundTimeLeft = 0
local compoundTimeRate = GetGlobalFloat("interestrepeat", 0)
local pmeta = FindMetaTable("Player")
local rockcards = 0
local papercards = 0
local scissorscards = 0
local stars = 0

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

local function DrawInfo()

	if not GetGlobalBool("IsRoundStarted", false) then return end
	//print("fuck")
	draw.RoundedBox(5, ScrW() * 0.01, ScrH() * 0.925, width / 3.885, height / 15.36, Color(50, 50, 50, 220)) // money
	draw.RoundedBox(5, ScrW() * 0.01, ScrH() * 0.005, width / 3.885, height / 15.36, Color(50, 50, 50, 220)) // debt
	draw.RoundedBox(5, ScrW() * 0.85, ScrH() * 0.005, width / 8, height / 10, Color(50, 50, 50, 220)) // time left
	//draw.RoundedBox(5, ScrW() * 0.85, ScrH() * 0.015, width / 8, height / 15.36, Color(50, 50, 50, 220)) // compound time left
	draw.RoundedBox(5, ScrW() * 0.28, ScrH() * 0.925, width / 9.066, height / 15.36, Color(50, 50, 50, 220)) // rock
	draw.RoundedBox(5, ScrW() * 0.48, ScrH() * 0.925, width / 9.066, height / 15.36, Color(50, 50, 50, 220)) // paper
	draw.RoundedBox(5, ScrW() * 0.68, ScrH() * 0.925, width / 9.066, height / 15.36, Color(50, 50, 50, 220)) // scissors 
	draw.RoundedBox(5, ScrW() * 0.88, ScrH() * 0.925, width / 9.066, height / 15.36, Color(50, 50, 50, 220)) // stars

	local roundColor
	local compoundColor
	local timeLeft = math.max(0, GetGlobalFloat("endroundtime", 0) - CurTime())
	local compoundTxt
	local txt

	if not txt then txt = string.ToMinutesSeconds(timeLeft) end
	if not compoundTxt then compoundTxt = string.ToMinutesSeconds(compoundTimeLeft) end

	rockcards = LocalPlayer():ReturnPlayerVar("rockcards")
	papercards = LocalPlayer():ReturnPlayerVar("papercards")
	scissorscards = LocalPlayer():ReturnPlayerVar("scissorscards")
	stars = LocalPlayer():ReturnPlayerVar("stars")

	roundColor = InterpolateColor(Color(10, 210, 10), Color(255, 0, 0), GetGlobalFloat("rps_roundtime"), timeLeft)
	compoundColor = InterpolateColor(Color(10, 210, 10), Color(255, 0, 0), GetGlobalFloat("interestrepeat", 0), compoundTimeLeft)

	// in the future, if scrw > 1920, switch to a different, bigger font
	draw.SimpleText("Rock: " ..rockcards, "CardText", ScrW() * 0.33, ScrH() * 0.935, Color(255, 162, 228, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	draw.SimpleText("Paper: " ..papercards, "CardText", ScrW() * 0.53, ScrH() * 0.935, Color(114, 189, 208, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	draw.SimpleText("Scissors: " ..scissorscards, "CardText", ScrW() * 0.73, ScrH() * 0.935, Color(161, 193, 36, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	draw.SimpleText(moneyAfterFormat, "NormalText", ScrW() * 0.02, ScrH() * 0.935, Color(48, 221, 55, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	draw.SimpleText(debtAfterFormat, "NormalText", ScrW() * 0.02, ScrH() * 0.015, Color(255, 80, 80, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	draw.SimpleText(txt, "NormalText", ScrW() * 0.885, ScrH() * 0.015, roundColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	draw.SimpleText(compoundTxt, "NormalText", ScrW() * 0.885, ScrH() * 0.055, compoundColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	draw.SimpleText("Stars: " ..stars, "CardText", ScrW() * 0.93, ScrH() * 0.935, Color(255, 191, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
end

function InterpolateColor(startcolor, finishcolor, maxvalue, currentvalue)
	local hsvStart = ColorToHSV(finishcolor)
	local hsvFinish = ColorToHSV(startcolor)
	local hueLerp = Lerp(normalize(0, maxvalue, currentvalue), hsvStart, hsvFinish)
	local finalHsv = HSVToColor(hueLerp, 1, 1)
	return finalHsv
end

local function UpdateDebt()
	if not GetGlobalBool("IsRoundStarted", false) then return end
	if (LocalPlayer():ReturnPlayerVar("debt") == nil) then ErrorNoHalt("debt shouldnt be nil") return end
	local roundedDebt = math.Round(LocalPlayer():ReturnPlayerVar("debt"), 2)
	debtAfterFormat = formatMoney(roundedDebt)
end

local function CardRoutine()
	rockcards = LocalPlayer():ReturnPlayerVar("rockcards")
	papercards = LocalPlayer():ReturnPlayerVar("papercards")
	scissorscards = LocalPlayer():ReturnPlayerVar("scissorscards")
	stars = LocalPlayer():ReturnPlayerVar("stars")
	coroutine.yield()
end

local function UpdateCards()
	if not GetGlobalBool("IsRoundStarted", false) then return end

	local co
	if not co or not coroutine.resume(co) then
		co = coroutine.create(CardRoutine)
		coroutine.resume(co)
	end
end

local function UpdateMoney()
	if not GetGlobalBool("IsRoundStarted", false) then return end
	if (LocalPlayer():ReturnPlayerVar("money") == nil) then ErrorNoHalt("how in the world is money nil??") return end
	local roundedMoney = math.Round(LocalPlayer():ReturnPlayerVar("money"), 2)
	// somehow add a lerp?
	moneyAfterFormat = formatMoney(roundedMoney)
end

local function UpdateCompoundTime()
	compoundTimeLeft = GetGlobalFloat("interestrepeat") // time to take a break
end

function GM:Think()
	if not GetGlobalBool("IsRoundStarted", false) then return end
	compoundTimeLeft = compoundTimeLeft - RealFrameTime()
	if compoundTimeLeft <= 0 then 
		compoundTimeLeft = compoundTimeLeft + GetGlobalFloat("interestrepeat", 2)
		//compoundTimeLeft = compoundTimeLeft + CurTime()
	end
end

timer.Create("UpdateMoney", 0.5, 0, UpdateMoney)
timer.Create("UpdateDebt", 0.5, 0, UpdateDebt)
//timer.Create("UpdateCompoundTime", GetGlobalFloat("interestrepeat"), 0, UpdateCompoundTime)

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
		
	elseif !enabled then
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

function GM:HUDPaint()
	localplayer = localplayer and IsValid(localplayer) and localplayer or LocalPlayer()
    if not IsValid(localplayer) then return end

    DrawInfo()
    DrawEntityDisplay()
end