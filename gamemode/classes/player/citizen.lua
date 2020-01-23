AddCSLuaFile()
DEFINE_BASECLASS("darkrp_baseclass")

local PLAYER = {}

PLAYER.DisplayName			= "DarkRP Citizen Class"

player_manager.RegisterClass( "darkrp_citizen", PLAYER, "darkrp_baseclass" )
