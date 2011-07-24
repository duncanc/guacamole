
local ffi         = require 'ffi'
local sdl         = require 'extern.sdl'
local E           = require 'guac.events'
local theRenderer = require 'guac.theRenderer'

local theApp = {}
do
	
	sdl.SDL_Init(sdl.SDL_INIT_VIDEO)
	
	function theApp:show(width, height, mode)
		local sdlMode
		if (mode == 'windowed') then
			sdlMode = 0
		elseif (mode == 'fullscreen') then
			sdlMode = sdl.SDL_FULLSCREEN
		elseif (mode == 'resizeable') or (mode == 'resizable') then
			sdlMode = sdl.SDL_RESIZABLE
		else
			error('bad parameter #3: unrecognized mode', 2)
		end
		local videosurface = sdl.SDL_SetVideoMode(width, height, 0, sdlMode)
	end
	
	local sdlEventHandlers = {
		[sdl.SDL_QUIT] = function(e)
			E.trigger(theApp, 'quit-requested')
		end;
	}
	
	local runningMainLoop = false
	
	function theApp:beginMainLoop()
		local event = ffi.new 'SDL_Event'
		local t = os.clock()
		runningMainLoop = true
		while runningMainLoop do
			while (sdl.SDL_PollEvent(event) ~= 0) do
				local handler = sdlEventHandlers[event.type]
				if handler then
					handler(event)
				end
			end
			local new_t = os.clock()
			E.trigger(theApp, 'update', new_t - t)
			t = new_t
			E.trigger(theRenderer, 'draw')
			sdl.SDL_Delay(sdl.SDL_TIMESLICE)
		end
	end
	
	function theApp:breakMainLoop()
		if not runningMainLoop then
			error('main loop is not running', 2)
		end
		runningMainLoop = false
	end

	E.bind(theApp, 'quit-requested', function()
		theApp:breakMainLoop()
	end)

end
return theApp
