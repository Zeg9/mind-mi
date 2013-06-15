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
minetest.register_alias("mapgen_cobble", "ground:stone") --TODO cobble and mossy cobble
minetest.register_alias("mapgen_mossycobble", "ground:stone")
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

------------
-- Sounds --
------------
ground.stone_sounds = {
	--footstep = <SimpleSoundSpec>,
	dug = "ground_break_stone",
	place = "ground_place_stone",
}
ground.sand_sounds = {
	footstep = {name="ground_footstep_sand",gain=0.25},
	dug = "ground_break_sand",
	place = "ground_place_stone",
}
ground.dirt_sounds = {
	dug = "ground_break_dirt",
	place = "ground_place_stone",
}

----------------------
-- Node definitions --
----------------------
minetest.register_node("ground:stone", {
	description = "Stone",
	tiles = {"ground_stone.png"},
	groups = {cracky=3},
	sounds = ground.stone_sounds,
})
minetest.register_node("ground:dirt", {
	description = "Dirt",
	tiles = {"ground_dirt.png"},
	groups = {crumbly=3},
	sounds = ground.dirt_sounds,
})
minetest.register_node("ground:dirt_with_grass", {
	description = "Dirt with grass",
	tiles = {"ground_grass.png","ground_dirt.png","ground_dirt.png^ground_grass_side.png"},
	groups = {crumbly=3},
	drop = "ground:dirt",
	sounds = ground.dirt_sounds,
})
minetest.register_node("ground:gravel", {
	description = "Gravel",
	tiles = {"ground_gravel.png"},
	groups = {crumbly=2,falling_node=1},
	sounds = ground.sand_sounds,
})
minetest.register_node("ground:sand", {
	description = "Sand",
	tiles = {"ground_sand.png"},
	groups = {crumbly=3,falling_node=1},
	sounds = ground.sand_sounds,
})
minetest.register_node("ground:sandstone", {
	description = "Sandstone",
	tiles = {"ground_sandstone.png"},
	groups = {cracky=4},
	sounds = ground.stone_sounds,
})
minetest.register_node("ground:water_source", {
	description = "Water",
	tiles = {"ground_water.png"},
	special_tiles = {"ground_water.png"},
	paramtype = "light",
	drawtype = "liquid",
	liquidtype = "source",
	alpha = 100,
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
	special_tiles = {"ground_water.png","ground_water.png"},
	paramtype = "light",
	drawtype = "flowingliquid",
	liquidtype = "flowing",
	alpha = 100,
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


