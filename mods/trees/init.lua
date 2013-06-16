trees = {}
trees.definitions = {}
trees.max = 0

minetest.register_node("trees:dirt_with_grass_roots", {
	description = "Dirt with grass and roots",
	tiles = {
		"ground_grass.png",
		"trees_dirt_roots.png",
		"trees_dirt_roots.png^ground_grass_side.png",
	},
	groups = {},
})

minetest.register_craftitem("trees:stick", {
	description = "Stick",
	inventory_image = "trees_stick.png",
})

trees.register_tree = function(name, description, definition)
	definition.trunk = "trees:"..name.."_trunk"
	definition.leaves = "trees:"..name.."_leaves"
	trees.definitions[name] = definition
	trees.max = trees.max +1

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
		drop = {
			max_items = 1,
			items = {
				{items = {"trees:"..name.."_sapling"}, rarity = 10},
				{items = {"trees:stick"}, rarity = 2},
				{items = {"trees:"..name.."_leaves"}}
			}
		},
		groups = {snappy=3},
	})
	minetest.register_node("trees:"..name.."_sapling", {
		description = description.." sapling",
		drawtype = "plantlike",
		tiles = {"trees_"..name.."_sapling.png"},
		paramtype = "light",
		groups = {dig_immediate=3},
	})
	minetest.register_abm({
		nodenames = {"trees:"..name.."_sapling"},
		-- FIXME change interval and/or chance
		interval = 1.0,
		chance = 1,
		action = function(pos, node, ...)
			pos.y = pos.y -1
			trees.grow_tree(pos, name, true)
		end,
	})
end

trees.grow_tree = function(pos, name, is_sapling)
	-- TODO maybe allow multiple nodes ? (group:soil?)
	if minetest.get_node(pos).name == "ground:dirt_with_grass" then
		minetest.set_node(pos, {name="trees:dirt_with_grass_roots"})
		pos.y = pos.y +1
		if is_sapling then
			minetest.remove_node(pos)
		end
		minetest.spawn_tree(pos,trees.definitions[name])
	end
end

--------------------
-- Register trees --
--------------------

-- Apple tree
minetest.register_node("trees:apple", {
	description = "Apple",
	drawtype = "plantlike",
	tiles = {"trees_apple.png"},
	inventory_image = "trees_apple.png",
	wield_image = "trees_apple.png",
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
	on_use = minetest.item_eat(4),
})
trees.register_tree("appletree", "Apple tree", {
	axiom="T&[Gf][+GfR][++Gf][+++GfR]^TT&&G^B+A+B+A^GGf",
	rules_a="[G^TTf][GG^ff][G+G^Rf]", -- branch (with fruit)
	rules_b="[G^TTf][GG^ff][G+G^ff]", -- branch (w/o fruit)
	angle=90,
	iterations=2,
	random_level=0,
	trunk_type="single",
	thin_branches=true,
	fruit_chance=5,
	fruit="trees:apple"
})
trees.register_tree("oak", "Oak", {
	axiom="&[GT]+[GT]+[GT]+[GT]+^TTTT[TTT]AFAFAGGB",
	rules_a="&[GFF]+[GFF]+[GFF]+[GFF]+^", -- branches
	rules_b="[&f+f+ff+ff+ff+f]", -- top leaves
	angle=90,
	iterations=2,
	random_level=0,
	trunk_type="single",
	thin_branches=true,
})

------------
-- Mapgen --
------------
minetest.register_on_generated(function(minp, maxp, seed)
	if maxp.y < 0 or minp.y > 100 then
		return -- don't spawn trees below water or above clouds
	end
	if trees.max < 1 then
		return -- if no tree defined (this shouldn't happen)
	end
	local pr = PseudoRandom(seed+116)
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
				local id = pr:next(1,trees.max)
				local i = 0
				for n, _ in pairs(trees.definitions) do
					i = i + 1
					if i == id then
						trees.grow_tree(treepos, n)
						break
					end
				end
			end
		end
	end
end)

