-- Write Sign Mod
-- Written by muhdnurhidayat based on and depends on WorldEdit
-- Released under same license as WorldEdit which is AGPL

-- Load stuffs needed by the mod
local safe_region = dofile(minetest.get_modpath("worldedit_commands") .. "/safe.lua")
local alias_chatcommand = dofile(minetest.get_modpath("worldedit_shortcommands") .. "/init.lua")

-- List of supported signs
local sign_list = {
	"default:sign_wall_wood",
	"default:sign_wall_steel",
	"signs:sign_yard",
	"signs:sign_hanging",
	"signs:sign_wall_green",
	"signs:sign_wall_yellow",
	"signs:sign_wall_red",
	"signs:sign_wall_white_red",
	"signs:sign_wall_white_black",
	"signs:sign_wall_orange",
	"signs:sign_wall_blue",
	"signs:sign_wall_brown",
	"locked_sign:sign_wall_locked",
	"signs:paper_poster",
	"signs:wooden_right_sign",
	"signs:wooden_left_sign",
	"signs_road:large_street_sign",
	"signs_road:blue_street_sign",
	"signs_road:green_street_sign",
	"signs_road:green_left_sign",
	"signs_road:green_right_sign",
	"signs_road:white_street_sign",
	"signs_road:white_left_sign",
	"signs_road:white_right_sign",
	"signs_road:red_street_sign",
	"signs_road:black_left_sign",
	"signs_road:black_right_sign",
	"signs_road:yellow_left_sign",
	"signs_road:yellow_right_sign",
	"steles:stone_stele",
	"steles:sandstone_stele",
	"steles:desert_stone_stele",
	"boards:black_board",
	"boards:green_board"
}

-- Checks if the node is a supported sign
local function is_sign(check_node)
	for i,node_name in ipairs(sign_list) do
		if node_name == check_node then
			return true
		end
	end  
	return false
end

--- Sets sign_text of a region.
-- @param pos1
-- @param pos2
-- @param sign_text String of the sign text to be written
-- @return The number of signs edited.
function worldedit.set_sign_text(pos1, pos2, sign_text)
	local pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	local registered_nodes = minetest.registered_nodes
	sign_text = sign_text:gsub("\\n","\n")
	worldedit.keep_loaded(pos1, pos2)
	
	local count = 0
	local pos = {x=pos1.x, y=0, z=0}
	while pos.x <= pos2.x do
		pos.y = pos1.y
		while pos.y <= pos2.y do
			pos.z = pos1.z
			while pos.z <= pos2.z do
				local node = minetest.get_node(pos)
				if is_sign(node.name) then
					local def = registered_nodes[node.name]
					if def then
						local meta = minetest.get_meta(pos)
						
						-- If signs_lib is enabled but not display_api
						if minetest.get_modpath("signs_lib") and not minetest.get_modpath("display_api") then
							if node.name == "locked_sign:sign_wall_locked" then
								local owner = meta:get_string("owner")
								meta:set_string("text", sign_text)
								meta:set_string("infotext", "Locked sign, owned by " .. owner .. "\n" .. sign_text:gsub("#[0-9a-fA-F]", ""):gsub("##", "#"))
								signs_lib.update_sign(pos)
							else
								meta:set_string("text", sign_text)
								meta:set_string("infotext", sign_text:gsub("#[0-9a-fA-F]", ""):gsub("##", "#"))
								signs_lib.update_sign(pos)
							end
						-- If display_api is enabled but not signs_lib
						elseif minetest.get_modpath("display_api") and not minetest.get_modpath("signs_lib") then
							if node.name == "signs:paper_poster" then
								meta:set_string("text", sign_text)
								local sign_text = sign_text:gsub("\n", " ")
								meta:set_string("display_text", sign_text)
								meta:set_string("infotext", "\""..sign_text.."\"\n".."(right-click to read more text)")
								display_api.update_entities(pos)
							elseif string.find(node.name,"signs_road:") then
								local sign_text = sign_text:gsub("\n", " ")
								meta:set_string("display_text", sign_text)
								meta:set_string("text", sign_text)
								meta:set_string("infotext", '"' .. sign_text .. '"')
								display_api.update_entities(pos)
							else
								meta:set_string("display_text", sign_text)
								meta:set_string("text", sign_text)
								meta:set_string("infotext", '"' .. sign_text .. '"')
								display_api.update_entities(pos)
							end
						-- If both display api and signs_lib are enabled
						elseif minetest.get_modpath("display_api") and minetest.get_modpath("signs_lib") then
							if node.name == "signs:paper_poster" then
								meta:set_string("text", sign_text)
								local sign_text = sign_text:gsub("\n", " ")
								meta:set_string("display_text", sign_text)
								meta:set_string("infotext", "\""..sign_text.."\"\n".."(right-click to read more text)")
								display_api.update_entities(pos)
							elseif node.name == "locked_sign:sign_wall_locked" then
								local owner = meta:get_string("owner")
								meta:set_string("text", sign_text)
								meta:set_string("infotext", "Locked sign, owned by " .. owner .. "\n" .. sign_text:gsub("#[0-9a-fA-F]", ""):gsub("##", "#"))
								signs_lib.update_sign(pos)
							elseif node.name == "signs:wooden_right_sign" or node.name == "signs:wooden_left_sign" then
								local sign_text = sign_text:gsub("\n", " ")
								meta:set_string("display_text", sign_text)
								meta:set_string("text", sign_text)
								meta:set_string("infotext", '"' .. sign_text .. '"')
								display_api.update_entities(pos)
							elseif string.find(node.name,"signs:") then
								meta:set_string("text", sign_text)
								meta:set_string("infotext", sign_text:gsub("#[0-9a-fA-F]", ""):gsub("##", "#"))
								signs_lib.update_sign(pos)
							elseif string.find(node.name,"signs_road:") then
								local sign_text = sign_text:gsub("\n", " ")
								meta:set_string("display_text", sign_text)
								meta:set_string("text", sign_text)
								meta:set_string("infotext", '"' .. sign_text .. '"')
								display_api.update_entities(pos)
							elseif string.find(node.name,"default:") then
								meta:set_string("text", sign_text)
								meta:set_string("infotext", sign_text:gsub("#[0-9a-fA-F]", ""):gsub("##", "#"))
								signs_lib.update_sign(pos)
							else
								meta:set_string("display_text", sign_text)
								meta:set_string("text", sign_text)
								meta:set_string("infotext", '"' .. sign_text .. '"')
								display_api.update_entities(pos)
							end
						-- If both display_api and signs_lib are not enabled (ie. only default signs)
						else
							meta:set_string("text", sign_text)
							meta:set_string("infotext", '"' .. sign_text .. '"')
						end
						count = count + 1
					end
				else
					count = count
				end
				pos.z = pos.z + 1
			end
			pos.y = pos.y + 1
		end
		pos.x = pos.x + 1
	end
	return count
end

-- Register chat command /writesign
minetest.register_chatcommand("/writesign", {
	params = "<sign_text>",
	description = "Set texts of supported signs in the current WorldEdit region to <sign_text>",
	privs = {worldedit=true},
	func = safe_region(function(name, param)
		local sign_text = param
		if not sign_text then
			worldedit.player_notify(name, "Invalid or missing sign_text argument")
			return
		elseif sign_text == " " then
			worldedit.player_notify(name, "Invalid or missing sign_text argument")
			return
		end

		local count = worldedit.set_sign_text(worldedit.pos1[name], worldedit.pos2[name], sign_text)
		worldedit.player_notify(name, count .. " signs altered")
	end, check_region),
})

-- Register alias for /writesign
worldedit.alias_chatcommand("/ws", "/writesign")