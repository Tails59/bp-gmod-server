AddCSLuaFile()
include("include.lua")
include("shared.lua")


local function testDraw()
	local frame = vgui.Create("TFrame")
end
concommand.Add("drawTest", testDraw)