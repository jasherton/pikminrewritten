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
	self:SetModel("models/brewstersmodels/pikmin2/bombrockp2.mdl");
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	--self:SetMaterial("models/shiny");
	--local rnd = math.random(0, 2);
	--self:SetSkin( rnd )
	self:SetColor(Color(255, 255, 255, 255))
	local phys = self:GetPhysicsObject();
	if (phys:IsValid()) then
		phys:Wake();
	self:GetPhysicsObject():SetMass(1)
	end
end

function ENT:SpawnFunction(ply, tr)
	if (!tr.Hit) then
		return;
	end
	local SpawnPos = (tr.HitPos + (tr.HitNormal * 16));
	local ent = ents.Create("pik_bomb");
	ent:SetPos(SpawnPos);
	ent:Spawn();
	ent:Activate();
	undo.Create("Bomb Rock");
		undo.AddEntity(ent);
		undo.SetPlayer(ply);
	undo.Finish();
end