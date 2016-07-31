AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include('shared.lua');

function ENT:Initialize()
	self:SetModel("models/pikmin/pikmin_collision.mdl")
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	self:SetMoveCollide(MOVETYPE_VPHYSICS);
	self:StartMotionController();
	--self:SetMaterial("models/shiny");
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	self:SetColor(Color(255, 255, 255, 255))
	local phys = self:GetPhysicsObject();
	if (phys:IsValid()) then
		phys:Wake();
		self:StartMotionController();
		phys:EnableMotion(true);
		self:GetPhysicsObject():ApplyForceCenter(Vector(0, 0, 10));
	end
	self.AutomaticFrameAdvance = true
	self.Rag = ents.Create( 'pik_enemy_model' )
	self.Rag:SetCollisionGroup( 10 )
	self.Rag:SetParent(self)
		self.Rag:Spawn()
end

function ENT:ChangeModel(name)
self.corpsemodel = name
end

function ENT:GetRagModel()
return self.Rag;
end

function ENT:OnRemove()
self.Rag:Remove()
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
	local ent = ents.Create("pik_corpse");
	ent:SetPos(SpawnPos);
	ent:Spawn();
	ent:Activate();
	undo.Create("Corpse");
		undo.AddEntity(ent);
		undo.SetPlayer(ply);
	undo.Finish();
end

function ENT:Think()
if (self.corpsemodel == nil) then
self.Rag:Remove()
self:Remove()
else
self.Rag:SetModel( self.corpsemodel )
self:SetModel("models/pikmin/pikmin_collision.mdl")
		self.Rag:SetPos( self:GetPos() )
		self.Rag:SetAngles( self:GetAngles() )
		self.Rag:SetBodygroup( 1, 1 )
	local anim = "carry";
	self.Rag:ResetSequence(self.Rag:LookupSequence(anim));
	end
	self:NextThink(CurTime());
	return true;
end
