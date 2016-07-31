
-- add pikmintime so clients download the needed resources

local TIME_NOON	= 12;		-- 12:00pm
local TIME_MIDNIGHT	= 0;		-- 12:00am
local TIME_DAWN_START	= 4;		-- 4:00am
local TIME_DAWN_END	= 6.5;		-- 6:30am
local TIME_DUSK_START	= 19;		-- 7:00pm;
local TIME_DUSK_END	= 20.5;		-- 8:30pm;

local STYLE_LOW	= string.byte( 'a' );		-- style for night time
local STYLE_HIGH = string.byte( 'm' );		-- style for day time

local NIGHT	= 0;
local DAWN = 1;
local DAY = 2;
local DUSK = 3;
local STORM = 4;
local STORM_NIGHT = 5;

hook.Add( "Initialize", "pikmintimeInitFix", function()

	if ( pikmintime_enabled:GetInt() <= 0 ) then return end

	RunConsoleCommand( "sv_skyname", "painted" );

	if ( game.ConsoleCommand ) then

		game.ConsoleCommand( "sv_skyname painted\n" );

	end

end );

hook.Add( "InitPostEntity", "pikmintimeInitPostEvo", function()

	-- HACK: fixes the darkened sky effect on evocity
	local map = string.lower( game.GetMap() );

	if ( string.find( map, "evocity" ) != nil ) then

		for _, brush in pairs( ents.FindByName( "daynight_brush" ) ) do

			pikmintime_log( "removing daynight_brush " .. tostring( brush ) );

			brush:Remove();

		end

	end

	-- HACK: fixes cleanup removing env_skypaint, light_environment
	local oldCleanUpMap = game.CleanUpMap;

	game.CleanUpMap = function(dontSendToClients, ExtraFilters)
		dontSendToClients = (dontSendToClients != nil and dontSendToClients or false);

		if ( ExtraFilters != nil ) then
			table.insert(ExtraFilters, "env_skypaint");
			table.insert(ExtraFilters, "light_environment");
		else
			ExtraFilters = { "env_skypaint", "light_environment" };
		end

		oldCleanUpMap(dontSendToClients, ExtraFilters);
	end

end );

local SKYPAINT =
{
	[DAWN] =
	{
		TopColor		= Vector( 0.2, 0.5, 1 ),
		BottomColor		= Vector( 0.46, 0.65, 0.49 ),
		FadeBias		= 1,
		HDRScale		= 0.26,
		StarScale 		= 1.84,
		StarFade		= 0.0,	-- Do not change!
		StarSpeed 		= 0.02,
		DuskScale		= 1,
		DuskIntensity	= 1,
		DuskColor		= Vector( 1, 0.2, 0 ),
		SunColor		= Vector( 0.2, 0.1, 0 ),
		SunSize			= 2,
	},
	[DAY] =
	{
		TopColor		= Vector( 0.2, 0.49, 1 ),
		BottomColor		= Vector( 0.8, 1, 1 ),
		FadeBias		= 1,
		HDRScale		= 0.26,
		StarScale 		= 1.84,
		StarFade		= 1.5,	-- Do not change!
		StarSpeed 		= 0.02,
		DuskScale		= 1,
		DuskIntensity	= 1,
		DuskColor		= Vector( 1, 0.2, 0 ),
		SunColor		= Vector( 0.83, 0.45, 0.11 ),
		SunSize			= 0.34,
	},
	[DUSK] =
	{
		TopColor		= Vector( 0.24, 0.15, 0.08 ),
		BottomColor		= Vector( .4, 0.07, 0 ),
		FadeBias		= 1,
		HDRScale		= 0.36,
		StarScale		= 1.50,
		StarFade		= 5.0,	-- Do not change!
		StarSpeed 		= 0.01,
		DuskScale		= 1,
		DuskIntensity	= 1.94,
		DuskColor		= Vector( 0.69, 0.22, 0.02 ),
		SunColor		= Vector( 0.90, 0.30, 0.00 ),
		SunSize			= 0.44,
	},
	[NIGHT] =
	{
		TopColor		= Vector( 0.00, 0.00, 0.00 ),
		BottomColor		= Vector( 0.05, 0.05, 0.11 ),
		FadeBias		= 0.1,
		HDRScale		= 0.19,
		StarScale		= 1.50,
		StarFade		= 5.0,	-- Do not change!
		StarSpeed 		= 0.01,
		DuskScale		= 0,
		DuskIntensity	= 0,
		DuskColor		= Vector( 1, 0.36, 0 ),
		SunColor		= Vector( 0.83, 0.45, 0.11 ),
		SunSize			= 0.0,
	},
	[STORM] =
	{
		TopColor		= Vector( 0.22, 0.22, 0.22 ),
		BottomColor		= Vector( 0.05, 0.05, 0.07 ),
		FadeBias		= 1,
		HDRScale		= 0.26,
		StarScale 		= 2.0,
		StarFade		= 5.0,	-- Do not change!
		StarSpeed 		= 0.04,
		DuskScale		= 0.0,
		DuskIntensity	= 0.0,
		DuskColor		= Vector( 0.23, 0.23, 0.23 ),
		SunColor		= Vector( 0.83, 0.45, 0.11 ),
		SunSize			= 0.1,
	},
	[STORM_NIGHT] =
	{
		TopColor		= Vector( 0.01, 0.01, 0.01 ),
		BottomColor		= Vector( 0.00, 0.00, 0.00 ),
		FadeBias		= 1,
		HDRScale		= 0.26,
		StarScale 		= 2.0,
		StarFade		= 5.0,	-- Do not change!
		StarSpeed 		= 0.04,
		DuskScale		= 0.0,
		DuskIntensity	= 0.0,
		DuskColor		= Vector( 0.23, 0.23, 0.23 ),
		SunColor		= Vector( 0.83, 0.45, 0.11 ),
		SunSize			= 0.1,
	}
};

local pikmintime =
{
	m_InitEntities = false,
	m_OldSkyName = "unknown",
	m_Time = 6.5,
	m_LastPeriod = NIGHT,
	m_LastStyle = '.',
	m_Cloudy = false,
	m_Paused = false,
	m_Storming = false,
	m_Snowing = false,
	m_NextWeatherCheck = CurTime() + pikmintime_weather_delay:GetInt(),
	m_WeatherEnd = 0,
	m_SnowEnd = 0,

	-- to easily hook functions within our own object instance
	Hook = function( this, name )

		local func = this[name];
		local function Wrapper( ... )
			func( this, ... );
		end

		hook.Add( name, string.format( "pikmintime.%s", tostring( this ), name ), Wrapper );

	end,

	LightStyle = function( self, style, force )

		if ( tostring( self.m_LastStyle ) == tostring( style ) and (force == nil or force == false) ) then return end
		if ( self.m_Storming and (force == nil or force == false)) then return end

		--pikmintime_log( "LightStyle set to " .. tostring(style) .. " " .. tostring(self.m_LastStyle) .. " " .. tostring(force) );

		if ( IsValid( self.m_LightEnvironment ) ) then

			self.m_LightEnvironment:Fire( "FadeToPattern", tostring( style ) );

		else

			engine.LightStyle( 0, style );

			timer.Simple( 0.1, function()

				net.Start( "pikmintime_lightmaps" );
				net.Broadcast();

			end );

		end

		self.m_LastStyle = style;

	end,

	Initialize = function( self )

		self.m_OldSkyName = GetConVar("sv_skyname"):GetString();

		self:Hook( "Think" );

		pikmintime_log( "pikmintime version %s initializing.", tostring( pikmintime_version ) );

	end,

	InitEntities = function( self )

		self.m_LightEnvironment = ents.FindByClass( "light_environment" )[1];
		self.m_EnvSun = ents.FindByClass( "env_sun" )[1];
		self.m_EnvSkyPaint = ents.FindByClass( "env_skypaint" )[1];
		self.m_RelayDawn = ents.FindByName( "dawn" )[1];
		self.m_RelayDusk = ents.FindByName( "dusk" )[1];
		self.m_RelayCloudy = ents.FindByName( "cloudy" )[1];

		-- put the sun on the horizon initially
		if ( IsValid( self.m_EnvSun ) ) then
			self.m_EnvSun:SetKeyValue( "sun_dir", "1 0 0" );
		end

		-- log found entities
		-- HACK: Fixes prop lighting since the first pattern change fails to update it.
		if ( IsValid( self.m_LightEnvironment ) ) then
			pikmintime_log( "Found light_environment" );

			self:LightStyle( "a", true );
		else
			pikmintime_log( "No light_environment, using engine.LightStyle instead." );

			-- a is too dark for use with engine.LightStyle, bugs out
			STYLE_LOW = string.byte( "b" );
			self:LightStyle( "b", true );
		end

		if ( IsValid( self.m_EnvSun ) ) then
			pikmintime_log( "Found env_sun" );
		end

		if ( IsValid( self.m_EnvSkyPaint ) ) then

			pikmintime_log( "Found env_skypaint" );

		else

			local skyPaint = ents.Create( "env_skypaint" );
			skyPaint:Spawn();
			skyPaint:Activate();

			self.m_EnvSkyPaint = skyPaint;

			pikmintime_log( "Created env_skypaint" );

		end

		self.m_EnvSkyPaint:SetStarTexture( "skybox/starfield" );

		self.m_InitEntities = true;

	end,

	Think = function( self )

		if ( pikmintime_enabled:GetInt() < 1 ) then return end
		if ( !self.m_InitEntities ) then self:InitEntities(); end

		local timeLen = 3600;
		if (self.m_Time > TIME_DUSK_START or self.m_Time < TIME_DAWN_END) then
			timeLen = pikmintime_dnc_length_night:GetInt();
		else
			timeLen = pikmintime_dnc_length_day:GetInt();
		end

		if ( !self.m_Paused and pikmintime_paused:GetInt() <= 0 ) then
			if ( pikmintime_realtime:GetInt() <= 0 ) then
				self.m_Time = self.m_Time + ( 24 / timeLen ) * FrameTime();
				if ( self.m_Time > 24 ) then
					self.m_Time = 0;
				end
			else
				self.m_Time = self:GetRealTime();
			end
		end

		-- since our dawn/dusk periods last several hours find the mid point of them
		local dawnMidPoint = ( TIME_DAWN_END + TIME_DAWN_START ) / 2;
		local duskMidPoint = ( TIME_DUSK_END + TIME_DUSK_START ) / 2;

		-- dawn/dusk/night events
		if ( self.m_Time >= TIME_DUSK_END and IsValid( self.m_EnvSun ) ) then
			if ( self.m_LastPeriod != NIGHT ) then
				self.m_EnvSun:Fire( "TurnOff", "", 0 );

				self.m_LastPeriod = NIGHT;
			end

		elseif ( self.m_Time >= duskMidPoint ) then
			if ( self.m_LastPeriod != DUSK ) then
				if ( IsValid( self.m_RelayDusk ) ) then
					self.m_RelayDusk:Fire( "Trigger", "" );
				end

				-- disabled because the clouds at night look pretty awful..
				--self.m_Cloudy = math.random() > 0.5;
				self.m_Cloudy = false;

				-- at dawn select if we should display clouds for night or not (50% chance)
				if ( IsValid( self.m_EnvSkyPaint ) ) then
					if ( self.m_Cloudy ) then
						self.m_EnvSkyPaint:SetStarTexture( "skybox/clouds" );
					else
						if ( !self.m_Storming ) then
							self.m_EnvSkyPaint:SetStarTexture( "skybox/starfield" );
						end
					end
				end

				self.m_LastPeriod = DUSK;
			end

		elseif ( self.m_Time >= dawnMidPoint ) then
			if ( self.m_LastPeriod != DAWN ) then
				if ( IsValid( self.m_RelayDawn ) ) then
					self.m_RelayDawn:Fire( "Trigger", "" );
				end

				-- disabled because clouds during transitions looks pretty awful, too
				--self.m_Cloudy = math.random() > 0.5;
				self.m_Cloudy = false;

				-- at dawn select if we should display clouds for day or not (50% chance)
				if ( IsValid( self.m_EnvSkyPaint ) ) then
					if ( self.m_Cloudy ) then
						self.m_EnvSkyPaint:SetStarTexture( "skybox/clouds" );
						SKYPAINT[DAY].StarFade = 1.5;
					else
						SKYPAINT[DAY].StarFade = 0;
					end
				end

				self.m_LastPeriod = DAWN;
			end

		elseif ( self.m_Time >= TIME_DAWN_START and IsValid( self.m_EnvSun ) ) then
			if ( self.m_LastPeriod != DAY ) then

				if ( !self:GetStorming() ) then
					self.m_EnvSun:Fire( "TurnOn", "", 0 );
				end

				self.m_LastPeriod = DAY;
			end

		end

		-- light_environment
		local lightfrac = 0;

		if ( self.m_Time >= dawnMidPoint and self.m_Time < TIME_NOON ) then
			lightfrac = math.EaseInOut( ( self.m_Time - dawnMidPoint ) / ( TIME_NOON - dawnMidPoint ), 0, 1 );
		elseif ( self.m_Time >= TIME_NOON and self.m_Time < duskMidPoint ) then
			lightfrac = 1 - math.EaseInOut( ( self.m_Time - TIME_NOON ) / ( duskMidPoint - TIME_NOON ), 1, 0 );
		end

		local style = string.char( math.floor( Lerp( lightfrac, STYLE_LOW, STYLE_HIGH ) + 0.5 ) );

		self:LightStyle( style );

		-- env_sun
		if ( IsValid( self.m_EnvSun ) ) then
			if ( self.m_Time >= TIME_DAWN_START and self.m_Time <= TIME_DUSK_END ) then
				local sunfrac = 1 - ( ( self.m_Time - TIME_DAWN_START ) / ( TIME_DUSK_END - TIME_DAWN_START ) );
				local angle = Angle( -180 * sunfrac, 15, 0 );

				self.m_EnvSun:SetKeyValue( "sun_dir", tostring( angle:Forward() ) );
			end
		end

		-- env_skypaint
		if ( IsValid( self.m_EnvSkyPaint ) ) then

			if ( IsValid( self.m_EnvSun ) ) then
				self.m_EnvSkyPaint:SetSunNormal( self.m_EnvSun:GetInternalVariable( "m_vDirection" ) );
			end

			local cur = NIGHT;
			local next = NIGHT;
			local frac = 0;
			local ease = 0.3;

			if ( self.m_Time >= TIME_DAWN_START and self.m_Time < dawnMidPoint ) then
				cur = NIGHT;
				next = DAWN;
				frac = math.EaseInOut( ( self.m_Time - TIME_DAWN_START ) / ( dawnMidPoint - TIME_DAWN_START ), ease, ease );
			elseif ( self.m_Time >= dawnMidPoint and self.m_Time < TIME_DAWN_END ) then
				cur = DAWN;
				next = DAY;
				frac = math.EaseInOut( ( self.m_Time - dawnMidPoint ) / ( TIME_DAWN_END - dawnMidPoint ), ease, ease );
			elseif ( self.m_Time >= TIME_DUSK_START and self.m_Time < duskMidPoint ) then
				cur = DAY;
				next = DUSK;
				frac = math.EaseInOut( ( self.m_Time - TIME_DUSK_START ) / ( duskMidPoint - TIME_DUSK_START ), ease, ease );
			elseif ( self.m_Time >= duskMidPoint and self.m_Time < TIME_DUSK_END ) then
				cur = DUSK;
				next = NIGHT;
				frac = math.EaseInOut( ( self.m_Time - duskMidPoint ) / ( TIME_DUSK_END - duskMidPoint ), ease, ease );
			elseif ( self.m_Time >= TIME_DAWN_END and self.m_Time <= TIME_DUSK_END ) then
				cur = DAY;
				next = DAY;
			end

			-- lazy math inbound
			if ( pikmintime_weather:GetInt() > 0 and self.m_NextWeatherCheck < CurTime() and ( cur == DAY or cur == DUSK ) ) then

				if ( !self:GetStorming() and !self:GetSnowing() ) then

					pikmintime_log( "Attempting to start weather" );

					local rnd = math.random( 1, 100 );
					local chance = pikmintime_weather_chance:GetInt();

					pikmintime_log( "rnd = %s\nchance = %s\n", tostring( rnd ), tostring( chance ) );

					if ( chance != 0 and rnd <= chance ) then

						local snowChance = math.random( 1, 2 );

						pikmintime_log( "snowChance = %s\n", tostring( snowChance ) );

						if ( pikmintime_snowenabled:GetInt() <= 0 ) then

							snowChance = 0;

						end

						if ( snowChance == 1 ) then

							self:StartSnow();

						else

							self:StartStorm();

						end

					end

					self.m_NextWeatherCheck = CurTime() + pikmintime_weather_delay:GetInt();

				end

			end

			if ( self:GetStorming() or self:GetSnowing() ) then

				if ( self.m_WeatherEnd < CurTime() ) then

					if ( self:GetStorming() ) then

						self:StopStorm();

					else

						self:StopSnow();

					end

				end

				if ( self:GetStorming() ) then

					if ( ( self.m_Time > TIME_MIDNIGHT and self.m_Time < TIME_DAWN_START ) or ( self.m_Time >= TIME_DUSK_END ) ) then

						cur = STORM_NIGHT;
						next = STORM_NIGHT;

					else

						cur = STORM;
						next = STORM;

					end

				end

			end

			self.m_EnvSkyPaint:SetTopColor( LerpVector( frac, SKYPAINT[cur].TopColor, SKYPAINT[next].TopColor ) );
			self.m_EnvSkyPaint:SetBottomColor( LerpVector( frac, SKYPAINT[cur].BottomColor, SKYPAINT[next].BottomColor ) );
			self.m_EnvSkyPaint:SetSunColor( LerpVector( frac, SKYPAINT[cur].SunColor, SKYPAINT[next].SunColor ) );
			self.m_EnvSkyPaint:SetDuskColor( LerpVector( frac, SKYPAINT[cur].DuskColor, SKYPAINT[next].DuskColor ) );
			self.m_EnvSkyPaint:SetFadeBias( Lerp( frac, SKYPAINT[cur].FadeBias, SKYPAINT[next].FadeBias ) );
			self.m_EnvSkyPaint:SetHDRScale( Lerp( frac, SKYPAINT[cur].HDRScale, SKYPAINT[next].HDRScale ) );
			self.m_EnvSkyPaint:SetDuskScale( Lerp( frac, SKYPAINT[cur].DuskScale, SKYPAINT[next].DuskScale ) );
			self.m_EnvSkyPaint:SetDuskIntensity( Lerp( frac, SKYPAINT[cur].DuskIntensity, SKYPAINT[next].DuskIntensity ) );
			self.m_EnvSkyPaint:SetSunSize( (self:GetStorming() and 0 or Lerp( frac, SKYPAINT[cur].SunSize, SKYPAINT[next].SunSize )) );

			self.m_EnvSkyPaint:SetStarFade( SKYPAINT[next].StarFade );
			self.m_EnvSkyPaint:SetStarScale( SKYPAINT[next].StarScale );
			self.m_EnvSkyPaint:SetStarSpeed( SKYPAINT[next].StarSpeed );

		end

	end,

	TogglePause = function( self )

		self.m_Paused = !self.m_Paused;

	end,

	SetTime = function( self, time )

		self.m_Time = math.Clamp( time, 0, 24 );

		-- FIXME: we're bypassing the sun code
		if ( IsValid( self.m_EnvSun ) ) then
			self.m_EnvSun:SetKeyValue( "sun_dir", "1 0 0" );
		end

		-- FIXME: we're bypassing the dusk/dawn events
		if ( IsValid( self.m_EnvSkyPaint ) ) then
			self.m_EnvSkyPaint:SetStarTexture( "skybox/starfield" );
			SKYPAINT[DAY].StarFade = 0;
		end

	end,

	GetRealTime = function( self )

		local t = os.date( "*t" );

		return t.hour + (t.min / 60) + (t.sec / 3600);

	end,

	GetTime = function( self )

		return (pikmintime_realtime:GetInt() <= 0 and self.m_Time or self:GetRealTime());

	end,

	StartSnow = function( self )

		pikmintime_log( "Starting snow" );

		self.m_Snowing = true;
		self.m_NextWeatherCheck = 0;
		self.m_WeatherEnd = CurTime() + pikmintime_weather_length:GetInt();

		net.Start( "pikmintime_snow" );
			net.WriteBool( true );
		net.Broadcast();

	end,

	StopSnow = function( self )

		pikmintime_log( "Stopping snow" );

		self.m_Snowing = false;
		self.m_NextWeatherCheck = CurTime() + pikmintime_weather_delay:GetInt();
		self.m_WeatherEnd = 0;

		net.Start( "pikmintime_snow" );
			net.WriteBool( false );
		net.Broadcast();

	end,

	StartStorm = function( self )

		pikmintime_log( "Starting storm" );

		self.m_Storming = true;
		self.m_NextWeatherCheck = 0;
		self.m_WeatherEnd = CurTime() + pikmintime_weather_length:GetInt();

		if ( !( ( self.m_Time > TIME_MIDNIGHT and self.m_Time < TIME_DAWN_START ) or ( self.m_Time >= TIME_DUSK_END ) ) ) then

			if ( pikmintime_weather_lightstyle:GetInt() > 0 ) then

				self:LightStyle( "d", true );

			end

		end

		if ( IsValid( self.m_EnvSkyPaint ) ) then

			self.m_Cloudy = true;
			self.m_EnvSkyPaint:SetStarTexture( "skybox/clouds" );

		end

		if ( IsValid( self.m_EnvSun ) ) then

			self.m_EnvSun:Fire( "TurnOff", "", 0 );

			if ( IsValid( self.m_EnvSkyPaint ) ) then

				self.m_EnvSkyPaint:SetSunSize( 0 );

			end

			pikmintime_log( "Hiding sun" );

		end

		net.Start( "pikmintime_storm" );
			net.WriteBool( true );
		net.Broadcast();

	end,

	StopStorm = function( self )

		pikmintime_log( "Stopping storm" );

		self.m_Storming = false;
		self.m_NextWeatherCheck = CurTime() + pikmintime_weather_delay:GetInt();
		self.m_WeatherEnd = 0;
		self.m_Cloudy = false;

		if ( IsValid( self.m_EnvSkyPaint ) ) then

			self.m_EnvSkyPaint:SetStarTexture( "skybox/starfield" );

		end

		if ( !( ( self.m_Time > TIME_MIDNIGHT and self.m_Time < TIME_DAWN_START ) or ( self.m_Time >= TIME_DUSK_END ) ) ) then

			if ( IsValid( self.m_EnvSun ) ) then

				self.m_EnvSun:Fire( "TurnOn", "", 0 );

				pikmintime_log( "Showing sun" );

			end

		end

		net.Start( "pikmintime_storm" );
			net.WriteBool( false );
		net.Broadcast();

		local style = self.m_LastStyle;

		if ( pikmintime_weather_lightstyle:GetInt() > 0 ) then

			self:LightStyle( style, true );

		end

	end,

	GetSnowing = function( self )

		return self.m_Snowing;

	end,

	GetStorming = function( self )

		return self.m_Storming;

	end,
};

-- global handle for debugging
pikmintimeGlobal = pikmintime;

hook.Add( "Initialize", "pikmintimeInit", function()

	pikmintime:Initialize();

end );

hook.Add( "PlayerInitialSpawn", "pikmintimeInitialSpawn", function( pl )

	net.Start( "pikmintime_storm" );
		net.WriteBool( pikmintime:GetStorming() );
	net.Send( pl );

	net.Start( "pikmintime_snow" );
		net.WriteBool( pikmintime:GetSnowing() );
	net.Send( pl );

end );

concommand.Add( "pikmintime_dnc_pause", function( pl, cmd, args )

	if ( !IsValid( pl ) or !pl:pikmintimeAdmin() ) then return end

	pikmintime:TogglePause();

	if ( IsValid( pl ) ) then

		pl:PrintMessage( HUD_PRINTCONSOLE, "DNC is " .. (pikmintime.m_Paused and "paused" or "no longer paused") );

	else

		print( "DNC is " .. (pikmintime.m_Paused and "paused" or "no longer paused") );

	end

end );

concommand.Add( "pikmintime_dnc_settime", function( pl, cmd, args )

	if ( !IsValid( pl ) or !pl:pikmintimeAdmin() ) then return end

	pikmintime:SetTime( tonumber( args[1] or "0" ) );

end );

concommand.Add( "pikmintime_dnc_gettime", function( pl, cmd, args )

	local time = pikmintime:GetTime();
	local hours = math.floor( time );
	local minutes = ( time - hours ) * 60;

	if ( IsValid( pl ) ) then

		pl:PrintMessage( HUD_PRINTCONSOLE, string.format( "The current time is %s", string.format( "%02i:%02i", hours, minutes ) ) );

	else

		print( string.format( "The current time is %s", string.format( "%02i:%02i", hours, minutes ) ) );

	end

end );

concommand.Add( "pikmintime_startstorm", function( pl, cmd, args )

	if ( !IsValid( pl ) or !pl:pikmintimeAdmin() ) then return end
	if ( pikmintime:GetStorming() or pikmintime:GetSnowing() ) then return end

	pikmintime:StartStorm();

	pikmintimeMessageAll( Color( 255, 153, 0 ), "[pikmintime] ", Color( 255, 255, 255 ), string.format( "%s has started a storm.", (IsValid( pl ) and pl:Nick() or "Console") ) );

	print( string.format( "%s has started a storm.", (IsValid( pl ) and pl:Nick() or "Console") ) );

end );

concommand.Add( "pikmintime_stopstorm", function( pl, cmd, args )

	if ( !IsValid( pl ) or !pl:pikmintimeAdmin() ) then return end
	if ( !pikmintime:GetStorming() ) then return end

	pikmintime:StopStorm();

	pikmintimeMessageAll( Color( 255, 153, 0 ), "[pikmintime] ", Color( 255, 255, 255 ), string.format( "%s has stopped a storm.", (IsValid( pl ) and pl:Nick() or "Console") ) );

	print( string.format( "%s has stopped a storm.", (IsValid( pl ) and pl:Nick() or "Console") ) );

end );

concommand.Add( "pikmintime_startsnow", function( pl, cmd, args )

	if ( !IsValid( pl ) or !pl:pikmintimeAdmin() ) then return end
	if ( pikmintime:GetStorming() or pikmintime:GetSnowing() ) then return end

	pikmintime:StartSnow();

	pikmintimeMessageAll( Color( 255, 153, 0 ), "[pikmintime] ", Color( 255, 255, 255 ), string.format( "%s has started a snow storm.", (IsValid( pl ) and pl:Nick() or "Console") ) );

	print( string.format( "%s has started a snow storm.", (IsValid( pl ) and pl:Nick() or "Console") ) );

end );

concommand.Add( "pikmintime_stopsnow", function( pl, cmd, args )

	if ( !IsValid( pl ) or !pl:pikmintimeAdmin() ) then return end
	if ( !pikmintime:GetSnowing() ) then return end

	pikmintime:StopSnow();

	pikmintimeMessageAll( Color( 255, 153, 0 ), "[pikmintime] ", Color( 255, 255, 255 ), string.format( "%s has stopped a snow storm.", (IsValid( pl ) and pl:Nick() or "Console") ) );

	print( string.format( "%s has stopped a snow storm.", (IsValid( pl ) and pl:Nick() or "Console") ) );

end );

function pikmintimeMessage( pl, ... )

	net.Start( "pikmintime_message" );
		net.WriteTable( { ... } );
	net.Send( pl );

end

function pikmintimeMessageAll( ... )

	net.Start( "pikmintime_message" );
		net.WriteTable( { ... } );
	net.Broadcast();

end

-- Net
util.AddNetworkString( "pikmintime_settings" );
util.AddNetworkString( "pikmintime_lightmaps" );
util.AddNetworkString( "pikmintime_storm" );
util.AddNetworkString( "pikmintime_snow" );
util.AddNetworkString( "pikmintime_message" );

-- Hacky workaround to make it possible for admins to change server cvars on dedicated servers
net.Receive( "pikmintime_settings", function( len, pl )

	if ( !IsValid( pl ) or !pl:pikmintimeAdmin() ) then return end

	local function safeVal( v )

		-- no lua injection plz
		v = tonumber( v );
		v = tostring( v );
		v = string.Replace( v, ":", "" );
		v = string.Replace( v, ";", "" );
		v = string.Replace( v, "'", "" );
		v = string.Replace( v, '"', "" );
		v = string.Replace( v, '(', "" );
		v = string.Replace( v, ')', "" );

		return v;

	end

	local tbl = net.ReadTable();

	local enabled = safeVal( tbl.enabled );
	local paused = safeVal( tbl.paused );
	local realtime = safeVal( tbl.realtime );
	local dnclength_day = safeVal( tbl.dnclength_day );
	local dnclength_night = safeVal( tbl.dnclength_night );
	local weather = safeVal( tbl.weather );
	local weatherchance = safeVal( tbl.weatherchance );
	local weatherlength = safeVal( tbl.weatherlength );
	local weatherdelay = safeVal( tbl.weatherdelay );
	--local weatherlighting = safeVal( tbl.weatherlighting );
	local snowenabled = safeVal( tbl.snowenabled );

	game.ConsoleCommand( "pikmintime_enabled " .. enabled .. "\n" );
	game.ConsoleCommand( "pikmintime_paused " .. paused .. "\n" );
	game.ConsoleCommand( "pikmintime_realtime " .. realtime .. "\n" );
	game.ConsoleCommand( "pikmintime_dnc_length_day " .. dnclength_day .. "\n" );
	game.ConsoleCommand( "pikmintime_dnc_length_night " .. dnclength_night .. "\n" );
	game.ConsoleCommand( "pikmintime_weather " .. weather .. "\n" );
	game.ConsoleCommand( "pikmintime_weather_chance " .. weatherchance .. "\n" );
	game.ConsoleCommand( "pikmintime_weather_length " .. weatherlength .. "\n" );
	game.ConsoleCommand( "pikmintime_weather_delay " .. weatherdelay .. "\n" );
	--game.ConsoleCommand( "pikmintime_weather_lighting " .. weatherlighting .. "\n" );
	game.ConsoleCommand( "pikmintime_snowenabled " .. snowenabled .. "\n" );

end );

-- For debug assistance
concommand.Add( "pikmintime_info", function( pl, cmd, args )

	local str = string.format(
		""
	);

	if ( IsValid( pl ) ) then

		pl:PrintMessage( HUD_PRINTCONSOLE, str );

	else

		print( str );

	end

end );

concommand.Add( "pikmintime_reset", function( pl, cmd, args )

	if ( IsValid( pl ) and !pl:pikmintimeAdmin() ) then return end

	game.ConsoleCommand( "pikmintime_enabled 1\n" );
	game.ConsoleCommand( "pikmintime_paused 0\n" );
	game.ConsoleCommand( "pikmintime_realtime 0\n" );
	game.ConsoleCommand( "pikmintime_dnc_length_day 3600\n" );
	game.ConsoleCommand( "pikmintime_dnc_length_night 3600\n" );
	game.ConsoleCommand( "pikmintime_weather 0\n" );
	game.ConsoleCommand( "pikmintime_weather_chance 0\n" );
	game.ConsoleCommand( "pikmintime_weather_length 1\n" );
	game.ConsoleCommand( "pikmintime_weather_delay 600\n" );
	game.ConsoleCommand( "pikmintime_weather_lighting 1\n" );
	game.ConsoleCommand( "pikmintime_snowenabled 1\n" );

	if ( IsValid( pl ) ) then

		pl:PrintMessage( HUD_PRINTCONSOLE, "pikmintime server settings reset." );

	else

		print( "pikmintime server settings reset." );

	end

end );

-- adds support for saving and restoring pikmintime values
saverestore.AddSaveHook( "pikmintimeSave", function( save )
	local pikmintimeData = {
		pikmintime_time = pikmintime.m_Time
	}

	saverestore.WriteTable(pikmintimeData, save);

	print("pikmintime save hook called!\n");
end);

saverestore.AddRestoreHook( "pikmintimeRestore", function( save )
	local tbl = saverestore.ReadTable( save );

	if (tbl.pikmintime_time != nil) then
		pikmintime:SetTime(tbl.pikmintime_time);
	end

	print("pikmintime saverestore hook called!\n");
end);
