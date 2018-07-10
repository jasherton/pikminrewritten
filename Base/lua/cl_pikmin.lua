local function SpawnPikminMenu(ply, cmd, args)
	local w, h = surface.ScreenWidth(), surface.ScreenHeight();
	local frame = vgui.Create("DFrame");
	frame:SetSize((w * .7), (h * .275));
	
	local W = frame:GetWide();
	local H = frame:GetTall();
	
	frame:SetPos(((w * .5) - (W * .5)), (h * .125));
	frame:SetVisible(true);
	frame:MakePopup();
	frame:SetTitle("Pikmin Spawn Menu");
	//function frame:Paint()
	//	draw.RoundedBox(3, 0, 0, W, H, Color(25, 100, 25, 250));
	//	return true;
	//end
	
	local piktbl = {
		"red",
		"yellow",
		"blue",
		"purple",
		"white"
	};
	
	local inc = 0;
	
	for i = 1, #piktbl do //lets do this neatly...
		local btn = vgui.Create("DModelPanel", frame);
		btn:SetPos(((W * .05) + inc), (H * .2));
		btn:SetWide((W * .175));
		btn:SetTall((H * .55));
		btn:SetModel("models/pikmin/pikmin_" ..  piktbl[i] .. "1.mdl");
		btn:SetLookAt(Vector(0, 0, 25));
		btn:SetFOV(56);
		btn:SetAmbientLight(Color(80, 80, 80));
		btn:SetCamPos(Vector(60, 15, 40));
		btn:SetAnimSpeed(math.Rand(.9, 1.2));
		btn:SetAnimated(true);
		function btn:LayoutEntity(ent)
			self:RunAnimation();
		end
		function btn:Think()
			local anim = btn.Entity:LookupSequence("dismissed");
			btn.Entity:ResetSequence(anim);
		end 
		function btn:DoClick()
			RunConsoleCommand("pikmin_create", piktbl[i])
		end
		inc = (inc + (28 + (w * .1)));
	end
	
	local rand = vgui.Create("DButton", frame);
	rand:SetPos((W * .1), (H * .8));
	rand:SetWide((W * .8));
	rand:SetTall((H * .1));
	rand:SetText("Random!");
	rand.DoClick = function()
						RunConsoleCommand("pikmin_create", "random");
					end
					
	frame:SizeToContents();
end
concommand.Add("pikmin_menu", SpawnPikminMenu);

function pikmin()
	hook.Add( "Think", "gm_construct", function()
    if ( string.find( string.lower( game.GetMap() ), "gm_construct" ) ) then
	resource.AddFile("pikmin/impact.mp3");
	surface.PlaySound( "pikmin/impact.mp3" );
	timer.Simple( 180, function() print( "restarting music" ) end )
	end
	end)
end

concommand.Add("pikmin_playm", pikmin)


function jashertonMenu(ply, cmd, args)
	local w, h = surface.ScreenWidth(), surface.ScreenHeight();
	local frame = vgui.Create("DFrame");
	frame:SetSize((w * .4), (h * .275));
	
	local W = frame:GetWide();
	local H = frame:GetTall();
	
	frame:SetPos(((w * .5) - (W * .5)), (h * .125));
	frame:SetVisible(true);
	frame:MakePopup();
	frame:SetTitle("jasherton Test Menu");
	//function frame:Paint()
	//	draw.RoundedBox(3, 0, 0, W, H, Color(25, 100, 25, 250));
	//	return true;
	//end
	
	--[[local piktbl = {
		"red",
		"yellow",
		"blue",
		"purple",
		"white"
	};
	
	local inc = 0;
	
	for i = 1, #piktbl do //lets do this neatly...
		local btn = vgui.Create("DModelPanel", frame);
		btn:SetPos(((W * .05) + inc), (H * .2));
		btn:SetWide((W * .175));
		btn:SetTall((H * .55));
		btn:SetModel("models/pikmin/pikmin_" ..  piktbl[i] .. "1.mdl");
		btn:SetLookAt(Vector(0, 0, 25));
		btn:SetFOV(56);
		btn:SetAmbientLight(Color(80, 80, 80));
		btn:SetCamPos(Vector(60, 15, 40));
		btn:SetAnimSpeed(math.Rand(.9, 1.2));
		btn:SetAnimated(true);
		function btn:LayoutEntity(ent)
			self:RunAnimation();
		end
		function btn:Think()
			local anim = btn.Entity:LookupSequence("dismissed");
			btn.Entity:ResetSequence(anim);
		end 
		function btn:DoClick()
			RunConsoleCommand("pikmin_create", piktbl[i])
		end
		inc = (inc + (28 + (w * .1)));
	end--]]
	
	if (ply:SteamID("STEAM_0:1:6140311")) then
	--do nothing
	else
	ply:ConCommand( "I've found jasherton's test menu!" )
	end
	
	local label = vgui.Create("DLabel" , frame);
	label:SetPos((W * .1), (H * .8));
	label:SetText("You've found my test menu!");
	label:SetWrap( false );
	label:SizeToContents();
	label:SetTextColor( Color( 0, 0, 0, 255 ) );
	local label2 = vgui.Create("DLabel" , frame);
	label2:SetPos((W * .17), (H * .92));
	label2:SetTextColor( Color( 0, 255, 250, 255 ) );
	label2:SetText("-jasherton");
	
	local pikpic = vgui.Create("DModelPanel", frame);
	pikpic:SetPos((W * .4), (H * 0.35));
	pikpic:SetWide((W * .175));
		pikpic:SetTall((H * .55));
		pikpic:SetModel("models/pikmin/pikmin_red3.mdl");
		pikpic:SetLookAt(Vector(0, 0, 30));
		pikpic:SetFOV(56);
		pikpic:SetAmbientLight(Color(80, 80, 80));
		pikpic:SetCamPos(Vector(60, 15, 40));
		pikpic:SetAnimSpeed(math.Rand(.9, 1.2));
		pikpic:SetAnimated(true);
		function pikpic:LayoutEntity(ent)
			self:RunAnimation();
		end
		function pikpic:Think()
			local anim = pikpic.Entity:LookupSequence("running");
			pikpic.Entity:ResetSequence(anim);
		end 
		function pikpic:DoClick()
			surface.PlaySound( "pikmin/coming.wav" )
			surface.PlaySound( "pikmin/impact.mp3" )
		end
	
	local pikpic2 = vgui.Create("DModelPanel", frame);
	pikpic2:SetPos((W * .5), (H * 0.35));
	pikpic2:SetWide((W * .175));
		pikpic2:SetTall((H * .55));
		pikpic2:SetModel("models/pikmin/pikmin_yellow3.mdl");
		pikpic2:SetLookAt(Vector(0, 0, 30));
		pikpic2:SetFOV(56);
		pikpic2:SetAmbientLight(Color(80, 80, 80));
		pikpic2:SetCamPos(Vector(60, 15, 40));
		pikpic2:SetAnimSpeed(math.Rand(.9, 1.2));
		pikpic2:SetAnimated(true);
		function pikpic2:LayoutEntity(ent)
			self:RunAnimation();
		end
		function pikpic2:Think()
			local anim = pikpic2.Entity:LookupSequence("running");
			pikpic2.Entity:ResetSequence(anim);
		end 
		function pikpic2:DoClick()
			surface.PlaySound( "pikmin/coming.wav" )
			ply:ConCommand( "stopsound" )
		end
		
		local pikpic3 = vgui.Create("DModelPanel", frame);
	pikpic3:SetPos((W * .6), (H * 0.35));
	pikpic3:SetWide((W * .175));
		pikpic3:SetTall((H * .55));
		pikpic3:SetModel("models/pikmin/pikmin_blue3.mdl");
		pikpic3:SetLookAt(Vector(0, 0, 30));
		pikpic3:SetFOV(56);
		pikpic3:SetAmbientLight(Color(80, 80, 80));
		pikpic3:SetCamPos(Vector(60, 15, 40));
		pikpic3:SetAnimSpeed(math.Rand(.9, 1.2));
		pikpic3:SetAnimated(true);
		function pikpic3:LayoutEntity(ent)
			self:RunAnimation();
		end
		function pikpic3:Think()
			local anim = pikpic3.Entity:LookupSequence("running");
			pikpic3.Entity:ResetSequence(anim);
		end 
		function pikpic3:DoClick()
			surface.PlaySound( "pikmin/coming.wav" )
			ply:ConCommand( "pikmin_create blue" )
		end
	--[[local rand = vgui.Create("DButton", frame);
	rand:SetPos((W * .1), (H * .8));
	rand:SetWide((W * .8));
	rand:SetTall((H * .1));
	rand:SetText("Random!");
	rand.DoClick = function()
						RunConsoleCommand("pikmin_create", "random");
					end--]]
					
	frame:SizeToContents();
end
concommand.Add("test_menu", jashertonMenu);
