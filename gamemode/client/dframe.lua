local TFrame = {}

AccessorFunc(TFrame, "_TitleBarHeight", "TitleBarHeight", 	FORCE_NUMBER)
AccessorFunc(TFrame, "_Font", 			"Font", 			FORCE_STRING)
AccessorFunc(TFrame, "_ShowTitleBar", 	"ShowTitleBar", 	FORCE_BOOL)
AccessorFunc(TFrame, "_BBlur", 			"BackgroundBlur",	FORCE_BOOL)

function TFrame:Init()
	self._startTime = SysTime()
	self._TitleBarHeight = 40
	self._Font = "CloseCaption_Bold"
	self._ShowTitleBar = true
	
	self.lblTitle:Remove()
	self.lblTitle = vgui.Create("DLabel", self)
	self.lblTitle:SetText("DFrame Title")
	self.lblTitle:SetFont("TDerma.Title")
	self.lblTitle:SizeToContents()

	self._Close = vgui.Create("TCloseButton", self)
	
	self.btnClose:Remove()
	self.btnMaxim:Remove()
	self.btnMinim:Remove()

	self:SetSize(500, 500)
	self:Center()
end

function TFrame:ShowCloseButton(bool)
	self._Close:SetVisible(bool)
end

function TFrame:GetTitleObj()
	return self.lblTitle
end

function TFrame:GetCloseButton()
	return self._Close
end

local colours
function TFrame:Paint(w, h)
	if self._BBlur then
		Derma_DrawBackgroundBlur(self, self._startTime)
	end

	colours = colours or LocalPlayer():GetColourScheme()
	
	surface.SetDrawColor(colours.ACCENT)
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(colours.BACKGROUND)
	surface.DrawRect(0, self._TitleBarHeight, w, h-self._TitleBarHeight)
end

function TFrame:PerformLayout()
	self.lblTitle:SizeToContents()
	self.lblTitle:SetPos(5, (self:GetTitleBarHeight() * 0.5) - (self:GetTitleBarHeight() * 0.5))
	self.lblTitle:SetSize(self:GetWide() - 25, self._TitleBarHeight)
end
vgui.Register("TFrame", TFrame, "DFrame")