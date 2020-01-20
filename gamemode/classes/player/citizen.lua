AddCSLuaFile()
DEFINE_BASECLASS("player_default")

local PLAYER = {}

PLAYER.DisplayName			= "DarkRP Default Class"

PLAYER.WalkSpeed			= 150
PLAYER.RunSpeed 			= 350

player_manager.RegisterClass( "darkrp_citizen", PLAYER, "player_default" )
