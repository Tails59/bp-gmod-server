local PLAYER = FindMetaTable("Player")

util.AddNetworkString("moneyChanged")

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