mind_mi = {}

minetest.register_item(":", {
	type = "none",
	wield_image = "wieldhand.png",
	wield_scale = {x=1,y=1,z=2.5},
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level = 0,
		groupcaps = {
		crumbly = {times={[2]=1.00, [3]=0.6}, uses=0, maxlevel=1},
		snappy = {times={[3]=0.40}, uses=0, maxlevel=1},
		cracky = {times={[2]=1,[3]=1,[4]=1}, uses=0, maxlevel=1},
		-- TODO replace the line above ^ by the line below
		--cracky = {times={[4]=3}, uses=0, maxlevel=1},
		oddly_breakable_by_hand = {times={[1]=7.00,[2]=4.00,[3]=1.40}, uses=0, maxlevel=3}
	},
	damage_groups = {fleshy=1},
	}
})

local pos_add = function(pos1, pos2)
	return {x=pos1.x+pos2.x, y=pos1.y+pos2.y, z=pos1.z+pos2.z}
end

-- TODO: velocity shouldn't be hard-coded, but read from a table:
-- minvel[particle], maxvel[particle]
mind_mi.add_particles_emiter = function(nodename, particle, count, relpos, size)
	minetest.register_abm({
		nodenames = {nodename},
		interval = 4.5,
		chance = 1,
		action = function(pos, node, ...)
			local ppos = pos_add(pos, relpos)
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
