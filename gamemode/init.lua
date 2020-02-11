include("shared.lua")
include("include.lua")

//Initialize the data cache for connecting players
local PLAYER_JOIN_DATA_CACHE = {}

local CurTime = CurTime
local pairs = pairs
local ipairs = ipairs
local string = string
local hook = hook
local player_manager = player_manager
local hook = hook
local GM = GM
local util = util

function GM:Initialize()
	DB:Connect()
end

function GM:PlayerInitialSpawn(ply, _)
	self:PlayerJoinTeam(ply, TEAM_CITIZEN, "darkrp_citizen")

	if DB:Connected() then
		timer.Simple(0.5, function() //very technical fix to this being called before other clientside files on local servers
			self:LoadPlayer(ply)
			self:DecachePlayer(util.SteamIDTo64(ply:SteamID()))
		end)
	end
end

function GM:LoadPlayer(ply)
	local dat = PLAYER_JOIN_DATA_CACHE[util.SteamIDTo64(ply:SteamID())]

	ply:SetMoney(dat["money"])
	ply:Init()
end

/*
	Modified to accept a class variable, which will automatically be applied at the same time their team
	is switched.

	Use this instead of directly calling player:SetTeam()
*/
function GM:PlayerJoinTeam(ply, team, class)
	if not isnumber(team) then return end

	local old = ply:Team()
	ply:SetTeam(team)
	
	if class then
		player_manager.SetPlayerClass(ply, class)
	end
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

	self:PlayerJoinTeam(ply, team, class)

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

	player_manager.RunClass(ply, "PlayerDeath", inflictor, attacker)	
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
				
				PLAYER_JOIN_DATA_CACHE[steamid64] = {}
				PLAYER_JOIN_DATA_CACHE[steamid64]["money"] = Config.STARTING_MONEY

				DB:NewPlayerSave(steamid64)
				hook.Run("newPlayerConnect", steamid64)
				return
			end

			PLAYER_JOIN_DATA_CACHE[steamid64] = {}
			PLAYER_JOIN_DATA_CACHE[steamid64]["money"] = data[1]["money"]

			hook.Run("precachePlayerData", steamid64)
		end)
	end

	preparedQ:setString(1, steamid64)
	preparedQ:start()
end)

gameevent.Listen("player_disconnect")
hook.Add("player_disconnect", "playerDisconnectGE", function(dat)
	GM.DecachePlayer(dat.networkid)
end)

function GM:DecachePlayer(steamid64)
	if PLAYER_JOIN_DATA_CACHE[steamid64] then
		PLAYER_JOIN_DATA_CACHE[steamid64] = nil
	end
end

function GM:PlayerSay(ply, text, teamChat)
	if string.StartWith(text, "//") then
	end

	if string.StartWith(text, Config.COMMAND_KEY) then
		local validCommand = hook.Call("playerRunCommand", self, ply, text)

		if not validCommand then
			ply:Notify("This is not a valid command!", NOTIFY_ERROR, 5)
		end

		return
	end

	if string.StartWith(text, Config.ADMIN_COMMAND_KEY) then
		if false then
			ply:Notify("You do not have permission to use this command!")
		end

		local validCommand = hook.Call("playerRunAdminCommand", self, ply, text)

		if not validCommand then
			ply:Notify("This is not a valid command!", NOTIFY_ERROR, 5)
		end

		return
	end

	return text
end

util.AddNetworkString("openF1")
function GM:ShowHelp(ply)
	ply:SendLua("ShowF1()")
end
