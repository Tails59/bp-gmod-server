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

if CLIENT then
	local function UpdateMoney()
		local m = net.ReadInt(31)
		hook.Run("moneyChanged", LocalPlayer():GetMoney(), m)
	end
	net.Receive("moneyChanged", UpdateMoney)
end

if SERVER then
	util.AddNetworkString("moneyChanged")

	function PLAYER:Init()
	end

	function PLAYER:SetMoney(new)
		new = math.Round(new)
		self:SetNWInt("Money", new)

		hook.Run("moneyChanged", self:GetMoney(), new)
		net.Start("moneyChanged")
			net.WriteInt(new, 31)
			net.WriteEntity(self)
		net.Send(self)
	end

	function PLAYER:AddMoney(amt)
		self:SetMoney(self:GetMoney() + amt)
	end

	function PLAYER:TakeMoney(amt)
		self:SetMoney(self:GetMoney() - amt)
	end
end