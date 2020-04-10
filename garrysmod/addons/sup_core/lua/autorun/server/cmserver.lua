// By vMajx-

if(!SERVER) then return end

util.AddNetworkString("ConnectionMsg")

local function CM_Message(...)
	net.Start("ConnectionMsg")
	net.WriteTable({...})
	net.Broadcast()
end

hook.Add("PlayerConnect", "CM_Connect", function(name)
	CM_Message(Color(75, 191, 85), name, Color(75, 191, 85), " заходит на сервер.")
end )

print("Connection Message Loaded")