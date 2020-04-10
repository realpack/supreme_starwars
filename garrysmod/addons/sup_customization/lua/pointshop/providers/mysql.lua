--[[

	PointShop MySQL Adapter by _Undefined

	Usage:

		First, make sure you have the MySQLOO module installed from:
			http://www.facepunch.com/showthread.php?t=1220537
			Installation instructions are in that thread.

		Then configure your MySQL details below and import the following tables into your database:

        DROP TABLE IF EXISTS `pointshop_data`;
        CREATE TABLE `pointshop_data` (
         `uniqueid` varchar(30) NOT NULL,
         `points` int(32) NOT NULL,
         `items` text NOT NULL,
         PRIMARY KEY (`uniqueid`)
        ) ENGINE=MyISAM DEFAULT CHARSET=latin1

		MAKE SURE YOU ALLOW REMOTE ACCESS TO YOUR DATABASE FROM YOUR GMOD SERVERS IP ADDRESS.

		If you're upgrading from the old version, run the following SQL before starting your server and then remove the old tables (pointshop_points and pointshop_items):

			INSERT INTO `pointshop_data` SELECT `pointshop_points`.`uniqueid`, `points`, `items` FROM `pointshop_points` INNER JOIN `pointshop_items` ON `pointshop_items`.`uniqueid` = `pointshop_points`.`uniqueid`

		Once configured, change PS.Config.DataProvider = 'pdata' to PS.Config.DataProvider = 'mysql' in pointshop's sh_config.lua.

]]--

-- config, change these to match your setup

local mysql_hostname = '127.0.0.1' -- Your MySQL server address.
local mysql_username = 'server' -- Your MySQL username.
local mysql_password = 'oX0G75LtOPug' -- Your MySQL password.
local mysql_database = 'sup_cwrp_pro' -- Your MySQL database.
local mysql_port = 3306 -- Your MySQL port. Most likely is 3306.

-- end config, don't change anything below unless you know what you're doing

require('mysqloo')

local db = mysqloo.connect(mysql_hostname, mysql_username, mysql_password, mysql_database, mysql_port)

function db:onConnected()
    MsgN('PointShop MySQL: Connected!')
end

function db:onConnectionFailed(err)
    MsgN('PointShop MySQL: Connection Failed, please check your settings: ' .. err)
end

db:connect()

function PROVIDER:GetData(ply, callback)
    local qs = [[SELECT * FROM `metahub_player_data` WHERE `steam_id`=%s;]]
    qs = string.format( qs, MySQLite.SQLStr(ply:SteamID()) )
    local q = db:query(qs)

    function q:onSuccess(data)
        if #data > 0 then
            local row = data[1]

            -- PrintTable(row)
            local points = row.money or 0
            local items = util.JSONToTable(row.items or '{}')
            -- PrintTable(items)

            callback(points, items)
        else
            callback(0, {})
        end
    end

    function q:onError(err, sql)
        if db:status() ~= mysqloo.DATABASE_CONNECTED then
            db:connect()
            db:wait()
        if db:status() ~= mysqloo.DATABASE_CONNECTED then
            ErrorNoHalt("Re-connection to database server failed.")
            callback(0, {})
            return
            end
        end
        MsgN('PointShop MySQL: Query Failed: ' .. err .. ' (' .. sql .. ')')
        q:start()
    end

    q:start()
end

function PROVIDER:SetPoints(ply, points)
    local qs = [[UPDATE `metahub_player_data` SET `money`=%s WHERE `steam_id`=%s]]
    qs = string.format(qs, MySQLite.SQLStr(tostring(points or 0)), MySQLite.SQLStr(ply:SteamID()))
    local q = db:query(qs)

    function q:onError(err, sql)
        if db:status() ~= mysqloo.DATABASE_CONNECTED then
            db:connect()
            db:wait()
        if db:status() ~= mysqloo.DATABASE_CONNECTED then
            ErrorNoHalt("Re-connection to database server failed.")
            return
            end
        end
        MsgN('PointShop MySQL: Query Failed: ' .. err .. ' (' .. sql .. ')')
        q:start()
    end

    q:start()
end

function PROVIDER:GivePoints(ply, points)
    local qs = [[UPDATE `metahub_player_data` SET money = money + %s WHERE `steam_id`=%s]]
    qs = string.format(qs, MySQLite.SQLStr(tostring(points or 0)), MySQLite.SQLStr(ply:SteamID()))
    local q = db:query(qs)

    function q:onError(err, sql)
        if db:status() ~= mysqloo.DATABASE_CONNECTED then
            db:connect()
            db:wait()
        if db:status() ~= mysqloo.DATABASE_CONNECTED then
            ErrorNoHalt("Re-connection to database server failed.")
            return
            end
        end
        MsgN('PointShop MySQL: Query Failed: ' .. err .. ' (' .. sql .. ')')
        q:start()
    end

    q:start()
end

function PROVIDER:TakePoints(ply, points)
    local qs = [[UPDATE `metahub_player_data` SET money = money - %s WHERE `steam_id`=%s]]
    qs = string.format(qs, MySQLite.SQLStr(tostring(points or 0)), MySQLite.SQLStr(ply:SteamID()))
    local q = db:query(qs)

    function q:onError(err, sql)
        if db:status() ~= mysqloo.DATABASE_CONNECTED then
            db:connect()
            db:wait()
        if db:status() ~= mysqloo.DATABASE_CONNECTED then
            ErrorNoHalt("Re-connection to database server failed.")
            return
            end
        end
        MsgN('PointShop MySQL: Query Failed: ' .. err .. ' (' .. sql .. ')')
        q:start()
    end

    q:start()
end

function PROVIDER:SaveItem(ply, item_id, data)
    self:GiveItem(ply, item_id, data)
end

function PROVIDER:GiveItem(ply, item_id, data)
    local tmp = table.Copy(ply.PS_Items)
    tmp[item_id] = data

    -- local qs = [[
    -- INSERT INTO `pointshop_data` (uniqueid, points, items)
    -- VALUES ('%s', '0', '%s')
    -- ON DUPLICATE KEY UPDATE
    --     items = VALUES(items)
    -- ]]
    local qs = [[UPDATE `metahub_player_data` SET items = %s WHERE `steam_id`=%s]]
    qs = string.format(qs, MySQLite.SQLStr(util.TableToJSON(tmp)), MySQLite.SQLStr(ply:SteamID()))
    local q = db:query(qs)

    function q:onError(err, sql)
        if db:status() ~= mysqloo.DATABASE_CONNECTED then
            db:connect()
            db:wait()
        if db:status() ~= mysqloo.DATABASE_CONNECTED then
            ErrorNoHalt("Re-connection to database server failed.")
            return
            end
        end
        MsgN('PointShop MySQL: Query Failed: ' .. err .. ' (' .. sql .. ')')
        q:start()
    end

    q:start()
end

function PROVIDER:TakeItem(ply, item_id)
    local tmp = table.Copy(ply.PS_Items)
    tmp[item_id] = nil

    local qs = [[UPDATE `metahub_player_data` SET items = %s WHERE `steam_id`=%s]]
    qs = string.format(qs, MySQLite.SQLStr(util.TableToJSON(tmp)), MySQLite.SQLStr(ply:SteamID()))
    local q = db:query(qs)

    function q:onError(err, sql)
        if db:status() ~= mysqloo.DATABASE_CONNECTED then
            db:connect()
            db:wait()
        if db:status() ~= mysqloo.DATABASE_CONNECTED then
            ErrorNoHalt("Re-connection to database server failed.")
            return
            end
        end
        MsgN('PointShop MySQL: Query Failed: ' .. err .. ' (' .. sql .. ')')
        q:start()
    end

    q:start()
end

function PROVIDER:SetData(ply, points, items)
    -- local qs = [[
    -- INSERT INTO `pointshop_data` (uniqueid, points, items)
    -- VALUES ('%s', '%s', '%s')
    -- ON DUPLICATE KEY UPDATE
    --     points = VALUES(points),
    --     items = VALUES(items)
    -- ]]
    local qs = [[UPDATE `metahub_player_data` SET points = %s, items = %s WHERE `steam_id`=%s]]
    qs = string.format(qs, MySQLite.SQLStr(tostring(points or 0)), MySQLite.SQLStr(util.TableToJSON(items)), MySQLite.SQLStr(ply:SteamID()))
    local q = db:query(qs)

    function q:onError(err, sql)
        if db:status() ~= mysqloo.DATABASE_CONNECTED then
            db:connect()
            db:wait()
        if db:status() ~= mysqloo.DATABASE_CONNECTED then
            ErrorNoHalt("Re-connection to database server failed.")
            return
            end
        end
        MsgN('PointShop MySQL: Query Failed: ' .. err .. ' (' .. sql .. ')')
        q:start()
    end

    q:start()
end
