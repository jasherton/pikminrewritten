ENT.Type 			= "anim";
ENT.Base 			= "base_anim";
ENT.PrintName		= "1 Pellet";
ENT.Author			= "jasherton";
ENT.Purpose			= "MORE PIKMIN!!!";
ENT.Category		= "Pikmin";

ENT.Spawnable			= true;
ENT.AdminSpawnable		= true;

function ENT:Initialize()
	ENT:SetModel("models/pikmin/pellet_1.mdl");
	ENT:PhysicsInit(SOLID_VPHYSICS);
	ENT:SetMoveType(MOVETYPE_VPHYSICS);
	ENT:SetSolid(SOLID_VPHYSICS);
	--ENT:SetMaterial("models/shiny");
	local rnd = math.random(0, 2);
	ENT:SetSkin( rnd )
	ENT:SetColor(Color(255, 255, 255, 255))
	local phys = ENT:GetPhysicsObject();
	if (phys:IsValid()) then
		phys:Wake();
	ENT:GetPhysicsObject():SetMass(5)
	end
	end

if (SERVER) then
function ENT:Initialize()
	self:SetModel("models/pikmin/pellet_1.mdl");
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	--self:SetMaterial("models/shiny");
	local rnd = math.random(0, 2);
	self:SetSkin( rnd )
	self:SetColor(Color(255, 255, 255, 255))
	local phys = self:GetPhysicsObject();
	if (phys:IsValid()) then
		phys:Wake();
	self:GetPhysicsObject():SetMass(5)
	end
end
end