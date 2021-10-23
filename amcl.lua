local currentMenuX = 1
local selectedMenuX = 1
local currentMenuY = 4
local selectedMenuY = 4
local menuX = { 0.018, 0.06, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.8, 0.95 }
local menuY = { 0.015, 0.05, 0.1, 0.2, 0.3, 0.4, 0.5 } 
local allowedToUseMenu = true

RegisterNetEvent('spoodymenu:client:sendalert')
AddEventHandler('spoodymmenu:client:sendalert', function(data)
	SendAlert(data.type, data.text, data.length, data.style)
end)

function SendAlert(type, text, length, style)
	SendNUIMessage({
		type = type,
		text = text,
		length = length,
		style = style
	})
end

Citizen.CreateThread(function()
	TriggerServerEvent("spoodymenu:openmenucheck")
end)

RegisterNetEvent("spoodymenu:openmenu")
AddEventHandler("spoodymenu:openmenu", function(isAllowedtoOpenMenu)
    allowedToUseMenu = isAllowedtoOpenMenu
end)


Citizen.CreateThread(function()

	WarMenu.CreateMenu('spoody', 'WarMenu')
	WarMenu.SetSubTitle('spoody', 'Ped Menu')
	WarMenu.CreateSubMenu('ped', 'spoody', 'Ped Menu')


	while true do
		playerhealth = GetEntityHealth(GetPlayerPed(selectedPlayer))
		playerarmor = GetPedArmour(GetPlayerPed(selectedPlayer))
		if WarMenu.IsMenuOpened('spoody') then
			if WarMenu.MenuButton('Ped Menu', 'ped') then 
			elseif WarMenu.Button('~r~Close') then WarMenu.CloseMenu()
            end
			
		elseif WarMenu.IsMenuOpened('ped') then
			if WarMenu.Button(ConfigCL.QOne) then
				DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 64 + 1)
    
				while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
					Citizen.Wait(0)
				end
				
				local modelhash = GetOnscreenKeyboardResult()
				
				if modelhash == nil then 
					modelhash = ""
				end
			
				if modelhash == "" then 
					return
				end
				
				local model = GetHashKey(modelhash)
			
				if IsModelValid(model) and IsModelAPed(model) then
					RequestModel(model)
					while not HasModelLoaded(model) do
						Wait(100)
					end
				else
					SendAlert('error', 'Invalid Ped Model.', 5000) 
				end
			
				SetPlayerModel(PlayerId(), model)
				SetModelAsNoLongerNeeded(model)
			end
			if WarMenu.Button(ConfigCL.WTwo) then -- Menu #1
				local ped = ('csb_maude')
local hash = GetHashKey(ped)
	RequestModel(hash)
	while not HasModelLoaded(hash)
			do RequestModel(hash)
				Citizen.Wait(0)
			end	
			SetPlayerModel(PlayerId(), hash)
			end
			if WarMenu.Button(ConfigCL.EThree) then -- Menu #2
				local ped = ('csb_ramp_mex')
local hash = GetHashKey(ped)
	RequestModel(hash)
	while not HasModelLoaded(hash)
			do RequestModel(hash)
				Citizen.Wait(0)
			end	
			SetPlayerModel(PlayerId(), hash)
			end
			if WarMenu.Button(ConfigCL.RFour) then
				local ped = ('csb_reporter')
local hash = GetHashKey(ped)
	RequestModel(hash)
	while not HasModelLoaded(hash)
			do RequestModel(hash)
				Citizen.Wait(0)
			end	
			SetPlayerModel(PlayerId(), hash)				
			end
			if WarMenu.Button(ConfigCL.TFive) then
				local ped = ('s_m_m_movspace_01')
local hash = GetHashKey(ped)
	RequestModel(hash)
	while not HasModelLoaded(hash)
			do RequestModel(hash)
				Citizen.Wait(0)
			end	
			SetPlayerModel(PlayerId(), hash)								
			end
			if WarMenu.Button(ConfigCL.YSix) then
				local ped = ('s_m_m_movalien_01')
local hash = GetHashKey(ped)
	RequestModel(hash)
	while not HasModelLoaded(hash)
			do RequestModel(hash)
				Citizen.Wait(0)
			end	
			SetPlayerModel(PlayerId(), hash)												
			end
		
		elseif IsControlJustReleased(0, ConfigCL.OpenMenu) then 
			if allowedToUseMenu then
				WarMenu.OpenMenu('spoody')
			end
		end

        WarMenu.Display()

		SetPlayerInvincible(PlayerId(), godmode)

		if noclip then
			local NoclipSpeed = ConfigCL.IndexTwo
            local isInVehicle = IsPedInAnyVehicle(PlayerPedId(), 0)
            local k = nil
            local x, y, z = nil
            
            if not isInVehicle then
                k = PlayerPedId()
                x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), 2))
            else
                k = GetVehiclePedIsIn(PlayerPedId(), 0)
                x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), ConfigCL.IndexTwo))
            end
            
            if isInVehicle and GetSeatPedIsIn(PlayerPedId()) ~= ConfigCL.Index then RequestControlOnce(k) end
            
            local dx, dy, dz = GetCamDirection()
            SetEntityVisible(PlayerPedId(), 0, 0)
            SetEntityVisible(k, 0, 0)
            
            SetEntityVelocity(k, ConfigCL.IndexThree, ConfigCL.IndexThree, ConfigCL.IndexThree)
            
            if IsDisabledControlPressed(0, ConfigCL.Five) then -- MOVE FORWARD
                x = x + NoclipSpeed * dx
                y = y + NoclipSpeed * dy
                z = z + NoclipSpeed * dz
            end
            
            if IsDisabledControlPressed(0, ConfigCL.Six) then -- MOVE BACK
                x = x - NoclipSpeed * dx
                y = y - NoclipSpeed * dy
                z = z - NoclipSpeed * dz
            end
			
			if IsDisabledControlPressed(0, ConfigCL.Seven) then -- MOVE UP
                z = z + NoclipSpeed
            end
            
			if IsDisabledControlPressed(0, ConfigCL.Eight) then -- MOVE DOWN
                z = z - NoclipSpeed
            end
            
            SetEntityCoordsNoOffset(k, x, y, z, true, true, true)
        end  

		if invis then
            SetEntityVisible(PlayerPedId(), 0, 0)
        end

		if drawspectate then
			local targetPed = GetPlayerPed(drawTarget)
			local thaname = GetPlayerName(selectedPlayer)
			drawspectext("Spectating: "..thaname.."\nPress [E] to Stop Sneaking")
			
			if IsControlJustPressed(0, ConfigCL.PressE) then
				spectate(targetPed)
				StopDrawPlayerInfo()
			end
			
		end

		Citizen.Wait(1)
	end
end)
