AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
AddCSLuaFile()
include('shared.lua');


/*****************************************
Initialize and spawn functions
Gotta have these, or we have no SEnt!
******************************************/

function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	self:SetCollisionGroup( COLLISION_GROUP_PLAYER )
	self:AddFlags(FL_CLIENT)
	self:DrawShadow(false);
	self:SetColor(Color(255, 255, 255, 255));
	self:StartMotionController();
	--self:CreateNextbot()
	self.IsCarrying = false
	self.MasterExists = false
	self.DrownSound = CreateSound(self, "pikmin/drowning.wav");
	for k, v in pairs(ents.FindByClass("pikmin")) do
		if (IsValid(v) && v != self) then
			constraint.NoCollide(self, v, 0, 0); 
		end
	end
	for k, v in pairs(ents.FindByClass("pikmin_model")) do
		if (IsValid(v) && v != self) then
			constraint.NoCollide(self, v, 0, 0); 
		end
	end
	for k, v in pairs(ents.FindByClass("npc_bullseye")) do
		if (IsValid(v) && v != self) then
			constraint.NoCollide(self, v, 0, 0); 
		end
	end
	for k, v in pairs(ents.FindByClass("pik_carrybot")) do
		if (IsValid(v) && v != self) then
			constraint.NoCollide(self, v, 0, 0); 
		end
	end
	local phys = self:GetPhysicsObject();
	if (phys:IsValid()) then
		phys:SetBuoyancyRatio(.375);
		phys:Wake();
	end
	self.Nextbot = ents.Create("pik_carrybot")
end

function ENT:CreateNextbot( height )
	self.nextbot = ents.Create("pik_carrybot")
	self.nextbot:SetSolid( SOLID_NONE )
	self.nextbot:SetCollisionGroup( COLLISION_GROUP_NONE )
	self.nextbot:SetOwner( self )
	self.Nextbot = self.nextbot
end

function ENT:GetNextBot()
if (self.Nextbot:IsValid()) then
return self.Nextbot
end
end

function ENT:SpawnFunction(ply, tr)
	ply:ConCommand("pikmin_menu");
end

/*****************************************
Easy access functions
Things like returning variables or setting them
******************************************/

function ENT:Mdl()
	if (IsValid(self.PikMdl)) then
		return self.PikMdl;
	end
	return nil;
end

function ENT:SetAnim(anim)
	local mdl = self:Mdl();
	mdl.Anim = anim;
end

function ENT:GetAnim()
	local mdl = self:Mdl();
	if (mdl.Anim) then
		return tostring(mdl.Anim);
	end
	return nil;
end

function ENT:SetPikLevel(lvl)
	self.PikLevel = tonumber(lvl);
	self:Mdl():SetModel("models/pikmin/pikmin_" .. self:GetPikType() .. self:GetPikLevel() .. ".mdl");
	self:Mdl():SetNetworkedInt("Level", lvl);
end

function ENT:GetPikLevel()
	if (self.PikLevel) then
		return tonumber(self.PikLevel);
	end
	return nil;
end

function ENT:GetPikType()
	if (self.PikClr) then
		return tostring(self.PikClr);
	end
	return nil;
end

/*****************************************
Juicy, meaty, core code
Here is where the Pikmin come alive!
******************************************/

function ENT:CreatePikRagdoll(dis)
	local mdl = self:Mdl();
	//w00t at TetaBonita for the ragdoll code!
	local rag = ents.Create("prop_ragdoll");
	rag:SetModel(mdl:GetModel());
	rag:SetPos(mdl:GetPos());
	rag:SetAngles(mdl:GetAngles());
	rag:Spawn();
	if (!rag:IsValid()) then
		return
	end
	rag:SetCollisionGroup(COLLISION_GROUP_DEBRIS);
	local entvel;
	local entphys = self:GetPhysicsObject();
	if (entphys:IsValid()) then
		entvel = entphys:GetVelocity();
	else
		entvel = self:GetVelocity();
	end
	for i = 1, rag:GetPhysicsObjectCount() do
		local bone = rag:GetPhysicsObjectNum(i);
		if (IsValid(bone)) then
			local bonepos, boneang = mdl:GetBonePosition(rag:TranslatePhysBoneToBone(i));
			bone:SetPos(bonepos);
			bone:SetAngles(boneang);
			if (dis) then //is this for the dissolve effect?
				bone:ApplyForceOffset((self:GetVelocity() * .04), self:GetPos());
				bone:AddVelocity((entvel * .05));
				bone:AddVelocity(Vector(0, 0, 10));
				bone:EnableGravity(false);
			else
				bone:ApplyForceOffset(self:GetVelocity(), self:GetPos());
				bone:AddVelocity(entvel);
			end
		end
	end
	rag:SetSkin(mdl:GetSkin());
	rag:SetColor(mdl:GetColor());
	rag:SetMaterial(mdl:GetMaterial());
	local phys = rag:GetPhysicsObject();
	if (phys:IsValid()) then
		phys:EnableGravity(false);
		phys:ApplyForceCenter(Vector(0, 0, 5));
	end
	self:Remove();
	return rag;
end

local function PikminCreate(ply, cmd, args)
	if (!args[1]) then
		return;
	end
	if (args[1] == "red" || args[1] == "yellow" || args[1] == "blue" || args[1] == "purple" || args[1] == "white" || args[1] == "random") then
		local mdlstr = "models/pikmin/pikmin_red1.mdl";
		local pikhp = 24;
		local pikdmg = 3;
		local clr = string.lower(args[1]);
		if (clr == "yellow") then
			mdlstr = "models/pikmin/pikmin_yellow1.mdl";
		elseif (clr == "blue") then
			mdlstr = "models/pikmin/pikmin_blue1.mdl";
		elseif (clr == "purple") then
			mdlstr = "models/pikmin/pikmin_purple1.mdl";
		elseif (clr == "white") then
			mdlstr = "models/pikmin/pikmin_white1.mdl";
		elseif (clr == "random") then
			local rnd = math.random(1, 5);
			if (rnd == 1) then
				clr = "red";
			elseif (rnd == 2) then
				clr = "yellow";
			elseif (rnd == 3) then
				clr = "blue";
			elseif (rnd == 4) then
				clr = "purple";
			elseif (rnd == 5) then
				clr = "white";
			end
			mdlstr = "models/pikmin/pikmin_" .. clr .. "1.mdl";
		end
		if (clr == "red") then
			pikhp = 24;
			pikdmg = 8;
		elseif (clr == "yellow") then
			pikhp = 18;
			pikdmg = 2;
		elseif (clr == "blue") then
			pikhp = 28;
			pikdmg = 2;
		elseif (clr == "purple") then
			pikhp = 40;
			pikdmg = 6;
		elseif (clr == "white") then
			pikhp = 12.5;
			pikdmg = 1;
		end
		local pos = ply:GetShootPos();
		pos = (pos + ((ply:GetForward() * -1) * 32));
		pos = (pos + (ply:GetRight() * math.Rand(-50, 50)));
		local ent = ents.Create("pikmin");
		ent.Olimar = ply;
		ent.PikClr = clr;
		ent.PikHP = pikhp;
		ent.PikDmg = pikdmg;
		if (clr != "purple" && clr != "white") then
			ent:SetModel("models/pikmin/pikmin_collision.mdl");
		else
			local str = string.Left(clr, 1);
			ent:SetModel("models/pikmin/pikmin_collision" .. str .. ".mdl");
		end
		ent:SetPos(pos);
		ent:SetMoveCollide(MOVECOLLIDE_FLY_SLIDE);
		ent:EmitSound(Sound("pikmin/pikmin_pluck.wav"));
		ent:Spawn();
		ent:Activate();
		mdl = ents.Create("pikmin_model");
		mdl:SetModel(mdlstr);
		mdl:SetPos(ent:GetPos());
		mdl:SetParent(ent);
		mdl:Spawn();
		mdl:Activate();
		ent.PikMdl = mdl;
		ent.PikMdl:SetNetworkedString("Color", clr);
		ent:SetPikLevel(1);
		undo.Create(clr .. " Pikmin");
			undo.AddEntity(ent);
			undo.SetPlayer(ply);
		undo.Finish();
	else
		ply:ChatPrint("Not a valid color: red, yellow, blue, purple, white");
end
end

local function PikminCreateBud(ply, cmd, args)
	if (!args[1]) then
		return;
	end
	if (args[1] == "red" || args[1] == "yellow" || args[1] == "blue" || args[1] == "purple" || args[1] == "white" || args[1] == "random") then
		local mdlstr = "models/pikmin/pikmin_red2.mdl";
		local pikhp = 24;
		local pikdmg = 3;
		local clr = string.lower(args[1]);
		if (clr == "yellow") then
			mdlstr = "models/pikmin/pikmin_yellow2.mdl";
		elseif (clr == "blue") then
			mdlstr = "models/pikmin/pikmin_blue2.mdl";
		elseif (clr == "purple") then
			mdlstr = "models/pikmin/pikmin_purple2.mdl";
		elseif (clr == "white") then
			mdlstr = "models/pikmin/pikmin_white2.mdl";
		elseif (clr == "random") then
			local rnd = math.random(1, 5);
			if (rnd == 1) then
				clr = "red";
			elseif (rnd == 2) then
				clr = "yellow";
			elseif (rnd == 3) then
				clr = "blue";
			elseif (rnd == 4) then
				clr = "purple";
			elseif (rnd == 5) then
				clr = "white";
			end
			mdlstr = "models/pikmin/pikmin_" .. clr .. "2.mdl";
		end
		if (clr == "yellow") then
			pikhp = 18;
			pikdmg = 2;
		elseif (clr == "blue") then
			pikhp = 28;
			pikdmg = 2;
		elseif (clr == "purple") then
			pikhp = 40;
			pikdmg = 6;
		elseif (clr == "white") then
			pikhp = 12.5;
			pikdmg = 1;
		end
		local pos = ply:GetShootPos();
		pos = (pos + ((ply:GetForward() * -1) * 32));
		pos = (pos + (ply:GetRight() * math.Rand(-50, 50)));
		local ent = ents.Create("pikmin");
		ent.Olimar = ply;
		ent.PikClr = clr;
		ent.PikHP = pikhp;
		ent.PikDmg = pikdmg;
		if (clr != "purple" && clr != "white") then
			ent:SetModel("models/pikmin/pikmin_collision.mdl");
		else
			local str = string.Left(clr, 1);
			ent:SetModel("models/pikmin/pikmin_collision" .. str .. ".mdl");
		end
		ent:SetPos(pos);
		ent:SetMoveCollide(MOVECOLLIDE_FLY_SLIDE);
		ent:EmitSound(Sound("pikmin/pikmin_pluck.wav"));
		ent:Spawn();
		ent:Activate();
		mdl = ents.Create("pikmin_model");
		mdl:SetModel(mdlstr);
		mdl:SetPos(ent:GetPos());
		mdl:SetParent(ent);
		mdl:Spawn();
		mdl:Activate();
		ent.PikMdl = mdl;
		ent.PikMdl:SetNetworkedString("Color", clr);
		ent:SetPikLevel(2);
		undo.Create(clr .. " Pikmin");
			undo.AddEntity(ent);
			undo.SetPlayer(ply);
		undo.Finish();
	else
		ply:ChatPrint("Not a valid color: red, yellow, blue, purple, white");
end
end

local function PikminCreateFlw(ply, cmd, args)
	if (!args[1]) then
		return;
	end
	if (args[1] == "red" || args[1] == "yellow" || args[1] == "blue" || args[1] == "purple" || args[1] == "white" || args[1] == "random") then
		local mdlstr = "models/pikmin/pikmin_red3.mdl";
		local pikhp = 24;
		local pikdmg = 3;
		local clr = string.lower(args[1]);
		if (clr == "yellow") then
			mdlstr = "models/pikmin/pikmin_yellow3.mdl";
		elseif (clr == "blue") then
			mdlstr = "models/pikmin/pikmin_blue3.mdl";
		elseif (clr == "purple") then
			mdlstr = "models/pikmin/pikmin_purple3.mdl";
		elseif (clr == "white") then
			mdlstr = "models/pikmin/pikmin_white3.mdl";
		elseif (clr == "random") then
			local rnd = math.random(1, 5);
			if (rnd == 1) then
				clr = "red";
			elseif (rnd == 2) then
				clr = "yellow";
			elseif (rnd == 3) then
				clr = "blue";
			elseif (rnd == 4) then
				clr = "purple";
			elseif (rnd == 5) then
				clr = "white";
			end
			mdlstr = "models/pikmin/pikmin_" .. clr .. "3.mdl";
		end
		if (clr == "yellow") then
			pikhp = 18;
			pikdmg = 2;
		elseif (clr == "blue") then
			pikhp = 28;
			pikdmg = 2;
		elseif (clr == "purple") then
			pikhp = 40;
			pikdmg = 6;
		elseif (clr == "white") then
			pikhp = 12.5;
			pikdmg = 1;
		end
		local pos = ply:GetShootPos();
		pos = (pos + ((ply:GetForward() * -1) * 32));
		pos = (pos + (ply:GetRight() * math.Rand(-50, 50)));
		local ent = ents.Create("pikmin");
		ent.Olimar = ply;
		ent.PikClr = clr;
		ent.PikHP = pikhp;
		ent.PikDmg = pikdmg;
		if (clr != "purple" && clr != "white") then
			ent:SetModel("models/pikmin/pikmin_collision.mdl");
		else
			local str = string.Left(clr, 1);
			ent:SetModel("models/pikmin/pikmin_collision" .. str .. ".mdl");
		end
		ent:SetPos(pos);
		ent:SetMoveCollide(MOVECOLLIDE_FLY_SLIDE);
		ent:EmitSound(Sound("pikmin/pikmin_pluck.wav"));
		ent:Spawn();
		ent:Activate();
		mdl = ents.Create("pikmin_model");
		mdl:SetModel(mdlstr);
		mdl:SetPos(ent:GetPos());
		mdl:SetParent(ent);
		mdl:Spawn();
		mdl:Activate();
		ent.PikMdl = mdl;
		ent.PikMdl:SetNetworkedString("Color", clr);
		ent:SetPikLevel(3);
		undo.Create(clr .. " Pikmin");
			undo.AddEntity(ent);
			undo.SetPlayer(ply);
		undo.Finish();
	else
		ply:ChatPrint("Not a valid color: red, yellow, blue, purple, white");
end
end

concommand.Add("pikmin_create_flower", PikminCreateFlw);
concommand.Add("pikmin_create_bud", PikminCreateBud);
concommand.Add("pikmin_create", PikminCreate);

function ENT:DisbandMat()
if (self:GetPikType() == "red") then
self:Mdl():SetSubMaterial(0,"models/pikmin/pik_dismiss_r")
elseif (self:GetPikType() == "yellow") then
self:Mdl():SetSubMaterial(0,"models/pikmin/pik_dismiss_y")
elseif (self:GetPikType() == "blue") then
self:Mdl():SetSubMaterial(0,"models/pikmin/pik_dismiss_b")
elseif (self:GetPikType() == "purple") then
self:Mdl():SetSubMaterial(0,"models/pikmin/pik_dismiss_p")
end
end

function ENT:JoinMat()
if (self:GetPikType() == "red") then
self:Mdl():SetSubMaterial(0,"models/pikmin/pik_r")
elseif (self:GetPikType() == "yellow") then
self:Mdl():SetSubMaterial(0,"models/pikmin/pik_y")
elseif (self:GetPikType() == "blue") then
self:Mdl():SetSubMaterial(0,"models/pikmin/pik_b")
elseif (self:GetPikType() == "purple") then
self:Mdl():SetSubMaterial(0,"models/pikmin/purpss00")
end
end

function ENT:Disband()
	if (!self.Attacking && !IsValid(self.AtkTarget) and !self.IsCarrying) then //Don't disband if we're attacking or charging after an enemy, our leader still wants the kill!
		self.DismissShadowAng = self:GetAngles();
		self.Dismissed = true;
		self.Olimar = nil
		self.Dismissed = true
		self.AtkTarget = nil;
		self.Attacking = false;
		self.Victim = nil;
		self.IsCarrying = false
		self:Mdl():SetNWBool("Dismissed", true);
		self:SetAnim("dismissed");
		constraint.RemoveConstraints( self, "Weld" );
		self:SetNWEntity( "carry", nil );
		self:SetNWBool("Dismissed",true)
		self:DisbandMat();
	end
end

function ENT:DisbandAndSeparate()
	if (!self.Attacking && !IsValid(self.AtkTarget) and !self.IsCarrying) then //Don't disband if we're attacking or charging after an enemy, our leader still wants the kill!
		self.DismissShadowAng = self:GetAngles();
		self.AtkTarget = nil;
		self.Attacking = false;
		self.Victim = nil;
		self.IsCarrying = false
		constraint.RemoveConstraints( self, "Weld" );
		self:SetNWEntity( "carry", nil );
		self:DisbandMat();

		if (self:GetPikType() == "red") then
local phys = self:GetPhysicsObject()
if ( IsValid( phys ) ) then
		phys:Wake()
						local dir = (self:GetPos() - self:GetPos());
					self:GetPhysicsObject():ApplyForceCenter(-self:GetVelocity())
					self:MoveTo(self.Olimar:GetPos()+Vector(100,30,0),80)
else
end
		end
		
		if (self:GetPikType() == "yellow") then
local phys = self:GetPhysicsObject()
if ( IsValid( phys ) ) then
		phys:Wake()
								local dir = (self:GetPos() - self:GetPos());
					self:GetPhysicsObject():ApplyForceCenter(-self:GetVelocity())
					self:MoveTo(self.Olimar:GetPos()+Vector(0,-120,0),80)
else
end
		end
		
		if (self:GetPikType() == "blue") then
		local phys = self:GetPhysicsObject()
if ( IsValid( phys ) ) then
		phys:Wake()
					self:GetPhysicsObject():ApplyForceCenter(-self:GetVelocity())
					self:MoveTo(self.Olimar:GetPos()+Vector(-100,70,0),80)
else
end
		end
		
		if (self:GetPikType() == "purple") then
		local phys = self:GetPhysicsObject()
if ( IsValid( phys ) ) then
		phys:Wake()
					self:MoveTo(self.Olimar:GetPos()+Vector(100,-120,0),700)
else
end
		end
		
		if (self:GetPikType() == "white") then
		local phys = self:GetPhysicsObject()
if ( IsValid( phys ) ) then
		phys:Wake()
					self:MoveTo(self.Olimar:GetPos()+Vector(-120,-120,0),80)
else
end
		end

self.Olimar = nil
self:Mdl():SetNWBool("Dismissed", true);
self:SetNWBool("Dismissed",true)
self.Dismissed = true;

end
end

function ENT:Join(ent)
	self.Olimar = ent;
	self.Dismissed = false;
	self.RejoinAnim = true;
	self:EmitSound("pikmin/call.mp3");
	timer.Simple(.325, 
		function()
			if (IsValid(self)) then
				self.RejoinAnim = false;
			end
		end);
	self:Mdl():SetNWBool("Dismissed", false);
	self:SetAnim("join");
	self:JoinMat();
end

function ENT:LatchOn(ent)
	if (ent:IsNPC() || ent:IsPlayer()) and (ent == self.AtkTarget or self.JustThrown) then
		if (self:GetPikType() == "purple" && self.JustThrown) then
			ent:TakeDamage(10);
			self:EmitSound("physics/body/body_medium_impact_hard" .. math.random(4, 6) .. ".wav");
		end
		local pos = self:GetPos();
		local epos = ent:GetPos();
		local dir = (epos - pos):Angle();
		self.Attacking = true;
		self.Victim = ent;
		self:SetAnim("attack");
		self:SetAngles(dir);
		self:SetParent(ent);
	end
end

function ENT:Die(sound)
	local rag = self:CreatePikRagdoll(false);
	if (self:IsOnFire()) then
		rag:Ignite(math.Rand(8, 10), 0);
	end
	local clr = self.PikClr;
	if (clr == "red") then
		rag.cr = 255;
		rag.cg = 10;
		rag.cb = 10;
	elseif (clr == "yellow") then
		rag.cr = 255;
		rag.cg = 255;
		rag.cb = 10;
	elseif (clr == "blue") then
		rag.cr = 10;
		rag.cg = 10;
		rag.cb = 255;
	elseif (clr == "purple") then
		rag.cr = 200;
		rag.cg = 10;
		rag.cb = 200;
	elseif (clr == "white") then
		rag.cr = 250;
		rag.cg = 250;
		rag.cb = 250;
	end
	self.DrownSound:Stop();
	
	if sound == false then
	self:Remove();
	else
	if (self:WaterLevel() >= 1) then
	self:EmitSound("pikmin/drown2.mp3", 100, math.random(95, 110));
	self:Remove();
	else
	self:EmitSound("pikmin/death1.mp3", 100, math.random(95, 110));
	self:Remove();
	end
	end
	
	timer.Simple(math.Rand(1.6, 2.5), //Give it some random-ness, so they don't die in order so much
		function()
			if (IsValid(rag)) then
				local pos = rag:GetPos();
				local r = rag.cr;
				local g = rag.cg;
				local b = rag.cb;
				local effectdata = EffectData();
				effectdata:SetOrigin(rag:GetPos());
				effectdata:SetStart(Vector(r, g, b));
				util.Effect("pikmin_pop", effectdata);
				local effectdata = EffectData();
				effectdata:SetOrigin((rag:GetPos() + Vector(0, 0, 15)));
				effectdata:SetStart(Vector((r * .5), (g * .5), (b * .5)));
				util.Effect("pikmin_deathsoul", effectdata);
				rag:EmitSound(Sound("pikmin/death2.mp3"), 100, math.random(95, 110));
				rag:Remove();
			end
		end);

end

function ENT:OnRemove()
	self.DrownSound:Stop();
	self.IsCarrying = false
	if (self.Nextbot:IsValid()) then
	self.Nextbot:Remove()
	end
	self:SetParent();
	if (self.Carrying && IsValid(self.CarryEnt)) then
		local ent = self.CarryEnt;
		local num = 1;
		if (self:GetPikType() == "purple") then
			num = 10;
		end
		ent.NumCarry = (ent.NumCarry - num);
		local typ = self:GetPikType();
		if (typ == "red") then
			ent.Reds = (ent.Reds - 1);
		elseif (typ == "yellow") then
			ent.Yellows = (ent.Blues - 1);
		elseif (typ == "blue") then
			ent.Blues = (ent.Blues - 1);
		end
	end
end

function ENT:OnTakeDamage(dmg)
	dmg:SetDamageForce((dmg:GetDamageForce() * .25));
	self:TakePhysicsDamage(dmg);
	self.PikHP = (self.PikHP - dmg:GetDamage());
	if (self.PikHP <= 0) then
		if (self:GetPikType() == "white") then //Poison the bastards that killed us
			local ef = EffectData();
				ef:SetOrigin(self:GetPos());
			util.Effect("pikmin_poison", ef);
			local poisonpos = self:GetPos();
			local pikolimar = self.Olimar;
			timer.Create("PikPoisonfor " .. self:EntIndex(), .9, math.random(10, 12),
				function(pos, o) //Todo: Clean this function
					for k, v in pairs(ents.FindInSphere(poisonpos, 125)) do
						if (v:IsPlayer() && v != o) then
							local coughrand = math.random(1, 2);
							if (coughrand == 1) then
								v:EmitSound("ambient/voices/cough" .. tostring(math.random(1, 4)) .. ".wav");
							end
							v:TakeDamage(math.random(1, 2), (o || self), self);
						end
					if (v:IsNPC()) then
						v:TakeDamage(math.random(1, 2), (o || self), self);
					end
					if (v:GetClass() == "pikmin") then
						if (v:GetPikType() == "white") then
							timer.Destroy("PikPoisonfor" .. v:EntIndex());
						end
					end
				end
			end, poisonpos, pikolimar);
		end
		self:Die(); // 3:
	else
		if (self:GetPikLevel() != 1) then
			local lvl = self:GetPikLevel();
			local effectdata = EffectData();
			local pos, ang;
			if (lvl == 2) then
				pos, ang = self:Mdl():GetBonePosition(self:Mdl():LookupBone("piki_bud"));
			else
				pos, ang = self:Mdl():GetBonePosition(self:Mdl():LookupBone("piki_flower"));
			end
			effectdata:SetOrigin(pos);
			local r = 255;
			local g = 255;
			local b = 255;
			if (self:GetPikType() == "white" || self:GetPikType() == "purple") then
				r = 220;
				g = 100;
				b = 150;
			end
			effectdata:SetStart(Vector(r, g, b));
			util.Effect("pikmin_leveldown", effectdata);
			self:SetPikLevel((self:GetPikLevel() - 1));
		end
	end
end

function ENT:PhysicsSimulate(phys, delta)
	local pos = self:GetPos();
	phys:Wake();
	self.ShadowParams={};
	self.ShadowParams.secondstoarrive = .2;
	
	if (IsValid(self.Olimar)) then
		pos = self.Olimar:GetPos();
	end
	if (IsValid(self.AtkTarget)) then
		pos = self.AtkTarget:GetPos();
	end
	
	self.ShadowParams.pos = Vector(0, 0, 0);
	self.ShadowParams.angle = (pos - self:GetPos()):Angle();
	self.ShadowParams.angle.p = 0; //Don't be turning your whole body up and down...
	--allow pikmin to change angle
	if (self.Dismissed) then
	if (!self.AtkTarget) then
		self.ShadowParams.angle = self.DismissShadowAng;
		self.ShadowParams.angle.p = 0;
	end
	end
	self.ShadowParams.maxangular = 5000;
	self.ShadowParams.maxangulardamp = 10000;
	self.ShadowParams.maxspeed = 0;
	self.ShadowParams.maxspeeddamp = 0;
	self.ShadowParams.dampfactor = 0.8;
	self.ShadowParams.teleportdistance = 0;
	self.ShadowParams.deltatime = delta;
	phys:ComputeShadowControl(self.ShadowParams);
end

ENT.LastHop = 0;
ENT.LastObHop = 0;
ENT.NextAttack = 0;
ENT.PlayDrownSound = true;
ENT.DrownTime = 0;
ENT.DrowningTimeBool = false;
ENT.CanMove = true;
ENT.ShouldSpin = false;
ENT.LastPullApart = 0;
ENT.Held = false;
ENT.IsCarrying = false;

function ENT:NodeTravel(ent)
for k,v in pairs(ents.FindByClass(ent)) do
mypos = self:GetPos()
infopos = v:GetPos()
local dist = mypos:Distance( infopos )
if (dist <= 100) then
self.AtkTarget = v
end
end
end

function ENT:MoveTo(pos,spd)
if (pos) then

local reached = false

local function movefunc()
local dist = (self:GetPos()):Distance(pos)

while dist > 50 do
dist = (self:GetPos()):Distance(pos)

self.ShadowParams.pos = Vector(0, 0, 0);
self.ShadowParams.angle = (pos - self:GetPos()):Angle();
self.ShadowParams.angle.p = 0;

local lvl = self:GetPikLevel();
local dir = (pos - self:GetPos());
local vec = Vector(dir.x, dir.y, 0);


if (dist <= 51 || self.Dismissed == false) then
reached = true
end

self:GetPhysicsObject():ApplyForceCenter(((vec:GetNormal() * spd)));
coroutine.yield()
end

end

local co
	hook.Add( "Think", "MoveTo"..self:GetCreationID(), function()
	if self then
		if (not co || not reached) then
			co = coroutine.create( movefunc )
			coroutine.resume( co )
		end
	end
	end )

end
end


function ENT:Think()

if (self.IsCarrying == true) then
if (self.Nextbot:IsValid()) then
self.AtkTarget = self.Nextbot
end
--timer.Create("move"..math.random(1, 1000), 1, 1, function()
--self:SetPos(Vector(self.Nextbot:GetPos().x, self.Nextbot:GetPos().y, self:GetPos().z))
--end)
end
if (self.IsCarrying == false) then
if (self.Nextbot:IsValid()) then
self.Nextbot:Remove()
end
end
for k, v in pairs( ents.FindByClass("pik_masteronion") ) do
	v:CallOnRemove( "NoMaster", function() self.MasterExists = false end )
end

--Blue Save Drowning Pikmin
for k, v in pairs(ents.FindByClass("pikmin")) do
local model = v:Mdl()
local seqinfo = model:GetSequenceInfo( model:GetSequence() )
if (seqinfo.label == "drowning") then
if (self:GetPikType() == "blue") then
local mypos = self:GetPos()
local pikpos = v:GetPos()
local dist = mypos:Distance( pikpos )
if (dist <= 500) then
self.AtkTarget = v
end
if (dist <= 50) then
self.AtkTarget = v
local phys = v:GetPhysicsObject()
if (phys:IsValid()) then

--do we throw to olimar or random?
if (IsValid(self.Olimar)) then
OlimarPos = self.Olimar:GetPos();
end

if (IsValid(OlimarPos)) then
if (OlimarPos:Distance(self:GetPos()) > 1000) then
local randomized = math.random(-20, 20)
phys:Wake()
local direction = Vector(randomized, randomized, 5)
phys:ApplyForceCenter(direction * 100)
else
--throw it to olimar you moron
local throwdir = (OlimarPos-self:GetPos())
local direction = Vector(throwdir.X, throwdir.Y, 5)
phys:ApplyForceCenter(direction * 25)
end
else
--WE HAVE TO SAVE THE LIVES OF THE PIKMIN!
--BLUE THROW IT TO THE NEAREST PLAYER
for num,ply in pairs(ents.FindByClass("player")) do
OlimarPos = ply:GetPos();

if (OlimarPos:Distance(self:GetPos()) > 1000) then
local randomized = math.random(-20, 20)
phys:Wake()
local direction = Vector(randomized, randomized, 5)
phys:ApplyForceCenter(direction * 100)
else
--throw it to olimar you moron
local throwdir = (OlimarPos-self:GetPos())
local direction = Vector(throwdir.X, throwdir.Y, 5)
phys:ApplyForceCenter(direction * 25)
end
end

end

end
end
end
else
if (self.AtkTarget == v) then
self.AtkTarget = nil
else
--nothing
end
end
end

if (self.Dismissed == true) then
for k,v in pairs(ents.GetAll()) do
if (v:GetClass() == "pik_pellet" or v:GetClass() == "pik_pellet5" or v:GetClass() == "pik_pellet10") then

--temp fix for now
if (v:GetSkin() == 0 and self:GetPikType() == "blue" || v:GetSkin() == 1 and self:GetPikType() == "yellow" || v:GetSkin() == 2 and self:GetPikType() == "red") then
--check for onion
for l,b in pairs(ents.GetAll()) do
if (b:GetClass() == "pik_redonion" and self:GetPikType() == "red" || b:GetClass() == "pik_yellowonion" and self:GetPikType() == "yellow" || b:GetClass() == "pik_blueonion" and self:GetPikType() == "blue") then

local count = 0

--madness
for _,pik in pairs(ents.FindByClass("pikmin")) do
if (IsValid(pik:GetNWEntity("carry"))) then
if (pik:GetNWEntity("carry") == v) then
count=count+1
end
end

end

--is it full on pikmin?
if (v:GetClass() == "pik_pellet" and count >= 2 || v:GetClass() == "pik_pellet5" and count >= 5 || v:GetClass() == "pik_pellet10" and count >= 10 ) then
--full
if (self.AtkTarget == v) then
self.AtkTarget = nil
constraint.RemoveConstraints( self, "Weld" )
end
else
local distance = (v:GetPos()):Distance(self:GetPos())
if (distance <= 200) then
if (self.AtkTarget == nil) then
self.AtkTarget = v
self:SetNWBool("Dismissed",false)
end

end
end
end


end
end
end

if (v:GetClass() == "pik_corpse") then
local distance = (v:GetPos()):Distance(self:GetPos())
if (distance <= 200) then
if (self.AtkTarget == nil) then
self.AtkTarget = v
self:SetNWBool("Dismissed",false)
end
end
end

end
end


	for k,v in pairs(ents.FindByClass("pik_redonion")) do
	if (self:GetPikType() == "red" ) then
	if (self:GetNWBool("Dismissed") == true) then
	victimpos = self:GetPos()
			targetpos = v:GetPos()
			dist = victimpos:Distance( targetpos )
			if (dist < 100) then
			if (self:GetPikLevel() == 1) then
			v:SetPikAmountLeaf(v:GetPikAmountLeaf() +1)
			self:Remove()
			end
			if (self:GetPikLevel() == 2) then
			v:SetPikAmountBud(v:GetPikAmountBud() +1)
			self:Remove()
			end
			if (self:GetPikLevel() == 3) then
			v:SetPikAmountFlw(v:GetPikAmountFlw() +1)
			self:Remove()
			end
	end
	end
	end
	end
	
	for k,v in pairs(ents.FindByClass("pik_yellowonion")) do
	if (self:GetPikType() == "yellow" ) then
	if (self:GetNWBool("Dismissed") == true) then
	victimpos = self:GetPos()
			targetpos = v:GetPos()
			dist = victimpos:Distance( targetpos )
			if (dist < 100) then
			if (self:GetPikLevel() == 1) then
			v:SetPikAmountLeaf(v:GetPikAmountLeaf() +1)
			self:Remove()
			end
			if (self:GetPikLevel() == 2) then
			v:SetPikAmountBud(v:GetPikAmountBud() +1)
			self:Remove()
			end
			if (self:GetPikLevel() == 3) then
			v:SetPikAmountFlw(v:GetPikAmountFlw() +1)
			self:Remove()
			end
	end
	end
	end
	end
	
	for k,v in pairs(ents.FindByClass("pik_blueonion")) do
	if (self:GetPikType() == "blue" ) then
	if (self:GetNWBool("Dismissed") == true) then
	victimpos = self:GetPos()
			targetpos = v:GetPos()
			dist = victimpos:Distance( targetpos )
			if (dist < 100) then
			if (self:GetPikLevel() == 1) then
			v:SetPikAmountLeaf(v:GetPikAmountLeaf() +1)
			self:Remove()
			end
			if (self:GetPikLevel() == 2) then
			v:SetPikAmountBud(v:GetPikAmountBud() +1)
			self:Remove()
			end
			if (self:GetPikLevel() == 3) then
			v:SetPikAmountFlw(v:GetPikAmountFlw() +1)
			self:Remove()
			end
	end
	end
	end
	end
	
			if (self:IsValid()) then
	local entity = constraint.FindConstraintEntity( self, "Weld" )
	--print(constraint.FindConstraintEntity( self, "Weld" ))
	if (entity:IsValid()) then
	if (constraint.FindConstraintEntity( self, "Weld" ) and entity:GetClass() == "phys_constraint") then
	for k,v in pairs(ents.GetAll()) do
	if (v:GetClass() == "pik_pellet" or v:GetClass() == "pik_pellet5" or v:GetClass() == "pik_pellet10" or v:GetClass() == "pik_corpse") then
	local opos = v:GetPos()
	local mypos = self:GetPos()
	local dist = mypos:Distance(opos)
	local vel = self:GetVelocity()
	if (dist <= 100 and vel:Length() >= 6) then
	timer.Create("carry"..math.random(0, 1), 0, 1, function()
	self:EmitSound("pikmin/carry.mp3", 100, 100)
	end)
	end
	end
	end
	end
	else
	--nothing
	end
	end
	
	for k,v in pairs(ents.FindByClass("pik_masteronion")) do
	if (self.Dismissed) then
	victimpos = self:GetPos()
			targetpos = v:GetPos()
			dist = victimpos:Distance( targetpos )
			if (dist < 100) then
			if (self:GetPikLevel() == 1) then
			v:SetPikAmountLeaf(v:GetPikAmountLeaf() +1)
			self:Remove()
			end
			if (self:GetPikLevel() == 2) then
			v:SetPikAmountBud(v:GetPikAmountBud() +1)
			self:Remove()
			end
			if (self:GetPikLevel() == 3) then
			v:SetPikAmountFlw(v:GetPikAmountFlw() +1)
			self:Remove()
			end
	end
	end
	end

	local pos = self:GetPos();
	local vel = self:GetVelocity();
	if (self.Dismissed) then
	
	if (vel:Length() <= 5 && self.Dismissed && !self.Victim && (!self.ShouldSpin || !self.JustThrown) && !self.RejoinAnim && !self.Sucking) then
		self:SetAnim("idle")
		self:SetAnim("dismissed")
	end
	
	if (vel:Length() >= 6 && self.Dismissed && !self.Victim && (!self.ShouldSpin || !self.JustThrown) && !self.RejoinAnim && !self.Sucking) then
		self:SetAnim("running");
	end
	
	end
	
	if (vel:Length() <= 5 && !self.Dismissed && !self.Victim && (!self.ShouldSpin || !self.JustThrown) && !self.RejoinAnim && !self.Sucking) then
		self:SetAnim("idle");
	end
	if (vel:Length() >= 6 && !self.Dismissed && !self.Victim && (!self.ShouldSpin || !self.JustThrown) && !self.RejoinAnim && !self.Sucking) then
		self:SetAnim("running");
	end
	if (vel:Length() <= 300 and vel:Length() >= 200 && !self.Dismissed && !self.Victim && (!self.ShouldSpin || !self.JustThrown) && !self.RejoinAnim && !self.Sucking) then
	local piktrip = GetConVar("sv_pikmin_cantrip"):GetInt()
	if (piktrip == 1) then
	local triprandom = math.random(-1000, 1000)
	if (triprandom >= 400 and triprandom < 501) then
	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then
		--phys:EnableMotion(true) -- Freezes the object in place.
	self:SetAngles(Angle(self:GetAngles().x + 5, self:GetAngles().y + 0, self:GetAngles().z + 0))
	self:SetAnim("onfire");
	--timer.Simple(0.5, function() phys:EnableMotion(true) self:SetPos(Vector(self:GetPos().x, self:GetPos().y, self:GetPos().z+25)) phys:ApplyForceCenter(Vector(0, 0, 50)) end)
	end
	end
	else
	--nothing is done.
	end
	end
	//Fail-safe
	if ((!IsValid(self.Olimar) || !self.Olimar:Alive()) && !self.Dismissed) then
		self:Disband();
	end
	if (self.Sucking) then
		self:SetAnim("nectar");
	end
	if (!self.Attacking && CurTime() >= self.LastPullApart) then
		self.LastPullApart = (CurTime() + .75);
		for k, v in pairs(ents.FindByClass("pikmin")) do
			if (v != self && v.Olimar == self.Olimar && pos:Distance(v:GetPos()) <= 10) then
				local phys = self:GetPhysicsObject();
				if (phys:IsValid()) then
									--self:EmitSound("pikmin/grab.wav", 100, math.random(98, 105));
									--self:SetPos( Vector( (self.Olimar:GetPos().x)*1,(self.Olimar:GetPos().y)+35,(self.Olimar:GetPos().z)*1 ))
					local dir = (pos - v:GetPos());
					dir = (dir + Vector(0, 0, 10));
					phys:ApplyForceCenter((dir * 35)); --35
				end
			end
		end
	end
	//Moving
		if (self.CanMove) then
			local opos = pos;
			local dist = nil;
			if (IsValid(self.Olimar)) then
				opos = self.Olimar:GetPos();
				dist = pos:Distance(opos);
			end

			if (dist) then
			if (dist >= 1600) then
			if (!self.Victim) then
				if (self.AtkTarget == nil) then
				self:Disband();
				elseif (self:WaterLevel() >= 1) then
					self:Disband();
				end
				end
			end
			if (dist >= 1000) then
				if (!self.Victim) then
				if (self.AtkTarget == nil) then
				for k,v in pairs(ents.FindByClass("pikmin")) do
				thatpos = v:GetPos()
				mypos = self:GetPos()
				distbetween = mypos:Distance(thatpos)
				if (distbetween <= 75) then
				--keep olimar
				else
					self:Disband();
				end
				end
					elseif (self:WaterLevel() >= 1) then
					self:Disband();
end
				end
			end
		end

			if (CurTime() >= self.LastObHop) then
				self.LastObHop = (CurTime() + 1.5);
				
				if (self.Olimar || self.AtkTarget) then
				local tbl = {};
				for k, v in pairs(ents.FindByClass("pikmin")) do
					tbl[(#tbl + 1)] = v;
				end
				for k, v in pairs(ents.FindByClass("pikmin_model")) do
					tbl[(#tbl + 1)] = v;
				end
				//See if we should hop over an obstacle
				local tr = util.QuickTrace((self:GetPos() + Vector(0, 0, 4)), (self:GetForward() * 20), tbl);
				if (tr.HitWorld) then
					local phys = self:GetPhysicsObject();
					if (phys:IsValid()) then
						local force = 1750;
						if (self:GetPikType() == "purple") then
							force = 10000;
						end
						phys:ApplyForceCenter((self:GetUp() * force));
					end
				end
			end
		end
			
			
			if (CurTime() >= self.LastHop) then
				
				--attack target main
				if (IsValid(self.AtkTarget)) then
					opos = self.AtkTarget:GetPos();
					dist = 200;
				end
				if (self:IsOnFire() && self:GetPikType() != "red") then
					opos = (self:GetPos() + Vector(math.Rand(-1000, 1000), math.Rand(-1000, 1000), 0));
					dist = 200;
				end
				
				if (dist) then
				if (dist >= 200) then
					if (vel:Length() <= 250) then
						self.LastHop = (CurTime() + .1);
						local force = 875;
						local zforce = 325; --325
						local lvl = self:GetPikLevel();
						local dir = (opos - pos);
						if (self:GetPikLevel() == 1) then
						if (self.IsCarrying) then
						local multipliedforce = force * 1.5
						force = multipliedforce
						else
						local multipliedforce = force * 1.3
						force = multipliedforce
						end
						end
						if (self:GetPikLevel() == 2) then
						if (self.IsCarrying) then
						local multipliedforce = force * 1.5
						force = multipliedforce
						else
						local multipliedforce = force * 1.5
						force = multipliedforce
						end
						end
						if (self:GetPikLevel() == 3) then
						if (self.IsCarrying) then
						local multipliedforce = force * 1.5
						force = multipliedforce
						else
						local multipliedforce = force * 2
						force = multipliedforce
						end
						end
						if (self.PikClr == "purple") then	--purple weight section
							force = 9900;
							zforce = 7000;
							self:GetPhysicsObject():SetMass(100);
						end
						if (self.PikClr == "white") then
							force = 1250;
						end
						dir = (dir * 1.5);
						local vec = Vector(dir.x, dir.y, 0);
						if (self:WaterLevel() >= 1) then
							vec = dir;
						end
						self:GetPhysicsObject():ApplyForceCenter(((vec:GetNormal() * (force + (lvl * 50))) + Vector(0, 0, zforce)));
					end
				end
			end
			end
		end

	//On fire
	if (self:IsOnFire()) then
		if (self:GetPikType() == "red") then
			self:Extinguish();
		else
			self:SetAnim("onfire");
			self:EmitSound("pikmin/burn" .. math.random(1, 4) .. ".wav", 100, math.random(98, 105));
		end
	end
	

	//Water
	if (self:WaterLevel() >= 1) then //We are in water
		local phys = self:GetPhysicsObject();
		if (self:IsOnFire()) then
			self:Extinguish();
		end
		if (self:GetPikType() == "blue") then //We're ok
			if (!self.Attacking) then
				self:SetAnim("swimming");
			end
		else //We're screwed
			if (self.Attacking) then
				local quickpos = (self:GetPos() + Vector(0, 0, 7.5));
				self.Attacking = false;
				self.AtkTarget = nil;
				self:SetParent();
				self:SetPos(quickpos);
				self.Victim = nil;
			end
			self:Disband();
			self:SetAnim("drowning");
			self.CanMove = true;
			if (phys:IsValid()) then
				local push = 0.1; --12
				if (self:GetPikType() == "purple") then
					push = 0.5; --8
				elseif (self:GetPikType() == "white") then
					push = 1; --22
				end
				phys:ApplyForceCenter(Vector(0, 0, push));
			end
			if (!self.DrowningTimeBool) then
				self.DrowningTimeBool = true;
				self.DrownTime = (CurTime() + 5);
			end
			if (CurTime() >= self.DrownTime) then
				self:Die();
			end
			if (self.PlayDrownSound) then
				 self.PlayDrownSound = false;
				 self.DrownSound:Play();
			end
		end
	else
		if (self.DrowningTimeBool) then
			self.DrowningTimeBool = false;
		end
		if (!self.PlayDrownSound) then
			self.PlayDrownSound = true;
			self.DrownSound:Stop();
			self.CanMove = true;
		end
	end
	//Attacking
	if (self.Attacking) then
		if (IsValid(self.Victim)) then
			if (CurTime() >= self.NextAttack) then
				self.NextAttack = (CurTime() + .76);
				local dmg = (self.PikDmg + self:GetPikLevel());
				if ((self.Victim:Health() - dmg) <= 0) then
					for k, v in pairs(ents.FindByClass("pikmin")) do
						if (v.Victim == self.Victim && v != self) then
							local quickpos = (v:GetPos() + Vector(0, 0, 7.5));
							v.Attacking = false;
							v.AtkTarget = nil;
							v:SetParent();
							v:SetPos(quickpos);
							v.Victim = nil;
						end
					end
					local rnd = math.random(1, 4);
					if (rnd == 1) then
						local nec = ents.Create("pikmin_nectar");
						nec:SetPos((self.Victim:GetPos() + Vector(0, 0, 50)));
						nec:Spawn();
						local phys = nec:GetPhysicsObject();
						if (phys:IsValid()) then
							phys:ApplyForceCenter(Vector(0, 0, 5000));
							phys:AddAngleVelocity(Vector(math.random(10, 100), math.random(10, 100), math.random(10, 100)));
						end
					elseif (rnd == 2) then
						local nec = ents.Create("pik_pellet");
						nec:SetPos((self.Victim:GetPos() + Vector(0, 0, 50)));
						nec:Spawn();
						local phys = nec:GetPhysicsObject();
						if (phys:IsValid()) then
							phys:ApplyForceCenter(Vector(0, 0, 5000));
							phys:AddAngleVelocity(Vector(math.random(10, 100), math.random(10, 100), math.random(10, 100)));
						end
					end
					self.Victim:TakeDamage(dmg, self.Olimar, self);
					local quickpos = (self:GetPos() + Vector(0, 0, 7.5));
					self.Attacking = false;
					self.AtkTarget = nil;
					self:SetParent();
					self:SetPos(quickpos);
					self.Victim = nil;
				else
					self.Victim:TakeDamage(dmg, self.Olimar, self);
				end
				self:EmitSound("pikmin/hit.wav", 100, math.random(98, 105));
			end
		end
	end
	self:NextThink(CurTime() +  0.25);
	return true;
end

function ENT:PhysicsCollide(data, phys)
	if (self.JustThrown && data.HitEntity:IsWorld()) then
		self.ShouldSpin = false;
	end
end

function ENT:StartTouch(thing)

	if (!self.Attacking) then
		if (thing:IsPlayer()) then
			if (self.Dismissed) then
				self:Join(thing);
			elseif (thing != self.Olimar) then
				self:LatchOn(thing);
			end
		elseif (thing:IsNPC() && thing:GetClass() != "npc_rollermine") then
			self:LatchOn(thing);
		end
		end

if (thing:GetClass() == "pik_bulborb") then
thing:TakeDamage( 5, self, self )
end

		if (thing:GetClass() == "prop_combine_ball" or thing:GetClass() == "npc_rollermine") then
		if (self.PikClr == "yellow") then
			self:EmitSound("pikmin/call.mp3", 100, math.random(95, 110));
			else
			if (IsValid(self) && !self.Dissolving) then
				self:EmitSound("pikmin/pikmin_die.wav", 100, math.random(95, 110));
				local mdl = self:CreatePikRagdoll(true);
				local dissolve = ents.Create("env_entity_dissolver");
				dissolve:SetPos(mdl:GetPos());
				mdl:SetName(tostring(mdl));
				dissolve:SetKeyValue("target", mdl:GetName());
				dissolve:SetKeyValue("dissolvetype", "0");
				dissolve:Spawn();
				dissolve:Fire("Dissolve", "", 0);
				dissolve:Fire("kill", "", 1);
				dissolve:EmitSound(Sound("NPC_CombineBall.KillImpact"));
				mdl:Fire("sethealth", "0", 0);
				mdl.Dissolving = true;
			end
	end
	end

	if (thing:GetClass() == "pik_geyser") then
		if (self:GetPikType() == "red") then
		self:Extinguish();
		else
		self:Ignite( 30 );
		end
		end

	if (thing:GetClass() == "pik_bomb") then
		if (self:GetPikType() == "yellow") then
		self:EmitSound("pikmin/call.mp3", 100, math.random(55, 75));
		constraint.Weld( thing, self, 0, 0, self.PhysicsBone, false, false );
		self:SetNWEntity( "carry", thing )
	local ent1 = self
	for k, v in pairs( ents.GetAll() ) do
if (v:IsNPC()) then
	if(ent1:GetPos():Distance(v:GetPos()) < 100) then
	constraint.RemoveConstraints( self, "Weld" );
	self:SetNWEntity( "carry", nil )
	local explosion = ents.Create( "env_explosion" );
	explosion:SetPos( v:GetPos() );
	explosion:SetOwner( self ) -- this sets you as the person who made the explosion
	explosion:Spawn(); --this actually spawns the explosion
	explosion:SetKeyValue( "iMagnitude", "220" ); -- the magnitude
	--timer.Simple( 5, function() self:EmitSound("pikmin/coming.wav", 100, math.random(55, 75)); end );
	explosion:Fire( "Explode", 0, 0 );
	explosion:EmitSound( "weapon_AWP.Single", 400, 400 ); -- weapon_AWP.Single the sound for the explosion, and how far away it can be heard
	thing:Remove();
end
else
--do nothing
end
end
end
end

	if ( (thing:GetClass() == "pik_pellet") or (thing:GetClass() == "pik_pellet5") or (thing:GetClass() == "pik_pellet10") or (thing:GetClass() == "pik_corpse") ) and (self.AtkTarget != nil or self.JustThrown) and (self.IsCarrying == false) then
	if (self.AtkTarget == thing or self.JustThrown) then
	constraint.Weld( thing, self, 0, 0, self.PhysicsBone, false, false );
	self:SetNWEntity( "carry", thing )
	--local onion = ents.Create("npc_bullseye");
	self.AtkTarget = nil
	for k, v in pairs( ents.FindByClass("pik_masteronion") ) do
		if IsValid(v) then
			self.MasterExists = true
			self.AtkTarget = v;
			self.IsCarrying = true
		end
	end
	if (self:GetPikType() == "red") then
	for k, v in pairs( ents.FindByClass("pik_redonion") ) do
		if self.MasterExists == false then
		self.Nextbot = ents.Create("pik_carrybot")
	self.Nextbot:SetPos( self:GetPos() + Vector(0,0,27) )
	self.Nextbot:SetAngles( self:GetAngles() )
	self.Nextbot:SetSolid( SOLID_NONE )
	self.Nextbot:SetCollisionGroup( COLLISION_GROUP_NONE )
	self.Nextbot:SetOwner( self )
		self.Nextbot:Spawn()
		for k, v in pairs(ents.FindByClass("pik_pellet")) do
		if (IsValid(v) && v != self.Nextbot) then
			constraint.NoCollide(self.Nextbot, v, 0, 0); 
		end
	end
	for k, v in pairs(ents.FindByClass("pik_pellet5")) do
		if (IsValid(v) && v != self.Nextbot) then
			constraint.NoCollide(self.Nextbot, v, 0, 0); 
		end
	end
	for k, v in pairs(ents.FindByClass("pik_pellet10")) do
		if (IsValid(v) && v != self.Nextbot) then
			constraint.NoCollide(self.Nextbot, v, 0, 0); 
		end
	end
	self.Nextbot:Activate()
		self.Nextbot:SetPos(self:GetPos())
		self.Nextbot:SetEnemy(v)
			self.IsCarrying = true
			end
		end
		elseif (self:GetPikType() == "yellow") then
	for k, v in pairs( ents.FindByClass("pik_yellowonion") ) do
		if self.MasterExists == false then
				self.Nextbot = ents.Create("pik_carrybot")
	self.Nextbot:SetPos( self:GetPos() + Vector(0,0,27) )
	self.Nextbot:SetAngles( self:GetAngles() )
	self.Nextbot:SetSolid( SOLID_NONE )
	self.Nextbot:SetCollisionGroup( COLLISION_GROUP_NONE )
	self.Nextbot:SetOwner( self )
		self.Nextbot:Spawn()
	self.Nextbot:Activate()
		self.Nextbot:SetPos(self:GetPos())
			self.Nextbot:SetEnemy(v)
			self.IsCarrying = true
			end
		end
		elseif (self:GetPikType() == "blue") then
	for k, v in pairs( ents.FindByClass("pik_blueonion") ) do
	if self.MasterExists == false then
			self.Nextbot = ents.Create("pik_carrybot")
	self.Nextbot:SetPos( self:GetPos() + Vector(0,0,27) )
	self.Nextbot:SetAngles( self:GetAngles() )
	self.Nextbot:SetSolid( SOLID_NONE )
	self.Nextbot:SetCollisionGroup( COLLISION_GROUP_NONE )
	self.Nextbot:SetOwner( self ) 
	self.Nextbot:Spawn()
	self.Nextbot:Activate()
	self.Nextbot:SetPos(self:GetPos())
	self.Nextbot:SetEnemy(v)
			--self.AtkTarget = v;
			self.IsCarrying = true
			end
		end
		elseif (self:GetPikType() == "purple") then
		local randonion = math.random(1, 3)
			if (randonion == 1) then
				for k, v in pairs( ents.FindByClass("pik_blueonion") ) do
				if self.MasterExists == false then
				self.Nextbot:SetEnemy(v)
					--self.AtkTarget = v;
					self.IsCarrying = true
					end
				end
			elseif (randonion == 2) then
				for k, v in pairs( ents.FindByClass("pik_redonion") ) do
						if self.MasterExists == false then
					self.AtkTarget = v;
					self.IsCarrying = true
					end
				end
			elseif (randonion == 3) then
				for k, v in pairs( ents.FindByClass("pik_yellowonion") ) do
				if self.MasterExists == false then
			self.AtkTarget = v;
			self.IsCarrying = true
			end
		end
		elseif (self:GetPikType() == "white") then
		local randonion = math.random(1, 3)
			if (randonion == 1) then
				for k, v in pairs( ents.FindByClass("pik_blueonion") ) do
				if self.MasterExists == false then
			self.AtkTarget = v;
			self.IsCarrying = true
			end
		end
			elseif (randonion == 2) then
				for k, v in pairs( ents.FindByClass("pik_redonion") ) do
				if self.MasterExists == false then
			self.AtkTarget = v;
			self.IsCarrying = true
			end
		end
			elseif (randonion == 3) then
				if self.MasterExists == false then
			self.AtkTarget = v;
			self.IsCarrying = true
			end
			end
			end
	else
	self.AtkTarget = nil
		end
				end
	end
				
	if (thing:GetClass() == "prop_physics" and thing:GetModel() != "models/gates/bramble.mdl") then
	if (self.AtkTarget == thing or self.JustThrown) then
	constraint.Weld( thing, self, 0, 0, self.PhysicsBone, false, false );
	self:SetNWEntity( "carry", thing )
	self.AtkTarget = nil
	end
	--for k, v in pairs( ents.FindByClass("pik_masteronion") ) do
		--if IsValid(v) then
			--self.MasterExists = true
			--self.AtkTarget = v;
			--self.IsCarrying = true
		--end
		--end
	end
		
	if (thing:GetClass() == "npc_bullseye") then
	self.AtkTarget = thing
		end
		
	if (thing:GetClass() == "pik_dropoff") then
		constraint.RemoveConstraints( self, "Weld" )
		end
	
	if (thing:GetClass() == "pik_bridgepart") and (!self.Dismissed) and (self.AtkTarget != nil) then
	for k,v in pairs(ents.FindByClass("pik_bridge")) do
	constraint.Weld( thing, self, 0, 0, self.PhysicsBone, false, false )
	self:SetNWEntity( "carry", thing )
	self.IsCarrying = true
	victimpos = self:GetPos()
			targetpos = v:GetPos()
			dist = victimpos:Distance( targetpos )
			if (dist < 1000) then
			self.AtkTarget = v
			else
			self.AtkTarget = nil
			self.IsCarrying = false
	end
	end
	end
	
	if (thing:IsOnFire() && thing:GetClass() == "prop_physics") then
	if (self:GetPikType() == "red") then
		self.PikHP = 24;
		self:SetPikLevel(3);
		constraint.RemoveConstraints( self, "Weld" );
		self:SetNWEntity( "carry", nil );
		else
		self:Ignite( 30 );
		constraint.RemoveConstraints( self, "Weld" );
		self:SetNWEntity( "carry", nil );
		end
		end
		
	if (thing:IsOnFire()) then
	if (self:GetPikType() == "red") then
		self.PikHP = 24;
		else
		self:Ignite( 30 );
		end
		end
		
	if (thing:GetClass() == "pik_efence") then
		if (self:GetPikType() == "yellow") then
		self.AtkTarget = nil;
		self:EmitSound("pikmin/call.mp3", 100, math.random(95, 110));
		else
		self:EmitSound("pikmin/pikmin_die.wav", 100, math.random(95, 110));
				local mdl = self:CreatePikRagdoll(true);
				local dissolve = ents.Create("env_entity_dissolver");
				dissolve:SetPos(mdl:GetPos());
				mdl:SetName(tostring(mdl));
				dissolve:SetKeyValue("target", mdl:GetName());
				dissolve:SetKeyValue("dissolvetype", "0");
				dissolve:Spawn();
				dissolve:Fire("Dissolve", "", 0);
				dissolve:Fire("kill", "", 1);
				dissolve:EmitSound(Sound("NPC_CombineBall.KillImpact"));
				mdl:Fire("sethealth", "0", 0);
				mdl.Dissolving = true;
		end
		end
		
	if (thing:GetClass() == "prop_physics" and thing:GetVelocity():Length() >= 600) then
	--print(thing:GetVelocity().z)
	--if math.abs(thing:GetVelocity().z) >= 600 then
	self:SetAnim("onfire")
	self:Die(false)
	self:EmitSound("pikmin/burn" .. math.random(1, 4) .. ".wav", 100, math.random(98, 105));
	--end
	end
end