ores = {}
ores.register_lump_and_ingot = function(name, description, lump_groups, ingot_groups)
	minetest.register_craftitem("ores:"..name.."_lump", {
		description = description.." lump",
		inventory_image = "ores_lump_"..name..".png",
		groups = lump_groups,
	})
	minetest.register_craftitem("ores:"..name.."_ingot", {
		description = description.." ingot",
		inventory_image = "ores_ingot_"..name..".png",
		groups = ingot_groups,
	})
	minetest.register_craft({
		type = "cooking",
		output = "ores:"..name.."_ingot",
		recipe = "ores:"..name.."_lump",
	})
end
ores.add_ore = function(name, description, mineral_type,
                        clust_scarcity, clust_num_ores, clust_size,
                        height_min, height_max, height_max_2, height_max_3,
                        lump_groups, ingot_groups)
	if mineral_type == "coallike" then
		minetest.register_craftitem("ores:"..name, {
			description = description,
			inventory_image = "ores_"..name..".png",
			groups = lump_groups,
		})
		minetest.register_node("ores:mineral_"..name, {
			description = description.." ore",
			tiles = {"ground_stone.png^ores_mineral_"..name..".png"},
			groups = {cracky=3},
			drop = "ores:"..name,
			sounds = mind_mi.stone_sounds,
		})
	end
	if mineral_type == "ironlike" then
		ores.register_lump_and_ingot(name, description, lump_groups, ingot_groups)
		minetest.register_node("ores:mineral_"..name, {
			description = description.." ore",
			tiles = {"ground_stone.png^ores_mineral_"..name..".png"},
			groups = {cracky=3},
			drop = "ores:"..name.."_lump",
			sounds = mind_mi.stone_sounds,
		})
	end
	minetest.register_ore({
		ore_type = "scatter",
		ore = "ores:mineral_"..name,
		wherein = "ground:stone",
		clust_scarcity = clust_scarcity,
		clust_num_ores = clust_num_ores,
		clust_size = clust_size,
		height_min = height_min,
		height_max = height_max,
		flags = "",
	})
	if height_max_2 then
		minetest.register_ore({
			ore_type = "scatter",
			ore = "ores:mineral_"..name,
			wherein = "ground:stone",
			clust_scarcity = clust_scarcity*2,
			clust_num_ores = clust_num_ores,
			clust_size = clust_size,
			height_min = height_min,
			height_max = height_max_2,
			flags = "",
		})
	end
	if height_max_3 then
		minetest.register_ore({
			ore_type = "scatter",
			ore = "ores:mineral_"..name,
			wherein = "ground:stone",
			clust_scarcity = clust_scarcity*3,
			clust_num_ores = clust_num_ores,
			clust_size = clust_size,
			height_min = height_min,
			height_max = height_max_3,
			flags = "",
		})
	end
end

-- TODO: silver, mithril
-- also chromium and others ?
ores.add_ore("coal","Coal","coallike", 8*8*8, 8, 3, -31000, 64, -24, -128, {coal=1})
ores.add_ore("diamond","Diamond","coallike", 20*20*20, 3, 3, -31000, -64, -256, -512, {coal=1})
ores.add_ore("iron","Iron","ironlike", 9*9*9, 6, 3, -31000, 0, -64, -256)
ores.add_ore("tin","Tin","ironlike", 9*9*9, 4, 2, -31000, 0, -64, -256)
ores.add_ore("copper","Copper","ironlike", 15*15*15, 4, 3, -31000, 0, -64, -256)
ores.add_ore("gold","Gold","ironlike", 20*20*20, 8, 3, -31000, -24, -128, -512)

minetest.register_craft({
	type = "fuel",
	recipe = "ores:coal",
	burntime = 25,
})

ores.register_lump_and_ingot("diamond_iron", "Diamond and Iron")
minetest.register_craft({
	type = "shapeless",
	output = '"ores:diamond_iron_lump" 2',
	recipe = {"ores:diamond", "ores:iron_lump", "ores:iron_lump"},
})

minetest.register_craftitem("ores:bronze_ingot", {
	description = "Bronze ingot",
	inventory_image = "ores_ingot_bronze.png",
})

machines.alloy_furnace.register_alloy('"ores:copper_lump" 3', "ores:tin_lump", '"ores:bronze_ingot" 4')

