
minetest.register_decoration({
	deco_type = "schematic",
	place_on = "ground:sand",
	sidelen = 80,
	fill_ratio = 0.00025,
	--TODO: biomes = (and use mgv7 instead of v6)
	schematic = minetest.get_modpath("temples").."/schems/pyramid.mts",
	flags = "place_center_x, place_center_z",
	rotation = "random",
})

minetest.register_node("temples:pyramid_chest", {
	description = "Pyramid treasure chest",
	tiles = {
		"tools_chest_top.png",
		"tools_chest_top.png",
		"tools_chest_side.png",
		"tools_chest_side.png",
		"tools_chest_side.png",
		"tools_chest_front.png",
	},
	paramtype2 = "facedir",
	on_rightclick = function(pos, node, clicker, itemstack)
		-- Loot is decided on rightclick because mapgen doesn't call on_construct
		local meta = minetest.get_meta(pos)
		if meta:get_string("isset") ~= "true" then
			local inv = meta:get_inventory()
			local size = 8*4
			inv:set_size("main", size)
			inv:set_stack("main", math.random(1,size), ItemStack({name="ores:diamond",count=math.random(1,4)}))
			inv:set_stack("main", math.random(1,size), ItemStack({name="ores:gold_ingot",count=math.random(1,5)}))
			inv:set_stack("main", math.random(1,size), ItemStack({name="ores:bronze_ingot",count=math.random(1,8)}))
			inv:set_stack("main", math.random(1,size), ItemStack({name="ores:copper_lump",count=math.random(1,12)}))
			inv:set_stack("main", math.random(1,size), ItemStack({name="ores:tin_lump",count=math.random(1,12)}))
			inv:set_stack("main", math.random(1,size), ItemStack({name="ores:iron_lump",count=math.random(1,13)}))
			inv:set_stack("main", math.random(1,size), ItemStack({name="ground:sandstone", count=math.random(1,37)}))
			inv:set_stack("main", math.random(1,size), ItemStack({name="ground:sandstone_brick", count=math.random(1,42)}))
			inv:set_stack("main", math.random(1,size), ItemStack({name="tnt:tnt", count=math.random(1,45)}))
			inv:set_stack("main", math.random(1,size), ItemStack({name="temples:bars", count=math.random(1,20)}))
			inv:set_stack("main", math.random(1,size), ItemStack({name="temples:spikes", count=math.random(1,20)}))
			meta:set_string("isset", "true")
		end
		minetest.show_formspec(clicker:get_player_name(), "",
			"size[8,9]" ..
			"list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";main;0,0;8,4;]" ..
			"list[current_player;main;0,5;8,4;]")
	end,
	drop = "",
	groups = {choppy=2},
	sounds = mind_mi.wood_sounds,
})

minetest.register_node("temples:spikes", {
	description = "Spikes",
	tiles = {"temples_spikes.png"},
	drawtype = "plantlike",
	paramtype = "light",
	walkable = false,
	groups = {cracky=3},
	sounds = mind_mi.stone_sounds,
})

local spikes_cooldown = 0
mind_mi.register_on_walk({
	nodename = "temples:spikes",
	action = function(pos, obj, dtime)
		if spikes_cooldown > 0 then
			spikes_cooldown = spikes_cooldown - dtime
		elseif obj:get_hp() > 0 then
			minetest.sound_play("temples_spikes",{
				pos = obj:getpos(),
				gain = 1.0,
				max_hear_distance = 16,
			})
			spikes_cooldown = 1
			obj:set_hp(0)
		end
	end,
})
minetest.register_globalstep(function(dtime)
	if spikes_cooldown > 0 then
		spikes_cooldown = spikes_cooldown - dtime
	else
		for _, pl in ipairs(minetest.get_connected_players()) do
			local npos = pl:getpos()
			npos.y = npos.y + .5
			if minetest.get_node(npos).name == "temples:spikes" then
				if pl:get_hp() > 0 then
					minetest.sound_play("temples_spikes",{
						pos = pl:getpos(),
						gain = 1.0,
						max_hear_distance = 16,
					})
					spikes_cooldown = 1
					pl:set_hp(0)
				end
			end
		end
	end
end)
minetest.register_node("temples:bars", {
	description = "Bars",
	tiles = {"temples_bars.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {-.5,-.5,-1/16,.5,.5,1/16},
	},
	groups = {cracky=3},
	sounds = mind_mi.stone_sounds,
})
minetest.register_node("temples:bars_dispenser", {
	description = "Bars dispenser",
	tiles = {"temples_bars_top.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {-.5,-.5,-.5,.5,-.45,.5},
	},
	selection_box = {
		type = "fixed",
		fixed = {-.5,-.5,-.5,.5,-.45,.5},
	},
	walkable = false,
	groups = {cracky=2},
	sounds = mind_mi.stone_sounds,
})
minetest.register_node("temples:bars_dispenser_top", {
	description = "Bars dispenser (top)",
	tiles = {"temples_bars_top.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {-.5,.45,-.5,.5,.5,.5},
	},
	selection_box = {
		type = "fixed",
		fixed = {-.5,.45,-.5,.5,.5,.5},
	},
	walkable = false,
	groups = {cracky=2},
	sounds = mind_mi.stone_sounds,
})



mind_mi.register_pressure_plate(
	"temples", "pyramid", "Pyramid",
	"ground_sandstone.png", mind_mi.stone_sounds, {cracky=2},
	function(pos, obj, dtime)
		local p = minetest.find_node_near(pos, 4, "temples:bars_dispenser")
		if p then minetest.set_node(p, {name="temples:bars",param2=minetest.get_node(p).param2}) end
		local p = minetest.find_node_near(pos, 4, "temples:bars_dispenser_top")
		if p then minetest.set_node(p, {name="temples:bars",param2=minetest.get_node(p).param2}) end
		local p = minetest.find_node_near(pos, 4, "tnt:tnt")
		if p then
			minetest.sound_play("tnt_ignite", {pos=p})
			minetest.env:set_node(p, {name="tnt:tnt_burning"})
			boom(p, 4, true)  -- don't drop items or there will be errors
		end
	end
)

