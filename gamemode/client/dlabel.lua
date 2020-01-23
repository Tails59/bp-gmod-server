local TLabel = {}

function TLabel:Init()
	self:SetFont("TDerma.Body")
	self:SetTextColor(LocalPlayer():GetColourScheme().TEXT_DARK)
end

vgui.Register("TLabel", TLabel, "DLabel")