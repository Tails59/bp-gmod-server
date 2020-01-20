Jobs = {}
Jobs.Teams = {}

local INDEX = 1
local DEFAULTS = {
	//These 4 values are NOT optional, and must be supplied every time Job.createJob is called. They are only present here
	//for key checking, and are not used. Do not change their values.
	PrintName = 0,
	Colour = 0,
    Models = 0,
    Description = 0,

	Weapons = {
    	["weapon_p2282"] = 100,
    },

    Count = -1,
    Salary = 75,

    customCheck = function(ply) return ply:getDarkRPVar("money") > 10000 end,

    CanDemote = { 
		TEAM_LOWERTEAM
    },

    Category = "Other",
    Position = 100,

    playerClass = "darkrp_citizen",
    playerCanPickupWeapon = function(ply, weapon) return true end,
    playerDeath = function(ply, weapon, killer) end,
    playerSpawn = function(ply) end,
    playerSpawnProp = function(ply, model) end,
    onPlayerChangedTeam = function(ply, oldTeam, newTeam) end,
}

/**
	Call when you want to create a new job/team.
	Takes a table as an argument, see the jobs.lua file for an example table structure

	If the table does not include the non-optional values, or includes keys which it should not
	then it will return false

	if the table is valid it will return the index of the team it creates.
*/
local isstring, isnumber, istable, isfunction = isstring, isnumber, istable, isfunction
function Jobs.createJob(tbl)
	if not tbl.PrintName or not tbl.Models or not tbl.Colour or not tbl.Description then
		ErrorNoHalt("createJob called with invalid table keys")
		return false
	end

	local keys = table.GetKeys(DEFAULTS)
	for k, _ in pairs(tbl) do
		if not DEFAULTS[k] then
			ErrorNoHalt("createJob called with a key that shouldn't exist")
			return false
		end
	end

	local i = INDEX
	INDEX = i + 1

	team.SetUp(i, tbl.PrintName, tbl.Colour, true)
	if tbl.playerClass then
		team.SetClass(i, tbl.playerClass)
	else
		team.SetClass(i, DEFAULTS.playerClass)
	end

	Jobs.Teams[i] = tbl
	return i
end

/*
	Return a table of information on a Job based on a given team index
	Or false if no team/job with that index exists
*/
function Jobs.teamData(index)
	if team.Valid(index) then
		return table.Copy(Jobs.Teams[i])
	end
end
