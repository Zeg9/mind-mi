mind_mi = {}

local modpath = minetest.get_modpath("main")
local modules = {"hand","item","helpers","sounds"}
for _, i in ipairs(modules) do
	dofile(modpath .. "/" .. i .. ".lua")
end

