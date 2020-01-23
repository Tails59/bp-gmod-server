----// DarkRPChat //----
-- Author: Exho (obviously), Tomelyr, LuaTenshi
-- Version: 4/12/15

if SERVER then
	AddCSLuaFile()
	return
end

DarkRPChat = {}

DarkRPChat.config = {
	timeStamps = true,
	position = 1,	
	fadeTime = 12,
}

surface.CreateFont( "DarkRPChat_18", {
	font = "Roboto LT",
	size = ScreenScale(6),
	weight = 500,
	//antialias = true,
	//shadow = true,
	//extended = true,
} )

surface.CreateFont( "DarkRPChat_16", {
	font = "Roboto LT",
	size = 16,
	weight = 500,
	antialias = true,
	shadow = true,
	extended = true,
} )

--// Prevents errors if the script runs too early, which it will
hook.Remove("Initialize", "DarkRPChat_init")

hook.Add("Initialize", "DarkRPChat_init", function()
	DarkRPChat.buildBox()
end)


--// Builds the chatbox but doesn't display it
function DarkRPChat.buildBox()
	colours = colours or LocalPlayer():GetColourScheme()

	DarkRPChat.frame = vgui.Create("DFrame")
	DarkRPChat.frame:SetSize( ScrW()*0.375, ScrH()*0.25 )
	DarkRPChat.frame:SetTitle("")
	DarkRPChat.frame:ShowCloseButton( false )
	DarkRPChat.frame:SetDraggable( true )
	DarkRPChat.frame:SetSizable( true )
	DarkRPChat.frame:SetPos( ScrW()*0.0116, (ScrH() - DarkRPChat.frame:GetTall()) - ScrH()*0.177)
	DarkRPChat.frame:SetMinWidth( 300 )
	DarkRPChat.frame:SetMinHeight( 100 )
	DarkRPChat.frame.Paint = function( self, w, h )
		DarkRPChat.blur( self, 10, 20, 255 )
	
		surface.SetDrawColor(colours.ACCENT)
		surface.DrawRect(0, 0, w, 25)

		surface.SetDrawColor(Color( 30, 30, 30, 100 ))
		surface.DrawRect(0, 25, w, h-25)
		//draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 200 ) )
		
		//draw.RoundedBox( 0, 0, 0, w, 25, Color( 80, 80, 80, 100 ) )
	end
	DarkRPChat.oldPaint = DarkRPChat.frame.Paint
	DarkRPChat.frame.Think = function()
		if input.IsKeyDown( KEY_ESCAPE ) then
			DarkRPChat.hideBox()
		end
	end
	
	local serverName = vgui.Create("DLabel", DarkRPChat.frame)
	serverName:SetText("[Servername] DarkRP")
	serverName:SetFont( "DarkRPChat_18")
	serverName:SetColor(colours.BACKGROUND)
	serverName:SizeToContents()
	serverName:SetPos( 5, 4 )
	
	local settings = vgui.Create("DButton", DarkRPChat.frame)
	settings:SetText("Settings")
	settings:SetFont( "DarkRPChat_18")
	settings:SetTextColor(colours.BACKGROUND)
	settings:SetSize( 70, 25 )
	settings:SetPos( DarkRPChat.frame:GetWide() - settings:GetWide() + 5, 0 )
	settings.Paint = function( self, w, h )	end
	settings.DoClick = function( self )
		DarkRPChat.openSettings()
	end
	
	DarkRPChat.entry = vgui.Create("DTextEntry", DarkRPChat.frame) 
	DarkRPChat.entry:SetSize( DarkRPChat.frame:GetWide() - 50, 20 )
	DarkRPChat.entry:SetTextColor( color_white )
	DarkRPChat.entry:SetFont("DarkRPChat_18")
	DarkRPChat.entry:SetDrawBorder( false )
	DarkRPChat.entry:SetDrawBackground( false )
	DarkRPChat.entry:SetCursorColor( color_white )
	DarkRPChat.entry:SetHighlightColor( Color(52, 152, 219) )
	DarkRPChat.entry:SetPos( 45, DarkRPChat.frame:GetTall() - DarkRPChat.entry:GetTall() - 5 )
	DarkRPChat.entry.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 100 ) )
		derma.SkinHook( "Paint", "TextEntry", self, w, h )
	end

	DarkRPChat.entry.OnTextChanged = function( self )
		if self and self.GetText then 
			gamemode.Call( "ChatTextChanged", self:GetText() or "" )
		end
	end

	DarkRPChat.entry.OnKeyCodeTyped = function( self, code )
		local types = {"", "teamchat", "console"}

		if code == KEY_ESCAPE then

			DarkRPChat.hideBox()
			gui.HideGameUI()

		elseif code == KEY_TAB then
			
			DarkRPChat.TypeSelector = (DarkRPChat.TypeSelector and DarkRPChat.TypeSelector + 1) or 1
			
			if DarkRPChat.TypeSelector > 3 then DarkRPChat.TypeSelector = 1 end
			if DarkRPChat.TypeSelector < 1 then DarkRPChat.TypeSelector = 3 end
			
			DarkRPChat.ChatType = types[DarkRPChat.TypeSelector]

			timer.Simple(0.001, function() DarkRPChat.entry:RequestFocus() end)

		elseif code == KEY_ENTER then
			-- Replicate the client pressing enter
			
			if string.Trim( self:GetText() ) != "" then
				if DarkRPChat.ChatType == types[2] then
					LocalPlayer():ConCommand("say_team \"" .. (self:GetText() or "") .. "\"")
				elseif DarkRPChat.ChatType == types[3] then
					LocalPlayer():ConCommand(self:GetText() or "")
				else
					LocalPlayer():ConCommand("say \"" .. self:GetText() .. "\"")
				end
			end

			DarkRPChat.TypeSelector = 1
			DarkRPChat.hideBox()
		end
	end

	DarkRPChat.chatLog = vgui.Create("RichText", DarkRPChat.frame) 
	DarkRPChat.chatLog:SetSize( DarkRPChat.frame:GetWide() - 10, DarkRPChat.frame:GetTall() - 60 )
	DarkRPChat.chatLog:SetPos( 5, 30 )
	DarkRPChat.chatLog.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 100 ) )
	end
	DarkRPChat.chatLog.Think = function( self )
		if DarkRPChat.lastMessage then
			if CurTime() - DarkRPChat.lastMessage > DarkRPChat.config.fadeTime then
				self:SetVisible( false )
			else
				self:SetVisible( true )
			end
		end
		self:SetSize( DarkRPChat.frame:GetWide() - 10, DarkRPChat.frame:GetTall() - DarkRPChat.entry:GetTall() - serverName:GetTall() - 20 )
		settings:SetPos( DarkRPChat.frame:GetWide() - settings:GetWide(), 0 )
	end
	DarkRPChat.chatLog.PerformLayout = function( self )
		self:SetFontInternal("DarkRPChat_18")
		self:SetFGColor( color_white )
	end
	DarkRPChat.oldPaint2 = DarkRPChat.chatLog.Paint
	
	local text = "Say :"

	local say = vgui.Create("DLabel", DarkRPChat.frame)
	say:SetText("")
	surface.SetFont( "DarkRPChat_18")
	local w, h = surface.GetTextSize( text )
	say:SetSize( w + 5, 20 )
	say:SetPos( 5, DarkRPChat.frame:GetTall() - DarkRPChat.entry:GetTall() - 5 )
	
	say.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 100 ) )
		draw.DrawText( text, "DarkRPChat_18", 2, 1, color_white )
	end

	say.Think = function( self )
		local types = {"", "teamchat", "console"}
		local s = {}

		if DarkRPChat.ChatType == types[2] then 
			text = "Say (TEAM) :"	
		elseif DarkRPChat.ChatType == types[3] then
			text = "Console :"
		else
			text = "Say :"
			s.pw = 45
			s.sw = DarkRPChat.frame:GetWide() - 50
		end

		if s then
			if not s.pw then s.pw = self:GetWide() + 10 end
			if not s.sw then s.sw = DarkRPChat.frame:GetWide() - self:GetWide() - 15 end
		end

		local w, h = surface.GetTextSize( text )
		self:SetSize( w + 5, 20 )
		self:SetPos( 5, DarkRPChat.frame:GetTall() - DarkRPChat.entry:GetTall() - 5 )

		DarkRPChat.entry:SetSize( s.sw, 20 )
		DarkRPChat.entry:SetPos( s.pw, DarkRPChat.frame:GetTall() - DarkRPChat.entry:GetTall() - 5 )
	end	
	
	DarkRPChat.hideBox()
end

--// Hides the chat box but not the messages
function DarkRPChat.hideBox()
	DarkRPChat.frame.Paint = function() end
	DarkRPChat.chatLog.Paint = function() end
	
	DarkRPChat.chatLog:SetVerticalScrollbarEnabled( false )
	DarkRPChat.chatLog:GotoTextEnd()
	
	DarkRPChat.lastMessage = DarkRPChat.lastMessage or CurTime() - DarkRPChat.config.fadeTime
	
	-- Hide the chatbox except the log
	local children = DarkRPChat.frame:GetChildren()
	for _, pnl in pairs( children ) do
		if pnl == DarkRPChat.frame.btnMaxim or pnl == DarkRPChat.frame.btnClose or pnl == DarkRPChat.frame.btnMinim then continue end
		
		if pnl != DarkRPChat.chatLog then
			pnl:SetVisible( false )
		end
	end
	
	-- Give the player control again
	DarkRPChat.frame:SetMouseInputEnabled( false )
	DarkRPChat.frame:SetKeyboardInputEnabled( false )
	gui.EnableScreenClicker( false )
	
	-- We are done chatting
	gamemode.Call("FinishChat")
	
	-- Clear the text entry
	DarkRPChat.entry:SetText( "" )
	gamemode.Call( "ChatTextChanged", "" )
end

--// Shows the chat box
function DarkRPChat.showBox()
	-- Draw the chat box again
	DarkRPChat.frame.Paint = DarkRPChat.oldPaint
	DarkRPChat.chatLog.Paint = DarkRPChat.oldPaint2
	
	DarkRPChat.chatLog:SetVerticalScrollbarEnabled( true )
	DarkRPChat.lastMessage = nil
	
	-- Show any hidden children
	local children = DarkRPChat.frame:GetChildren()
	for _, pnl in pairs( children ) do
		if pnl == DarkRPChat.frame.btnMaxim or pnl == DarkRPChat.frame.btnClose or pnl == DarkRPChat.frame.btnMinim then continue end
		
		pnl:SetVisible( true )
	end
	
	-- MakePopup calls the input functions so we don't need to call those
	DarkRPChat.frame:MakePopup()
	DarkRPChat.entry:RequestFocus()
	
	-- Make sure other addons know we are chatting
	gamemode.Call("StartChat")
end

--// Opens the settings panel
function DarkRPChat.openSettings()
	DarkRPChat.hideBox()
	
	DarkRPChat.frameS = vgui.Create("DFrame")
	DarkRPChat.frameS:SetSize( 400, 300 )
	DarkRPChat.frameS:SetTitle("")
	DarkRPChat.frameS:MakePopup()
	DarkRPChat.frameS:SetPos( ScrW()/2 - DarkRPChat.frameS:GetWide()/2, ScrH()/2 - DarkRPChat.frameS:GetTall()/2 )
	DarkRPChat.frameS:ShowCloseButton( true )
	DarkRPChat.frameS.Paint = function( self, w, h )
		DarkRPChat.blur( self, 10, 20, 255 )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 200 ) )
		
		draw.RoundedBox( 0, 0, 0, w, 25, Color( 80, 80, 80, 100 ) )
		
		draw.RoundedBox( 0, 0, 25, w, 25, Color( 50, 50, 50, 50 ) )
	end
	
	local serverName = vgui.Create("DLabel", DarkRPChat.frameS)
	serverName:SetText( "DarkRPChat - Settings" )
	serverName:SetFont( "DarkRPChat_18")
	serverName:SizeToContents()
	serverName:SetPos( 5, 4 )
	
	local label1 = vgui.Create("DLabel", DarkRPChat.frameS)
	label1:SetText( "Time stamps: " )
	label1:SetFont( "DarkRPChat_18")
	label1:SizeToContents()
	label1:SetPos( 10, 40 )
	
	local checkbox1 = vgui.Create("DCheckBox", DarkRPChat.frameS ) 
	checkbox1:SetPos(label1:GetWide() + 15, 42)
	checkbox1:SetValue( DarkRPChat.config.timeStamps )
	
	local label2 = vgui.Create("DLabel", DarkRPChat.frameS)
	label2:SetText( "Fade time: " )
	label2:SetFont( "DarkRPChat_18")
	label2:SizeToContents()
	label2:SetPos( 10, 70 )
	
	local textEntry = vgui.Create("DTextEntry", DarkRPChat.frameS) 
	textEntry:SetSize( 50, 20 )
	textEntry:SetPos( label2:GetWide() + 15, 70 )
	textEntry:SetText( DarkRPChat.config.fadeTime ) 
	textEntry:SetTextColor( color_white )
	textEntry:SetFont("DarkRPChat_18")
	textEntry:SetDrawBorder( false )
	textEntry:SetDrawBackground( false )
	textEntry:SetCursorColor( color_white )
	textEntry:SetHighlightColor( Color(52, 152, 219) )
	textEntry.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 100 ) )
		derma.SkinHook( "Paint", "TextEntry", self, w, h )
	end
	
	--[[local checkbox2 = vgui.Create("DCheckBox", DarkRPChat.frameS ) 
	checkbox2:SetPos(label2:GetWide() + 15, 72)
	checkbox2:SetValue( DarkRPChat.config.seDarkRPChatTags )
	
	local label3 = vgui.Create("DLabel", DarkRPChat.frameS)
	label3:SetText( "Use chat tags: " )
	label3:SetFont( "DarkRPChat_18")
	label3:SizeToContents()
	label3:SetPos( 10, 100 )
	
	local checkbox3 = vgui.Create("DCheckBox", DarkRPChat.frameS ) 
	checkbox3:SetPos(label3:GetWide() + 15, 102)
	checkbox3:SetValue( DarkRPChat.config.usDarkRPChatTag )]]
	
	local save = vgui.Create("DButton", DarkRPChat.frameS)
	save:SetText("Save")
	save:SetFont( "DarkRPChat_18")
	save:SetTextColor( Color( 230, 230, 230, 150 ) )
	save:SetSize( 70, 25 )
	save:SetPos( DarkRPChat.frameS:GetWide()/2 - save:GetWide()/2, DarkRPChat.frameS:GetTall() - save:GetTall() - 10)
	save.Paint = function( self, w, h )
		if self:IsDown() then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 80, 80, 80, 200 ) )
		else
			draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 50, 50, 200 ) )
		end
	end
	save.DoClick = function( self )
		DarkRPChat.frameS:Close()
		
		DarkRPChat.config.timeStamps = checkbox1:GetChecked() 
		DarkRPChat.config.fadeTime = tonumber(textEntry:GetText()) or DarkRPChat.config.fadeTime
	end
end

--// Panel based blur function by Chessnut from NutScript
local blur = Material( "pp/blurscreen" )
function DarkRPChat.blur( panel, layers, density, alpha )
	-- Its a scientifically proven fact that blur improves a script
	local x, y = panel:LocalToScreen(0, 0)

	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( blur )

	for i = 1, 3 do
		blur:SetFloat( "$blur", ( i / layers ) * density )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
	end
end

local oldAddText = chat.AddText

--// Overwrite chat.AddText to detour it into my chatbox
function chat.AddText(...)
	if not DarkRPChat.chatLog then
		DarkRPChat.buildBox()
	end
	
	local msg = {}
	
	-- Iterate through the strings and colors
	for _, obj in pairs( {...} ) do
		if type(obj) == "table" then
			DarkRPChat.chatLog:InsertColorChange( obj.r, obj.g, obj.b, obj.a )
			table.insert( msg, Color(obj.r, obj.g, obj.b, obj.a) )
		elseif type(obj) == "string"  then
			DarkRPChat.chatLog:AppendText( obj )
			table.insert( msg, obj )
		elseif obj:IsPlayer() then
			local ply = obj
			
			if DarkRPChat.config.timeStamps then
				DarkRPChat.chatLog:InsertColorChange( 130, 130, 130, 255 )
				DarkRPChat.chatLog:AppendText( "["..os.date("%X").."] ")
			end
			
			if DarkRPChat.config.seDarkRPChatTags and ply:GetNWBool("DarkRPChat_tagEnabled", false) then
				local col = ply:GetNWString("DarkRPChat_tagCol", "255 255 255")
				local tbl = string.Explode(" ", col )
				DarkRPChat.chatLog:InsertColorChange( tbl[1], tbl[2], tbl[3], 255 )
				DarkRPChat.chatLog:AppendText( "["..ply:GetNWString("DarkRPChat_tag", "N/A").."] ")
			end
			
			local col = GAMEMODE:GetTeamColor( obj )
			DarkRPChat.chatLog:InsertColorChange( col.r, col.g, col.b, 255 )
			DarkRPChat.chatLog:AppendText( obj:Nick() )
			table.insert( msg, obj:Nick() )
		end
	end
	DarkRPChat.chatLog:AppendText("\n")
	
	DarkRPChat.chatLog:SetVisible( true )
	DarkRPChat.lastMessage = CurTime()
	DarkRPChat.chatLog:InsertColorChange( 255, 255, 255, 255 )
--	oldAddText(unpack(msg))
end

--// Write any server notifications
hook.Remove( "ChatText", "DarkRPChat_joinleave")
hook.Add( "ChatText", "DarkRPChat_joinleave", function( index, name, text, type )
	if not DarkRPChat.chatLog then
		DarkRPChat.buildBox()
	end
	
	if type != "chat" then
		DarkRPChat.chatLog:InsertColorChange( 0, 128, 255, 255 )
		DarkRPChat.chatLog:AppendText( text.."\n" )
		DarkRPChat.chatLog:SetVisible( true )
		DarkRPChat.lastMessage = CurTime()
		return true
	end
end)

--// Stops the default chat box from being opened
hook.Remove("PlayerBindPress", "DarkRPChat_hijackbind")
hook.Add("PlayerBindPress", "DarkRPChat_hijackbind", function(ply, bind, pressed)
	if string.sub( bind, 1, 11 ) == "messagemode" then
		if bind == "messagemode2" then 
			DarkRPChat.ChatType = "teamchat"
		else
			DarkRPChat.ChatType = ""
		end
		
		if IsValid( DarkRPChat.frame ) then
			DarkRPChat.showBox()
		else
			DarkRPChat.buildBox()
			DarkRPChat.showBox()
		end
		return true
	end
end)

--// Hide the default chat too in case that pops up
hook.Remove("HUDShouldDraw", "DarkRPChat_hidedefault")
hook.Add("HUDShouldDraw", "DarkRPChat_hidedefault", function( name )
	if name == "CHudChat" then
		return false
	end
end)

 --// Modify the Chatbox for align.
local oldGetChatBoxPos = chat.GetChatBoxPos
function chat.GetChatBoxPos()
	return DarkRPChat.frame:GetPos()
end

function chat.GetChatBoxSize()
	return DarkRPChat.frame:GetSize()
end

chat.Open = DarkRPChat.showBox
function chat.Close(...) 
	if IsValid( DarkRPChat.frame ) then 
		DarkRPChat.hideBox(...)
	else
		DarkRPChat.buildBox()
		DarkRPChat.showBox()
	end
end