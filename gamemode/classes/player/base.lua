AddCSLuaFile()
DEFINE_BASECLASS("player_default")

local PLAYER = {}

PLAYER.DisplayName			= "DarkRP BASE PLAYER CLASS"

PLAYER.WalkSpeed			= 150
PLAYER.RunSpeed 			= 350

function PLAYER:SetupDataTables()
end

if SERVER then
	function PLAYER:Init()
	end

	function PLAYER:Spawn()
		self:SetModel()
		self:Loadout()
	end

	function PLAYER:Loadout()
		Jobs.Loadout(self.Player)
	end

	function PLAYER:SetModel()
		local model = Jobs.getModel(self.Player)
		util.PrecacheModel( model )
		self.Player:SetModel( model )

		hook.Run()
	end

	function PLAYER:PlayerDeath(inflictor, attacker)
	end
end
player_manager.RegisterClass( "darkrp_baseclass", PLAYER, "player_default" )
