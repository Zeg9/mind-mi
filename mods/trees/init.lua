trees = {}
trees.definitions = {}

minetest.register_node("trees:dirt_with_grass_roots", {
	description = "Dirt with grass and roots",
	tiles = {
		"ground_grass.png",
		"trees_dirt_roots.png",
		"trees_dirt_roots.png^ground_grass_side.png",
	},
	groups = {},
})

trees.register_tree = function(name, description, definition)
	trees.definitions[name] = definition

	minetest.register_node("trees:"..name.."_trunk", {
		description = description.." trunk",
		tiles = {
			"trees_"..name.."_trunk_top.png",
			"trees_"..name.."_trunk_top.png",
			"trees_"..name.."_trunk.png"
		},
		drawtype = "nodebox",
		paramtype = "light",
		node_box = {
			type = "fixed",
			fixed = {-7/16,-0.5,-7/16,7/16,0.5,7/16},
		},
		groups = {choppy=2},
	})
	minetest.register_node("trees:"..name.."_leaves", {
		description = description.." leaves",
		drawtype = "allfaces_optional",
		tiles = {"trees_"..name.."_leaves.png"},
		paramtype = "light",
		groups = {snappy=3},
	})
	-- TODO: saplings
end

trees.grow_tree = function(pos, name)
	minetest.set_node(pos, {name="trees:dirt_with_grass_roots"})
	pos.y = pos.y +1
	minetest.spawn_tree(pos,trees.definitions[name])
end

--------------------
-- Register trees --
--------------------

-- Apple tree
minetest.register_node("trees:apple", {
	description = "Apple",
	drawtype = "plantlike",
	tiles = {"trees_apple.png"},
	node_box = {
		type = "fixed",
		fixed = {-5/16, -5/16, -5/16, 5/16, 5/16, 5/16}
	},
	selection_box = {
		type = "fixed",
		fixed = {-5/16, -5/16, -5/16, 5/16, 5/16, 5/16}
	},
	paramtype="light",
	groups={dig_immediate=3},
})
trees.register_tree("appletree", "Apple tree", {
	axiom="T&[Gf][+GfR][++Gf][+++GfR]^TT&&G^B+A+B+A^GGf",
	rules_a="[G^TTf][GG^ff][G+G^Rf]", -- branch (with fruit)
	rules_b="[G^TTf][GG^ff][G+G^ff]", -- branch (w/o fruit)
	trunk="trees:appletree_trunk",
	leaves="trees:appletree_leaves",
	angle=90,
	iterations=5,
	random_level=0,
	trunk_type="single",
	thin_branches=true,
	fruit_chance=5,
	fruit="trees:apple"
})

------------
-- Mapgen --
------------
minetest.register_on_generated(function(minp, maxp, seed)
	if maxp.y < 0 or minp.y > 100 then
		return -- don't spawn trees below water or above clouds
	end
	local pr = PseudoRandom(seed+97)
	local trees_count = pr:next(0,20)
	for i=0,trees_count do
		local treepos = {}
		treepos.x = minp.x+pr:next(0,maxp.x-minp.x)
		treepos.z = minp.z+pr:next(0,maxp.z-minp.z)
		-- There was some pull request in minetest engine, so we could get
		-- the surface height, but sadly it hasn't been merged (yet?)...
		for y=minp.y,maxp.y do
			treepos.y = y
			if minetest.get_node(treepos).name == "ground:dirt_with_grass" then
				-- FIXME this should grow a random tree
				trees.grow_tree(treepos, "appletree")
			end
		end
	end
end)

