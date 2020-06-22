local foodPeds = {
  -- Shops
  {model="mp_m_shopkeep_01", voice="GENERIC_HI", x=-47.4, y=-1758.7, z=28.4, a=46.395},
  {model="mp_m_shopkeep_01", voice="GENERIC_HI", x=24.376, y=-1345.558, z=28.421, a=267.940},
  {model="mp_m_shopkeep_01", voice="GENERIC_HI", x=1134.182, y=-982.477, z=45.416, a=275.432},
  {model="mp_m_shopkeep_01", voice="GENERIC_HI", x=373.015, y=328.332, z=102.566, a=257.309},
  {model="mp_m_shopkeep_01", voice="GENERIC_HI", x=2676.389, y=3280.362, z=54.241, a=332.305},
  {model="mp_m_shopkeep_01", voice="GENERIC_HI", x=1958.960, y=3741.979, z=31.344, a=303.196},
  {model="mp_m_shopkeep_01", voice="GENERIC_HI", x=-2966.391, y=391.324, z=14.043, a=88.867},
  {model="mp_m_shopkeep_01", voice="GENERIC_HI", x=-1698.542, y=4922.583, z=42.064, a=324.021},
  {model="mp_m_shopkeep_01", voice="GENERIC_HI", x=1164.565, y=-322.121, z=68.205, a=100.492},
  {model="mp_m_shopkeep_01", voice="GENERIC_HI", x=-1486.530, y=-377.768, z=39.163, a=147.669},
  {model="mp_m_shopkeep_01", voice="GENERIC_HI", x=-1221.568, y=-908.121, z=11.326, a=31.739},
  {model="mp_m_shopkeep_01", voice="GENERIC_HI", x=-706.153, y=-913.464, z=18.216, a=82.056},
  {model="mp_m_shopkeep_01", voice="GENERIC_HI", x=-1820.230, y=794.369, z=137.089, a=130.327},
  {model="mp_m_shopkeep_01", voice="GENERIC_HI", x=2555.474, y=380.909, z=107.623, a=355.737},
  {model="mp_m_shopkeep_01", voice="GENERIC_HI", x=1728.614, y=6416.729, z=34.037, a=247.369},
  {model="mp_m_shopkeep_01", voice="GENERIC_HI", x=1165.99, y=2710.8, z=37.2, a=174.78},
  {model="mp_m_shopkeep_01", voice="GENERIC_HI", x=-3040.58, y=583.86, z=6.9, a=18.28},
  {model="mp_m_shopkeep_01", voice="GENERIC_HI", x=-3244.163, y=1000.068, z=11.83, a=354.22},
  {model="mp_m_shopkeep_01", voice="GENERIC_HI", x=549.337, y=2669.48, z=41.15, a=91.95},
  {model="mp_m_shopkeep_01", voice="GENERIC_HI", x=1696.79, y=4923.478, z=41.15, a=325.66},
  -- ToolsMag
  {model="mp_m_shopkeep_01", voice="GENERIC_HI", x=2747.26, y=3473.01, z=54.66, a=249.40},
  -- AeroMag
  {model="mp_m_shopkeep_01", voice="GENERIC_HI", x=-1005.1, y=-2764.55, z=12.75, a=327.63},
  -- DrugDealer Weed
  --{model="a_m_m_og_boss_01", voice="GENERIC_HI", x=-1170.88, y=-1570.78, z=3.66, a=124.46}
}


Citizen.CreateThread(function()

	for k,v in ipairs(foodPeds) do
		RequestModel(GetHashKey(v.model))
		while not HasModelLoaded(GetHashKey(v.model)) do
			Wait(50)
		end

		local storePed = CreatePed(4, GetHashKey(v.model), v.x, v.y, v.z, v.a, false, false)
		SetBlockingOfNonTemporaryEvents(storePed, false)
    FreezeEntityPosition(storePed, true)
		--GiveWeaponToPed(storePed, 0x1D073A89, 2800, false, true)
		SetPedFleeAttributes(storePed, 0, 0)
		SetPedArmour(storePed, 200)
		SetPedMaxHealth(storePed, 200)
		SetPedDiesWhenInjured(storePed, true)
		SetAmbientVoiceName(storePed, v.voice)
		TaskStartScenarioInPlace(storePed, "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT", 0, 0)

		SetModelAsNoLongerNeeded(GetHashKey(v.model))
	end
end)

-- LSPD
local lspdPeds = {
  -- lspd armurerie
  --{model="s_m_m_armoured_01", voice="GENERIC_HI", x=454.05, y=-980.02, z=29.68, a=85.60},
  -- lspd entrée
  --{model="s_m_y_cop_01", voice="GENERIC_HI", x=433.43, y=-985.62, z=29.7, a=67.64},
  --{model="s_f_y_cop_01", voice="GENERIC_HI", x=433.8, y=-978.41, z=29.7, a=67.64}
}


Citizen.CreateThread(function()
  if NetworkIsHost() then
    if (not generalLoaded) then

      for k,v in ipairs(lspdPeds) do
        RequestModel(GetHashKey(v.model))
        while not HasModelLoaded(GetHashKey(v.model)) do
          Wait(10)
        end

        local lspdPed = CreatePed(7, GetHashKey(v.model), v.x, v.y, v.z, v.a, false, false)
        SetEntityAsMissionEntity(lspdPed, true, true)
        FreezeEntityPosition(lspdPed, true)
        SetBlockingOfNonTemporaryEvents(lspdPed, false)
        --GiveWeaponToPed(lspdPed, 0x1D073A89, 2800, false, true)
        --SetPedFleeAttributes(lspdPed, 0, 0)
        --SetPedCombatAttributes(lspdPed, 16, 1)
        --SetPedCombatAttributes(lspdPed, 46, 1)
        SetPedArmour(lspdPed, 100)
        SetPedMaxHealth(lspdPed, 100)
        SetPedDiesWhenInjured(lspdPed, false)
        SetAmbientVoiceName(lspdPed, v.voice)
        TaskStartScenarioInPlace(lspdPed, "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT", 0, 0)
        SetPedSeeingRange(lspdPed, 15.0)

        SetModelAsNoLongerNeeded(GetHashKey(v.model))
        generalLoaded = true
      end
    end
  end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if GetPlayerWantedLevel(PlayerId()) ~= 0 then
            SetPlayerWantedLevel(PlayerId(), 0, false)
            SetPlayerWantedLevelNow(PlayerId(), false)
        end
    end
end)