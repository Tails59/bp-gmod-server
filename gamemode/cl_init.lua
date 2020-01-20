AddCSLuaFile()
include("include.lua")
include("shared.lua")

concommand.Add("changeTeamaaa", function()
	print("test")
	net.Start("changeTeamaaa")
	net.SendToServer()
end)