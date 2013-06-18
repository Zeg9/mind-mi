ores = {}
ores.add_ore = function(name, description, mineral_type,
                        clust_scarcity, clust_num_ores, clust_size,
                        height_min, height_max, height_max_2, height_max_3)
	minetest.register_node("ores:mineral_"..name, {
		description = description.." ore",
		tiles = {"ground_stone.png^ores_mineral_"..name..".png"},
		groups = {cracky=3},
		drop = "ores:"..name.."_lump",
		sounds = ground.stone_sounds,
	})
	minetest.register_craftitem("ores:"..name.."_lump", {
		description = description.." lump",
		inventory_image = "ores_lump_"..name..".png",
	})
	if mineral_type == "ironlike" then
		minetest.register_craftitem("ores:"..name.."_ingot", {
			description = description.." ingot",
			inventory_image = "ores_ingot_"..name..".png",
		})
		minetest.register_craft({
			type = "cooking",
			output = "ores:"..name.."_ingot",
			recipe = "ores:"..name.."_lump",
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

-- TODO: silver, chromium?... other metals
ores.add_ore("coal","Coal","coallike", 8*8*8, 8, 3, -31000, 64, -24, -128)
ores.add_ore("iron","Iron","ironlike", 9*9*9, 6, 3, -31000, 0, -64, -256)
ores.add_ore("tin","Tin","ironlike", 8*8*8, 4, 2, -31000, 0, -64, -256)
ores.add_ore("copper","Copper","ironlike", 9*9*9, 15, 3, -31000, 0, -64, -256)
ores.add_ore("gold","Gold","ironlike", 10*10*10, 8, 3, -31000, -24, -128, -512)

minetest.register_craft({
	type = "fuel",
	recipe = "ores:coal_lump",
	burntime = 25,
})
