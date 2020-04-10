If you would like to use the support for MySQL you NEED to follow these steps. Please do not ask for help if you did not follow these steps!


1. In your MySQL server, create a new database for Awarn2. In my example, I use awarn2 (You can use an existing database if you wish)
2. Make sure you have an SQL user that has read and write access to that database.
3. Open awarn2/lua/awarn/modules/awarn_sql.lua
4. Edit the config at the top of the file with the information for your MySQL server.
5. Restart your server and if configured properly, AWarn2 will create 2 tables inside the database you selected.
	- awarn_playerdata and awarn_warnings
	
Enjoy!