require("mysqloo")

DB = {}
DB.Enabled = true

DB.host = "127.0.0.1"
DB.user = "gmod"
DB.pass = "q=6+yz:FaL]Vk`"
DB.db = "darkrp"
DB.port = 3306

DB.DATABASE = DB.DATABASE or nil

/*
	Returns the query results if successful.
	If wait is true, it will force the server to wait until the query has finished executing before returning
*/
function DB:Query(query, callback, wait)
	if (not DB.DATABASE or not DB.DATABASE:status() == mysqloo.DATABASE_CONNECTED) then
		error("Database not connected!")
	end

	local queryObj = DB.DATABASE:query(query)
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
	Returns a PreparedQuery object for frequently-used queries
*/
function DB:PreparedQuery(query, callback)
	local preparedQuery = DB.DATABASE:prepare(query)

	function preparedQuery:onSuccess(data)
		if callback then callback(data) end
	end

	function preparedQuery:onError(err)
		ErrorNoHalt("Prepared query didn't run!\n")
		ELogs.Error("Error: "..err)
	end

	return preparedQuery
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
RANK_USER = 1
function DB:NewPlayerSave(steamid64)
	local q = [[INSERT INTO main VALUES(
		]]..steamid64..[[,
		]]..Config.STARTING_MONEY..[[,
		]]..RANK_USER..[[
	)]]

	print(q)
	local query = DB.DATABASE:query(q)

	function query:onSuccess(data)
	end

	function query:onError(err)
		ELogs.Error(err)
	end

	query:start()
	query:wait(true)
end

/**
	Called to create the main table if required
	If the main table is created successfully or already exists,
	onDatabaseSetup hook will be called to allow plugins to 
	create their own tables at the right time.
*/
function DB:Setup()
	local q = [[CREATE TABLE IF NOT EXISTS main(
	steamid VARCHAR(17) NOT NULL UNIQUE,
	money INT(10) UNSIGNED NOT NULL,
	rank_id INT(2) NOT NULL,

	CONSTRAINT main_pk PRIMARY KEY (steamid),

	INDEX(steamid)
	)]]

	local query = DB.DATABASE:query(q)

	function query.onSuccess(data)
		hook.Call("onDatabaseSetup")
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
	DB.DATABASE = mysqloo.connect(DB.host, DB.user, DB.pass, DB.db, DB.port)

	function DB.DATABASE:onConnected()
		ELogs.Output("Database connection established!")
		DB:Setup()
		hook.Run("onDatabaseConnected")
	end

	function DB.DATABASE:onConnectionFailed(err)
		ELogs.Error(err)

		timer.Simple(20, function()
			DB.Connect()
		end)
	end

	DB.DATABASE:setAutoReconnect(true)
	DB.DATABASE:connect()
end
