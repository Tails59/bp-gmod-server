
local ScrW = ScrW
local ScrH = ScrH
local surface = surface
local draw = draw
local ColourScheme
local ply

local function healthBar()

end

local function drawHud()
	ply = ply or LocalPlayer()
	ColourScheme = ColourScheme or ply:GetColourScheme()

	healthBar()
end
hook.Add("HUDPaint", "drawHealthBar", drawHud)