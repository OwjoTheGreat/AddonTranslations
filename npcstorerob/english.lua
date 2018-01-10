// Again, don't touch this part
Config = Config or {}
Config.Laws = Config.Laws or {}
Config.Icons = Config.Icons or {}
Config.Design = Config.Design or {}
Config.Ranks = Config.Ranks or {}

include("multihud/multihud_config.lua")

// This is hiding the default HUD shit
local hideHUDElements = {
	["DarkRP_LocalPlayerHUD"]   = true,
	["CHudAmmo"]                = true,
	["CHudSecondaryAmmo"]       = true,
	["CHudHealth"]              = true,
	["CHudBattery"]             = true,
	["CHudSuitPower"]           = true,
}

hook.Add("HUDShouldDraw", "CrisisHUD:HideHUD", function(name)
	if hideHUDElements[name] then return false end
end)

// Ignore this for now
local H = 0
local W = ScrW() / 2
local QuestionVGUI = {}
local PanelNum = 0
local VoteVGUI = {}

// Creating fonts for the base HUD, will make a file for this later
surface.CreateFont("CrisisHUD_Font", {font = "Circular Std Bold", size = 17})
surface.CreateFont("CrisisHUD_OFont", {font = "Circular Std Bold", size = 45})
surface.CreateFont("CrisisHUD_ODickyMe", {font = "Circular Std Bold", size = 25})

// Makes the law disapear when F1 is pressed
local shouldShowLaws = true
local Timer = CurTime()
	hook.Add( "Think", "LawsOfTheLandToggle", function()
	if input.IsKeyDown( KEY_F1 ) and Timer < CurTime()  then
		shouldShowLaws = !shouldShowLaws
		Timer = CurTime()+0.5
	end
end )

// Lockdown HUD
local function IsLockDown()
    if GetGlobalBool("DarkRP_LockDown") then
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(Config.Icons["Lockdown"])
		surface.DrawTexturedRect(ScrW() / 2, H + 12, 16, 16)
		draw.SimpleText("Lockdown Active", "CrisisHUD_OFont", ScrW() / 2 - 155, H + 60, Color(200, 0, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
    end
end

// 'Arrested' HUD
	local Arrested = function() end

	usermessage.Hook("GotArrested", function(msg)
    	local ArrestedStart = CurTime()
    	local ArrestedExpires = msg:ReadFloat()
	local time = ( ArrestedExpires - ( CurTime() - ArrestedStart ) )

	Arrested = function()
	if LocalPlayer():isArrested() then
			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(Config.Icons["Arrested"])
			surface.DrawTexturedRect(ScrW() * 0.777, H + 12, 16, 16)
			draw.SimpleText("You are Arrested", "CrisisHUD_OFont", ScrW() / 2 - 125, ScrH() / 2 - 100, Color(200, 0, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
			draw.DrawNonParsedText(string.upper( DarkRP.getPhrase( "youre_arrested", math.ceil( ArrestedExpires - ( CurTime() - ArrestedStart ) ) ) ), "CrisisHUD_Font", 10, ScrH() / 2 + 30, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	elseif not LocalPlayer():getDarkRPVar("Arrested") then
			Arrested = function() end
		end
	end
end)

//////////////////////////////////////////////
////// AVATAR CODE [ PROB SHOULD REDO ] //////
//////////////////////////////////////////////
local scrAvatar = {}

function scrAvatar:Draw()
	if IsValid(self.avatar) then return end
	local mX, mY, mW, mH = 10, ScrH() - 133, 81, 78 -- The model background and model box position
		self.avatar = vgui.Create( "AvatarImage")
		self.avatar:SetSize(mW, mH)
		self.avatar:SetPos(mX, mY)
		self.avatar:SetPlayer( LocalPlayer(), 64 )
end

function scrAvatar:Remove()
	if IsValid(self.avatar) then
		self.avatar:Remove()
	end
end

//////////////////////////////////////////////
////////// Start of HUD 1 ////////////////////
//////////////////////////////////////////////
local function DrawFirstHUD()

		// Make sure to delete avatar if existing (this should be optimized to only be called on the hud switch function)
		scrAvatar:Remove()
		
		local glow = math.abs( math.sin ( CurTime() * 1.3 ) * 100 )

		local BGColor = Color( 116 + glow, 25, 25, 220 )
		local Reverse = Color( 216 - glow, 25, 25, 220 )

		FutureRP.DrawRect( 5, H + 5, ScrW() - 10, H + 30, Color( 0, 0, 0, 220 ) )
		FutureRP.DrawOutlinedRect( 5, H + 3, ScrW() - 10, H + 33, 2, BGColor  )

		local triangle = {
			{ x = ScrW() / 2 - 163, y = 34 },
			{ x = ScrW() / 2 - 163, y = 60 },
			{ x = ScrW() / 2 - 188, y = 34 }
		}

		local triangletwo = {
			{ x = ScrW() / 2 + 134, y = 35 },
			{ x = ScrW() / 2 + 159, y = 35 },
			{ x = ScrW() / 2 + 134, y = 60 }
		}

		local trianglethree = {
			{ x = ScrW() / 2 - 163, y = 33 },
			{ x = ScrW() / 2 - 163, y = 56 },
			{ x = ScrW() / 2 - 187, y = 33 }
		}

		local trianglefour = {
			{ x = ScrW() / 2 + 132, y = 33 },
			{ x = ScrW() / 2 + 157, y = 33 },
			{ x = ScrW() / 2 + 132, y = 59 }
		}

		FutureRP.DrawRect( ScrW() / 2 - 165, 33, 300, 25, Color( 0, 0, 0 ) )
		FutureRP.DrawRect( ScrW() / 2 - 164, 57, 299, 2, BGColor )

		surface.SetDrawColor( BGColor )

		draw.NoTexture()
		surface.DrawPoly( triangle )
		surface.DrawPoly( triangletwo )
		surface.SetDrawColor( Color( 0, 0, 0 ) )
		surface.DrawPoly( trianglethree )
		surface.DrawPoly( trianglefour )

		FutureRP.DrawText( 'InfinityRP', 'CrisisHUD_ODickyMe', ScrW() / 2 - 20, 30, Reverse )

		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(Config.Icons["Name"])
		surface.DrawTexturedRect(ScrW() * 0.01, H + 12, 16, 16)
		draw.SimpleText(LocalPlayer():Nick(), "CrisisHUD_Font", ScrW() * 0.022, H + 12, Config.Design["FontColor"], TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)

		FutureRP.DrawRect( ScrW() * 0.13, H + 8, 165, 23, Color( 48, 48, 48 )  )
		FutureRP.DrawRect( ScrW() * 0.13, H + 8, 165 / 100 * LocalPlayer():Health() <= 165 and 165 / 100 * LocalPlayer():Health() or 165, 23, Color( 200, 50, 50, 230 )  )

		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(Config.Icons["Health"])
		surface.DrawTexturedRect( ScrW() * 0.133, H + 12, 16, 16)

		if LocalPlayer():Health() > 0 then
			draw.SimpleText(LocalPlayer():Health() .. "%", "CrisisHUD_Font", ScrW() * 0.21, H + 11, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
		else
			draw.SimpleText("0%", "CrisisHUD_Font", ScrW() * 0.21, H + 11, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
		end

		// Armor
		FutureRP.DrawRect( ScrW() * 0.22, H + 8, 165, 23, Color( 48, 48, 48 )  )
		FutureRP.DrawRect( ScrW() * 0.22, H + 8, 165 / 100 * LocalPlayer():Armor() <= 165 and 165 / 100 * LocalPlayer():Armor() or 165, 23, Color( 0, 0, 255 )  )

		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(Config.Icons["Armor"])
		surface.DrawTexturedRect(ScrW() * 0.224, H + 11, 16, 16)
		draw.SimpleText(LocalPlayer():Armor() .. "%", "CrisisHUD_Font", ScrW() * 0.28, H + 11, LocalPlayer():Armor() > 0 and Color(255, 255, 255) or Color( 200, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)

		// Job
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(Config.Icons["Job"])
		surface.DrawTexturedRect(ScrW() * 0.35, H + 11, 16, 16)
		draw.SimpleText(LocalPlayer():getDarkRPVar("job"), "CrisisHUD_Font", ScrW() * 0.363, H + 11, team.GetColor(LocalPlayer():Team()), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)

		// Money
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(Config.Icons["Money"])
		surface.DrawTexturedRect(ScrW() * 0.6, H + 11, 16, 16)
		draw.SimpleText(DarkRP.formatMoney(LocalPlayer():getDarkRPVar("money")).. " (+"..DarkRP.formatMoney(LocalPlayer():getDarkRPVar("salary"))..")", "CrisisHUD_Font", ScrW() * 0.615, H + 11, Color( 46,204,113 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		
		// Players Rank
		local RankData = Config.Ranks[LocalPlayer():GetNWString("usergroup")] or 'User'
		local color = LOUNGE_TAB and LOUNGE_TAB.UsergroupColors[LocalPlayer():GetNWString("usergroup")] or Color(255,255,255)
			if (color == "rainbow") then
			color = HSVToColor(RealTime() * 2, 1, 1)
		end

		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(Config.Icons["Rank"])
		surface.DrawTexturedRect(ScrW() * 0.72, H + 11, 16, 16)
		draw.SimpleText(RankData, "CrisisHUD_Font", ScrW() * 0.735, H + 11, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)

		// Gun License
		if LocalPlayer():getDarkRPVar("HasGunlicense") then
			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(Config.Icons["License"])
			surface.DrawTexturedRect(ScrW() * 0.80, H + 11, 16, 16)
			draw.SimpleText("Licensed", "CrisisHUD_Font", ScrW() * 0.815, H + 11, Config.Design["FontColor"], TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		else
			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(Config.Icons["License"])
			surface.DrawTexturedRect(ScrW() * 0.80, H + 11, 16, 16)
			draw.SimpleText("Not Licensed", "CrisisHUD_Font", ScrW() * 0.815, H + 11, Config.Design["FontColor"], TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		end

		// WANTED
		if LocalPlayer():isWanted() then
			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(Config.Icons["Wanted"])
			surface.DrawTexturedRect(ScrW() * 0.909, H + 12, 16, 16)
			draw.SimpleText("Wanted", "CrisisHUD_Font", ScrW() * 0.635, H + 12, Color(255,0,0,200), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		else
			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(Config.Icons["Wanted"])
			surface.DrawTexturedRect(ScrW() * 0.909, H + 11, 16, 16)
			draw.SimpleText("Not Wanted", "CrisisHUD_Font", ScrW() * 0.92, H + 11, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		end

		// Laws of the land
	if shouldShowLaws then
			// Drawing UI for laws
			surface.SetDrawColor( Color( 216, 25, 25, 220 ) )
			surface.DrawRect(5, H + 40, ScrW() * 0.30, H + 20) -- Red Bar
			surface.SetDrawColor( Color( 0, 0, 0, 220 ) )
			surface.DrawRect(5, H + 60, ScrW() * 0.30, ((#DarkRP.getLaws() * 26) + 1) -15) -- Black Bar

			FutureRP.DrawOutlinedRect( 5, H + 40, ScrW() * 0.30, ((#DarkRP.getLaws() * 26) + 1)+5, 2, BGColor  ) -- Outline

			local lastHeight = 0

			// These laws automatically update
			draw.SimpleText(DarkRP.getPhrase("laws_of_the_land"), "CrisisHUD_Font", W / W + 10, H + 42, Config.Design["FontColor"], TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
			draw.SimpleText("Press F1 to toggle", "CrisisHUD_Font", ScrW() * 0.22, H + 40, Config.Design["FontColor"], TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		for k,v in ipairs(DarkRP.getLaws()) do
			draw.SimpleText(string.format("%u. %s", k, v), "CrisisHUD_Font", 10, 65 + lastHeight, Config.Design["FontColor"], TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
			lastHeight = lastHeight + (fn.ReverseArgs(string.gsub(v, "\n", "")) + 1) * 21
		end
	end

		// Lockdown
		IsLockDown()

		// Arrested
		Arrested()

	// Server stats, disable this is in config if you don't want it
	if Config.ServerStats then
		if LocalPlayer():isArrested() then return false end
			local fps = math.Round(1/RealFrameTime(), 0)

		surface.SetDrawColor( Color( 0, 0, 0, 220 ) )
		surface.DrawRect( 5, ScrH() - 90, 260, 50 )
		surface.SetDrawColor( Color( 216, 25, 25, 220 ) )
		surface.DrawRect( 5, ScrH() - 110, 260, 20)

		surface.SetMaterial(Config.Icons["Ammo"] )
		surface.SetDrawColor(255, 255, 255)
		surface.DrawTexturedRect(3, ScrH() - 110, 20, 20)

		FutureRP.DrawOutlinedRect( 5, ScrH() - 110, 260, 70, 2, BGColor  )

		draw.SimpleText("Current Props: " .. LocalPlayer():GetCount( "props" ) .. " | " .. "Current Players: " .. #player.GetAll() .. "/" .. game.MaxPlayers(), "CrisisHUD_Font", 135, ScrH() - 80, Config.Design["FontColor"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("Your Ping: " .. LocalPlayer():Ping() .. " | " .. "Your FPS: " .. fps, "CrisisHUD_Font", 130, ScrH() - 60, Config.Design["FontColor"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		// Weapon Name
		if IsValid(LocalPlayer():GetActiveWeapon()) then
			local wep = LocalPlayer():GetActiveWeapon()
			local wep_name = wep.PrintName or wep:GetPrintName() or wep:GetClass()
			draw.SimpleText(wep_name, "CrisisHUD_Font", 70, ScrH() - 100, Config.Design["FontColor"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		// Amount of Ammo
		if IsValid(LocalPlayer():GetActiveWeapon()) then
			local mag_extra = LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType())
			local ammo = (math.max((LocalPlayer():GetActiveWeapon():Clip1()), 0)) .. " | " .. mag_extra
			if !ammo == 0 then
				draw.SimpleText(ammo, "CrisisHUD_Font", 220, ScrH() - 100, Config.Design["FontColor"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end

	end
end

//////////////////////////////////////////////
////////// Start of HUD 2 ////////////////////
//////////////////////////////////////////////

	// Making dem fonts :p
	surface.CreateFont( "Elegant_HUD_Font_Generic", { font = "Calibri", size = 18, weight = 800 } )
	surface.CreateFont( "Elegant_HUD_Font_Data", { font = "Arial", size = 18, weight = 800 } )
	surface.CreateFont( "Elegant_HUD_Font_Ammo", { font = "Calibri", size = 22, weight = 800 } )
	surface.CreateFont( "Elegant_HUD_Font_Agenda", { font = "Calibri", size = 26, weight = 800 } )

	// Localisations :p
	local health_icon = Material( "icon16/heart.png" )
	local shield_icon = Material( "icon16/shield.png" )
	local cash_icon = Material( "icon16/money.png" )
	local star_icon = Material( "icon16/star.png" )
	local tick_icon = Material( "icon16/tick.png" )
	local medal_icon = Material( "icon16/medal_gold_2.png" )
	local maxBarSize = 215

	local function DrawFillableBar( x, y, w, h, baseCol, fillCol, icon, txt )
		DrawRect( x, y, w, h, baseCol )
		DrawRect( x, y, w, h, fillCol )
	end

	local function DrawRect( x, y, w, h, col )
		surface.SetDrawColor( col )
		surface.DrawRect( x, y, w, h )
	end

	local function DrawText( msg, fnt, x, y, c, align )
		draw.SimpleText( msg, fnt, x, y, c, align and align or TEXT_ALIGN_CENTER )
	end

	local function DrawOutlinedRect( x, y, w, h, t, c )
		surface.SetDrawColor( c )
		for i = 0, t - 1 do
			surface.DrawOutlinedRect( x + i, y + i, w - i * 2, h - i * 2 )
		end
	end

	local function CreateImageIcon( icon, x, y, col, val )
		surface.SetDrawColor( col )
		surface.SetMaterial( icon )
		local w, h = 16, 16
		if val then
			surface.SetDrawColor( Color( 255, 255, 255 ) )
		end
		surface.DrawTexturedRect( x, y, w, h )
	end

	local function GetBarSize( data )
		return ( maxBarSize / 100 ) * data < maxBarSize and ( maxBarSize / 100 ) * data or maxBarSize
	end

	local function DrawAmmo( self )
		if IsValid( self:GetActiveWeapon() ) and self:Alive() then
				local plane, size, hY = ScrW() - 115, self:GetActiveWeapon():Clip1(), ScrH() - 113
				local ammo, reserve = self:GetActiveWeapon():Clip1() < 0 and 0 or self:GetActiveWeapon():Clip1(), self:GetAmmoCount( self:GetActiveWeapon():GetPrimaryAmmoType() )
				local x, y = ScrW() - 220, ScrH() - 75
				DrawRect( x, y, 200, 40, Color( 14, 14, 14 ) )
				DrawRect( x, y, 5, 40, Color( 231, 76, 60 ) )
				DrawOutlinedRect( x, y, 200, 40, 2, Color( 0, 0, 0, 250 ) )
				DrawText( self:GetActiveWeapon():GetPrintName(), "Elegant_HUD_Font_Ammo", x + 100, y - 1, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER )
			if !ammo == 0 then
				DrawText( ammo .. '/' .. reserve, "Elegant_HUD_Font_Ammo", x + 100, y + 16, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER )
			end
		end
	end

	// This will draw if an Agenda is valid :p
	local function DrawAgenda( self )
		if !self:getAgendaTable() then return end
		local x, y, w, h = 5, 5, 500, 120
		local sX, sY, num = 30, 10, #self:getAgendaTable()
		DrawRect( x, y, w, 110, Color( 22, 22, 22, 240 ) )
		DrawRect( x, 30, w, 2, Color( 0, 128, 255 ) )
		DrawRect( x, 5, 3, 110, Color( 0, 128, 255 ) )
		DrawText( string.upper( self:getAgendaTable().Title ), "Elegant_HUD_Font_Agenda", x + 10, y, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT )
		local text = LocalPlayer():getDarkRPVar( "agenda" ) or ""
		text = DarkRP.textWrap( text, "Elegant_HUD_Font_Agenda", 480 )
		draw.DrawNonParsedText( text, "Elegant_HUD_Font_Agenda", 18, 35, Color( 255, 255, 255 ), 0 )
	end

	// Lockdown function :p
	local function Lockdown()
		if GetGlobalBool( "DarkRP_LockDown" ) then
			DrawRect( 5, ScrH() - 193, 320, 25, Color( 18, 18, 18, 250 ) )
			DrawOutlinedRect( 5, ScrH() - 193, 320, 25, 1, Color( 120, 0, 0 ) )
			DrawText( 'LOCKDOWN ACTIVE!', "Elegant_HUD_Font_Agenda", 75, ScrH() - 194, Color( 120, 0, 0 ), TEXT_ALIGN_LEFT )
		end
	end

local function DrawSecondHUD()

	// Localisations :p
    local self = LocalPlayer()
    local bX, bY, bW, bH = 5, ScrH() - 140, 320, 110 -- The main box with shit in it
    local tX, tY, tW, tH = 5, ScrH() - 166, 320, 25 -- The title bar box (above main box)
    local mX, mY, mW, mH = 10, ScrH() - 133, 81, 78 -- The model background and model box position
    local back = Color( 12, 12, 12 )
    local through = Color( 0, 0, 0, 250 )
    local job = team.GetName( self:Team() )
    local hX, hY, hW, hH = 120, ScrH() - 132, 190, 24
    local divide = 5
    local offset = 20
	  
	// Drawing the 'box' for the HUD :p
    DrawRect( bX, bY, bW, bH, back )
    DrawRect( tX, tY, tW, tH, back )
    DrawRect( 5, ScrH() - 141, 320, 20, back )
    DrawRect( mX, mY, mW, mH, Color( 44, 44, 44, 130 ) )
    DrawOutlinedRect( mX, mY, mW, mH, 2, through )

	// Players Name
    DrawText( self:Nick(), "Elegant_HUD_Font_Generic", 15, ScrH() - 159, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT )

	// Players job :p
    if gmod.GetGamemode().Name == 'DarkRP' then DrawText( job, "Elegant_HUD_Font_Generic", 315, ScrH() - 159, Color( 255, 255, 255 ), TEXT_ALIGN_RIGHT ) end
	
	// Drawing a players avatar :p
	scrAvatar:Draw()

	// Players health :p
    DrawRect( hX - offset, hY, maxBarSize + divide / 2, hH, Color( 26, 26, 26 ) )
    DrawRect( hX + divide, hY, GetBarSize( self:Health() ) - divide / 2 - offset, hH, Color( 220, 20, 60, 190 ) )
    DrawText( self:Health() > 0 and self:Health() .. "%" or 0 .. "%", "Elegant_HUD_Font_Data", 215, hY + 3, Color( 255, 255, 255 ) )

	// Players armor :p
    DrawRect( hX - offset, hY + 28, maxBarSize + divide / 2, hH, Color( 26, 26, 26 ) )
    DrawRect( hX + divide, hY + 28, GetBarSize( self:Armor() > 0 and self:Armor() or 0 ) - divide / 2 - offset, hH, Color( 30, 144, 255 ) )
    DrawText( self:Armor() > 0 and self:Armor() .. "%" or 0 .. "%", "Elegant_HUD_Font_Data", 215, hY + 31, Color( 255, 255, 255 ) )

    DrawRect( hX - offset, hY + 55, maxBarSize + divide / 2, hH, Color( 26, 26, 26 ) )
    DrawRect( hX + divide, hY + 55, GetBarSize( 100 ) - divide / 2 - offset, hH, gmod.GetGamemode().Name == 'DarkRP' and Color( 46, 204, 133 ) or Color( 52, 152, 219 ) )

	// Icon drawing :p
    CreateImageIcon( health_icon, 104, ScrH() - 128, Color( 255, 0, 0 ) )
    CreateImageIcon( shield_icon, 103, ScrH() - 101, Color( 30,144,255 ) )
    CreateImageIcon( gmod.GetGamemode().Name == 'DarkRP' and cash_icon or medal_icon, 104, ScrH() - 73, Color( 255, 255, 255 ) )

	// These won't draw unless you're on DarkRP :p
    if gmod.GetGamemode().Name == 'DarkRP' then
        CreateImageIcon( star_icon, 30, ScrH() - 53, Color( 40, 40, 40 ), self:isWanted() )
        CreateImageIcon( tick_icon, 55, ScrH() - 52, Color( 40, 40, 40 ), self:getDarkRPVar("HasGunlicense") )
    end

	// Money, Salary, Ammo and Agenda :p
    DrawText(DarkRP.formatMoney(LocalPlayer():getDarkRPVar("money")).. " (+"..DarkRP.formatMoney(LocalPlayer():getDarkRPVar("salary"))..")", "Elegant_HUD_Font_Data", 215, ScrH() - 73, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER )
    DrawAmmo( self )
    if gmod.GetGamemode().Name == 'DarkRP' then DrawAgenda( self ) Lockdown() end

end

//////////////////////////////////////////////
//////// Vote system, needs redoing //////////
//////////////////////////////////////////////
local function MsgDoVote(msg)
	local _, chatY = chat.GetChatBoxPos()

	local question = msg:ReadString()
	local voteid = msg:ReadShort()
	local timeleft = msg:ReadFloat()
	if timeleft == 0 then
		timeleft = 100
	end
	local OldTime = CurTime()
	if not IsValid(LocalPlayer()) then return end

	LocalPlayer():EmitSound("Town.d1_town_02_elevbell1", 100, 100)
	local panel = vgui.Create("DFrame")
	panel:SetPos(30 + PanelNum, chatY - 145)
	panel:SetTitle("")
	panel:SetSize(150, 150)
	panel:SetSizable(false)
	panel:ShowCloseButton(false)
	panel.btnClose:SetVisible(false)
	panel:SetDraggable(false)
	function panel:Close()
		PanelNum = PanelNum - 140
		VoteVGUI[voteid .. "vote"] = nil

		local num = 0
		for k,v in SortedPairs(VoteVGUI) do
			v:SetPos(num, ScrH() / 2 - 50)
			num = num + 140
		end

		for k,v in SortedPairs(QuestionVGUI) do
			v:SetPos(num, ScrH() / 2 - 50)
			num = num + 300
		end
		self:Remove()
	end

	function panel:Think()
		if timeleft - (CurTime() - OldTime) <= 0 then
			panel:Close()
		end
	end
	panel.Paint = function( self, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,220 ) )
		draw.RoundedBox( 0, 1, 1, w - 2, h - 2, Color( 0,0,0,220 ) )
		draw.RoundedBox( 0, 0, 0, w, 36, Color( 216,25,25,220 ) )

		surface.SetDrawColor( Color( 216,25,25,220 ) )
		surface.DrawLine( 1, 1, w - 1, 1 )
		surface.DrawLine( 1, 1, 1, 20 )
		surface.DrawLine( 1, 34, w - 1, 34 )
		surface.DrawLine( w - 1, 1, w - 1, 34 )

		local time = "Time: ".. tostring(math.Clamp(math.ceil(timeleft - (CurTime() - OldTime)), 0, 9999))
		draw.SimpleText( time, "CrisisHUD_Font", w - 3, 7, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT )
	end

	panel:SetKeyboardInputEnabled(false)
	panel:SetMouseInputEnabled(true)
	panel:SetVisible(true)

	for i = 22, string.len(question), 22 do
		if not string.find(string.sub(question, i - 20, i), "\n", 1, true) then
			question = string.sub(question, 1, i) .. "\n".. string.sub(question, i + 1, string.len(question))
		end
	end

	local label = vgui.Create("DLabel")
	label:SetParent(panel)
	label:SetPos(5, 42)
	label:SetFont( "CrisisHUD_Font" )
	label:SetText(question)
	label:SetTextColor( Color( 255,255,255,220 ) )
	label:SizeToContents()
	label:SetVisible(true)

	local nextHeight = label:GetTall() > 78 and label:GetTall() - 78 or 0
	panel:SetTall(panel:GetTall() + nextHeight)

	local ybutton = vgui.Create("Button")
	ybutton:SetParent(panel)
	ybutton:SetPos(panel:GetWide() / 2 - 40 - 5, panel:GetTall() - 25)
	ybutton:SetSize(40, 20)
	ybutton:SetCommand("!")
	ybutton:SetText(DarkRP.getPhrase("yes"))
	ybutton:SetVisible(true)
	ybutton:SetFont( "CrisisHUD_Font" )
	ybutton:SetTextColor( Color(255,255,255) )
	ybutton.DoClick = function()
		LocalPlayer():ConCommand("vote " .. voteid .. " yea\n")
		panel:Close()
	end
	ybutton.Paint = function( self, w, h )
		local gcol
		if self.hover then
			gcol = Color( 119,18,2,220)
		else
			gcol = Color( 216,25,25,220 )
		end
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,220 ) )
		draw.RoundedBox( 0, 1, 1, w - 2, h - 2, gcol )
	end
	ybutton.OnCursorEntered = function( self )
		self.hover = true
	end
	ybutton.OnCursorExited = function( self )
		self.hover = false
	end

	local nbutton = vgui.Create("Button")
	nbutton:SetParent(panel)
	nbutton:SetPos(panel:GetWide() / 2 + 5, panel:GetTall() - 25)
	nbutton:SetSize(40, 20)
	nbutton:SetCommand("!")
	nbutton:SetText(DarkRP.getPhrase("no"))
	nbutton:SetVisible(true)
	nbutton:SetFont( "CrisisHUD_Font" )
	nbutton:SetTextColor( Color(255,255,255) )
	nbutton.DoClick = function()
		LocalPlayer():ConCommand("vote " .. voteid .. " nay\n")
		panel:Close()
	end
	nbutton.Paint = function( self, w, h )
		local gcol
		if self.hover then
			gcol = Color( 119,18,2,220 )
		else
			gcol = Color( 216,25,25,220 )
		end
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,220 ) )
		draw.RoundedBox( 0, 1, 1, w - 2, h - 2, gcol )
	end
	nbutton.OnCursorEntered = function( self )
		self.hover = true
	end
	nbutton.OnCursorExited = function( self )
		self.hover = false
	end

	PanelNum = PanelNum + 140
	VoteVGUI[voteid .. "vote"] = panel
	panel:SetSkin(GAMEMODE.Config.DarkRPSkin)
end
timer.Simple( 0.7, function()
	usermessage.Hook("DoVote", MsgDoVote)
end )

//////////////////////////////////////////////
///// Localisations [ BETA ] /////
//////////////////////////////////////////////
HUDTable = {}
HUDTable[1] = DrawFirstHUD()
HUDTable[2] = DrawSecondHUD()

//////////////////////////////////////////////
///// Client convars [ BETA ] /////
//////////////////////////////////////////////
CreateClientConVar( "multihud_option", HUDNumber, true, false )

////////////////////////////////
///// Pick the HUD to draw /////
////////////////////////////////
hook.Add("HUDPaint", "DadSaidToDoThis", function()
	local var = GetConVar("multihud_option"):GetInt()
	
	HUDTable[var]()
end)