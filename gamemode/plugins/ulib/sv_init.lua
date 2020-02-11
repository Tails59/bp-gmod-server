if not ULib then
	include("sh_init.lua")

	-- For historical purposes
	if not ULib.consoleCommand then ULib.consoleCommand = game.ConsoleCommand end

	file.CreateDir( "ulib" )
	
	local function clReady( ply )
		ply.ulib_ready = true
		hook.Call( ULib.HOOK_LOCALPLAYERREADY, _, ply )
	end
	concommand.Add( "ulib_cl_ready", clReady ) -- Called when the c-side player object is ready
end
