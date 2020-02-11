require("mysqloo")

DB = {}
DB.Enabled = true

DB.host = "127.0.0.1"
DB.user = "gmod"
DB.pass = "q=6+yz:FaL]Vk`"
DB.db = "darkrp"
DB.port = 3306

local DATABASE = DATABASE or nil
local mysqloo = mysqloo
/*
	Returns the query results if successful.
	If wait is true, it will force the server to wait until the query has finished executing before returning
*/
function DB:Query(query, callback, wait)
	if (not DATABASE or not DATABASE:status() == mysqloo.DATABASE_CONNECTED) then
		error("Database not connected!")
	end

	local queryObj = DATABASE:query(query)
	function queryObj:onSuccess(data)
		if callback then callback(data) end
	end

	function queryObj:onError(err, quer)
		ErrorNoHalt("Query didn't run!\n")
		ELogs.Error("Query: "..quer)
		ELogs.Error("Error: "..err)
	end

	queryObj:start()
	if wait then queryObj:wait(true) end
end

/*
	Returns true if the database is connected (based on the mysqloo.DATABASE_CONNECTED enum)
*/
function DB:Connected()
	return DATABASE:status() == mysqloo.DATABASE_CONNECTED 
end

/*
	Returns the connection status of the database
*/
function DB:status()
	return DATABASE:status()
end

/*
	Returns a PreparedQuery object for frequently-used queries
*/
function DB:PreparedQuery(query, callback)
	local preparedQuery = DATABASE:prepare(query)

	function preparedQuery:onSuccess(data)
		if callback then callback(data) end
	end

	function preparedQuery:onError(err)
		ErrorNoHalt("Prepared query didn't run!\n")
		ELogs.Error("Error: "..err)
	end

	return preparedQuery
end

/*
	Returns true if a column exists, false otherwise.
	This does not use a PreparedQuery as it causes timing issues in this use case.
	This function is only intended to be called on the setupDatabase hook so it shouldn't
	cause too much of an issue.

	This function will force the server to wait until the query has completed, if you don't want
	this to happen then use something else
*/
function DB:ColumnExists(col_name, table_name)
	local result = false;
	local query = [[
		SELECT * 
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_SCHEMA='darkrp' AND 
		TABLE_NAME=']]..table_name..[[' AND 
		COLUMN_NAME=']]..col_name..[[']]
	
	function callback(data)
		if data[1] != nil then
			return false
		else
			return true;
		end
	end

	DB:Query(query, callback, true)
end

function DB:LoadPlayer(ply)

end

/**
	Saves the players information for the darkrp.main table, then calls the savePlayer hook for
	plugins to save their own data

*/
function DB:SavePlayer(ply)
	local q = [[INSERT INTO main VALUES(
		steamid=]]..util.SteamIDTo64(ply:SteamID())..[[,
		money=100,
		rank_id=1)
	]]
end

/**
	Called when a new player connects and should be given an entry in the database
	This function should only be called from the player_connect gameevent
	after checking if a player doesnt already have a record
*/
function DB:NewPlayerSave(steamid64)
	local q = [[INSERT INTO main(steamid, money) VALUES(
		']]..steamid64..[[',
		]]..Config.STARTING_MONEY..[[
	)]]

	local query = DB:Query(q, function(data)
		print("added new player to the db!")
	end, true)
end

/**
	Called to create the main table if required
	If the main table is created successfully or already exists,
	setupDatabase hook will be called to allow plugins to 
	create their own tables at the right time.
*/
function DB:Setup()
	local q = [[CREATE TABLE IF NOT EXISTS main(
	steamid VARCHAR(17) NOT NULL UNIQUE,
	money INT UNSIGNED NOT NULL,
	
    INDEX(steamid),
    PRIMARY KEY(steamid)
	)
	]]

	local query = DATABASE:query(q)

	function query.onSuccess(data)
		hook.Call("setupDatabase")
	end

	function query.onError(err)
		ELogs.Error("Query didnt run!"..err.error(err))
	end

	query:start()
	query:wait(true)
end

/**
	Called to establish connection to the database
	In turn will acll the onDatabaseConnected hook if the connection 
	is established

	Prints an error and puts the server in safe mode if no connection is made
*/
function DB:Connect()
	DATABASE = mysqloo.connect(DB.host, DB.user, DB.pass, DB.db, DB.port)

	function DATABASE:onConnected()
		ELogs.Output("Database connection established!")
		DB:Setup()
		hook.Run("onDatabaseConnected")
	end

	function DATABASE:onConnectionFailed(err)
		ELogs.Error(err)

		timer.Simple(20, function()
			DB.Connect()
		end)
	end

	DATABASE:setAutoReconnect(true)
	DATABASE:connect()
end
