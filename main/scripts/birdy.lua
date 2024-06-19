local collision = require('main.scripts.collision')
local utils = require('main.scripts.utils')

local birdy = {}

local bird_initial_position = vmath.vector3(-55, 0, 0.3)
local bird_position = bird_initial_position
local bird_rotation = 0
local bird_factory_url = '/factories#birdy'
local bird_id = hash('')
local velocity = vmath.vector3()
local gravity = 650
local max_falling_speed = 500
local up_rotation_speed = 900
local down_rotation_speed = 150
local force = 140
local max_force = 300
local is_flap = false
local bird_sprite = msg.url()
local bird_size = vmath.vector3(12, 10, 0)
local is_start = false
local is_dead = false
local reboot = false

function birdy.init()
	-- RESET
	bird_position = bird_initial_position
	velocity = vmath.vector3()
	bird_rotation = 0
	is_start = false
	is_dead = false
	reboot = false
	is_flap = false

	bird_id = factory.create(bird_factory_url, bird_position)
	bird_sprite = msg.url(nil, bird_id, 'sprite')
	collision.add_bird(bird_id, bird_size.x, bird_size.y)
	timer.delay(0.5, false, function()
		is_start = true
	end)
end

local function birdy_rotate(dt)
	if is_start then
		if velocity.y > 0 then
			bird_rotation = bird_rotation + up_rotation_speed * dt
		elseif is_flap == false then
			bird_rotation = bird_rotation - down_rotation_speed * dt
		end
		bird_rotation = utils.clamp(bird_rotation, -65, 25)
		go.set(bird_id, 'euler.z', bird_rotation)
	end
end

function birdy.update(dt)
	if reboot then
		return is_dead
	end
	if is_flap then
		if velocity.y < max_force and bird_position.y < utils.zoom.h - bird_size.y then
			velocity.y = force
		else
			if is_start then
				is_flap = false
			end
		end
	else
		if is_start then
			if velocity.y > -max_falling_speed then
				velocity.y = velocity.y - gravity * dt
			end
		end
	end

	local result, count = collision.check()

	if result then
		if (result[1] == collision.ground_id or result[2] == collision.ground_id) and reboot == false then
			go.set(bird_sprite, "playback_rate", 0)
			is_dead = true
			reboot = true

			timer.delay(0.3, false, function()
				collision.stop()
				msg.post('.', 'reboot')
			end)
			return is_dead
		elseif is_dead == false then
			go.set(bird_sprite, "playback_rate", 0)
			is_flap = false
			is_dead = true
			return is_dead
		end
	end

	birdy_rotate(dt)
	bird_position = bird_position + velocity * dt
	go.set_position(bird_position, bird_id)

	return is_dead
end

function birdy.flap(flap)
	if is_dead then
		return
	end
	is_flap = flap
	is_start = true
	if is_flap then
		go.set(bird_sprite, "playback_rate", 4)
	else
		go.set(bird_sprite, "playback_rate", 1)
	end
end

function birdy.reset()
	go.delete(bird_id)
end

return birdy
