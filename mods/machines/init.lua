machines = {}

function hacky_swap_node(pos,name)
	local node = minetest.get_node(pos)
	local meta = minetest.get_meta(pos)
	local meta0 = meta:to_table()
	if node.name == name then
		return
	end
	node.name = name
	local meta0 = meta:to_table()
	minetest.set_node(pos,node)
	meta = minetest.get_meta(pos)
	meta:from_table(meta0)
end

machines.modpath = minetest.get_modpath("machines")
dofile(machines.modpath .. "/furnace.lua")
dofile(machines.modpath .. "/alloy_furnace.lua")

