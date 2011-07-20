
local extern = {}

extern.placeholder = {}

function extern.checkname(given, wanted)
	if (given ~= 'extern.'..wanted) then
		error("please use the correct casing 'extern." .. wanted .. "' (sorry for being picky! there is a reason for this)", 3)
		--[[
			say the most recent version of SomeLibrary is extern.SomeLibrary.v1_2
			if I want to force extern.SomeLibrary.v1_1 instead, I require that first
			it sets package.loaded['SomeLibrary'] as part of its initialization
			...but this will get messed up if you try to require 'somelibrary' instead!
		--]]
	end
end

function extern.defaultversion(given_name, expected_name, version)
	extern.checkname(given_name, expected_name)
	package.loaded['extern.' .. expected_name] = extern.placeholder
	return require('extern.' .. expected_name .. '.' .. version)
end

function extern.defineversion(given_name, expected_name, version)
	extern.checkname(given_name, expected_name .. '.' .. version)
	if package.loaded['extern.' .. expected_name] and package.loaded['extern.' .. expected_name] ~= extern.placeholder then
		error('a different version of ' .. expected_name .. ' has already been loaded')
	end
end

return extern
