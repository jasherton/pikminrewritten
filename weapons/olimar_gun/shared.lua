	if (SERVER) then
	AddCSLuaFile("shared.lua");
	
	SWEP.Weight				= 5;
	SWEP.AutoSwitchTo		= false;
	SWEP.AutoSwitchFrom		= false;
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "none"
end


if (CLIENT) then
	SWEP.PrintName			= ("Olimar Gun");	
	SWEP.Slot				= 1;
	SWEP.SlotPos			= 1;
	SWEP.DrawAmmo			= true;
	SWEP.DrawCrosshair		= true;
	SWEP.WepSelectIcon = surface.GetTextureID("weapons/pikmincommand");
end

function SWEP:Initialize()
	self.Owner.HasPikmin = false;
	self.WhistleSound = CreateSound(self, Sound("pikmin/whistle.wav"));
	if (SERVER) then
		self:SetWeaponHoldType(self.HoldType);
	end
end

function SWEP:CustomAmmoDisplay()
	self.AmmoDisplay = self.AmmoDisplay or {}

	self.AmmoDisplay.Draw = false //draw the display?

	if self.Primary.ClipSize > 0 then
		self.AmmoDisplay.PrimaryClip = self:Clip1() //amount in clip
		self.AmmoDisplay.PrimaryAmmo = self:Ammo1() //amount in reserve
	end
	if self.Secondary.ClipSize > 0 then
		self.AmmoDisplay.SecondaryClip = self:Clip2()
		self.AmmoDisplay.SecondaryAmmo = self:Ammo2()
	end

	return self.AmmoDisplay //return the table
end

function SWEP:Deploy()
	if (SERVER) then
		self.Owner.HasPikmin = false;
		self:SendWeaponAnim(ACT_VM_DRAW);
		timer.Destroy("PikDeployIdleAnim" .. self.Owner:UniqueID());
		timer.Create("PikDeployIdleAnim" .. self.Owner:UniqueID(), 1.2, 1, function() self:SendWeaponAnim(ACT_VM_IDLE) end);
	end
	return true;
end

function SWEP:Holster()
	if (SERVER) then
		timer.Destroy("PikDeployIdleAnim" .. self.Owner:UniqueID());
		timer.Destroy("PikPrimaryIdleAnim" .. self.Owner:UniqueID());
		timer.Destroy("Pik2ndryIdleAnim" .. self.Owner:UniqueID());
		timer.Destroy("PikReloadIdleAnim" .. self.Owner:UniqueID());
		self.Whistling = false;
		self.WhistleSound:Stop();
		if (IsValid(throwpikmin)) then
			throwpikmin = nil;
		end
		self:SendWeaponAnim(ACT_VM_HOLSTER);
	end
	return true;
end

function SWEP:PrimaryAttack()
end

SWEP.SelRadius = 0;

local throwpikmin = nil;

function SWEP:Think()
if (self.Owner:WaterLevel() <= 1) then
elseif (self.Owner:WaterLevel() < 3 and self.Owner:WaterLevel() >= 2) then
local vel = self.Owner:GetVelocity();
if (vel:Length() >= 50) then
self.Owner:EmitSound("pikmin/splash" .. math.random(1,4) .. ".mp3")
end
else
--nah
end

	if (self.Whistling) then
		self.SelRadius = (self.SelRadius + 2); //Grow larger as long as we whistle
		local tr = util.QuickTrace(self.Owner:GetShootPos(), (self.Owner:GetAimVector() * 750), {self.Owner, self});
		if (tr.Hit) then
		throwpikmin = nil;
			local pos = tr.HitPos;
			for k, v in pairs(ents.FindByClass("pikmin")) do
				if (v:GetPos():Distance(pos) <= (10 + self.SelRadius)) then
					if (v.Dismissed) then
						v:Join(self.Owner);
					end
							if constraint.FindConstraint( v, "Weld" ) then
							constraint.RemoveAll( v )
							end
					if (v.Olimar == self.Owner) then
						if (v:IsOnFire()) then
							v:Extinguish();
						end
						v.AtkTarget = nil;
						if (v.Attacking) then
							local quickpos = v:GetPos();
							v.Attacking = false;
							v:SetParent();
							v:SetPos((quickpos + Vector(0, 0, 8)));
							v.Victim = nil;
						end
					end
				end
			end
			local Opos = self.Owner:GetPos();
									for k, v in pairs(ents.FindByClass("pik_redonion")) do
				if (v:GetPos():Distance(Opos) < (100)) then
				if (v:CanCall() == true ) then
					if (v:GetPikAmountLeaf() > 0) then
					v:SetPikAmountLeaf(v:GetPikAmountLeaf() -1)
					self.Owner:ConCommand( "pikmin_create red" )
					else
					--nope
					end
					if (v:GetPikAmountBud() > 0) then
					v:SetPikAmountBud(v:GetPikAmountBud() -1)
					self.Owner:ConCommand( "pikmin_create_bud red" )
					else
					--nope
					end
					if (v:GetPikAmountFlw() > 0) then
					v:SetPikAmountFlw(v:GetPikAmountFlw() -1)
					self.Owner:ConCommand( "pikmin_create_flower red" )
					else
					--nope
					end
					end
					end
					end
					
				for k, v in pairs(ents.FindByClass("pik_yellowonion")) do
				if (v:GetPos():Distance(Opos) < (100)) then
				if (v:CanCall() == true ) then
					if (v:GetPikAmountLeaf() > 0) then
					v:SetPikAmountLeaf(v:GetPikAmountLeaf() -1)
					self.Owner:ConCommand( "pikmin_create yellow" )
					else
					--nope
					end
					if (v:GetPikAmountBud() > 0) then
					v:SetPikAmountBud(v:GetPikAmountBud() -1)
					self.Owner:ConCommand( "pikmin_create_bud yellow" )
					else
					--nope
					end
					if (v:GetPikAmountFlw() > 0) then
					v:SetPikAmountFlw(v:GetPikAmountFlw() -1)
					self.Owner:ConCommand( "pikmin_create_flower yellow" )
					else
					--nope
					end
					end
					end
					end
					
					for k, v in pairs(ents.FindByClass("pik_blueonion")) do
				if (v:GetPos():Distance(Opos) < (100)) then
				if (v:CanCall() == true ) then
					if (v:GetPikAmountLeaf() > 0) then
					v:SetPikAmountLeaf(v:GetPikAmountLeaf() -1)
					self.Owner:ConCommand( "pikmin_create blue" )
					else
					--nope
					end
					if (v:GetPikAmountBud() > 0) then
					v:SetPikAmountBud(v:GetPikAmountBud() -1)
					self.Owner:ConCommand( "pikmin_create_bud blue" )
					else
					--nope
					end
					if (v:GetPikAmountFlw() > 0) then
					v:SetPikAmountFlw(v:GetPikAmountFlw() -1)
					self.Owner:ConCommand( "pikmin_create_flower blue" )
					else
					--nope
					end
					end
					end
					end
					
		end
		else
		if (target) then
		target:Remove()
		end
	end
	--[[local pikamount = {}
						for k, v in pairs(ents.FindByClass("pikmin")) do
							if (v.Olimar == self.Owner) then
						table.insert(pikamount, v);
						--print(table.Count( pikamount ))			
							end
						end
for k, v in pairs(ents.FindByClass("pikmin")) do
	if (v.Olimar == self.Owner) then
	if (table.Count(pikamount) > 0) then
	--self:SetClip1(table.Count( pikamount ))
	end
--		else
--	self:SetClip1(table.Count( pikamount ))
							end
							end--]]
							
							
end

local function PikSWepKeyPress(ply, key)
	if (SERVER) then
		if (ply:Alive()) then
			if (IsValid(ply:GetActiveWeapon()) && ply:GetActiveWeapon():GetClass() == "olimar_gun") then
				if (key == IN_ATTACK) then
					local piks = {};
					local check = false;
					for k, v in pairs(ents.FindByClass("pikmin")) do
						if (v.Olimar == ply && !v.Attacking) then
							local pos = ply:GetPos();
							local ppos = v:GetPos();
							if (ppos:Distance(pos) <= 200 && !v.JustThrown) then
								check = true;
								table.insert(piks, v);
							end
						end
					end
					if (check) then
						timer.Destroy("PikPrimaryGrabSound" .. ply:UniqueID());
						local rnd = math.random(1, #piks);
						throwpikmin = piks[rnd];
						ply.HasPikmin = true;
						throwpikmin:EmitSound("pikmin/grab.wav", 100, math.random(98, 105));
						local phys = throwpikmin:GetPhysicsObject()
 
	if phys and phys:IsValid() then
		phys:EnableMotion(true) -- Freezes the object in place.
	end
									constraint.RemoveConstraints( throwpikmin, "Weld" )
									--throwpikmin:SetPos( Vector( (ply:GetPos().x)+25,(ply:GetPos().y)+25,(ply:GetPos().z)+25 ))
									local vec = ply:GetAimVector();
						local force = 50;
						if (throwpikmin:GetPikType() == "yellow") then
							force = 75;
						elseif (throwpikmin:GetPikType() == "purple") then
							force = 45;
						end
						vec = (vec * force);
						--throwpikmin:SetPos((ply:GetShootPos() + (vec * 1)))
									--constraint.Weld( ply, throwpikmin, 0, 0, throwpikmin.PhysicsBone, true, false );
									throwpikmin:SetAnim("onfire")
									throwpikmin:SetAnim("onfire")
									throwpikmin:SetAnim("onfire")
						timer.Create("PikPrimaryGrabSound" .. ply:UniqueID(), .8, 1,
							function(ply)
								if (player.HasPikmin) then
									ply:EmitSound(Sound("pikmin/grab.wav"));
								end
							end, ply);
					end
				end
				
								if (key == IN_WALK) then --IN_FORWARD
						--if (ply:KeyDown(IN_WALK)) then
					local piks = {};
					local check = false;
					for k, v in pairs(ents.FindByClass("pikmin")) do
						if (v.Olimar == ply && !v.Attacking) then
						local pik = v;
						local ppos = pik:GetPos();
						local vec = ply:GetAimVector();
						local phys = pik:GetPhysicsObject();
						local force = 25;
						vec = (vec * force);
						if (phys:IsValid()) then
						local pos = ply:GetPos();
							local ppos = v:GetPos();
							if (ppos:Distance(pos) <= 300 && !v.JustThrown) then
							if constraint.FindConstraint( v, "Weld" ) then
							else
							phys:ApplyForceCenter(((vec + Vector(0, 0, 5)) * 50));
							v:EmitSound(Sound("pikmin/coming.wav"));
							end
						end
					end
				end
				end
				end
				--end
				
				if (key == IN_RELOAD) then
					if (!ply:KeyDown(IN_USE)) then
						local tr = util.QuickTrace(ply:GetShootPos(), (ply:GetAimVector() * 1000), {ply, ply:GetActiveWeapon()});
						--local target = ents.Create("prop_physics")
		--target:SetModel("models/pikmin/pellet_1.mdl")
		--target:Spawn()
						if (tr.Hit) then
						--target:SetPos(pos)
							timer.Destroy("PikWhistlefor" .. ply:UniqueID());
							timer.Destroy("PikPrimaryIdleAnim" .. ply:UniqueID());
							timer.Destroy("Pik2ndryIdleAnim" .. ply:UniqueID());
							timer.Destroy("Pik2ndWhistle" .. ply:UniqueID());
							timer.Destroy("PikDeployIdleAnim" .. ply:UniqueID());
							timer.Destroy("PikReloadIdleAnim" .. ply:UniqueID());
							ply:GetActiveWeapon().Whistling = true;
							ply:GetActiveWeapon().WhistleSound:Stop();
							ply:GetActiveWeapon().WhistleSound:Play();
							ply:GetActiveWeapon():SendWeaponAnim(ACT_VM_RELOAD);
							timer.Create("PikReloadIdleAnim" .. ply:UniqueID(), 1.45, 1,
								function()
									ply:GetActiveWeapon():SendWeaponAnim(ACT_VM_IDLE);
								end);
							timer.Create("PikWhistlefor" .. ply:UniqueID(), 1.4, 1,
								function()
									if (ply:GetActiveWeapon().Whistling) then
										ply:GetActiveWeapon().Whistling = false;
										ply:GetActiveWeapon().WhistleSound:Stop();
									end
								end);
						end
					else
						local doanim = false;
						if (ply.Whistling) then
							ply.Whistling = false;
							ply.WhistleSound:Stop();
						end
						local piks2 = {};
						local pikred = {};
						local pikyel = {};
						local pikblu = {};
						local pikpur = {};
						local pikwhi = {};
						for k, v in pairs(ents.FindByClass("pikmin")) do
							if (v.Olimar == ply) then
						table.insert(piks2, v);
						if (v:GetPikType() == "red") then
						table.insert(pikred, v);
						end
						if (v:GetPikType() == "yellow") then
						table.insert(pikyel, v);
						end
						if (v:GetPikType() == "blue") then
						table.insert(pikblu, v);
						end
						if (v:GetPikType() == "purple") then
						table.insert(pikpur, v);
						end
						if (v:GetPikType() == "white") then
						table.insert(pikwhi, v);
						end
						print(table.Count( piks2 ))
								doanim = true;								
							end
						end
for k, v in pairs(ents.FindByClass("pikmin")) do
	if (v.Olimar == ply) then
if (table.Count( piks2 ) > 1) then
if (table.Count(pikred) > 0 and table.Count(pikyel) > 0 or table.Count(pikred) > 0 and table.Count(pikblu) > 0 or table.Count(pikyel) > 0 and table.Count(pikred) > 0 or table.Count(pikyel) > 0 and table.Count(pikblu) > 0 or table.Count(pikblu) > 0 and table.Count(pikred) > 0 or table.Count(pikblu) > 0 and table.Count(pikyel) > 0 or table.Count(pikred) > 0 and table.Count(pikpur) > 0 or table.Count(pikyel) > 0 and table.Count(pikpur) > 0 or table.Count(pikblu) > 0 and table.Count(pikpur) > 0 or table.Count(pikred) > 0 and table.Count(pikwhi) > 0 or table.Count(pikyel) > 0 and table.Count(pikwhi) > 0 or table.Count(pikblu) > 0 and table.Count(pikwhi) > 0 or table.Count(pikpur) > 0 and table.Count(pikwhi) > 0) then
v:DisbandAndSeparate();
else
v:Disband();
end
		else
		v:Disband();
							end
							end
							end
						if (doanim) then
							timer.Destroy("PikReloadIdleAnim" .. ply:UniqueID());
							timer.Destroy("PikDeployIdleAnim" .. ply:UniqueID());
							timer.Destroy("Pik2ndryIdleAnim" .. ply:UniqueID());
							timer.Destroy("Pik2ndWhistle" .. ply:UniqueID());
							ply:GetActiveWeapon().WhistleSound:Stop()
							ply:GetActiveWeapon():SendWeaponAnim(ACT_VM_DRYFIRE);
							timer.Create("PikReloadIdleAnim" .. ply:UniqueID(), .75, 1,
										function()
											ply:GetActiveWeapon():SendWeaponAnim(ACT_VM_IDLE);
										end);
							ply:EmitSound("pikmin/disband.wav");
						end
					end
				end
			end
		end
	end
end
hook.Add("KeyPress", "GrabPikmin", PikSWepKeyPress);

local function PikSWepKeyRelease(ply, key) //release primary, throw pikmin
	if (SERVER) then
		if (ply:Alive()) then
			if (IsValid(ply:GetActiveWeapon()) && ply:GetActiveWeapon():GetClass() == "olimar_gun") then
				if (key == IN_ATTACK) then
					if (IsValid(throwpikmin) && ply.HasPikmin) then
					constraint.RemoveConstraints( throwpikmin, "Weld" )
						timer.Destroy("PikPrimaryIdleAnim" .. ply:UniqueID());
						timer.Destroy("PikDeployIdleAnim" .. ply:UniqueID());
						local pik = throwpikmin;
						local ppos = pik:GetPos();
						local vec = ply:GetAimVector();
						local phys = pik:GetPhysicsObject();
						pik:SetPos((ply:GetShootPos() + (vec * 25)));
						local force = 50;
						if (pik:GetPikType() == "yellow") then
							force = 75;
						elseif (pik:GetPikType() == "purple") then
							force = 450;
						end
						vec = (vec * force);
						if (phys:IsValid()) then
						phys:EnableMotion(true)
							phys:ApplyForceCenter(((vec + Vector(0, 0, 5)) * 125));
						end
						ply:GetActiveWeapon():SendWeaponAnim(ACT_VM_PRIMARYATTACK);
						ply:SetAnimation(ACT_MELEE_ATTACK_SWING); //this doesnt work  :(
						pik:SetAnim("thrown");
						ply:EmitSound("pikmin/pikmin_throw.wav");
						timer.Create("PikPrimaryIdleAnim" .. ply:UniqueID(), .75, 1,
							function()
								ply:GetActiveWeapon():SendWeaponAnim(ACT_VM_IDLE);
							end);
						pik.JustThrown = true; //Going to check if they should follow us while in the air...
						pik.ShouldSpin = true;
						pik.CanMove = false;
						timer.Simple(2.5,
							function()
								if (IsValid(pik)) then
									pik.CanMove = true;
									pik.JustThrown = false;
								end
							end);
						ply.HasPikmin = false;
					end
				end
				if (key == IN_RELOAD) then
					if (ply:GetActiveWeapon().Whistling) then
						timer.Destroy("PikReloadIdleAnim" .. ply:UniqueID());
						timer.Destroy("PikDeployIdleAnim" .. ply:UniqueID());
						ply:GetActiveWeapon():SendWeaponAnim(ACT_VM_IDLE);
						ply:GetActiveWeapon().Whistling = false;
						ply:GetActiveWeapon().WhistleSound:FadeOut(.2);
						ply:GetActiveWeapon().SelRadius = 0;
					end
				end
			end
		end
	end
end
hook.Add("KeyRelease", "ThrowPikmin", PikSWepKeyRelease);

function SWEP:SecondaryAttack()
	local tr = util.QuickTrace(self.Owner:GetShootPos(), (self.Owner:GetAimVector() * 10000), self.Owner);
	if (IsValid(tr.Entity)) then
		for k, v in pairs(ents.FindByClass("pikmin")) do
			if (v.Olimar == self.Owner && tr.Entity:GetClass() != "npc_bullseye" && (tr.Entity:GetClass() == "pik_corpse" or tr.Entity:GetClass() == "pik_bulborb" or tr.Entity:GetClass() == "prop_physics" or (tr.Entity:GetClass() == "pikmin_nectar" and v:GetPikLevel() != 3) or tr.Entity:GetClass() == "pik_pellet" or  tr.Entity:GetClass() == "pik_pellet5" or tr.Entity:GetClass() == "pik_pellet10" or  tr.Entity:IsNPC() || tr.Entity:IsPlayer())) then
				timer.Destroy("Pik2ndryIdleAnim" .. self.Owner:UniqueID());
				timer.Destroy("Pik2ndWhistle" .. self.Owner:UniqueID());
				self.WhistleSound:Stop();
				if (tr.Entity:GetClass() == "pikmin_nectar") then
				v.AtkTarget = tr.Entity;
				else
				end
				v.AtkTarget = tr.Entity;
				self:SendWeaponAnim(ACT_VM_SECONDARYATTACK);
				timer.Create("Pik2ndryIdleAnim" .. self.Owner:UniqueID(), 1.3, 1, function() self:SendWeaponAnim(ACT_VM_IDLE) end);
				self.WhistleSound:Play();
				timer.Create("Pik2ndWhistle" .. self.Owner:UniqueID(), 1.45, 1,
					function()
						if (IsValid(self)) then
							self.WhistleSound:Stop();
						end
					end);
			end
		end
	end
end
------------General Swep Info---------------
SWEP.Author = ("Aska and jasherton");
SWEP.Purpose = ("Control Pikmin");
SWEP.Instructions = ("Primary Fire - Throw Pikmin\nSecondary Fire - Order Pikmin to attack\nReload - Whistle (hold to call Pikmin)\nUse+Reload - Dismiss Pikmin");
SWEP.Spawnable = true;
SWEP.AdminSpawnable = true;
SWEP.HoldType = ("melee");
SWEP.Category = ("Pikmin");
-----------------------------------------------

------------Models---------------------------
SWEP.ViewModel = ("models/weapons/v_olimar.mdl");
SWEP.WorldModel = ("models/weapons/w_olimar.mdl");
-----------------------------------------------
