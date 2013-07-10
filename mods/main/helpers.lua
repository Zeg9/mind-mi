---------------
-- Callbacks --
---------------

mind_mi.registered_on_walks = {}
-- on_walk:
-- {
--     nodename = "yourmod:awesomenode",
--     action = function(pos, obj, dtime),
-- }
mind_mi.register_on_walk = function(on_walk)
	table.insert(mind_mi.registered_on_walks, on_walk)
end
minetest.register_globalstep(function(dtime)
	for _, pl in ipairs(minetest.get_connected_players()) do
		local npos = pl:getpos()
		npos.y = npos.y + .5
		for _, on_walk in ipairs(mind_mi.registered_on_walks) do
			if minetest.get_node(npos).name == on_walk.nodename then
				on_walk.action(npos, pl, dtime)
			end
		end
	end
end)

---------------------
-- Pressure plates --
---------------------
mind_mi.register_pressure_plate = function(modname, name, description, texture, sounds, groups, on_walk)
	minetest.register_node(modname..":"..name.."_pressure_plate", {
		description = description .. " pressure plate",
		tiles = {texture},
		drawtype = "nodebox",
		paramtype = "light",
		node_box = {
			type = "fixed",
			fixed = {-7/16,-.5,-7/16,7/16,-7/16,7/16},
		},
		selection_box = {
			type = "fixed",
			fixed = {-7/16,-.5,-7/16,7/16,-7/16,7/16},
		},
		walkable = false,
		groups = {cracky=2},
		sounds = sounds,
	})
	minetest.register_node(modname..":"..name.."_pressure_plate_active", {
		description = description .. " pressure plate (active)",
		tiles = {texture},
		drawtype = "nodebox",
		paramtype = "light",
		node_box = {
			type = "fixed",
			fixed = {-7/16,-.5,-7/16,7/16,-7.5/16,7/16},
		},
		selection_box = {
			type = "fixed",
			fixed = {-7/16,-.5,-7/16,7/16,-7.5/16,7/16},
		},
		walkable = false,
		groups = {cracky=2},
		sounds = sounds,
	})
	mind_mi.register_on_walk({
		nodename = modname..":"..name.."_pressure_plate",
		action = function(pos, obj, dtime)
			if sounds.footstep then
				minetest.sound_play(sounds.footstep,{
					pos = pos,
					gain = 1.0,
					max_hear_distance = 16,
				})
			end
			minetest.set_node(pos, {name=modname..":"..name.."_pressure_plate_active"})
			on_walk(pos, obj, dtime)
		end,
	})

	minetest.register_abm({
		nodenames = {"temples:pyramid_pressure_plate_active"},
		interval = 1,
		chance = 1,
		action = function(mpos, node,...)
			local pos = mpos
			pos.y = pos.y -.5
			if #minetest.get_objects_inside_radius(pos, 1) == 0 then
				if sounds.footstep then
					minetest.sound_play(sounds.footstep,{
						pos = pos,
						gain = 1.0,
						max_hear_distance = 16,
					})
				end
				minetest.set_node(pos, {name=modname..":"..name.."_pressure_plate"})
			end
		end,
	})
end

----------------------
-- Particles helper --
----------------------

local pos_add = function(pos1, pos2)
	return {x=pos1.x+pos2.x, y=pos1.y+pos2.y, z=pos1.z+pos2.z}
end

-- TODO: velocity shouldn't be hard-coded, but read from a table:
-- e.g. register_particle(name, minvel, maxvel)
mind_mi.add_particles_emiter = function(nodename, particle, count, relpos, size)
	minetest.register_abm({
		nodenames = {nodename},
		interval = 4.5,
		chance = 1,
		action = function(pos, node, ...)
			local ppos = pos_add(pos, relpos)
			if minetest.registered_nodes[nodename].paramtype2 == "wallmounted" then
				if node.param2 == 0 then
				elseif node.param2 == 1 then
				elseif node.param2 == 2 then
					ppos = pos_add(ppos, {x=.45,y=0,z=0})
				elseif node.param2 == 3 then
					ppos = pos_add(ppos, {x=-.45,y=0,z=0})
				elseif node.param2 == 4 then
					ppos = pos_add(ppos, {x=0,y=0,z=.45})
				elseif node.param2 == 5 then
					ppos = pos_add(ppos, {x=0,y=0,z=-.45})
				end
			end
			minetest.add_particlespawner(count, 5.0,
				ppos, ppos,
				{x=-.05,y=0,z=-.05}, {x=.05,y=.1,z=.05},
				{x=0,y=0,z=0}, {x=0,y=0,z=0},
				5.0/count, 5.0/count,
				size, size,
				false, "particles_"..particle..".png")
		end,
	})
end
