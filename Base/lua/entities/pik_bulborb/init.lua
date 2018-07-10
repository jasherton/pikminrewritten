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
	self.iseating = false
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
	self.HP = 400
	local phys = self:GetPhysicsObject();
	if (phys:IsValid()) then
		phys:Wake();
		phys:EnableMotion(true);
	end
	self.mdl = ents.Create("pik_enemy_model");
	self.PikMdl = self.mdl
	self.AutomaticFrameAdvance = true
			self.mdl:SetModel("models/jasherton/pikmin2/bulborb/bulborb.mdl");
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
	local ent = ents.Create("pik_bulborb");
	ent:SetPos(SpawnPos);
	ent:Spawn();
	ent:Activate();
	undo.Create("Bulborb");
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
	local eatingthing = self.iseating
	
	if (vel:Length() <= 250) then
	for k,v in pairs(ents.FindByClass("player")) do
	pos = self:GetPos()
	opos = v:GetPos()
	self.target = v
	local dir = (opos - pos);
	local vec = Vector(dir.x, dir.y, 0);
						self.LastHop = (CurTime() + .1);
						local force = 1;
						local zforce = 5;
						local lvl = 1;
		local dist2 = pos:Distance(opos)
		if (dist2 <= 300 and dist2 >= 160 ) then
		self:GetPhysicsObject():ApplyForceCenter(((vec:GetNormal() * (force + (lvl * 1))) + Vector(0, 0, zforce)));
		dir = (dir + Vector(0, 0, 10));
					self:GetPhysicsObject():ApplyForceCenter((dir));
					local dir2 = (opos - pos):Angle();
					model:SetAngles(dir2);
		end
		if (dist2 <= 140) then
		eatingthing = true
		local dir2 = (opos - pos):Angle();
					model:SetAngles(dir2);
	if (eatingthing == true) then
	local eating = model:LookupSequence( "eat" )
	model:ResetSequence( eating )
	model:SetPlaybackRate( 1 )
	self.target:TakeDamage( 0.1, self.target, self )
	end
	eatingthing = false
	timer.Simple( model:SequenceDuration( eating ), function()
	end)
		end
		end
		
		--Pikmin Chasing and Eating
		for k,v in pairs(ents.FindByClass("pikmin")) do
	pos = self:GetPos()
	opos = v:GetPos()
	local dist2 = pos:Distance(opos)
	if (dist2 <= 300) then
	self.target = v
	end
	local dir = (opos - pos);
	local vec = Vector(dir.x, dir.y, 0);
						self.LastHop = (CurTime() + .1);
						local force = 1;
						local zforce = 5;
						local lvl = 1;
		local dist2 = pos:Distance(opos)
		if (dist2 <= 300 and dist2 >= 130 ) then
		dir = (dir + Vector(0, 0, 10));
					self:GetPhysicsObject():ApplyForceCenter((dir));
		local dir2 = (opos - pos):Angle();
					model:SetAngles(dir2);
		self:GetPhysicsObject():ApplyForceCenter(((vec:GetNormal() * (force + (lvl * 1))) + Vector(0, 0, zforce)));
		end
		if (dist2 <= 140) then
		eatingthing = true
		caneatpik = math.random(1, 100)
		if (caneatpik == 5) then
		if (eatingthing == true) then
		local dir2 = (opos - pos):Angle();
					model:SetAngles(dir2);
	local eating = model:LookupSequence( "eat" )
	model:ResetSequence( eating )
	model:SetPlaybackRate( 1 )
	end
		local pos = self:GetPos();
	if (self.target:GetPikType() == "red") then
		self.cr = 255;
		self.cg = 10;
		self.cb = 10;
	elseif (self.target:GetPikType() == "yellow") then
		self.cr = 255;
		self.cg = 255;
		self.cb = 10;
	elseif (self.target:GetPikType() == "blue") then
		self.cr = 10;
		self.cg = 10;
		self.cb = 255;
	elseif (self.target:GetPikType() == "purple") then
		self.cr = 200;
		self.cg = 10;
		self.cb = 200;
	elseif (self.target:GetPikType() == "white") then
		self.cr = 250;
		self.cg = 250;
		self.cb = 250;
	end
				local r = self.cr;
				local g = self.cg;
				local b = self.cb;
				local effectdata = EffectData();
				effectdata:SetOrigin(self.target:GetPos());
				effectdata:SetStart(Vector(r, g, b));
				util.Effect("pikmin_pop", effectdata);
				local effectdata = EffectData();
				effectdata:SetOrigin((self.target:GetPos() + Vector(0, 0, 15)));
				effectdata:SetStart(Vector((r * .5), (g * .5), (b * .5)));
				util.Effect("pikmin_deathsoul", effectdata);
				self.target:EmitSound(Sound("pikmin/death2.mp3"), 100, math.random(95, 110));
				self.target:Remove()
				end
	timer.Simple( model:SequenceDuration( eating ), function()
	eatingthing = false
	end)
		end
		
		end
	if (vel:Length() <= 1 and !eatingthing) then
		local rag = model:LookupSequence( "ragdoll" )
	model:ResetSequence( rag )
	model:SetPlaybackRate( 1 )
	end
	if (vel:Length() >= 1 and !eatingthing) then
		local walking = model:LookupSequence( "walk" )
	model:ResetSequence( walking )
	model:SetPlaybackRate( 0.1 )
	end
	if (eatingthing) then
	--do a thing
	end
self:NextThink( CurTime() )
	return true
end
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
		Rag:ChangeModel("models/jasherton/pikmin2/bulborb/bulborb.mdl")
						local effectdata = EffectData();
				effectdata:SetOrigin((Rag:GetPos() + Vector(0, 0, 70)));
				effectdata:SetStart(Vector(255, 203, 255));
				util.Effect("enemy_death", effectdata);
	end )
--self:BecomeRagdoll( dmginfo )
end
end