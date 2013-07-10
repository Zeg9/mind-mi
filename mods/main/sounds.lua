------------
-- Sounds --
------------
mind_mi.stone_sounds = {
	footstep = {name="default_hard_footstep",gain=0.5},
	dug = {name="default_hard_footstep", gain=1.0},
	place = {name="default_place_node_hard", gain=1.0},
}
mind_mi.dirt_sounds = {
	footstep = {name="default_dirt_footstep", gain=.5},
	dug = {name="default_dirt_footstep", gain=2.0},
	place = {name="default_place_node", gain=1.0},
}
mind_mi.grass_sounds = {
	footstep = {name="default_grass_footstep", gain=0.25},
	dug = mind_mi.dirt_sounds.dug,
	place = mind_mi.dirt_sounds.place,
}
mind_mi.sand_sounds = {
	footstep = {name="default_sand_footstep", gain=0.5},
	dug = {name="default_sand_footstep", gain=1.0},
	place = {name="default_place_node", gain=1.0},
}
mind_mi.gravel_sounds = {
	footstep = {name="default_gravel_footstep", gain=0.5},
	dug = {name="default_gravel_footstep", gain=1.0},
	place = {name="default_place_node", gain=1.0},
}
mind_mi.wood_sounds = {
	footstep = {name="default_wood_footstep", gain=0.5},
	dug = {name="default_wood_footstep", gain=1.0},
	place = {name="default_place_node_hard", gain=1.0},
}
mind_mi.leaves_sounds = {
	footstep = {name="default_grass_footstep", gain=0.35},
	dug = {name="default_grass_footstep", gain=0.85},
	dig = {name="default_dig_crumbly", gain=0.4},
	place = {name="default_place_node", gain=1.0},
}

