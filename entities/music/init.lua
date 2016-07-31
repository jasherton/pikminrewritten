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
		local yellow1 = ents.Create( "pik_pluckyellow" )
local yellow2 = ents.Create( "pik_pluckyellow" );
local yellow3 = ents.Create( "pik_pluckyellow" );
local yellow4 = ents.Create( "pik_pluckyellow" );
local yellow5 = ents.Create( "pik_pluckyellow" );
local yellow6 = ents.Create( "pik_pluckyellow" );
yellow1:SetPos( Vector ( -193.822983, 106.492928, -83.984100 ));
yellow2:SetPos( Vector ( -223.170593, -6.530893, -83.984100 ));
yellow3:SetPos( Vector ( -421.852539, 70.582542, -84.075790 ));
yellow4:SetPos( Vector ( -250.700226, 162.797501, -83.976791 ));
yellow5:SetPos( Vector ( -326.688293, -72.896790, -83.976791 ));
yellow6:SetPos( Vector ( -203.628677, -201.104172, -83.976791 ));
yellow1:Spawn();
yellow2:Spawn();
yellow3:Spawn();
yellow4:Spawn();
yellow5:Spawn();
yellow6:Spawn();
	undo.Create("DropOff");
		undo.AddEntity(ent);
		undo.SetPlayer(ply);
	undo.Finish();
end