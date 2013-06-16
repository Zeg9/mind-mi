ores = {}
ores.add_ore = function(name, description, type,
                        clust_scarcity, clust_num_ores, clust_size,
                        height_min, height_max, height_max_2, height_max_3)
	minetest.register_node("ores:mineral_"..name, {
		description = description.." ore",
		tiles = {"ground_stone.png^ores_mineral_"..name..".png"},
		groups = {cracky=2},
		drop = "ores:"..name.."_lump",
		sounds = ground.stone_sounds,
	})
	minetest.register_craftitem("ores:"..name.."_lump", {
		description = description.." lump",
		inventory_image = "ores_lump_"..name..".png",
	})
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

ores.add_ore("coal","Coal","coallike", 8*8*8, 8, 3, -31000, 64, -24, -128)
