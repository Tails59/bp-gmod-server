include("player.lua")

local function UpdateMoney()
	local m = net.ReadInt(31)
	hook.Run("moneyChanged", LocalPlayer():GetMoney(), m)
end
net.Receive("moneyChanged", UpdateMoney)
