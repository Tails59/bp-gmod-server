include("shared.lua")
include("include.lua")

local CurTime = CurTime
local pairs = pairs
local ipairs = ipairs
local hook = hook


function GM:Initialize()

end

function GM:PlayerInitialSpawn(ply, _)
	
end

function GM:PlayerSpawn(ply, _)
	player_manager.SetPlayerClass(ply, "darkrp_custom_playerclass")
	player_manager.OnPlayerSpawn(ply)
	
end
