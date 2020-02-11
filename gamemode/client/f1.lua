local PANEL = {}

local ply;
function PANEL:Init()
	if ply._ChatBoxOpen then DarkRPChat.hideBox() end

	self._start = CurTime()

	self.frame = vgui.Create("TFrame")
	self.frame:MakePopup()
	self.frame:SetDraggable(false)
	self.frame:SetTitle("DarkRP F1 Menu")
	self.frame:SetSize(300, 500)
	self.frame:SetPos(-300, ScrH() / 2 - 250)
	self.frame:SetBackgroundBlur(true)

	self.frame:MoveTo(0, ScrH() / 2 - 250, 1, 0, -1)

	self.jobsButton = vgui.Create("DButton", self.frame)
	self.jobsButton:SetPos(0, self.frame:GetTitleBarHeight())
	self.jobsButton:SetSize(self.frame:GetWide(), 50)
end

function PANEL:OnClose()
	ply.F1Menu = nil
end

function PANEL:Close()
	self:OnClose()
	self:Remove()
end
vgui.Register("F1Menu", PANEL, nil)

function ShowF1()
	ply = ply or LocalPlayer()
	if ply.F1Menu then
		ply.F1Menu:Close()
		ply.F1Menu = nil
	end

	ply.F1Menu = vgui.Create("F1Menu")
end
