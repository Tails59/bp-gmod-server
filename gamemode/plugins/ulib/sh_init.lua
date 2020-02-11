AddCSLuaFile()

ULib = ULib or {}

include("shared/util.lua")
include("shared/ucl.lua")
include("shared/commands.lua")
include("shared/defines.lua")
include("shared/hook.lua")
include("shared/messages.lua")
include("shared/misc.lua")
include("shared/player.lua")
include("shared/tables.lua")

if SERVER then
	include("server/sv_util.lua")
	include("server/sv_concommand.lua")
	include("server/sv_entity_ext.lua")
	include("server/sv_phys.lua")
	include("server/sv_player.lua")
	include("server/sv_player_ext.lua")
	include("server/sv_ucl.lua")
end

include("shared/cami_global.lua")
include("shared/cami_ulib.lua")
include("shared/plugin.lua")

if CLIENT then
	include("client/cl_draw.lua")
	include("client/cl_util.lua")
	include("client/cl_commands.lua")
end