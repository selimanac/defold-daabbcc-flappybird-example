local utils = require('main.scripts.utils')

local collision = {}

local collision_group_id = -1
collision.bird_id = -1
collision.ground_id = -1

function collision.init()
	daabbcc.run(true)
	collision_group_id  = daabbcc.new_group()
	collision.ground_id = daabbcc.insert_aabb(collision_group_id, 0, -144, utils.zoom.w, 32)
end

local function add_gameobject(url, width, height)
	local msg_url = msg.url(url)
	return daabbcc.insert_gameobject(collision_group_id, msg_url, width, height)
end

function collision.add_bird(url, width, height)
	collision.bird_id = add_gameobject(url, width, height)
end

function collision.add_pipe(url, width, height)
	add_gameobject(url, width, height)
end

function collision.check()
	local result, count = daabbcc.query_id(collision_group_id, collision.bird_id)
	return result, count
end

function collision.stop()
	daabbcc.run(false)
end

function collision.reset()
	daabbcc.reset()
	collision_group_id = -1
	collision.bird_id = -1
	collision.ground_id = -1
end

return collision
