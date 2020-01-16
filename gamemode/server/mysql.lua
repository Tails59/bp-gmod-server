require("mysqloo")

DB = {}
DB.Enabled = true

DB.host = ""
DB.user = ""
DB.pass = ""
DB.db = ""
DB.port = 3306

DB.DATABASE = DATABASE or nil

/*
	Returns the query results if successful.
	If wait is true, it will force the server to wait until the query has finished executing before returning
*/
function DB:Query(query, callback, wait)
	if (not DB.DATABASE or not DB.DATABASE:status() == mysqloo.DATABASE_CONNECTED) then
		error("Database not connected!")
	end

	local q = DB.DATABASE:escape(query)
	if !q then return end

	function q:onSuccess(data)
		if callback then callback(data) end
	end

	function q:onError(err, quer)
		error("Query didn't run!")
		ELogs.Error("Query: "..quer)
		ELogs.Error("Error: "..err)
	end

	if wait then q:wait(true) end

	q:start()
end

/*
	Returns a PreparedQuery object for frequently-used queries
*/
function DB:PreparedQuery(query, callback)
	local safeQuery = DB.DATABASE:escape(query)
	if not safeQuery then return end
	
	local preparedQuery = DB.Database:prepare(safeQuery)

	function preparedQuery:onSuccess(data)
		if callback then callback(data) end
	end

	function preparedQuery:onError(err)
		error("Prepared query didn't run!")
		ELogs.Error("Query: "..quer)
		ELogs.Error("Error: "..err)
	end

	return preparedQuery
end

function DB:LoadPlayer(ply)

end

function DB:Connect()
	DB.DATABASE = mysqloo.connect(BP.host, BP.user, BP.database, BP.port)

	function DB.Database:onConnected()
		ELogs.Output("Database connection established!")
		hook.Run("onDatabaseConnected")
	end

	function DB.Database:onConnectionFailed()
		ELogs.Error("Failed to connect to database")
		//Stop players connecting and plugins from loading
		//Retry connection
	end

	DB.Database:connect()
end
