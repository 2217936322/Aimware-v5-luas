----    Base    code    for    auto    updating.
--
--local    cS    =    GetScriptName()
--local    cV    =    '1.0.0'
--local    gS    =    'PUT    LINK    TO    RAW    LUA    SCRIPT'
--local    gV    =    'PUT    LINK    TO    RAW    VERSION'
--
--local    function    AutoUpdate()
--	if    gui.GetValue('lua_allow_http')    and    gui.GetValue('lua_allow_cfg')    then
--		local    nV    =    http.Get(gV)
--		if    cV    ~=    nV    then
--			local    nF    =    http.Get(gS)
--			local    cF    =    file.Open(cS,    'w')
--			cF:Write(nF)
--			cF:Close()
--			print(cS,    'updated    from',    cV,    'to',    nV)
--		else
--			print(cS,    'is    up-to-date.')
--		end
--	end
--end		
--
--callbacks.Register('Draw',    'Auto    Update')
--callbacks.Unregister('Draw',    'Auto    Update')



local FindByClass, GetLocalPlayer, Text, Color, WorldToScreen = entities.FindByClass, entities.GetLocalPlayer, draw.Text, draw.Color, client.WorldToScreen

local function draw_decoys(team, index)
	local decoys = FindByClass('CDecoyProjectile')

	for i=1, #decoys do
		local decoy = decoys[i]
		local pX, pY, pZ = decoy:GetAbsOrigin()
		local tX, tY = WorldToScreen( pX, pY, pZ )
		if tX ~= nil then
			local thrower = decoy:GetPropEntity('m_hThrower')

			if thrower:GetIndex() == index then
				Color(255, 255, 255)
				Text(tX - 35, tY, 'Own Decoy')
			else
				local bX, bY = WorldToScreen( pX, pY, pZ )

				if thrower:GetTeamNumber() == team then
					Color(0, 255, 42)
					Text(bX, bY, 'Teammate '.. thrower:GetName())
					Text(tX - 20, tY, 'Decoy')
				else
					Color(255, 0, 25)
					Text(bX, bY, 'Enemy '.. thrower:GetName())
					Text(tX - 20, tY, 'Decoy')
				end
			end
		end
	end
end

local function draw_smokes(team, index)
	local decoys = FindByClass('CSmokeGrenadeProjectile')

	for i=1, #decoys do
		local decoy = decoys[i]
		local pX, pY, pZ = decoy:GetAbsOrigin()
		local tX, tY = WorldToScreen( pX, pY, pZ )
		if tX ~= nil then
			local thrower = decoy:GetPropEntity('m_hThrower')

			if thrower:GetIndex() == index then
				Color(255, 255, 255)
				Text(tX - 38, tY, 'Own Smoke')
			else
				local bX, bY = WorldToScreen( pX, pY, pZ )

				if thrower:GetTeamNumber() == team then
					Color(0, 255, 42)
					Text(bX, bY, 'Teammate '.. thrower:GetName())
					Text(tX - 22, tY, 'Smoke')
				else
					Color(255, 0, 25)
					Text(bX, bY, 'Enemy '.. thrower:GetName())
					Text(tX - 22, tY, 'Smoke')
				end
			end
		end
	end
end

callbacks.Register('Draw', function()
	if not entities.GetLocalPlayer() then return end;
	
	local local_player = GetLocalPlayer()
	local my_index = local_player:GetIndex()
	local my_team = local_player:GetTeamNumber()

	draw_decoys(my_team, my_index)
	draw_smokes(my_team, my_index)
end)
