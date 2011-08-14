
local lfs = require 'lfs'

local tests = {}
for test in lfs.dir('tests') do
	test = 'tests/' .. test
	if (lfs.attributes(test, 'mode') == 'file') and test:lower():match('%.lua$') then
		tests[#tests+1] = test
	end
end

local test
while true do
	print('Please select a test:')
	for i, test in ipairs(tests) do
		print(string.format('[%d] %s', i, test))
	end
	io.write('>')
	local selection = io.read('*l')
	if (selection == nil) then
		os.exit(0)
	end
	selection = tonumber(selection)
	selection = selection and tests[selection]
	if selection then
		test = selection
		break
	end
end

do
	local _require = require
	local expectedModuleCase = {}
	function require(module)
		local expected = expectedModuleCase[string.lower(module)]
		if expected and (expected ~= module) then
			error('module case inconsistency: \'' .. module .. '\' vs. \'' .. expected .. '\'', 2)
		end
		expectedModuleCase[string.lower(module)] = module
		return _require(module)
	end
end

dofile(test)
