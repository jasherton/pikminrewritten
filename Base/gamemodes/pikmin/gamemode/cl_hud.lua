local function DrawHUD()
local ply = LocalPlayer();
hook.Add( "HUDPaint", "drawsometext", function()
	for k, v in pairs (ents.FindByClass("pik_pellet")) do
	positionsx = v:GetPos()
	screenx = positionsx:ToScreen()
	object = v
		local piks2 = {};
	for k, v in pairs(ents.FindByClass("pikmin")) do
		--if (constraint.Find( v, object, "Weld", 0, 0) == object) then
		table.insert(piks2, v);
		--end
		end
	draw.SimpleText( table.Count(piks2), "Default", screenx.x+3, screenx.y-85, Color(255,255,255,255), 1, 1)
	surface.SetFont( "Default" )
	surface.SetTextColor( 255, 255, 255, 255 )
	surface.SetTextPos( screenx.x, screenx.y-110 )
	surface.DrawText( "1" )
	surface.SetFont( "Default" )
	surface.SetTextColor( 255, 255, 255, 255 )
	surface.SetTextPos( screenx.x, screenx.y-105 )
	surface.DrawText( "_" )
end
local piks3 = {};
local pikteam = {};
local selfpik = nil
	for k, v in pairs(ents.FindByClass("pikmin")) do
		table.insert(piks3, v);
		end
		
	for k, v in pairs(ents.FindByClass("pikmin")) do
	if (v.Olimar == ply) then
		table.insert(pikteam, v);
		end
		end
		--end
draw.SimpleText( "Pikmin On Field: "..table.Count(piks3), "CloseCaption_Bold", 900, 1000, Color(150,150,150,255), 1, 1)
draw.SimpleText( "Pikmin In Squad: "..table.Count(pikteam), "CloseCaption_Bold", 1140, 1000, Color(150,150,150,255), 1, 1)
draw.RoundedBox( 5, 800, 985, 450, 30, Color(0,0,0,150) )

if (game.GetMap() == "gm_flatgrass") then
print("playable map")
surface.PlaySound( "pikmin/challengemusic2.wav" )
elseif (game.GetMap() == "gm_construct") then
print("playable map")
surface.PlaySound( "pikmin/challengemusic2.wav" )
else
print("not a playable map.")
end
end )
end