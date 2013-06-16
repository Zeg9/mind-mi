tools = {}
tools.add_pick = function(name, desc, material, tool_capabilities)
	minetest.register_tool("tools:pick_"..name, {
		description = desc.." pickaxe",
		inventory_image = "tools_"..name.."_pick.png",
		tool_capabilities = tool_capabilities,
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

tools.add_pick("stone","Stone", "ground:pebble", {
	full_punch_interval = 1.0,
	max_drop_level=0,
	groupcaps={
		cracky = {times={[3]=2.0}, uses=20, maxlevel=1},
	},
})
tools.add_pick("iron","Iron", "ores:iron_ingot", {
	full_punch_interval = .7,
	max_drop_level=0,
	groupcaps={
		cracky = {times={[2]=0.8,[3]=1.0}, uses=50, maxlevel=1},
	},
})


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
