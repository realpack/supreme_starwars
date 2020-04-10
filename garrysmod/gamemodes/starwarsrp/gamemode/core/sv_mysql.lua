hook.Add( "DatabaseInitialized", "DatabaseInitialized", function()
	MySQLite.query([[
		CREATE TABLE IF NOT EXISTS metahub_player_data(
            id int auto_increment not null primary key,
			steam_id varchar(25),
			community_id TEXT,
			player varchar(255),
            money INT,
            vehicles TEXT
		);
	]],nil,function(err)
		print(err)
	end)
	MySQLite.query([[
		CREATE TABLE IF NOT EXISTS metahub_characters(
            character_id int auto_increment not null primary key,
			player_id int,
            rpid INT,
            rank varchar(255),
            features TEXT,
            team_id varchar(255),
            character_name varchar(255),
            model varchar(255)
		);
	]],nil,function(err)
		print(err)
	end)
	MySQLite.query([[
		CREATE TABLE IF NOT EXISTS metahub_spawnpoints(
			map varchar(255),
            vector TEXT,
            category varchar(255)
		);
	]],nil,function(err)
		print(err)
	end)
    MySQLite.query([[
		CREATE TABLE IF NOT EXISTS metahub_player_levelsystem(
			steam_id varchar(25) primary key,
            level INT(4),
            experience INT(4)
		);
	]],nil,function(err)
		print(err)
	end)
	-- MySQLite.query([[
	-- 	CREATE TABLE IF NOT EXISTS metahub_player_inventory(
	-- 		steam_id varchar(25),
	-- 		community_id TEXT,
	-- 		data TEXT,
	-- 		clothes TEXT,
	-- 		scraps TEXT,
	-- 		PRIMARY KEY (`steam_id`)
	-- 	);
	-- ]])
	-- MySQLite.query([[
	-- 	CREATE TABLE IF NOT EXISTS metahub_doorsystem_data(
	-- 		id INT AUTO_INCREMENT,
	-- 		mapid INT,
	-- 		vector VARCHAR(255),
    --         rpgroup INT,
	-- 		PRIMARY KEY (id)
	-- 	);
	-- ]],nil,function(error)
	-- 	print(error)
	-- end)
end)
