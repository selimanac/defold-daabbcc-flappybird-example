local collision = require('main.scripts.collision')
local utils = require('main.scripts.utils')

local pipes = {}

local pipe_container = {}
local pipe_factory_url = '/factories#pipes'
local pipe_size = { w = 32, h = 256 }
local speed = 50
local passage = 60
local distance = 100
local pipe_count = 5
local top_min = 85
local top_max = 260
local top = 0
local current_pipe = {}

local function get_top_position()
	return rnd.range(top_min, top_max)
end

function pipes.init()
	pipe_container = {}
	current_pipe = {}

	local right = utils.zoom.w + pipe_size.w
	local top_position = vmath.vector3(0, 0, 0.1)
	local bottop_position = vmath.vector3(0, 0, 0.1)
	local rot = vmath.quat_rotation_z(math.rad(180))
	local bottom_sprite = msg.url()
	local top_pipe
	local bottom_pipe

	for i = 1, pipe_count do
		-- TOP PIPE
		top = get_top_position()
		top_position = vmath.vector3(right, top, 0.1)
		top_pipe = factory.create(pipe_factory_url, top_position)
		collision.add_pipe(top_pipe, pipe_size.w, pipe_size.h)

		-- BOTTOM PIPE
		bottop_position = vmath.vector3(top_position.x, top_position.y - pipe_size.h - passage, 0.1)
		bottom_pipe = factory.create(pipe_factory_url, bottop_position, rot)
		collision.add_pipe(bottom_pipe, pipe_size.w, pipe_size.h)
		bottom_sprite = msg.url(nil, bottom_pipe, 'pipe')
		sprite.set_hflip(bottom_sprite, true)

		table.insert(pipe_container, { top = top_pipe, bottom = bottom_pipe, top_position = top_position, bottom_position = bottop_position })
		right = right + pipe_size.w + distance
	end
end

function pipes.update(dt, is_dead)
	if is_dead then
		return
	end

	for i = 1, pipe_count do
		current_pipe = pipe_container[i]
		current_pipe.top_position.x = current_pipe.top_position.x + -1 * speed * dt
		current_pipe.bottom_position.x = current_pipe.bottom_position.x + -1 * speed * dt

		if current_pipe.top_position.x <= -utils.screen.w then
			local last_pos_x               = pipe_container[pipe_count].top_position.x + pipe_size.w + distance
			current_pipe.top_position.x    = last_pos_x
			current_pipe.bottom_position.x = last_pos_x
			local first_pipe               = current_pipe
			top                            = get_top_position()
			first_pipe.top_position.y      = top
			first_pipe.bottom_position.y   = top - pipe_size.h - passage
			table.remove(pipe_container, i)
			table.insert(pipe_container, first_pipe)
		end

		go.set_position(current_pipe.top_position, current_pipe.top)
		go.set_position(current_pipe.bottom_position, current_pipe.bottom)
	end
end

function pipes.reset()
	for i = 1, pipe_count do
		go.delete(pipe_container[i].top)
		go.delete(pipe_container[i].bottom)
	end
end

return pipes
