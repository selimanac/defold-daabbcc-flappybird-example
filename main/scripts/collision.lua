local utils = require('main.scripts.utils')

local collision = {}

local collision_group_id = -1
collision.bird_id = -1
collision.ground_id = -1

function collision.init()
	aabb.run(true)
	collision_group_id  = aabb.new_group()
	collision.ground_id = aabb.insert(collision_group_id, 0, -144, utils.zoom.w, 32)
end

local function add_gameobject(url, width, height)
	local msg_url = msg.url(url)
	return aabb.insert_gameobject(collision_group_id, msg_url, width, height)
end

function collision.add_bird(url, width, height)
	collision.bird_id = add_gameobject(url, width, height)
end

function collision.add_pipe(url, width, height)
	add_gameobject(url, width, height)
end

function collision.check()
	local result, count = aabb.query_id(collision_group_id, collision.bird_id)
	return result, count
end

function collision.stop()
	aabb.run(false)
end

function collision.reset()
	aabb.clear()
	collision_group_id = -1
	collision.bird_id = -1
	collision.ground_id = -1
end

return collision
