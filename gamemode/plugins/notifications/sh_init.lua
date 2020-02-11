if SERVER then
	util.AddNetworkString("notification.FromServer")
end

local meta = FindMetaTable("Player")

function meta:Notify(text, type, len)
	if not text then return end
	if not type then type = NOTIFY_GENERIC end
	if not len then len = 5 end

	if CLIENT then
		notification.AddLegacy(text, type, len)
	elseif SERVER then
		net.Start("notification.FromServer")
			net.WriteString(text)
			net.WriteString(type)
			net.WriteFloat(len)
		net.Send(self)
	end
end