// By vMajx-

if(!CLIENT) then return end

AddCSLuaFile()

net.Receive("ConnectionMsg", function(len)
	local CM_Data = net.ReadTable()
	chat.AddText(Color(181, 81, 81), "● ", unpack(CM_Data))
end )