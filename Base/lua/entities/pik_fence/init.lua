//Template for code block comments
//Template for code block comments
/*****************************************

******************************************/


AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include('shared.lua');


/*****************************************
Initialize and spawn functions
Gotta have these, or we have no SEnt!
******************************************/

function ENT:Initialize()
	self:SetModel("models/gates/bramblewalls.mdl");
	self:SetMaterial("models/gates/bramble");
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	self:SetColor(Color(255,255,255,255))
	self.stage = 0
	self.damage = 0
	self.fencepart = ents.Create("prop_physics");
	local fence = self.fencepart
	local phys = self:GetPhysicsObject();
	if (phys:IsValid()) then
		phys:Wake();
	end
end

function ENT:SpawnFunction(ply, tr)
	if (!tr.Hit) then
		return;
	end
	local SpawnPos = (tr.HitPos + (tr.HitNormal * 1));
	local ent = ents.Create("pik_fence");
	ent:SetPos(SpawnPos);
	ent:Spawn();
	ent:Activate();
	undo.Create("Bramble Fence");
		undo.AddEntity(ent);
		undo.SetPlayer(ply);
	undo.Finish();
end

function ENT:OnRemove()
self.fencepart:Remove()
end

function ENT:Think()
print(self.damage)
print(self.stage)
if (!self.fencepart:IsValid()) then
self:Remove()
end
if (self.fencepart:IsValid()) then
for k,v in pairs(ents.FindByClass("pikmin")) do
local mypos = self:GetPos()
local thepos = v:GetPos()
local dist = mypos:Distance(thepos)
if (dist <= 100 and !v:IsOnFire() and v.AtkTarget == self.fencepart and self.stage != 5) then
v.AtkTarget = self.fencepart
v:SetAnim("attack")
self.damage = self.damage+0.1
end
if (dist <= 100 and v.AtkTarget == self.fencepart and self.stage == 5 or dist <= 100 and v.AtkTarget == self and self.stage == 5) then
v.AtkTarget = nil
end
end
end
self.fencepart:SetModel("models/gates/bramble.mdl");
self.fencepart:SetAngles(self:GetAngles())
	self.fencepart:SetMaterial("models/gates/bramble");
	self.fencepart:PhysicsInit(SOLID_VPHYSICS);
	self.fencepart:SetMoveType(MOVETYPE_VPHYSICS);
	self.fencepart:SetSolid(SOLID_VPHYSICS);
	self.fencepart:Spawn()
	self.fencepart:Activate()
	self.fencepart:SetNWBool( "fencebreak", true )
	constraint.NoCollide(self, self.fencepart, 0, 0); 
	self.fencepart:GetPhysicsObject():EnableMotion(false)
	if (self.stage == 0) then
	self.fencepart:SetPos(Vector(self:GetPos().x, self:GetPos().y, self:GetPos().z))
	end
	if (self.damage >= 90 and self.damage < 100 ) then
	self.fencepart:SetPos(Vector(self:GetPos().x, self:GetPos().y, self.fencepart:GetPos().z+math.random(-5, 5)))
	end
	if (self.damage >= 100 and self.stage < 5) then
	self.stage = self.stage+1
	self.damage = 0
	end
	if (self.stage == 1) then
	self.fencepart:SetPos(Vector(self:GetPos().x, self:GetPos().y, self:GetPos().z-30))
	end
	if (self.stage == 2) then
	self.fencepart:SetPos(Vector(self:GetPos().x, self:GetPos().y, self:GetPos().z-60))
	end
	if (self.stage == 3) then
	self.fencepart:SetPos(Vector(self:GetPos().x, self:GetPos().y, self:GetPos().z-90))
	end
	if (self.stage == 4) then
	self.fencepart:SetPos(Vector(self:GetPos().x, self:GetPos().y, self:GetPos().z-120))
	end
	if (self.stage == 5) then
	self.fencepart:SetCollisionGroup(10)
	self.fencepart:SetRenderMode( RENDERMODE_TRANSALPHA )
	self.fencepart:SetColor(Color(255,255,255,0))
	end
	self:NextThink(CurTime());
	return true;
	end