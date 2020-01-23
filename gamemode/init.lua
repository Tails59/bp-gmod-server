include("shared.lua")
include("include.lua")

//Initialize the data cache for connecting players
local PLAYER_JOIN_DATA_CACHE = {}

local CurTime = CurTime
local pairs = pairs
local ipairs = ipairs
local hook = hook
local player_manager = player_manager
local hook = hook
local GM = GM
local util = util

function GM:Initialize()
	DB:Connect()
end

function GM:PlayerInitialSpawn(ply, _)
	player_manager.SetPlayerClass(ply, "darkrp_citizen")
	ply:SetTeam(TEAM_CITIZEN)

	self:LoadPlayer(ply)

	self:DecachePlayer(util.SteamIDTo64(ply:SteamID()))
end

function GM:LoadPlayer(ply)
	ply:SetMoney(PLAYER_JOIN_DATA_CACHE[util.SteamIDTo64(ply:SteamID())]["money"])
	ply:Init()
end

function GM:PlayerCanJoinTeam(ply, team)
	return true
end

function GM:PlayerLoadout(ply)
	player_manager.RunClass(ply, "Loadout")
end

function GM:PlayerSpawn(ply, _)
	player_manager.OnPlayerSpawn(ply)
	player_manager.RunClass(ply, "Spawn")

	ply:SetTeam(TEAM_CITIZEN)

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

	hook.Run("PlayerDeath")
end

local preparedQ = preparedQ or nil
//Cache connecting players details
gameevent.Listen("player_connect")
hook.Add("player_connect", "playerConnectGE", function(dat)
	local steamid64 = util.SteamIDTo64(dat.networkid)
	if not preparedQ then
		preparedQ = DB:PreparedQuery([[SELECT * FROM main WHERE steamid=?]], function(data)
			if data[1] == nil then
				ELogs.Output(steamid64.." joined for the first time!")
				DB:NewPlayerSave(steamid64)
				hook.Run("newPlayerConnect", steamid64)

				PLAYER_JOIN_DATA_CACHE[steamid64] = {}
				PLAYER_JOIN_DATA_CACHE[steamid64]["money"] = Config.STARTING_MONEY
				PLAYER_JOIN_DATA_CACHE[steamid64]["rank"] = 1

				return
			end

			hook.Run("precachePlayerData", steamid64)

			PLAYER_JOIN_DATA_CACHE[steamid64] = {}
			PLAYER_JOIN_DATA_CACHE[steamid64]["money"] = data[1]["money"]
			PLAYER_JOIN_DATA_CACHE[steamid64]["rank"] = data[1]["rank_id"]
		end)
	end

	preparedQ:setString(1, steamid64)
	preparedQ:start()
end)

gameevent.Listen("player_disconnect")
hook.Add("player_disconnect", "playerDisconnectGE", function(dat)
	gamemode.Call("DecachePlayer", dat.networkid)
end)

function GM:DecachePlayer(steamid64)
	if PLAYER_JOIN_DATA_CACHE[steamid64] then
		PLAYER_JOIN_DATA_CACHE[steamid64] = nil
	end
end

