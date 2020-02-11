AddCSLuaFile()
local PLAYER = FindMetaTable("Player")

function PLAYER:Init()

end

function PLAYER:GetColourScheme()
	return self._DarkRPColourScheme or TDerma.Colours.DEFAULT
end

function PLAYER:SetColourScheme(new)
	self._DarkRPColourScheme = new
end

function PLAYER:GetMoney()
	return self:GetNWInt("Money", 0)
end

