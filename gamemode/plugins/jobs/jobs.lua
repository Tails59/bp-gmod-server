include("lib/sh_jobs.lua")

/*
TEAM_EXAMPLE = Jobs.createJob({
	PrintName = "Citizens", //User-friendly name
	Colour = Color(255, 255, 255, 255), //Team colour
    
    //A table of models, one will be selected randomly when a player joins this job
    Models = { 
        "models/player/Group03/Female_01.mdl",
        "models/player/Group03/Female_02.mdl"
    },

    //Team Description
    Description = [[This text will serve as the description of 
                    this team.]],

    -- The following fields are OPTIONAL. If you do not need them, or do not need to change them from their defaults, REMOVE them.

    //Note the square brackets around the weapon name = this is required
    Weapons = { //SWEPs the player will spawn with, and the amount of ammo
    	["weapon_p2282"] = 100;
    },
    
    Count = 0.7, //The amount of players that can have this job. Negative numbers impose no limit, whole numbers represent an absolute limit and decimal values represent a percentage
    //For example, 0.7 means only 70% of the connected players can be in this category. 5 would mean, only 5 players can be in it, and -1 means any number of players can
    Salary = 45,

    customCheck = function(ply) return ply:getDarkRPVar("money") > 10000 end,

    CanDemote = { //A table of teams this team is able to target with /demote
		TEAM_LOWERTEAM
    },

    Category = "Other", -- The name of the category it is in. Note: the category must be created!
    Position = 100, -- The position of this thing in its category. Lower number means higher up.

    playerClass = "player_darkrp",
    playerCanPickupWeapon = function(ply, weapon) return true end,
    playerDeath = function(ply, weapon, killer) end,
    playerLoadout = function(ply) return true end,
    playerSpawnProp = function(ply, model) end,
    onPlayerChangedTeam = function(ply, oldTeam, newTeam) end,
})
*/

TEAM_CITIZEN = Jobs.createJob({
	PrintName = "Citizen",
	Colour = Color(255, 255, 255, 255), 

    Models = { 
        "models/player/Group03/Female_01.mdl",
        "models/player/Group03/Female_02.mdl"
    },

    Description = [[This text will serve as the description of
                    this team.]],

    Salary = 45,
    Category = "Civilians",
    Position = 1,

    playerClass = "darkrp_citizen",
    playerCanPickupWeapon = function(ply, weapon) return true end,
    playerDeath = function(ply, weapon, killer) end,
    playerSpawnProp = function(ply, model) end,
    onPlayerChangedTeam = function(ply, oldTeam, newTeam) end,
})