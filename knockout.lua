Framework = nil
local knockedOut = false
local count = 60

Citizen.CreateThread(function()
    if Config.core == "qb" then
        while Framework == nil do
            Framework = exports['qb-core']:GetCoreObject()
            Citizen.Wait(4)
        end
    elseif Config.core == "esx" then
        while Framework == nil do
            Framework = exports["es_extended"]:getSharedObject()
            Citizen.Wait(4)
        end
    elseif Config.core == false then
			
	else
        print("You didnt configure esx or qbcore in config, if your using custom core edit knockout.lua and change core object!!!!")
        print("You didnt configure esx or qbcore in config, if your using custom core edit knockout.lua and change core object!!!!")
        print("You didnt configure esx or qbcore in config, if your using custom core edit knockout.lua and change core object!!!!")
        print("You didnt configure esx or qbcore in config, if your using custom core edit knockout.lua and change core object!!!!")
        print("You didnt configure esx or qbcore in config, if your using custom core edit knockout.lua and change core object!!!!")
        print("You didnt configure esx or qbcore in config, if your using custom core edit knockout.lua and change core object!!!!")
        print("You didnt configure esx or qbcore in config, if your using custom core edit knockout.lua and change core object!!!!")
        print("You didnt configure esx or qbcore in config, if your using custom core edit knockout.lua and change core object!!!!")
        print("You didnt configure esx or qbcore in config, if your using custom core edit knockout.lua and change core object!!!!")
        print("You didnt configure esx or qbcore in config, if your using custom core edit knockout.lua and change core object!!!!")
        --[[ while Framework == nil do
            Framework = exports["es_extended"]:getSharedObject()
            Citizen.Wait(4)
        end ]]
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1)
        local Ped = PlayerPedId()
        -- With melee weapon or unarmed only
        if IsPedInMeleeCombat(Ped) then
            -- Without any kind of weapon {UNARMED ONLY}
            if (HasPedBeenDamagedByWeapon(Ped, GetHashKey("WEAPON_UNARMED"), 0) )then
                -- Health to be knocked out
                if GetEntityHealth(Ped) < 145 then
                    local math = math.random(1, Config.chance)
                    if math == 1 then
			    SetPlayerInvincible(PlayerId(), false)
			    -- Position taken by your Ped
			    SetPedToRagdoll(Ped, 1000, 1000, 0, 0, 0, 0)
			    --  Effect 
			    ShakeGameplayCam('LARGE_EXPLOSION_SHAKE', 2.5)
			    -- Time to wait
			    wait = Config.knockoutDurantion
			    if Config.core == 'qb' then
				Framework.Functions.Progressbar("random_task", "You are knocked out", Config.progressbarDurantion, false, true, {
				    disableMovement = false,
				    disableCarMovement = false,
				    disableMouse = false,
				    disableCombat = true,
				}, {
				    animDict = "mp_suicide",
				    anim = "pill",
				    flags = 49,
				}, {}, {}, function()
				    -- Done
				    StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
				end, function() -- Cancel
				    StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
				end)
			    elseif Config.core == 'esx' then
				    ESX.Progressbar("test", 25000,{
					FreezePlayer = false, 
					animation ={
					    type = "anim",
					    dict = "mp_suicide", 
					    lib ="pill" 
					}, 
					onFinish = function()
					--Code here
				    end})
			    else
        			--print("You need to configure your own progressbar")
				--exports['progressBars']:startUI(Config.progressbarDurantion, "You are knocked out")
				lib.progressBar({label = 'Sinut saatiin tajuttomaksi', duration = Config.progressbarDurantion, anim = { dict = 'mp_suicide', clip = 'pill', flag = 49}}) 
			    end
			    knockedOut = true
			    -- Health after knockout preferably dont make it more than 150 (50 %) because people will abuse with it {No need to go to hospital or so}
			    SetEntityHealth(Ped, 125)
                    end	
                end
            end
        end
        
        if knockedOut == true then        
            --Your ped is able to die
            SetPlayerInvincible(PlayerId(), false)
            DisablePlayerFiring(PlayerId(), true)
            SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
            ResetPedRagdollTimer(myPed)
            SetTimecycleModifier('Bloom')
            SetTimecycleModifierStrength(2.8);
            -- Cam vibration
            ShakeGameplayCam("VIBRATE_SHAKE", 1.0)
			if wait >= 0 then
				count = count - 1
                if count == 0 then
                    
					count = 60
					wait = wait - 1
					--- in case bark
                    if GetEntityHealth(myPed) <= 50 then
                        -- Ped healing 
						SetEntityHealth(myPed, GetEntityHealth(myPed)+2)
						
					end
				end
            else
                -- Remove red cam
                ClearTimecycleModifier()	
                -- Ped Able to die again
				SetPlayerInvincible(PlayerId(), false)
				knockedOut = false
			end
		end

	end
end)
