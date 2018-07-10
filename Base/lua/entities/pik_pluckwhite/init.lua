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
	self:SetModel("models/pikmin/pikmin_white1.mdl"); -- old model: models/props_junk/PlasticCrate01a.mdl
	--self:PhysicsInit(SOLID_VPHYSICS);
	--self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	--self:SetMaterial("models/shiny");
	local rnd = math.random(0, 2);
	self:SetSkin( rnd )
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	self:SetColor(Color(255, 255, 255, 255))
	self.time = CurTime()
	self.pluckstages = 0
	local phys = self:GetPhysicsObject();
	if (phys:IsValid()) then
		--phys:Wake();
	end
end

function ENT:SpawnFunction(ply, tr)
	if (!tr.Hit) then
		return;
	end
	local SpawnPos = (tr.HitPos + (tr.HitNormal * -33));
	local ent = ents.Create("pik_pluckwhite");
	ent:SetPos(SpawnPos);
	ent:Spawn();
	ent:Activate();
	--[[rag = ents.Create("prop_ragdoll");
	local SpawnPos2 = (tr.HitPos + (tr.HitNormal * -24));
	rag:SetModel("models/pikmin/pikmin_red1.mdl");
	rag:SetPos(SpawnPos2);
	rag:Spawn();
	rag:Activate();--]]
	undo.Create("White Pikmin");
		undo.AddEntity(ent);
		--undo.AddEntity(rag);
		undo.SetPlayer(ply);
	undo.Finish();
end

function ENT:Think()
	local ent1 = self
	if (self.pluckstages == 0) then
	if (CurTime() - self.time >= 1) then
	self:SetPos(Vector(self:GetPos().x, self:GetPos().y, self:GetPos().z+12))
	self:EmitSound("pikmin/pikpluckstage.mp3", 100, math.random(98, 105));
	if (CurTime() - self.time >= 1) then
	self.pluckstages = 1
	end
	end
		else
	--no please.
	end
	
	if (self.pluckstages == 1) then
	if (CurTime() - self.time >= 3) then
	self:SetModel("models/pikmin/pikmin_white2.mdl")
	local effectdata = EffectData();
			local pos, ang;
				pos, ang = self:GetBonePosition(self:LookupBone("piki_bud"));
			effectdata:SetOrigin(pos);
				local r = 220;
				local g = 100;
				local b = 150;
				--r = 220;
				--g = 100;
				--b = 150;
			effectdata:SetStart(Vector(r, g, b));
			util.Effect("pikmin_leveldown", effectdata);
	self:EmitSound("pikmin/pikpluckstage.mp3", 100, math.random(98, 105));
	if (CurTime() - self.time >= 1) then
	self.pluckstages = 2
	end
	end
		else
	--no please.
	end
	
	if (self.pluckstages == 2) then
	if (CurTime() - self.time >= 7) then
	self:SetModel("models/pikmin/pikmin_white3.mdl")
	local effectdata = EffectData();
			local pos, ang;
				pos, ang = self:GetBonePosition(self:LookupBone("piki_flower"));
			effectdata:SetOrigin(pos);
			local r = 0;
			local g = 127;
			local b = 31;
			effectdata:SetStart(Vector(r, g, b));
			util.Effect("pikmin_leveldown", effectdata);
			self:EmitSound("pikmin/pikpluckstage.mp3", 100, math.random(98, 105));
			if (CurTime() - self.time >= 1) then
	self.pluckstages = 3
	end
			end
		else
	--no please.
	end
	
	for k, v in pairs( ents.GetAll() ) do
if (v:IsPlayer()) then
if (self.pluckstages == 1) then
	if(ent1:GetPos():Distance(v:GetPos()) < 50) then
	self:EmitSound("pikmin/burrowpull.wav", 100, math.random(98, 105));
	self:Remove();
	v:ConCommand( "pikmin_create white" );
else
--no please
end
else
--do nothing
	end
if (self.pluckstages == 2) then
	if(ent1:GetPos():Distance(v:GetPos()) < 50) then
	self:EmitSound("pikmin/burrowpull.wav", 100, math.random(98, 105));
	self:Remove();
	v:ConCommand( "pikmin_create_bud white" );
else
--no please
end
else
--do nothing
	end
if (self.pluckstages == 3) then
	if(ent1:GetPos():Distance(v:GetPos()) < 50) then
	self:EmitSound("pikmin/burrowpull.wav", 100, math.random(98, 105));
	self:Remove();
	v:ConCommand( "pikmin_create_flower white" );
else
--no please
end
else
--do nothing
	end
end
end

	self:NextThink( CurTime() + 0.3 )
	return true
end