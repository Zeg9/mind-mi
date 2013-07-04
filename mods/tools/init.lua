tools = {}
tools.add_pick = function(name, desc, material, full_punch_interval, groupcaps_cracky)
	minetest.register_tool("tools:pick_"..name, {
		description = desc.." pickaxe",
		inventory_image = "tools_"..name.."_pick.png",
		tool_capabilities = {
			full_punch_interval = full_punch_interval,
			groupcaps = { cracky = groupcaps_cracky },
		},
	})
	minetest.register_craft({
		output = "tools:pick_"..name,
		recipe = {
			{material, material, material},
			{"","trees:stick",""},
			{"","trees:stick",""},
		},
	})
end
tools.add_shovel = function(name, desc, material, full_punch_interval, groupcaps_crumbly)
	minetest.register_tool("tools:shovel_"..name, {
		description = desc.." shovel",
		inventory_image = "tools_"..name.."_shovel.png",
		tool_capabilities = {
			full_punch_interval = full_punch_interval,
			groupcaps = { crumbly = groupcaps_crumbly },
		},
	})
	minetest.register_craft({
		output = "tools:shovel_"..name,
		recipe = {
			{"", material, ""},
			{"","trees:stick",""},
			{"","trees:stick",""},
		},
	})
end
tools.add_axe = function(name, desc, material, full_punch_interval, groupcaps_choppy)
	minetest.register_tool("tools:axe_"..name, {
		description = desc.." axe",
		inventory_image = "tools_"..name.."_axe.png",
		tool_capabilities = {
			full_punch_interval = full_punch_interval,
			groupcaps = { choppy = groupcaps_choppy },
		},
	})
	minetest.register_craft({
		output = "tools:axe_"..name,
		recipe = {
			{material, material, ""},
			{material,"trees:stick",""},
			{"","trees:stick",""},
		},
	})
end
tools.add_tools = function(name, desc, material, full_punch_interval,
                           groupcaps_cracky, groupcaps_crumbly, groupcaps_choppy)
	tools.add_pick(name, desc, material, full_punch_interval, groupcaps_cracky)
	tools.add_shovel(name, desc, material, full_punch_interval, groupcaps_crumbly)
	tools.add_axe(name, desc, material, full_punch_interval, groupcaps_choppy)
end

tools.add_tools("stone","Stone", "ground:pebble", 1.0,
	{times={[3]=2.0}, uses=20, maxlevel=1}, -- pickaxe
	{times={[2]=0.8,[3]=0.4}, uses=20, maxlevel=1}, -- shovel
	{times={[2]=2.0,[3]=2.0}, uses=20, maxlevel=1} -- axe
)
tools.add_tools("iron","Iron", "ores:iron_ingot", 0.7,
	{times={[2]=0.8,[3]=1.0}, uses=50, maxlevel=1}, -- pickaxe
	{times={[1]=0.8,[2]=0.6,[3]=0.2}, uses=50, maxlevel=1}, -- shovel
	{times={[2]=0.8,[3]=1.0}, uses=50, maxlevel=1} -- axe
)


minetest.register_node("tools:torch", {
	description = "Torch",
	tiles = {"tools_torch_top.png","tools_torch_bottom.png","tools_torch_side.png"},
	inventory_image = "tools_torch.png",
	wield_image = "tools_torch.png",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "wallmounted",
	light_source = 13,
	groups = {dig_immediate=3,attached_node=1},
	sounds = ground.stone_sounds,
	after_destruct = function(pos, oldnode)
		print("destructed a torch, param2 = "..oldnode.param2)
	end,
	node_box = {
		type = "wallmounted",
		wall_bottom = {-1/16, -.5, -1/16, 1/16, 3/16, 1/16},
		wall_top = {-1/16, 1/16, -1/16, 1/16, .5, 1/16},
		wall_side = {-.5, -.5, -1/16, -6/16, 3/16, 1/16},
	},
})
mind_mi.add_particles_emiter("tools:torch","flames",3,{x=0,y=.2,z=0},3.0)
minetest.register_craft({
	output = '"tools:torch" 2',
	recipe = {
		{"group:coal"},
		{"trees:stick"},
	},
})

minetest.register_tool("tools:bucket", {
	description = "Bucket",
	inventory_image = "tools_bucket.png",
	liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type ~= "node" then return end
		if minetest.get_node(pointed_thing.under).name == "ground:water_source" then
			minetest.remove_node(pointed_thing.under)
			return ItemStack("tools:bucket_water")
		end
	end,
})
minetest.register_tool("tools:bucket_water", {
	description = "Water Bucket",
	inventory_image = "tools_bucket_water.png",
	liquids_pointable = true,
	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type ~= "node" then return end
		if minetest.get_node(pointed_thing.above).name == "air" then
			minetest.set_node(pointed_thing.above,{name="ground:water_source"})
			return ItemStack("tools:bucket")
		end
	end,
})
minetest.register_craft({
	output = "tools:bucket",
	recipe = {
		{"ores:iron_ingot","","ores:iron_ingot"},
		{"","ores:iron_ingot",""},
	},
})
