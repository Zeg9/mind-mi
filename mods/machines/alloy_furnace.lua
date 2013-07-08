machines.alloy_furnace = {
	get_active_formspec = function(pos, percent)
		local formspec =
			"size[8,9]"..
			"image[2,2;1,1;machines_furnace_fire_bg.png^[lowpart:"..
			(100-percent)..":machines_furnace_fire_fg.png]"..
			"list[current_name;fuel;2,3;1,1;]"..
			"list[current_name;src;1.5,1;2,1;]"..
			"list[current_name;dst;5,1;2,2;]"..
			"list[current_player;main;0,5;8,4;]"
		return formspec
	end,

	inactive_formspec =
		"size[8,9]"..
		"image[2,2;1,1;machines_furnace_fire_bg.png]"..
		"list[current_name;fuel;2,3;1,1;]"..
		"list[current_name;src;1.5,1;2,1;]"..
		"list[current_name;dst;5,1;2,2;]"..
		"list[current_player;main;0,5;8,4;]",

	registered_alloys = {},
	-- in1, in2, out: itemstring
	register_alloy = function(in1, in2, out)
		local ni1 = ItemStack(in1):get_name()
		local ni2 = ItemStack(in2):get_name()
		local no = ItemStack(out):get_name()
		machines.alloy_furnace.registered_alloys[ni1.." "..ni2] = {
			input = {in1, in2},
			output = out,
		}
	end,
	-- in1, in2: ItemStack
	get_alloy_result = function(in1, in2)
		local ni1 = in1:get_name()
		local ni2 = in2:get_name()
		local alloy = machines.alloy_furnace.registered_alloys[ni1.." "..ni2]
		if alloy then
			local take1 = ItemStack(alloy.input[1])
			local take2 = ItemStack(alloy.input[2])
			if in1:get_count() < take1:get_count() or
			   in2:get_count() < take2:get_count() then
				-- not enough input
				return nil
			end
			return alloy
		end
		return nil
	end,

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", machines.alloy_furnace.inactive_formspec)
		meta:set_string("infotext", "Alloy furnace")
		local inv = meta:get_inventory()
		inv:set_size("fuel", 1)
		inv:set_size("src", 2)
		inv:set_size("dst", 4)
	end,

	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("fuel") then
			return false
		elseif not inv:is_empty("dst") then
			return false
		elseif not inv:is_empty("src") then
			return false
		end
		return true
	end,

	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		if listname == "fuel" then
			if minetest.get_craft_result({method="fuel",width=1,items={stack}}).time ~= 0 then
				if inv:is_empty("src") then
					meta:set_string("infotext","Alloy furnace is empty")
				end
				return stack:get_count()
			else
				return 0
			end
		elseif listname == "src" then
			return stack:get_count()
		elseif listname == "dst" then
			return 0
		end
	end,
	
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local stack = inv:get_stack(from_list, from_index)
		if to_list == "fuel" then
			if minetest.get_craft_result({method="fuel",width=1,items={stack}}).time ~= 0 then
				if inv:is_empty("src") then
					meta:set_string("infotext","Alloy furnace is empty")
				end
				return count
			else
				return 0
			end
		elseif to_list == "src" then
			return count
		elseif to_list == "dst" then
			return 0
		end
	end,
}

minetest.register_node("machines:alloy_furnace", {
	description = "Alloy furnace",
	tiles = {"machines_alloy_furnace_top.png", "machines_alloy_furnace_top.png", "machines_alloy_furnace_side.png",
		"machines_alloy_furnace_side.png", "machines_alloy_furnace_side.png", "machines_alloy_furnace_front.png"},
	paramtype2 = "facedir",
	groups = {cracky=3},
	legacy_facedir_simple = true,
	sounds = mind_mi.stone_sounds,
	on_construct = machines.alloy_furnace.on_construct,
	can_dig = machines.alloy_furnace.can_dig,
	allow_metadata_inventory_put = machines.alloy_furnace.allow_metadata_inventory_put,
	allow_metadata_inventory_move = machines.alloy_furnace.allow_metadata_inventory_move,
})

minetest.register_node("machines:alloy_furnace_active", {
	description = "Alloy furnace",
	tiles = {"machines_alloy_furnace_top.png", "machines_alloy_furnace_top.png", "machines_alloy_furnace_side.png",
		"machines_alloy_furnace_side.png", "machines_alloy_furnace_side.png", "machines_alloy_furnace_front_active.png"},
	paramtype2 = "facedir",
	light_source = 8,
	drop = "machines:alloy_furnace",
	groups = {cracky=3,not_in_creative_inventory=1},
	legacy_facedir_simple = true,
	sounds = mind_mi.stone_sounds,
	on_construct = machines.alloy_furnace.on_construct,
	can_dig = machines.alloy_furnace.can_dig,
	allow_metadata_inventory_put = machines.alloy_furnace.allow_metadata_inventory_put,
	allow_metadata_inventory_move = machines.alloy_furnace.allow_metadata_inventory_move,
})

minetest.register_abm({
	nodenames = {"machines:alloy_furnace","machines:alloy_furnace_active"},
	interval = 1.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local meta = minetest.get_meta(pos)
		for i, name in ipairs({
				"fuel_totaltime",
				"fuel_time",
				"src_totaltime",
				"src_time"
		}) do
			if meta:get_string(name) == "" then
				meta:set_float(name, 0.0)
			end
		end

		local inv = meta:get_inventory()

		local srclist = inv:get_list("src")
		local alloy = nil
		
		if srclist then
			alloy = machines.alloy_furnace.get_alloy_result(srclist[1], srclist[2])
		end
		
		local was_active = false
		
		if meta:get_float("fuel_time") < meta:get_float("fuel_totaltime") then
			was_active = true
			meta:set_float("fuel_time", meta:get_float("fuel_time") + 1)
			meta:set_float("src_time", meta:get_float("src_time") + 1)
			-- FIXME hard-coded cooking time (5)
			if alloy and meta:get_float("src_time") >= 5 then
				-- check if there's room for output in "dst" list
				if inv:room_for_item("dst",alloy.output) then
					-- Put result in "dst" list
					inv:add_item("dst", alloy.output)
					-- take stuff from "src" list
					inv:remove_item("src", alloy.input[1])
					inv:remove_item("src", alloy.input[2])
				else
					print("Could not insert '"..alloy.output.."'")
				end
				meta:set_string("src_time", 0)
			end
		end
		
		if meta:get_float("fuel_time") < meta:get_float("fuel_totaltime") then
			local percent = math.floor(meta:get_float("fuel_time") /
					meta:get_float("fuel_totaltime") * 100)
			meta:set_string("infotext","Alloy furnace active: "..percent.."%")
			hacky_swap_node(pos,"machines:alloy_furnace_active")
			meta:set_string("formspec",machines.alloy_furnace.get_active_formspec(pos, percent))
			return
		end

		local fuel = nil
		local afterfuel
		local alloy = nil
		local fuellist = inv:get_list("fuel")
		local srclist = inv:get_list("src")
		
		if srclist then
			alloy = machines.alloy_furnace.get_alloy_result(srclist[1], srclist[2])
		end
		if fuellist then
			fuel, afterfuel = minetest.get_craft_result({method = "fuel", width = 1, items = fuellist})
		end

		if fuel.time <= 0 then
			meta:set_string("infotext","Alloy furnace out of fuel")
			hacky_swap_node(pos,"machines:alloy_furnace")
			meta:set_string("formspec", machines.alloy_furnace.inactive_formspec)
			return
		end

		if alloy == nil then
			if was_active then
				meta:set_string("infotext","Alloy furnace is empty")
				hacky_swap_node(pos,"machines:alloy_furnace")
				meta:set_string("formspec", machines.alloy_furnace.inactive_formspec)
			end
			return
		end

		meta:set_string("fuel_totaltime", fuel.time)
		meta:set_string("fuel_time", 0)
		
		inv:set_stack("fuel", 1, afterfuel.items[1])
	end,
})

minetest.register_craft({
	output = "machines:alloy_furnace",
	recipe = {
		{"ground:clay","ground:clay","ground:clay"},
		{"ground:clay", ""          ,"ground:clay"},
		{"ground:clay","ground:clay","ground:clay"},
	},
})

