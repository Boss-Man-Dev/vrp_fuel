local cfg = {}

cfg.pay = true							-- bypas payment (testing is false)
cfg.wallet = true

cfg.decor = "_FUEL_LEVEL"				-- no need to change this
cfg.multiplier = 1.0					--Modify the fuel-cost here

--speedometer
cfg.hud = true

cfg.speedometer = {	
	-- each x is 0.04 above each other
	mph = {
		0.26,		-- x
		0.882,		-- y
		0.005,		-- width
		0.0028,		-- height
		0.6,		-- scale
		255,		-- red
		255,		-- green
		255,		-- blue
		255,		-- alpha
		6,			-- font
		1,			-- jus
	},
	kmh = {
		0.26,		-- x
		0.922,		-- y
		0.005,		-- width
		0.0028,		-- height
		0.6,		-- scale
		255,		-- red
		255,		-- green
		255,		-- blue
		255,		-- alpha
		6,			-- font
		1,			-- jus
	},
	fuel = {
		0.26,		-- x
		0.962,		-- y
		0.005,		-- width
		0.0028,		-- height
		0.6,		-- scale
		255,		-- red
		255,		-- green
		255,		-- blue
		255,		-- alpha
		6,			-- font
		1,			-- jus
	}
}

-- the higher the rating the more fuel will be consumed
cfg.impact = {
	cunsumption = 1,			--defautl: 1
	rpm = 0.0005,				--defautl: 0.0005
	acceleration = 0.0002,		--defautl: 0.0002
	traction = 0.0001			--defautl: 0.0001
}

cfg.DisableKeys = {
    [0] = true,				-- ["V"]
    [8] = false,			-- ["S"]
    [9] = false,			-- ["D"]
    [10] = false,			-- ["PAGEUP"]
    [11] = false,			-- ["PAGEDOWN"]
    [18] = false,			-- ["ENTER"]
    [19] = false,			-- ["LEFTALT"]
    [20] = false,			-- ["Z"]
    [21] = false,			-- ["LEFTSHIFT"]
    [22] = true,			-- ["SPACE"]
    [23] = true,			-- ["F"]
    [26] = false,			-- ["C"]
    [27] = false,			-- ["UP"]
    [29] = true,			-- ["B"]
    [32] = false,			-- ["W"]
    [34] = false,			-- ["A"]
    [36] = false,			-- ["LEFTCTRL"]
    [37] = true,			-- ["TAB"]
    [38] = false,			-- ["E"]
    [39] = false,			-- ["["]
    [40] = false,			-- ["]"]
    [44] = true,			-- ["Q"]
    [45] = false,			-- ["R"]
    [47] = false,			-- ["G"]
    [56] = true,			-- ["F9"]
    [57] = false,			-- ["F10"]
    [60] = false,			-- ["N5"]
    [61] = false,			-- ["N8"]
    [70] = false,			-- ["RIGHTCTRL"]
    [73] = false,			-- ["X"]
    [74] = false,			-- ["H"]
    [81] = false,			-- ["."]
    [82] = true,			-- [","]
    [83] = false,			-- ["="]
    [84] = false,			-- ["-"]
    [96] = false,			-- ["N+"]
    [97] = false,			-- ["N-"]
    [107] = false,			-- ["N6"]
    [108] = false,			-- ["N4"]
    [117] = false,			-- ["N7"]
    [118] = false,			-- ["N9"]
    [137] = false,			-- ["CAPS"]
    [157] = false,			-- ["1"]
    [158] = false,			-- ["2"]
    [159] = false,			-- ["6"]
    [160] = false,			-- ["3"]
    [161] = false,			-- ["7"]
    [162] = false,			-- ["8"]
    [163] = false,			-- ["9"]
    [164] = false,			-- ["4"]
    [165] = false,			-- ["5"]
    [166] = true,			-- ["F5"]
    [167] = true,			-- ["F6"]
    [168] = true,			-- ["F7"]
    [169] = true,			-- ["F8"]
    [170] = true,			-- ["F3"]
    [173] = false,			-- ["DOWN"]
    [174] = false,			-- ["LEFT"]
    [175] = false,			-- ["RIGHT"]
    [177] = false,			-- ["BACKSPACE"]
    [178] = false,			-- ["DELETE"]
    [182] = false,			-- ["L"]
    [199] = false,			-- ["P"]
    [201] = false,			-- ["NENTER"]
    [213] = false,			-- ["HOME"]
    [243] = false,			-- ["~"]
    [244] = false,			-- ["M"]
    [245] = false,			-- ["T"]
    [246] = false,			-- ["Y"]
    [249] = false,			-- ["N"]
    [288] = false,			-- ["F1"]
    [289] = false,			-- ["F2"]
    [303] = false,			-- ["U"]
    [311] = true,			-- ["K"]
	[322] = true			-- ["ESC"]
}

--https://gtahash.ru/?s=gas_pump	-- list of all gas pumps
-- list of all gas pump props
cfg.pumps = {
	[1339433404] = true,	-- prop_gas_pump_1a
	[1694452750] = true,	-- prop_gas_pump_1b
	[1933174915] = true,	-- prop_gas_pump_1c
	[-2007231801] = true,	-- prop_gas_pump_1d
	[-462817101] = true,	-- prop_vintage_pump
	[-469694731] = true,	-- prop_gas_pump_old2
	[-164877493] = true		-- prop_gas_pump_old3
}

-- Blacklist certain vehicles. 
--Use names. https://wiki.gtanet.work/index.php?title=Vehicle_Models
cfg.blacklist = {
	--"Adder",
	--"Dinghy2",
	"BJXL"
}

-- Class multipliers. If you want SUVs to use less fuel, 
-- you can change it to anything under 1.0, and vise versa.
cfg.classes = {
	[0] = 1.0, -- Compacts
	[1] = 1.0, -- Sedans
	[2] = 1.0, -- SUVs
	[3] = 1.0, -- Coupes
	[4] = 1.0, -- Muscle
	[5] = 1.0, -- Sports Classics
	[6] = 1.0, -- Sports
	[7] = 1.0, -- Super
	[8] = 1.0, -- Motorcycles
	[9] = 1.0, -- Off-road
	[10] = 1.0, -- Industrial
	[11] = 1.0, -- Utility
	[12] = 1.0, -- Vans
	[13] = 0.0, -- Cycles
	[14] = 1.0, -- Boats
	[15] = 1.0, -- Helicopters
	[16] = 1.0, -- Planes
	[17] = 1.0, -- Service
	[18] = 1.0, -- Emergency
	[19] = 1.0, -- Military
	[20] = 1.0, -- Commercial
	[21] = 1.0, -- Trains
}

-- The left part is at percentage RPM, and the right is how much fuel 
-- (divided by 10) you want to remove from the tank every second
cfg.usuage = {
	[1.0] = 1.4,
	[0.9] = 1.2,
	[0.8] = 1.0,
	[0.7] = 0.9,
	[0.6] = 0.8,
	[0.5] = 0.7,
	[0.4] = 0.5,
	[0.3] = 0.4,
	[0.2] = 0.2,
	[0.1] = 0.1,
	[0.0] = 0.0,
}

cfg.marker = {
	-- marker https://docs.fivem.net/docs/game-references/blips/
	--color={r,g,b,a}
	Station = {
		"PoI",{ blip_id = 361, blip_color = 4}
	},
	
	pump = {		-- x,y,z is handled internally
		1,			-- 	type [[ integer ]]
		--x,			--	posX [[ number ]] 
		--y,			--	posY --[[ number ]]
		--z,			--	posZ --[[ number ]]
		0.0,		--	dirX --[[ number ]]
		0.0,		--	dirY --[[ number ]]
		0.0,		--	dirZ --[[ number ]]
		0.0,		--	rotX --[[ number ]]
		180.0,		--	rotY --[[ number ]]
		0.0,		--	rotZ --[[ number ]]
		2.0,		--	scaleX --[[ number ]]
		2.0,		--	scaleY --[[ number ]]
		2.0,		--	scaleZ --[[ number ]]
		255,		--	red --[[ integer ]]
		128,		--	green --[[ integer ]]
		0,			--	blue --[[ integer ]]
		100,		--	alpha --[[ integer ]]
		false,		--	bobUpAndDown --[[ boolean ]]
		true,		--	faceCamera --[[ boolean ]]
		2,			--	p19 --[[ integer ]]
		nil,		--	textureDict --[[ string ]]
		nil,		--	textureName --[[ string ]]
		false		--	drawOnEnts --[[ boolean ]]
	}
}

cfg.gas_station = {
	--{Name, Gtype, Cords}
	{"Vinewood", 		"Station", 49.4187, 2778.793, 58.043},
	{"Vinewood", 		"Station", 263.894, 2606.463, 44.983},
	{"Vinewood", 		"Station", 1039.958, 2671.134, 39.550},
	{"Vinewood", 		"Station", 1207.260, 2660.175, 37.899},
	{"Vinewood", 		"Station", 2539.685, 2594.192, 37.944},
	{"Vinewood", 		"Station", 2679.858, 3263.946, 55.240},
	{"Vinewood", 		"Station", 2005.055, 3773.887, 32.403},
	{"Vinewood", 		"Station", 1687.156, 4929.392, 42.078},
	{"Vinewood", 		"Station", 1701.314, 6416.028, 32.763},
	{"Vinewood", 		"Station", 179.857, 6602.839, 31.868},
	{"Vinewood", 		"Station", -94.4619, 6419.594, 31.489},
	{"Vinewood", 		"Station", -2554.996, 2334.40, 33.078},
	{"Vinewood", 		"Station", -1800.375, 803.661, 138.651},
	{"Vinewood", 		"Station", -1437.622, -276.747, 46.207},
	{"Vinewood", 		"Station", -2096.243, -320.286, 13.168},
	{"Vinewood", 		"Station", -724.619, -935.1631, 19.213},
	{"Vinewood", 		"Station", -526.019, -1211.003, 18.184},
	{"Vinewood", 		"Station", -70.2148, -1761.792, 29.534},
	{"Vinewood", 		"Station", 265.648, -1261.309, 29.292},
	{"Vinewood", 		"Station", 819.653, -1028.846, 26.403},
	{"Vinewood", 		"Station", 1208.951, -1402.567,35.224},
	{"Vinewood", 		"Station", 1181.381, -330.847, 69.316},
	{"Vinewood", 		"Station", 620.843, 269.100, 103.089},
	{"Vinewood", 		"Station", 2581.321, 362.039, 108.468},
	{"Vinewood", 		"Station", 176.631, -1562.025, 29.263},
	{"Vinewood", 		"Station", 176.631, -1562.025, 29.263},
	{"Vinewood", 		"Station", -319.292, -1471.715, 30.549},
	{"Vinewood", 		"Station", 1784.324, 3330.55, 41.253}
}
return cfg