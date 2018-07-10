//Template for code block comments
//Template for code block comments
/*****************************************

******************************************/


AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
AddCSLuaFile()
include('shared.lua');


/*****************************************
Initialize and spawn functions
Gotta have these, or we have no SEnt!
******************************************/

function ENT:Initialize()
	self:SetModel( "models/pikmin/pikmin_collision.mdl" )
	--self:PhysicsInit(SOLID_VPHYSICS);
	--self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	self:SetMoveCollide(MOVECOLLIDE_FLY_SLIDE);
	self:StartMotionController();
	--self:SetMaterial("models/shiny");
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	self:SetColor(Color(255, 255, 255, 255))
	self.carrying = false
	for k, v in pairs(ents.FindByClass("pik_bulborb")) do
		if (IsValid(v) && v != self) then
			constraint.NoCollide(self, v, 0, 0); 
		end
	end
	for k, v in pairs(ents.FindByClass("pik_gbreadbug")) do
		if (IsValid(v) && v != self) then
			constraint.NoCollide(self, v, 0, 0); 
		end
	end
	for k, v in pairs(ents.FindByClass("pik_enemy_model")) do
		if (IsValid(v) && v != self) then
			constraint.NoCollide(self, v, 0, 0); 
		end
	end
	self.target = nil
	self.grabbedobject = nil
	self.HP = 700
	local phys = self:GetPhysicsObject();
	if (phys:IsValid()) then
		phys:Wake();
		phys:EnableMotion(true);
	end
	self.mdl = ents.Create("pik_enemy_model");
	self.PikMdl = self.mdl
	self.AutomaticFrameAdvance = true
			self.mdl:SetModel("models/jasherton/pikmin2/giant_breadbug.mdl");
		self.mdl:SetPos(self:GetPos());
		self.mdl:SetParent(self)
		self.mdl:SetAngles(self:GetAngles());
		self.mdl:SetCollisionGroup( 10 )
		self.mdl:Spawn();
		self.mdl:Activate();
end

function ENT:OnRemove()
self.mdl:Remove()
end

function ENT:GetObj()
return self.grabbedobject
end

function ENT:PhysicsSimulate(phys, delta)
	local pos = self:GetPos();
	phys:Wake();
	self.ShadowParams={};
	self.ShadowParams.secondstoarrive = .2;
	self.ShadowParams.pos = Vector(0, 0, 0);
	self.ShadowParams.angle = (pos - self:GetPos()):Angle();
	self.ShadowParams.angle.p = 0; //Don't be turning your whole body up and down...
	self.ShadowParams.maxangular = 5000;
	self.ShadowParams.maxangulardamp = 10000;
	self.ShadowParams.maxspeed = 0;
	self.ShadowParams.maxspeeddamp = 0;
	self.ShadowParams.dampfactor = 0.8;
	self.ShadowParams.teleportdistance = 0;
	self.ShadowParams.deltatime = delta;
	phys:ComputeShadowControl(self.ShadowParams);
end

function ENT:SpawnFunction(ply, tr)
	if (!tr.Hit) then
		return;
	end
	local SpawnPos = (tr.HitPos + (tr.HitNormal * 1));
	local ent = ents.Create("pik_gbreadbug");
	ent:SetPos(SpawnPos);
	ent:Spawn();
	ent:Activate();
	undo.Create("Giant Breadbug");
		undo.AddEntity(ent);
		undo.SetPlayer(ply);
	undo.Finish();
end

function ENT:Think()
		local pos = self:GetPos();
	local vel = self:GetVelocity();
	local model = self.mdl
	local opos = nil
	local pos = nil
	
	if (vel:Length() <= 250) then
	if (!self.carrying) then
	for k,v in pairs(ents.FindByClass("pik_pellet")) do
	pos = self:GetPos()
	opos = v:GetPos()
	local dist = pos:Distance(opos)
	if (dist <= 6000) then 
	self.target = v
	if (self.target:IsValid()) then
	for k, v in pairs(ents.FindByClass("pik_gbreadbug")) do
		if (IsValid(v) && v != self) then		
		if (v.grabbedobject == self.target) then
		self.target = nil
		end
		end 
		end
	local dir = (opos - pos);
	local vec = Vector(dir.x, dir.y, 0);
						self.LastHop = (CurTime() + .1);
						local force = 1;
						local zforce = 5;
						local lvl = 1;
		local dist2 = pos:Distance(opos)
		if (dist2 <= 6000 and dist2 >= 80 ) then
		self:GetPhysicsObject():ApplyForceCenter(((vec:GetNormal() * (force + (lvl * 1))) + Vector(0, 0, zforce)));
		dir = (dir + Vector(0, 0, 10));
					self:GetPhysicsObject():ApplyForceCenter((dir));
					local dir2 = (opos - pos):Angle();
					model:SetAngles(dir2);
		end
		if (dist2 <= 70) then
		self.grabbedobject = v
		self.carrying = true
		end
	end
	end
		end
		else
		local dir = (self:GetPos() - self:GetPos())
		dir = (dir + Vector(math.random(100, 200), math.random(100, 200), 10));
					self:GetPhysicsObject():ApplyForceCenter((dir));
					model:SetAngles(dir:GetNormalized():Angle())
		end
		end
	if (vel:Length() <= 1 and !self.carrying) then
		local rag = model:LookupSequence( "ragdoll" )
	model:SetSequence( rag )
	self:GetPhysicsObject():SetMass(8)
	model:SetPlaybackRate( 1 )
	end
	if (vel:Length() >= 1 and !self.carrying) then
		local walking = model:LookupSequence( "walk" )
	model:SetSequence( walking )
	self:GetPhysicsObject():SetMass(8)
	model:SetPlaybackRate( 1 )
	end
	if (vel:Length() >= 1 and self.carrying) then
		local walking = model:LookupSequence( "grabwalk" )
	model:SetSequence( walking )
	self:GetPhysicsObject():SetMass(50)
	model:SetPlaybackRate( 1 )
	end
	if (vel:Length() <= 1 and self.carrying) then
		local walking = model:LookupSequence( "grab" )
	model:SetSequence( walking )
	self:GetPhysicsObject():SetMass(50)
	model:SetPlaybackRate( 1 )
	end
	if (self.carrying) then
	if (!self.grabbedobject:IsValid()) then
	self.carrying = false
	self.grabbedobject = nil
	else
	constraint.Weld( self.grabbedobject, self, 0, 0, self.PhysicsBone, false, false );
		local dir2 = (self.grabbedobject:GetPos() - self:GetPos()):Angle();
					model:SetAngles(dir2);
					end
					end
self:NextThink( CurTime() )
	return true
end

function ENT:OnTakeDamage(dmg)
	dmg:SetDamageForce((dmg:GetDamageForce() * .25));
	self:TakePhysicsDamage(dmg);
	self.HP = (self.HP - dmg:GetDamage());
	if (self.HP <= 0) then

	local FakePly = ents.Create( 'base_gmodentity' )

	FakePly:SetModel( self.mdl:GetModel() )
	FakePly:SetPos( self.mdl:GetPos() )
	FakePly:SetAngles( self.mdl:GetAngles() )
	FakePly:SetBodygroup( 1, 1 )
	FakePly:Spawn()
	self:Remove()
	self.mdl:Remove()

	local sequence = self.mdl:LookupSequence( "die" )
	
	FakePly:SetSequence( sequence ) --Set a random death animation
	FakePly:SetPlaybackRate( 1 )
	FakePly.AutomaticFrameAdvance = true --Auto advance the animation
	function FakePly:Think() --This makes it actually play

		self:NextThink( CurTime() )
		return true

	end
	
	timer.Simple( FakePly:SequenceDuration( sequence ), function() --Or however long the sequence goes for before a ragdoll is spawned in place

		local Rag = ents.Create( 'pik_corpse' )
		Rag:SetPos( FakePly:GetPos() )
		Rag:SetAngles( FakePly:GetAngles() )
		Rag:SetBodygroup( 1, 1 )

		FakePly:Remove()

		--for i = 0, Rag:GetBoneCount() - 1 do -- Doesn't work since SetBonePosition is clientside (THIS NEEDS FIXING)
		--	local vec, ang = victim:GetBonePosition( i )
		--	Rag:SetBonePosition( i, vec, ang )
		--end
		Rag:Spawn()
		Rag:ChangeModel("models/jasherton/pikmin2/giant_breadbug.mdl")
	end )
--self:BecomeRagdoll( dmginfo )
end
end