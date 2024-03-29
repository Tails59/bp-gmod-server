AddCSLuaFile()

include("shared/easylogs.lua")

local folder_name = "bp-gmod-server"

local function addShared(File)
	include("shared/"..File)
	if SERVER then
		AddCSLuaFile("shared/"..File)
	end
end

local function addClient(File)
	if CLIENT then
		include("client/"..File)
	else
		AddCSLuaFile("client/"..File)
	end
end

local function addServer(file)
	if SERVER then
		include("server/"..file)
	end
end

local function loader(file, dir)
	type = string.sub(file, 1, 2)

	if type == "cl" then
		if CLIENT then
			include(dir..file)
		else
			AddCSLuaFile(dir..file)
		end
	elseif type == "sv" then
		if SERVER then
			include(dir..file)
		end
	else
		include(dir..file)
		if SERVER then
			AddCSLuaFile(dir..file)
		end
	end
end

//Load custom classes
do
	local path = folder_name.."/gamemode/classes/"
	local files, folders = file.Find(path.."*", "LUA")

	for k, v in pairs(files) do
		include(path..v)
		if SERVER then
			AddCSLuaFile(path..v)
		end
	end

	for k, v in pairs(folders) do
		local f, _ = file.Find(path..v.."/*.lua", "LUA")
		
		for i, j in pairs(f) do
			include(path..v.."/"..j)
			if SERVER then
				AddCSLuaFile(path..v.."/"..j)
			end
		end
	end
end

//Load metatables
do
	local files, folders = file.Find(folder_name.."/gamemode/metatables/*.lua", "LUA")

	for k, v in pairs(files) do
		loader(v, "metatables/")
	end
end

//load plugins
do
	local _, folders = file.Find(folder_name.."/gamemode/plugins/*", "LUA")

	for k, dir in pairs(folders) do
		local files, _ = file.Find(folder_name.."/gamemode/plugins/"..dir.."/*.lua", "LUA")

		for k, v in pairs(files) do
			loader(v, "plugins/"..dir.."/")
		end
	end

	ELogs.Output("Loaded "..#folders.." plugins!")
end

//Load serverside lua files
if SERVER then
	ELogs.Output("Loading serverside lua content...")
	local files, dir = file.Find(folder_name.."/gamemode/server/*.lua", "LUA")

	for i = 1, #files do
		addServer(files[i])
	end

	ELogs.Output("Loaded ".. #files.." serverside files")
end

//Load shared files
do
	ELogs.Output("Loading shared lua content...")

	local files, dir = file.Find(folder_name.."/gamemode/shared/*.lua", "LUA")

	for i = 1, #files do
		addShared(files[i])
	end

	ELogs.Output("Loaded ".. #files.." shared files")
end

//load clientside files
if CLIENT then
	ELogs.Output("Loading clientside lua content...")

	local files, dir = file.Find(folder_name.."/gamemode/client/*.lua", "LUA")

	for i = 1, #files do
		addClient(files[i])
	end

	ELogs.Output("Loaded ".. #files.." clientside files")
end
