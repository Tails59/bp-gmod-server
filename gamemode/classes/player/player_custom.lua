AddCSLuaFile()
DEFINE_BASECLASS("player_default")

local PLAYER = {}

PLAYER.DisplayName			= "DarkRP Default Class"

PLAYER.WalkSpeed			= 150
PLAYER.RunSpeed 			= 350

player_manager.RegisterClass( "darkrp_custom_playerclass", PLAYER, "player_default" )
