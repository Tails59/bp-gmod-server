include("include.lua")
include("shared.lua")
util.AddNetworkString("changeTeamaaa")

local CurTime = CurTime
local pairs = pairs
local ipairs = ipairs
local hook = hook
local player_manager = player_manager

function GM:Initialize()

end

function GM:PlayerInitialSpawn(ply, _)
	GM:PlayerJoinTeam(ply, TEAM_CITIZEN)
end

function GM:PlayerCanJoinTeam(ply, team)

end

function GM:PlayerLoadout(ply)
	player_manager.RunClass(ply, "Loadout")
end

function GM:PlayerSpawn(ply, _)
	player_manager.OnPlayerSpawn(ply)
	
	ply:SetTeam(TEAM_CITIZEN)

	hook.Call("PlayerLoadout", ply)
	hook.Call("PlayerSetModel", ply)
end

function GM:AddNotify(str, type, len)
	notification.AddLegacy(str, type, len)
end
