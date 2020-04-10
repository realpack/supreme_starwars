local Tag = "ChatAddText"

if SERVER then
	util.AddNetworkString(Tag)

	function ChatAddText(target, ...)
		net.Start(Tag)
			net.WriteTable({...})
		net.Send(target)
	end

	function ChatAddTextAll(...)
		net.Start(Tag)
			net.WriteTable({...})
		net.Broadcast()
	end
end

if CLIENT then
	local function receive()
		local data = net.ReadTable()
		if not istable(data) then return end

		chat.AddText(unpack(data))
	end

	net.Receive(Tag, receive)
end
