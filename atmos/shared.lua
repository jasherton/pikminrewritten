
pikmintime_enabled = CreateConVar( "pikmintime_enabled", "1", bit.bor( FCVAR_ARCHIVE, FCVAR_GAMEDLL, FCVAR_REPLICATED, FCVAR_NOTIFY ), "pikmintime enabled." );
pikmintime_paused = CreateConVar( "pikmintime_paused", "0", bit.bor( FCVAR_ARCHIVE, FCVAR_GAMEDLL, FCVAR_REPLICATED, FCVAR_NOTIFY ), "pikmintime time progression enabled." );
pikmintime_realtime = CreateConVar( "pikmintime_realtime", "0", bit.bor( FCVAR_ARCHIVE, FCVAR_GAMEDLL, FCVAR_REPLICATED, FCVAR_NOTIFY ), "Whether or not pikmintime progresses based on the servers time zone." );
pikmintime_logging = CreateConVar( "pikmintime_log", "0", bit.bor( FCVAR_ARCHIVE, FCVAR_GAMEDLL, FCVAR_REPLICATED, FCVAR_NOTIFY ), "Turn pikmintime logging to console on or off." );

pikmintime_dnc_length_day = CreateConVar( "pikmintime_dnc_length_day", "900", bit.bor( FCVAR_ARCHIVE, FCVAR_GAMEDLL, FCVAR_REPLICATED ), "The duration modifier of daytime in seconds." );
pikmintime_dnc_length_night = CreateConVar( "pikmintime_dnc_length_night", "900", bit.bor( FCVAR_ARCHIVE, FCVAR_GAMEDLL, FCVAR_REPLICATED ), "The duration modifier of nighttime in seconds." );

pikmintime_weather = CreateConVar( "pikmintime_weather", "1", bit.bor( FCVAR_ARCHIVE, FCVAR_GAMEDLL, FCVAR_REPLICATED, FCVAR_NOTIFY ), "pikmintime Weather enabled." );
pikmintime_weather_chance = CreateConVar( "pikmintime_weather_chance", "30", bit.bor( FCVAR_ARCHIVE, FCVAR_GAMEDLL, FCVAR_REPLICATED ), "Chance for bad weather to occur between 1-100." );
pikmintime_weather_length = CreateConVar( "pikmintime_weather_length", "480", bit.bor( FCVAR_ARCHIVE, FCVAR_GAMEDLL, FCVAR_REPLICATED ), "The duration of a storm in seconds." );
pikmintime_weather_delay = CreateConVar( "pikmintime_weather_delay", "600", bit.bor( FCVAR_ARCHIVE, FCVAR_GAMEDLL, FCVAR_REPLICATED ), "How many seconds it takes for pikmintime to do a dice roll for weather, default is 600 (10 minutes), which means pikmintime will attempt to trigger a storm every 10 minutes using the chance value." );
pikmintime_weather_lightstyle = CreateConVar( "pikmintime_weather_lighting", "1", bit.bor( FCVAR_ARCHIVE, FCVAR_GAMEDLL, FCVAR_REPLICATED, FCVAR_NOTIFY ), "Allow weather to change the lighting (can be buggy?)." );

pikmintime_snowenabled = CreateConVar( "pikmintime_snowenabled", "0", bit.bor( FCVAR_ARCHIVE, FCVAR_GAMEDLL, FCVAR_REPLICATED, FCVAR_NOTIFY ), "pikmintime Snow enabled." );

pikmintime_version = 1.9;
pikmintime_dev = false;
pikmintimeURL = "";

pikmintimeHeightMin = 300;

function pikmintime_log( ... )

	if ( pikmintime_logging:GetInt() < 1 ) then return end

	print( "[pikmintime] " .. string.format( ... ) .. "\n" );

end

function pikmintime_Outside( pos )

	if ( pos != nil ) then

		local trace = { };
		trace.start = pos;
		trace.endpos = trace.start + Vector( 0, 0, 32768 );
		trace.mask = MASK_BLOCKLOS;

		local tr = util.TraceLine( trace );

		pikmintimeHeightMin = ( tr.HitPos - trace.start ):Length(); -- thanks to SW for this improvement

		if ( tr.StartSolid ) then return false end
		if ( tr.HitSky ) then return true end

	end

	return false;

end

function pikmintime_outside( pos )

	return pikmintime_Outside( pos );

end

-- usergroup support
local meta = FindMetaTable( "Player" )

function meta:pikmintimeAdmin()

	return self:IsSuperAdmin() or self:IsAdmin();

end

function meta:pikmintimeVIP()

	return self:IsUserGroup( "vip" ) or self:IsUserGroup( "moderator" ) or self:IsUserGroup( "donator" );

end
