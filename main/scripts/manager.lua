local ground    = require('main.scripts.ground')
local birdy     = require('main.scripts.birdy')
local collision = require('main.scripts.collision')
local utils     = require('main.scripts.utils')
local pipes     = require('main.scripts.pipes')

local manager   = {}

local FLAP      = hash('flap')
local is_dead   = false

function manager.init()
	is_dead = false
	utils.init()
	collision.init()
	pipes.init()
	birdy.init()
end

function manager.update(dt)
	is_dead = birdy.update(dt)
	ground.update(dt, is_dead)
	pipes.update(dt, is_dead)
end

function manager.reboot()
	collision.reset()
	pipes.reset()
	birdy.reset()
	ground.reset()
	manager.init()
end

function manager.input(action_id, action)
	if action_id == FLAP and action.pressed then
		birdy.flap(true)
	elseif action.released then
		birdy.flap(false)
	end
end

return manager
