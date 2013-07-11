ground = {}

--------------------
-- Mapgen aliases --
--------------------
minetest.register_alias("mapgen_air", "air")
minetest.register_alias("mapgen_stone", "ground:stone")
minetest.register_alias("mapgen_dirt", "ground:dirt")
minetest.register_alias("mapgen_dirt_with_grass", "ground:dirt_with_grass")
minetest.register_alias("mapgen_sand", "ground:sand")
minetest.register_alias("mapgen_gravel", "ground:gravel")
minetest.register_alias("mapgen_clay", "ground:sand")
minetest.register_alias("mapgen_desert_sand", "ground:sand")
minetest.register_alias("mapgen_desert_stone", "ground:sandstone")
minetest.register_alias("mapgen_cobble", "ground:cobble")
minetest.register_alias("mapgen_mossycobble", "ground:mossycobble")
minetest.register_alias("mapgen_water_source", "ground:water_source")
minetest.register_alias("mapgen_lava_source", "ground:lava_source")
-- Don't generate trees, they are done in the "trees" mod
minetest.register_alias("mapgen_tree", "air")
minetest.register_alias("mapgen_leaves", "air")
minetest.register_alias("mapgen_jungletree", "air")
minetest.register_alias("mapgen_jungleleaves", "air")
minetest.register_alias("mapgen_apple", "air")
minetest.register_alias("mapgen_junglegrass", "air")
-- Don't generate ores, they are done in the "ores" mod
minetest.register_alias("mapgen_stone_with_coal", "mapgen_stone")
minetest.register_alias("mapgen_stone_with_iron", "mapgen_stone")
minetest.register_alias("mapgen_mese", "mapgen_stone")

-----------------------
-- Biome definitions --
-----------------------
minetest.register_biome({
	name = "normal",
	node_top = "ground:dirt_with_grass",
	depth_top = 1,
	node_filler = "ground:dirt",
	depth_filler = 1,
	height_min = 4,
	height_max = 31000,
	heat_point = 40.0,
	humidity_point = 40.0,
})
minetest.register_biome({
	name = "desert",
	node_top = "ground:sand",
	depth_top = 3,
	node_filler = "ground:sandstone",
	depth_filler = 10,
	height_min = 4,
	height_max = 31000,
	heat_point = 60.0,
	humidity_point = 20.0,
})
minetest.register_biome({
	name = "beach",
	node_top = "ground:sand",
	depth_top = 2,
	node_filler = "ground:sand",
	depth_filler = 1,
	height_min = 0,
	height_max = 4,
	heat_point = 40.0,
	humidity_point = 40.0,
})
minetest.register_biome({
	name = "ocean_dirt",
	node_top = "ground:dirt",
	depth_top = 1,
	node_filler = "ground:dirt",
	depth_filler = 1,
	height_min = -31000,
	height_max = 0,
	heat_point = 40.0,
	humidity_point = 60.0,
})
minetest.register_biome({
	name = "ocean_sand",
	node_top = "ground:sand",
	depth_top = 2,
	node_filler = "ground:sand",
	depth_filler = 1,
	height_min = -31000,
	height_max = 0,
	heat_point = 40.0,
	humidity_point = 60.0,
})

------------------
-- On_generated --
------------------
minetest.register_decoration({
	deco_type = "simple",
	place_on = "ground:dirt_with_grass",
	sidelen = 16,
	fill_ratio = 0.02,
	decoration = "ground:pebbles",
	height = 1,
})

----------------------
-- Node definitions -- TODO: swamp biomes
----------------------
minetest.register_node("ground:stone", {
	description = "Stone",
	tiles = {"ground_stone.png"},
	groups = {cracky=3},
	sounds = mind_mi.stone_sounds,
})
minetest.register_node("ground:pebbles", {
	description = "Pebbles (node)",
	tiles = {"ground_stone.png"},
	groups = {cracky=4, falling_node=1},
	sounds = mind_mi.stone_sounds,
	buildable_to = true,
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-7/16, -8/16, -2/16, -5/16, -7/16, -1/16},
			{-5/16, -8/16, 4/16,  -4/16, -7/16, 6/16},
			{-3/16, -8/16, -3/16, -1/16, -6/16, -1/16},
			{6/16,  -8/16, -5/16, 8/16,  -7/16, -3/16},
			{1/16,  -8/16, 2/16,  2/16,  -6/16, 3/16},
			{3/16,  -8/16, 5/16,  4/16,  -7/16, 6/16},
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {-.5,-.5,-.5,.5,-6/16,.5},
	},
	drop = '"ground:pebble" 2',
})
minetest.register_craftitem("ground:pebble", {
	description = "Pebble",
	inventory_image = "ground_pebble.png",
})
minetest.register_node("ground:cobble", {
	description = "Cobblestone",
	tiles = {"ground_cobble.png"},
	groups = {cracky=3},
	sounds = mind_mi.stone_sounds,
})
minetest.register_node("ground:mossycobble", {
	description = "Mossy cobblestone",
	tiles = {"ground_mossycobble.png"},
	groups = {cracky=3},
	sounds = mind_mi.stone_sounds,
})
-- cobble will become mossy cobble in presence of water
minetest.register_abm({
	nodenames = {"ground:cobble"},
	neighbors = {"ground:water_source","ground:water_flowing"},
	interval = 5.0,
	chance = 10,
	action = function(pos,...)
		minetest.set_node(pos,{name="ground:mossycobble"})
	end,
})
minetest.register_craft({
	output = '"ground:pebble" 9',
	recipe = {{"ground:stone"}},
})
minetest.register_craft({
	output = '"ground:pebble" 9',
	recipe = {{"ground:cobble"}},
})
minetest.register_craft({
	output = "ground:cobble",
	recipe = {
		{"ground:pebble","ground:pebble","ground:pebble"},
		{"ground:pebble","ground:pebble","ground:pebble"},
		{"ground:pebble","ground:pebble","ground:pebble"},
	},
})
minetest.register_node("ground:dirt", {
	description = "Dirt",
	tiles = {"ground_dirt.png"},
	groups = {crumbly=3,falling_node=1},
	sounds = mind_mi.dirt_sounds,
})
minetest.register_node("ground:dirt_with_grass", {
	description = "Dirt with grass",
	tiles = {"ground_grass.png","ground_dirt.png","ground_dirt.png^ground_grass_side.png"},
	groups = {crumbly=3,falling_node=1},
	drop = "ground:dirt",
	sounds = mind_mi.grass_sounds,
})
minetest.register_node("ground:gravel", {
	description = "Gravel",
	tiles = {"ground_gravel.png"},
	groups = {crumbly=2,falling_node=1},
	sounds = mind_mi.gravel_sounds,
})
minetest.register_node("ground:sand", {
	description = "Sand",
	tiles = {"ground_sand.png"},
	groups = {crumbly=3,falling_node=1},
	sounds = mind_mi.sand_sounds,
})
minetest.register_node("ground:clay", {
	description = "Clay block",
	tiles = {"ground_clay.png"},
	drop = "ground:clay_lump 4",
	groups = {crumbly=3, falling_node=1},
	sounds = mind_mi.dirt_sounds,
})
minetest.register_node("ground:brick", {
	description = "Brick block",
	tiles = {"ground_brick.png"},
	groups = {crumbly=3},
	sounds = mind_mi.stone_sounds,
})
minetest.register_craftitem("ground:clay_lump", {
	description = "Clay lump",
	inventory_image = "ground_clay_lump.png",
})
minetest.register_craftitem("ground:clay_brick", {
	description = "Clay brick",
	inventory_image = "ground_clay_brick.png",
})
minetest.register_craft({
	type = "cooking",
	output = "ground:clay_brick",
	recipe = "ground:clay_lump",
})
minetest.register_craft({
	output = "ground:clay",
	recipe = {
		{"ground:clay_lump","ground:clay_lump"},
		{"ground:clay_lump","ground:clay_lump"},
	},
})
minetest.register_craft({
	output = "ground:brick",
	recipe = {
		{"ground:clay_brick","ground:clay_brick"},
		{"ground:clay_brick","ground:clay_brick"},
	},
})
minetest.register_ore({
	ore_type = "scatter",
	ore = "ground:clay",
	wherein = "ground:sand",
	clust_scarcity = 20*20*20,
	clust_num_ores = 56,
	clust_size = 4,
	height_min = -10,
	height_max = 0,
})
minetest.register_node("ground:sandstone", {
	description = "Sandstone",
	tiles = {"ground_sandstone.png"},
	groups = {cracky=3},
	sounds = mind_mi.stone_sounds,
})
minetest.register_node("ground:sandstone_brick", {
	description = "Sandstone brick",
	tiles = {"ground_sandstone_brick.png"},
	groups = {cracky=3},
	sounds = mind_mi.stone_sounds,
})
minetest.register_craft({
	output = "ground:sandstone_brick",
	recipe = {
		{"ground:sandstone","ground:sandstone"},
		{"ground:sandstone","ground:sandstone"},
	},
})
-- Should darkstone be in ores mod?
minetest.register_node("ground:darkstone", {
	description = "Darkstone",
	tiles = {"ground_darkstone.png"},
	groups = {cracky=1},
	sounds = mind_mi.stone_sounds,
})
minetest.register_ore({
	ore_type = "scatter",
	ore = "ground:darkstone",
	wherein = "ground:stone",
	clust_scarcity = 40*40*40,
	clust_num_ores = 100,
	clust_size = 6,
	height_min = -31000,
	height_max = -200,
})
minetest.register_node("ground:water_source", {
	description = "Water",
	tiles = {
		{name="ground_water_source_animated.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=2.0}}
	},
	special_tiles = {
		-- New-style water source material (mostly unused)
		{
			name="ground_water_source_animated.png",
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=2.0},
			backface_culling = false,
		}
	},
	paramtype = "light",
	drawtype = "liquid",
	liquidtype = "source",
	alpha = 160,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	liquid_alternative_flowing = "ground:water_flowing",
	liquid_alternative_source = "ground:water_source",
	liquid_viscosity = 1,
	post_effect_color = {a=50, r=0, g=105, b=255},
})
minetest.register_node("ground:water_flowing", {
	description = "Flowing water",
	tiles = {"ground_water.png"},
	special_tiles = {
		{
			image="ground_water_flowing_animated.png",
			backface_culling=false,
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=0.8}
		},
		{
			image="ground_water_flowing_animated.png",
			backface_culling=true,
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=0.8}
		},
	},
	paramtype = "light",
	drawtype = "flowingliquid",
	liquidtype = "flowing",
	alpha = 160,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	liquid_alternative_flowing = "ground:water_flowing",
	liquid_alternative_source = "ground:water_source",
	liquid_viscosity = 1,
	post_effect_color = {a=50, r=0, g=105, b=255},
})

minetest.register_node("ground:lava_source", {
	description = "Lava",
	tiles = {"ground_lava.png"},
	special_tiles = {"ground_lava.png"},
	light_source = 14,
	paramtype = "light",
	drawtype = "liquid",
	liquidtype = "source",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	liquid_alternative_flowing = "ground:lava_flowing",
	liquid_alternative_source = "ground:lava_source",
	liquid_viscosity = 1,
	post_effect_color = {a=255, r=255, g=0, b=0},
})
minetest.register_node("ground:lava_flowing", {
	description = "Flowing lava",
	tiles = {"ground_lava.png"},
	special_tiles = {"ground_lava.png","ground_lava.png"},
	light_source = 14,
	paramtype = "light",
	drawtype = "flowingliquid",
	liquidtype = "flowing",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	liquid_alternative_flowing = "ground:lava_flowing",
	liquid_alternative_source = "ground:lava_source",
	liquid_viscosity = 1,
	post_effect_color = {a=255, r=255, g=0, b=0},
})


