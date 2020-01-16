AddCSLuaFile()
ELogs = {}

local function sysTime()
	return "["..os.date('%H:%M:%S').."] " 
end

function ELogs.Error(msg)
	MsgC(Color(255, 0, 0), sysTime(), "[ERROR] "..msg)
	MsgN("")
end

function ELogs.Warn(msg)
	MsgC(Color(245, 144, 66), sysTime(), "[WARNING] "..msg)
	MsgN("")
end

function ELogs.Output(msg)
	MsgC(Color(66, 245, 150), sysTime(),"[MESSAGE] ".. msg)
	MsgN("")
end