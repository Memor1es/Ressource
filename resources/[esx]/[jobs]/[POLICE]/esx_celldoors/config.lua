dzdConfig = {}
Config.Locale = 'fr'

Config.DoorList = {

	--
	-- Mission Row First Floor
	--

	-- Entrance Doors
	{
		objName = 'v_ilev_ph_door01',
		objCoords  = {x = 434.747, y = -980.618, z = 30.839},
		textCoords = {x = 434.747, y = -981.50, z = 31.50},
		authorizedJobs = { 'police' },
		locked = false,
		distance = 2.5
	},

	{
		objName = 'v_ilev_ph_door002',
		objCoords  = {x = 434.747, y = -983.215, z = 30.839},
		textCoords = {x = 434.747, y = -982.50, z = 31.50},
		authorizedJobs = { 'police' },
		locked = false,
		distance = 2.5
	},

	-- To locker room & roof
	{
		objName = 'v_ilev_ph_gendoor004',
		objCoords  = {x = 449.698, y = -986.469, z = 30.689},
		textCoords = {x = 450.104, y = -986.388, z = 31.739},
		authorizedJobs = { 'police' },
		locked = true
	},

	-- Rooftop
	{
		objName = 'v_ilev_gtdoor02',
		objCoords  = {x = 464.361, y = -984.678, z = 43.834},
		textCoords = {x = 464.361, y = -984.050, z = 44.834},
		authorizedJobs = { 'police' },
		locked = true
	},

	-- Hallway to roof
	{
		objName = 'v_ilev_arm_secdoor',
		objCoords  = {x = 461.286, y = -985.320, z = 30.839},
		textCoords = {x = 461.50, y = -986.00, z = 31.50},
		authorizedJobs = { 'police' },
		locked = true
	},

	-- Armory
	{
		objName = 'v_ilev_arm_secdoor',
		objCoords  = {x = 453.11, y = -982.702, z = 30.689},
		textCoords = {x = 453.079, y = -982.600, z = 30.739},
		authorizedJobs = { 'police' },
		locked = true
	},

	-- Captain Office 11111111111111111111111111111111111111111111111111111111111
	{
		objName = 'v_ilev_ph_gendoor002',
		objCoords  = {x = 447.238, y = -980.630, z = 30.689},
		textCoords = {x = 447.200, y = -980.010, z = 31.739},
		authorizedJobs = { 'police' },
		locked = true
	},

	-- To downstairs (double doors)
	{
		objName = 'v_ilev_ph_gendoor005',
		objCoords  = {x = 443.97, y = -989.033, z = 30.6896},
		textCoords = {x = 444.020, y = -989.445, z = 31.739},
		authorizedJobs = { 'police' },
		locked = true,
		distance = 4
	},

	{
		objName = 'v_ilev_ph_gendoor005',
		objCoords  = {x = 445.37, y = -988.705, z = 30.6896},
		textCoords = {x = 445.350, y = -989.445, z = 31.739},
		authorizedJobs = { 'police' },
		locked = true,
		distance = 4
	},

	-- 
	-- Mission Row Cells
	--

	-- Main Cells


	-- Cell 1
	{
		objName = 'v_ilev_ph_cellgate',
		objCoords  = {x = 462.381, y = -993.651, z = 24.914},
		textCoords = {x = 461.806, y = -993.308, z = 25.064},
		authorizedJobs = { 'police' },
		locked = true
	},

	-- Cell 2
	{
		objName = 'v_ilev_ph_cellgate',
		objCoords  = {x = 462.331, y = -998.152, z = 24.914},
		textCoords = {x = 461.806, y = -998.800, z = 25.064},
		authorizedJobs = { 'police' },
		locked = true
	},

	-- Cell 3
	{
		objName = 'v_ilev_ph_cellgate',
		objCoords  = {x = 462.704, y = -1001.92, z = 24.9149},
		textCoords = {x = 461.806, y = -1002.450, z = 25.064},
		authorizedJobs = { 'police' },
		locked = true
	},
	


	-- To Back
	{
		objName = 'v_ilev_gtdoor',
		objCoords  = {x = 463.478, y = -1003.538, z = 25.005},
		textCoords = {x = 464.00, y = -1003.50, z = 25.50},
		authorizedJobs = { 'police' },
		locked = true
	},
	
	-- Cellule
	
	{
		objName = 'v_ilev_ph_cellgate',
		objCoords  = {x = 468.40, y = -999.48, z = 24.920},
		textCoords = {x = 468.40, y = -999.48, z = 24.920},
		authorizedJobs = { 'police' },
		locked = true
	},	
	
	{
		objName = 'v_ilev_ph_cellgate',
		objCoords  = {x = 471.89, y = -999.50, z = 24.920},
		textCoords = {x = 471.89, y = -999.50, z = 24.920},
		authorizedJobs = { 'police' },
		locked = true
	},	
	
	{
		objName = 'v_ilev_ph_cellgate',
		objCoords  = {x = 476.12, y = -1007.51, z = 24.27},
		textCoords = {x = 476.12, y = -1007.51, z = 24.27},
		authorizedJobs = { 'police' },
		locked = true
	},	
	
	{
		objName = 'v_ilev_ph_cellgate',
		objCoords  = {x = 479.53, y = -1007.61, z = 24.27},
		textCoords = {x = 479.53, y = -1007.61, z = 24.27},
		authorizedJobs = { 'police' },
		locked = true
	},		

	-- iNTEROGATOIRE


	-- Saisi


	-- Autres portes
	{
		objName = 'v_ilev_ph_gendoor006',
			objCoords  = {x = 468.24, y = -978.0, z = 23.94},
			textCoords = {x = 468.24, y = -978.0, z = 25.12},
			authorizedJobs = { 'police' },
			locked = true
	},

	-- Autres portes
	{
		objName = 'v_ilev_ph_gendoor006',
			objCoords  = {x = 463.59, y = -981.23, z = 23.94},
			textCoords = {x = 463.59, y = -981.23, z = 25.12},
			authorizedJobs = { 'police' },
			locked = true
	},





	{
		objName = 'v_ilev_ph_gendoor005',
			objCoords  = {x = 455.69, y = -981.36, z = 26.67},
			textCoords = {x = 455.69, y = -981.36, z = 26.67},
			authorizedJobs = { 'police' },
			distance = 2,
			locked = true
	},
	
	{
		objName = 'v_ilev_ph_gendoor005',
			objCoords  = {x = 470.40, y = -992.18, z = 24.92},
			textCoords = {x = 470.40, y = -992.18, z = 24.92},
			authorizedJobs = { 'police' },
			distance = 2,
			locked = true
	},	
	
	{
		objName = 'v_ilev_ph_gendoor005',
			objCoords  = {x = 465.61, y = -985.40, z = 25.56},
			textCoords = {x = 465.61, y = -985.40, z = 25.56},
			authorizedJobs = { 'police' },
			distance = 2,
			locked = true
	},	
	
	{
		objName = 'v_ilev_ph_gendoor005',
			objCoords  = {x = 455.47, y = -980.76, z = 26.67},
			textCoords = {x = 0, y = 0, z = 0},
			authorizedJobs = { 'police' },
			distance = 2,
			locked = true
	},	



	{
		objName = 'v_ilev_gtdoor',
			objCoords  = {x = 445.23, y = -998.98, z = 29.73},
			textCoords = {x = 445.23, y = -998.98, z = 30.73},
			authorizedJobs = { 'police' },
			distance = 2,
			locked = true
	},

	{
		objName = 'v_ilev_gtdoor',
		objCoords  = {x = 446.62, y = -998.98, z = 29.73},
		textCoords = {x = 446.62, y = -998.98, z = 30.73},
			authorizedJobs = { 'police' },
			distance = 2,
			locked = true
	},

	{
		objName = 'slb2k11_glassdoor',
			objCoords  = {x = 429.28, y = -995.72, z = 34.77},
			textCoords = {x = 429.28, y = -995.72, z = 36.10},
			authorizedJobs = { 'police' },
			distance = 2,
			locked = true
	},

	{
		objName = 'slb2k11_glassdoor',
			objCoords  = {x = 429.28, y = -994.6, z = 34.77},
			textCoords = {x = 429.28, y = -994.6, z = 36.10},
			authorizedJobs = { 'police' },
			distance = 2,
			locked = true
	},

	{
		objName = '',
			objCoords  = {x = 463.59, y = -981.23, z = 23.94},
			textCoords = {x = 463.59, y = -981.23, z = 25.12},
			authorizedJobs = { 'police' },
			locked = true
	},

	--
	-- Mission Row Back
	--

	-- Back (double doors)
	{
		objName = 'v_ilev_rc_door2',
		objCoords  = {x = 467.371, y = -1014.452, z = 26.536},
		textCoords = {x = 468.09, y = -1014.452, z = 27.1362},
		authorizedJobs = { 'police' },
		locked = true,
		distance = 4
	},

	{
		objName = 'v_ilev_rc_door2',
		objCoords  = {x = 469.967, y = -1014.452, z = 26.536},
		textCoords = {x = 469.35, y = -1014.452, z = 27.136},
		authorizedJobs = { 'police' },
		locked = true,
		distance = 4
	},

	-- Back Gate
	{
		objName = 'hei_prop_station_gate',
		objCoords  = {x = 488.894, y = -1017.210, z = 27.146},
		textCoords = {x = 488.894, y = -1020.210, z = 30.00},
		authorizedJobs = { 'police' },
		locked = true,
		distance = 14,
		size = 2
	},

	--
	-- Sandy Shores
	--

	-- Entrance
	{
		objName = 'v_ilev_shrfdoor',
		objCoords  = {x = 1855.105, y = 3683.516, z = 34.266},
		textCoords = {x = 1855.105, y = 3683.516, z = 35.00},
		authorizedJobs = { 'sheriff' },
		locked = true
	},

	--
	-- Paleto Bay
	--

	-- Entrance (double doors)
	{
		objName = 'v_ilev_shrf2door',
		objCoords  = {x = -443.14, y = 6015.685, z = 31.716},
		textCoords = {x = -443.14, y = 6015.685, z = 32.00},
		authorizedJobs = { 'police' },
		locked = false,
		distance = 2.5
	},

	{
		objName = 'v_ilev_shrf2door',
		objCoords  = {x = -443.951, y = 6016.622, z = 31.716},
		textCoords = {x = -443.951, y = 6016.622, z = 32.00},
		authorizedJobs = { 'police' },
		locked = false,
		distance = 2.5
	},

	--
	-- Bolingbroke Penitentiary
	--

	-- Entrance (Two big gates)
	{
		objName = 'prop_gate_prison_01',
		objCoords  = {x = 1844.998, y = 2604.810, z = 44.638},
		textCoords = {x = 1844.998, y = 2608.50, z = 48.00},
		authorizedJobs = { 'police' },
		locked = true,
		distance = 12,
		size = 2
	},

	{
		objName = 'prop_gate_prison_01',
		objCoords  = {x = 1818.542, y = 2604.812, z = 44.611},
		textCoords = {x = 1818.542, y = 2608.40, z = 48.00},
		authorizedJobs = { 'police' },
		locked = true,
		distance = 12,
		size = 2
	},
	

	--
	-- MECANO
	--
	
	{
		objName = 'lr_prop_supermod_door_01',
		objCoords  = {x = -205.6828, y = -1310.683, z = 30.29572},
		textCoords = {x = -205.73, y = -1310.55, z = 32.37},
		authorizedJobs = { 'mecano' },
		locked = true,
		distance = 12,
		size = 2
	},
	

	--
	-- Unicorn
	--

	{
		objName = 'prop_magenta_door',
		objCoords  = {x = 96.092, y = -1284.854, z = 29.438},
		textCoords = {x = 95.392, y = -1284.854, z = 29.738},
		authorizedJobs = { 'unicorn' },
		locked = true,
		distance = 2.5,
		size = 1
	},
        {
		objName = 'prop_strip_door_01',
		objCoords  = {x = 127.955, y = -1298.503, z = 29.419},
		textCoords = {x = 128.500, y = -1298.053, z = 29.719},
		authorizedJobs = { 'unicorn' },
		locked = true,
		distance = 10,
		size = 2
	},
	

	--[[
	-- Entrance Gate (Mission Row mod) https://www.gta5-mods.com/maps/mission-row-pd-ymap-fivem-v1
	{
		objName = 'prop_gate_airport_01',
		objCoords  = {x = 420.133, y = -1017.301, z = 28.086},
		textCoords = {x = 420.133, y = -1021.00, z = 32.00},
		authorizedJobs = { 'police' },
		locked = true,
		distance = 14,
		size = 2
	},
	--]]
	
	
	{
		objName = 'vw_prop_vw_casino_door_r_02a',
		objCoords  = {x = 923.4196, y = 42.70175, z = 81.54192},
		textCoords = {x = 923.4250, y = 42.70250, z = 81.54250},
		authorizedJobs = { 'casino' },
		locked = true,
		distance = 2.5,
		size = 2
	},
        {
		objName = 'vw_prop_vw_casino_door_02a',
		objCoords  = {x = 924.75, y = 44.83086, z = 81.54192},
		textCoords = {x = 924.100, y = 44.83250, z = 81.54250},
		authorizedJobs = { 'casino' },
		locked = true,
		distance = 2.5,
		size = 2
	},
	
	
	{
		objName = 'vw_prop_vw_casino_door_r_02a',
		objCoords  = {x = 924.9089, y = 45.085, z = 81.54192},
		textCoords = {x = 924.9250, y = 45.250, z = 81.54250},
		authorizedJobs = { 'casino' },
		locked = true,
		distance = 2.5,
		size = 2
	},
        {
		objName = 'vw_prop_vw_casino_door_02a',
		objCoords  = {x = 926.2393, y = 47.21412, z = 81.54192},
		textCoords = {x = 926.2250, y = 47.21250, z = 81.54250},
		authorizedJobs = { 'casino' },
		locked = true,
		distance = 2.5,
		size = 2
	},
	
	
	{
		objName = 'vw_prop_vw_casino_door_r_02a',
		objCoords  = {x = 926.4083, y = 47.47442, z = 81.54192},
		textCoords = {x = 926.4250, y = 47.47250, z = 81.54250},
		authorizedJobs = { 'casino' },
		locked = true,
		distance = 2.5,
		size = 2
	},
        {
		objName = 'vw_prop_vw_casino_door_02a',
		objCoords  = {x = 927,7387, y = 49,60353, z = 81,54192},
		textCoords = {x = 927,7250, y = 49,60250, z = 81.54250},
		authorizedJobs = { 'casino' },
		locked = true,
		distance = 2.5,
		size = 2
	},
	
}

---------------------------------
--- Copyright by ikNox#6088 ---
---------------------------------