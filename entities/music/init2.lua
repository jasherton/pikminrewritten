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
	self:SetModel("models/props_vehicles/carparts_tire01a.mdl");
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	--self:SetMaterial("models/shiny");
	--local rnd = math.random(1, 4);
	--self:SetSkin( rnd )
	self:SetColor(Color(255, 255, 255, 255))
	local phys = self:GetPhysicsObject();
	if (phys:IsValid()) then
		phys:Wake();
	self:EmitSound("pikmin/spring.mp3", 100, 100, 1, CHAN_AUTO );
	--self:GetPhysicsObject():SetMass(5)
	end
end

function ENT:SpawnFunction(ply, tr)
	if (!tr.Hit) then
		return;
	end
	local SpawnPos = (tr.HitPos + (tr.HitNormal * 55));
	local ent = ents.Create("music");
	ent:SetPos(SpawnPos);
	ent:Spawn();
	ent:Activate();
	undo.Create("DropOff");
		undo.AddEntity(ent);
		undo.SetPlayer(ply);
	undo.Finish();
end