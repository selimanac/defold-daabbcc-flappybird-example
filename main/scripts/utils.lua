local camera = require "orthographic.camera"

local utils = {}

local CAMERA_ID = hash("/camera")
local zoom = 0

utils.screen = { w = sys.get_config_int("display.width") / 2, h = sys.get_config_int("display.height") / 2 }
utils.zoom = { w = sys.get_config_int("display.width") / 2, h = sys.get_config_int("display.height") / 2 }

function utils.init()
	zoom = camera.get_zoom(CAMERA_ID)
	utils.zoom.w = utils.screen.w / zoom
	utils.zoom.h = utils.screen.h / zoom
end

function utils.clamp(num, min, max)
	if num < min then
		num = min
	elseif num > max then
		num = max
	end
	return num
end

return utils
