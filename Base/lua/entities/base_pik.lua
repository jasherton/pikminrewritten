
AddCSLuaFile()

ENT.Base = "base_entity"
ENT.Type = "piki"

ENT.PrintName		= ""
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""
ENT.RenderGroup		= RENDERGROUP_OPAQUE

-- Defaulting this to OFF. This will automatically save bandwidth
-- on stuff that is already out there, but might break a few things
-- that are out there. I'm choosing to break those things because
-- there are a lot less of them that are actually using the animtime

ENT.AutomaticFrameAdvance = false

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end


function ENT:OnRemove()
end


function ENT:PhysicsCollide( data, physobj )
end


function ENT:PhysicsUpdate( physobj )
end

if ( CLIENT ) then

	function ENT:Draw()

		self:DrawModel()

	end

	function ENT:DrawTranslucent()

		-- This is here just to make it backwards compatible.
		-- You shouldn't really be drawing your model here unless it's translucent

		self:Draw()

	end

end

if ( SERVER ) then

	function ENT:OnTakeDamage( dmginfo )

	--[[
		Msg( tostring(dmginfo) .. "\n" )
		Msg( "Inflictor:\t" .. tostring(dmginfo:GetInflictor()) .. "\n" )
		Msg( "Attacker:\t" .. tostring(dmginfo:GetAttacker()) .. "\n" )
		Msg( "Damage:\t" .. tostring(dmginfo:GetDamage()) .. "\n" )
		Msg( "Base Damage:\t" .. tostring(dmginfo:GetBaseDamage()) .. "\n" )
		Msg( "Force:\t" .. tostring(dmginfo:GetDamageForce()) .. "\n" )
		Msg( "Position:\t" .. tostring(dmginfo:GetDamagePosition()) .. "\n" )
		Msg( "Reported Pos:\t" .. tostring(dmginfo:GetReportedPosition()) .. "\n" )	-- ??
	--]]

	end


	function ENT:Use( activator, caller, type, value )
	end


	function ENT:StartTouch( entity )
	end


	function ENT:EndTouch( entity )
	end


	function ENT:Touch( entity )
	end

	--[[---------------------------------------------------------
	   Name: Simulate
	   Desc: Controls/simulates the physics on the entity.
		Officially the most complicated callback in the whole mod.
		 Returns 3 variables..
		 1. A SIM_ enum
		 2. A vector representing the linear acceleration/force
		 3. A vector represending the angular acceleration/force
		If you're doing nothing you can return SIM_NOTHING
		Note that you need to call ent:StartMotionController to tell the entity
			to start calling this function..
	-----------------------------------------------------------]]
	function ENT:PhysicsSimulate( phys, deltatime )
		return SIM_NOTHING
	end

end


--
-- Name: NEXTBOT:BehaveStart
-- Desc: Called to initialize the behaviour.\n\n You shouldn't override this - it's used to kick off the coroutine that runs the bot's behaviour. \n\nThis is called automatically when the NPC is created, there should be no need to call it manually.
-- Arg1:
-- Ret1:
--
function ENT:BehaveStart()

	self.BehaveThread = coroutine.create( function() self:RunBehaviour() end )

end

--
-- Name: NEXTBOT:BehaveUpdate
-- Desc: Called to update the bot's behaviour
-- Arg1: number|interval|How long since the last update
-- Ret1:
--
function ENT:BehaveUpdate( fInterval )

	if ( !self.BehaveThread ) then return end

	--
	-- Give a silent warning to developers if RunBehaviour has returned
	--
	if ( coroutine.status( self.BehaveThread ) == "dead" ) then

		self.BehaveThread = nil
		Msg( self, " Warning: ENT:RunBehaviour() has finished executing\n" )

		return

	end

	--
	-- Continue RunBehaviour's execution
	--
	local ok, message = coroutine.resume( self.BehaveThread )
	if ( ok == false ) then

		self.BehaveThread = nil
		ErrorNoHalt( self, " Error: ", message, "\n" )

	end

end

function ENT:OnNavAreaChanged( old, new )

	--MsgN( "OnNavAreaChanged", old, new )

end

--
-- Name: NextBot:FindSpots
-- Desc: Returns a table of hiding spots.
-- Arg1: table|specs|This table should contain the search info.\n\n * 'type' - the type (either 'hiding')\n * 'pos' - the position to search.\n * 'radius' - the radius to search.\n * 'stepup' - the highest step to step up.\n * 'stepdown' - the highest we can step down without being hurt.
-- Ret1: table|An unsorted table of tables containing\n * 'vector' - the position of the hiding spot\n * 'distance' - the distance to that position
--
function ENT:FindSpots( tbl )

	local tbl = tbl or {}

	tbl.pos			= tbl.pos			or self:WorldSpaceCenter()
	tbl.radius		= tbl.radius		or 1000
	tbl.stepdown	= tbl.stepdown		or 20
	tbl.stepup		= tbl.stepup		or 20
	tbl.type		= tbl.type			or 'hiding'

	-- Use a path to find the length
	local path = Path( "Follow" )

	-- Find a bunch of areas within this distance
	local areas = navmesh.Find( tbl.pos, tbl.radius, tbl.stepdown, tbl.stepup )

	local found = {}

	-- In each area
	for _, area in pairs( areas ) do

		-- get the spots
		local spots

		if ( tbl.type == 'hiding' ) then spots = area:GetHidingSpots() end

		for k, vec in pairs( spots ) do

			-- Work out the length, and add them to a table
			path:Invalidate()

			path:Compute( self, vec, 1 ) -- TODO: This is bullshit - it's using 'self.pos' not tbl.pos

			table.insert( found, { vector = vec, distance = path:GetLength() } )

		end

	end

	return found

end

--
-- Name: NextBot:FindSpot
-- Desc: Like FindSpots but only returns a vector
-- Arg1: string|type|Either "random", "near", "far"
-- Arg2: table|options|A table containing a bunch of tweakable options. See the function definition for more details
-- Ret1: vector|If it finds a spot it will return a vector. If not it will return nil.
--
function ENT:FindSpot( type, options )

	local spots = self:FindSpots( options )
	if ( !spots || #spots == 0 ) then return end

	if ( type == "near" ) then

		table.SortByMember( spots, "distance", true )
		return spots[1].vector

	end

	if ( type == "far" ) then

		table.SortByMember( spots, "distance", false )
		return spots[1].vector

	end

	-- random
	return spots[ math.random( 1, #spots ) ].vector

end

--
-- Name: NextBot:HandleStuck
-- Desc: Called from Lua when the NPC is stuck. This should only be called from the behaviour coroutine - so if you want to override this function and do something special that yields - then go for it.\n\nYou should always call self.loco:ClearStuck() in this function to reset the stuck status - so it knows it's unstuck.
-- Arg1:
-- Ret1:
--
function ENT:HandleStuck()

	--
	-- Clear the stuck status
	--
	self.loco:ClearStuck()

end

--
-- Name: NextBot:MoveToPos
-- Desc: To be called in the behaviour coroutine only! Will yield until the bot has reached the goal or is stuck
-- Arg1: Vector|pos|The position we want to get to
-- Arg2: table|options|A table containing a bunch of tweakable options. See the function definition for more details
-- Ret1: string|Either "failed", "stuck", "timeout" or "ok" - depending on how the NPC got on
--
function ENT:MoveToPos( pos, options )

	local options = options or {}

	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, pos )

	if ( !path:IsValid() ) then return "failed" end

	while ( path:IsValid() ) do

		path:Update( self )

		-- Draw the path (only visible on listen servers or single player)
		if ( options.draw ) then
			path:Draw()
		end

		-- If we're stuck then call the HandleStuck function and abandon
		if ( self.loco:IsStuck() ) then

			self:HandleStuck()

			return "stuck"

		end

		--
		-- If they set maxage on options then make sure the path is younger than it
		--
		if ( options.maxage ) then
			if ( path:GetAge() > options.maxage ) then return "timeout" end
		end

		--
		-- If they set repath then rebuild the path every x seconds
		--
		if ( options.repath ) then
			if ( path:GetAge() > options.repath ) then path:Compute( self, pos ) end
		end

		coroutine.yield()

	end

	return "ok"

end

--
-- Name: NextBot:PlaySequenceAndWait
-- Desc: To be called in the behaviour coroutine only! Plays an animation sequence and waits for it to end before returning.
-- Arg1: string|name|The sequence name
-- Arg2: number|the speed (default 1)
-- Ret1:
--
function ENT:PlaySequenceAndWait( name, speed )

	local len = self:SetSequence( name )
	speed = speed or 1

	self:ResetSequenceInfo()
	self:SetCycle( 0 )
	self:SetPlaybackRate( speed )

	-- wait for it to finish
	coroutine.wait( len / speed )

end
