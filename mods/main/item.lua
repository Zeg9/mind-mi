----------------------------------
-- Item additions and overrides --
----------------------------------

-- set_item override: always use a rotating wielditem
minetest.registered_entities["__builtin:item"].set_item = function(self, itemstring)
	self.itemstring = itemstring
	local stack = ItemStack(itemstring)
	local itemtable = stack:to_table()
	local itemname = nil
	if itemtable then
		itemname = stack:to_table().name
	end
	self.object:set_properties({
		is_visible = true,
		visual = "wielditem",
		textures = {itemname},
		visual_size = {x=0.20, y=0.20},
		automatic_rotate = math.pi * 0.25,
	})
end

-- on_step additions: see what to do below
local old_on_step = minetest.registered_entities["__builtin:item"].on_step
minetest.registered_entities["__builtin:item"].on_step = function(self, dtime)
	old_on_step(self,dtime)
	-- TODO: remove item when inside lava, push when inside water
	--       and maybe, let the user grab it by walking over it
end
