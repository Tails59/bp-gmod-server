include("include.lua")
include("shared.lua")

local CurTime = CurTime
local pairs = pairs
local ipairs = ipairs
local hook = hook
local player_manager = player_manager

function GM:Initialize()
	PrintTable(self)
end

function GM:PlayerInitialSpawn(ply, _)
	player_manager.SetPlayerClass(ply, "darkrp_citizen")
	ply:SetTeam(TEAM_CITIZEN)
end

function GM:PlayerCanJoinTeam(ply, team)
	return true
end

function GM:PlayerSpawn(ply, _)
	player_manager.OnPlayerSpawn(ply)
	player_manager.RunClass(ply, "Spawn")

	hook.Call("PlayerSetModel", ply)
end

function GM:PlayerLoadout(ply)
	player_manager.RunClass(ply, "Loadout")
	hook.Call("PlayerLoadout", ply)
end

function GM:AddNotify(str, type, len)
	notification.AddLegacy(str, type, len)
end

function GM:PlayerSetModel(ply)
	player_manager.RunClass(ply, "SetModel")
end

function GM:PlayerDeath(ply, inflictor, attacker)
	ply.NextSpawnTime = CurTime() + 2
	ply.DeathTime = CurTime()
end