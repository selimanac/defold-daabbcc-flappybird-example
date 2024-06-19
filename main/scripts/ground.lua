local utils = require('main.scripts.utils')

local ground = {}

local speed = 50
local container = '/grounds'
local container_initial_position = vmath.vector3(0, -144, 0.2)
local container_position = container_initial_position

function ground.update(dt, is_dead)
	if is_dead then
		return
	end
	container_position.x = container_position.x + -1 * speed * dt
	container_position.x = container_position.x <= -utils.screen.w and 0 or container_position.x
	go.set_position(container_position, container)
end

function ground.reset()
	container_position = container_initial_position
end

return ground
