local TCloseButton = {}
function TCloseButton:Init()
	self:SetTextColor(LocalPlayer():GetColourScheme().CLOSE_BUTTON)
	self:SetSize(24, 24)
	self:SetFont("TDerma.Title")
	self:SetText("X")
	self:SetPos(self:GetParent():GetWide() - 29, 5)
end

function TCloseButton:DoClick()
	if self:GetParent() then 
		self:GetParent():Remove()
	else
		self:Remove()
	end
end

function TCloseButton:Paint(w, h)
	
end

function TCloseButton:PerformLayout()
	self:SetSize(24, 24)
	self:SetPos(self:GetParent():GetWide() - 29, self:GetParent():GetTitleBarHeight()/2 - 12)
end
vgui.Register("TCloseButton", TCloseButton, "DButton")