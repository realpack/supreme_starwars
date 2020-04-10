NETWORK_PROTOCOL_PRIVATE = 0x01;
NETWORK_PROTOCOL_PUBLIC  = 0x02;

nw = nw or {}
nw.manager = nw.manager or { cache = {}, name = "SrawlNManager" };

local meta = debug.getregistry()[ "Entity" ];

function meta:GetNVar( name )
	return nw.manager[ self:EntIndex() ] and ( nw.manager[ self:EntIndex() ][ name ] or false ) or false;
end

if ( SERVER ) then 
	util.AddNetworkString( nw.manager.name .. "AddNetwork" );
	util.AddNetworkString( nw.manager.name .. "DataChannel" );
	util.AddNetworkString('SetupPlayerVars');

	hook.Add('PlayerInitialSpawn','SetupPlayerVars.PlayerInitialSpawn', function( pPlayer )
		net.Start('SetupPlayerVars')
			net.WriteTable(nw.manager)
		net.Send(pPlayer)
	end)

	function meta:SetNVar( name, value, nprot ) 
		nw.manager[ self:EntIndex() ] = nw.manager[ self:EntIndex() ] or {};
		nw.manager[ self:EntIndex() ][ name ] = value;

		net.Start( nw.manager.name .. "DataChannel" );
			net.WriteInt( self:EntIndex(), 32 );
			net.WriteString( name );
			net.WriteTable( {value} );
		net[ nprot == NETWORK_PROTOCOL_PUBLIC and "Broadcast" or "Send" ]( self );
	end

	function meta:GetNetworkManager()
		return nw.manager;
	end
else 
	net.Receive( nw.manager.name .. "DataChannel", function( len ) 
		local index = net.ReadInt( 32 );
		local name = net.ReadString();
		
		nw.manager[ index ] = nw.manager[ index ] or {};
		nw.manager[ index ][ name ] = net.ReadTable()[ 1 ];
	end)
	net.Receive( "SetupPlayerVars", function( len )
		local tbl = net.ReadTable()
		nw.manager = tbl
	end)
end