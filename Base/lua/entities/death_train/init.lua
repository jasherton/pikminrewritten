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
	self:SetModel("models/quarterlife/fsd-overrun-toy.mdl");
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	--self:SetMaterial("models/shiny");
	self:SetColor(Color(255, 255, 255, 255))
	local phys = self:GetPhysicsObject();
	if (phys:IsValid()) then
		phys:Wake();
	end
end

function ENT:SpawnFunction(ply, tr)
	if (!tr.Hit) then
		return;
	end
	local SpawnPos = (tr.HitPos + (tr.HitNormal * 16));
	local ent = ents.Create("death_train");
	ent:SetPos(SpawnPos);
	ent:Spawn();
	ent:Activate();
	undo.Create("TRAIN OF DEATH");
		undo.AddEntity(ent);
		undo.SetPlayer(ply);
	undo.Finish();
end

function ENT:StartTouch(thing)
if (thing:IsPlayer()) then
ply = thing
plyname = ply:GetName()
ply:ConCommand( "say I am " .. plyname .. " and I am FLYING AWAY!!!" )
--ply:ConCommand( "setpos -2799.644043 -1506.435303 -356.768738;setang 0.903252 -3.179942 0.000000" )
timer.Simple( 0.6, function() ply:SetVelocity( Vector( 100, 150, 1000 ) ) end )
else
constraint.RemoveConstraints( thing, "Weld" );
constraint.RemoveConstraints( thing, "Axis" );
end
end