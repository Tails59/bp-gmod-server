local meta = FindMetaTable("Player")

function meta:Notify(text, type, len)
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