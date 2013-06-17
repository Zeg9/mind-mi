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
	{times={[3]=2.0}, uses=20, maxlevel=1} -- axe
)
tools.add_tools("iron","Iron", "ores:iron_ingot", 0.7,
	{times={[2]=0.8,[3]=1.0}, uses=50, maxlevel=1}, -- pickaxe
	{times={[1]=0.8,[2]=0.6,[3]=0.2}, uses=50, maxlevel=1}, -- shovel
	{times={[2]=0.8,[3]=1.0}, uses=50, maxlevel=1} -- axe
)


minetest.register_node("tools:torch", {
	description = "Torch",
	tiles = {"tools_torch_top.png","tools_torch_bottom.png","tools_torch.png"},
	inventory_image = "tools_torch.png",
	wield_image = "tools_torch.png",
	drawtype = "nodebox",
	light_source = 13,
	groups = {dig_immediate=3},
	sounds = ground.stone_sounds,
	node_box = {
		type = "fixed",
		fixed = {-1/16, -.5, -1/16, 1/16, 3/16, 1/16},
	},
})
mind_mi.add_particles_emiter("tools:torch","flames",3,{x=0,y=.2,z=0},3.0)
minetest.register_craft({
	output = "tools:torch",
	recipe = {
		{"ores:coal_lump"},
		{"trees:stick"},
	},
})
