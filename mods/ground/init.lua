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
minetest.register_alias("mapgen_cobble", "ground:cobble") --TODO mossy cobble (with abm of course)
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

------------------
-- On_generated --
------------------

minetest.register_on_generated(function(minp, maxp, seed)
	local pr = PseudoRandom(seed+12)
	-- Generate pebbles
	local pebbles_count = pr:next(0,100)
	for i=0,pebbles_count do
		local p = {}
		p.x = minp.x+pr:next(0,maxp.x-minp.x)
		p.z = minp.z+pr:next(0,maxp.z-minp.z)
		for y=minp.y,maxp.y do
			p.y = y
			if minetest.get_node(p).name == "ground:dirt_with_grass" then
				p.y = p.y +1
				minetest.set_node(p, {name="ground:pebbles"})
				break
			end
		end
	end
end)

------------
-- Sounds --
------------
ground.stone_sounds = {
	footstep = {name="ground_footstep_stone",gain=0.25},
	dug = {name="ground_break_stone",gain=0.5},
	place = {name="ground_place_stone",gain=0.5},
}
ground.sand_sounds = {
	footstep = {name="ground_footstep_sand",gain=0.25},
	dug = "ground_break_sand",
	place = "ground_place_sand",
}
ground.dirt_sounds = {
	footstep = "ground_footstep_dirt",
	dug = "ground_break_dirt",
	place = "ground_place_dirt",
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
minetest.register_node("ground:pebbles", {
	description = "Pebbles (node)",
	tiles = {"ground_stone.png"},
	groups = {cracky=4, falling_node=1},
	sounds = ground.stone_sounds,
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
	sounds = ground.stone_sounds,
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
	sounds = ground.dirt_sounds,
})
minetest.register_node("ground:dirt_with_grass", {
	description = "Dirt with grass",
	tiles = {"ground_grass.png","ground_dirt.png","ground_dirt.png^ground_grass_side.png"},
	groups = {crumbly=3,falling_node=1},
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
	groups = {cracky=3},
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


