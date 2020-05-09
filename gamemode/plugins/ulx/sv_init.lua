if not ulx then
	ulx = {}

	-- Get data folder up to speed
	include( "sv_data.lua" )

	local sv_modules = file.Find( "bp-gmod-server/gamemode/plugins/ulx/modules/*.lua", "LUA" )
	local sh_modules = file.Find( "bp-gmod-server/gamemode/plugins/ulx/modules/sh/*.lua", "LUA" )
	local cl_modules = file.Find( "bp-gmod-server/gamemode/plugins/ulx/modules/cl/*.lua", "LUA" )

	include( "sh_defines.lua" )
	include( "sv_lib.lua" )
	include( "sv_base.lua" )
	include( "sh_base.lua" )
	include( "sv_log.lua" )

	for _, file in ipairs( sv_modules ) do
		include( "modules/" .. file )
	end

	for _, file in ipairs( sh_modules ) do
		include( "modules/sh/" .. file )
	end

	include( "sv_end.lua" )

	-- Find c-side modules and load them
	for _, file in ipairs( cl_modules ) do
		AddCSLuaFile( "modules/cl/" .. file )
	end

	for _, file in ipairs( sh_modules ) do
		AddCSLuaFile( "modules/sh/" .. file )
	end
end
