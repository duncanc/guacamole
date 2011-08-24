
local ffi = require 'ffi'

local contextFactory = {}
do

	local loader_proto = {}
	local loader_meta = {__index = loader_proto}
	
	function loader_proto:mangleConstantName(rawName)
		if (self.style == 'webgl') then
			return rawName
		else
			return 'GL_' .. rawName
		end
	end
	
	function loader_proto:mangleFunctionName(rawName)
		if (self.style == 'webgl') then
			return rawName:sub(1,1):lower() .. rawName:sub(2)
		else
			return 'gl' .. rawName
		end
	end
	
	function loader_proto:loadPackage(package)
		for i, package in ipairs(package.inherits or {}) do
			self:loadPackage(package)
		end
		do
			local typedefs = {}
			for glType, basicType in pairs(package.basicTypes or {}) do
				if not pcall(ffi.typeof, glType) then
					typedefs[#typedefs+1] = 'typedef ' .. basicType .. ' ' .. glType .. ';'
				end
			end
			if typedefs[1] then
				ffi.cdef(table.concat(typedefs, '\r\n'))
			end
		end
		do
			for alias, glType in pairs(package.typeAliases or {}) do
				self.typeAliases[alias] = glType
			end
		end
		for constantName, constantValue in pairs(package.magicNumbers or {}) do
			self:loadConstant(constantName, constantValue)
		end
		for i, funcDef in ipairs(package.funcs or {}) do
			self:loadFunction(funcDef)
		end
	end
	
	function loader_proto:loadConstant(rawName, rawValue)
		local mangledName = self:mangleConstantName(rawName)
		self.context[mangledName] = rawValue
	end
	
	function loader_proto:loadFunction(funcDef)
		local importer = self.customImporters[funcDef[1]]
		if importer and (importer(self, funcDef) ~= 'default') then
			return
		end
		
		local func = self:importFunction(funcDef)
		
		local wrapper = {ret = self.returnWrappers[funcDef.ret] and funcDef.ret or false}
		wrapper.use = not not wrapper.ret
		for i = 2, #funcDef, 2 do
			local paramwrap = (self.paramWrappers[funcDef[i]] or self.paramWrappers[funcDef[i+1]:sub(1,1):upper() .. funcDef[i+1]:sub(2)]) and funcDef[i] or false
			wrapper[#wrapper+1] = paramwrap
			wrapper.use = wrapper.use or paramwrap
		end
		if wrapper.use then
			local imports = {}
			local paramNames = {}
			for i = 1, #wrapper do
				paramNames[i] = funcDef[1 + (i * 2)]
				if wrapper[i] then
					imports[wrapper[i]] = true
				end
			end
			local buf = {'local ' .. funcDef[1] .. ', box, unbox = ...\n'}
			if wrapper.ret then
				buf[#buf+1] = 'local box_' .. wrapper.ret .. ' = box.' .. wrapper.ret .. '\n'
			end
			for import in pairs(imports) do
				buf[#buf+1] = 'local unbox_' .. import .. ' = unbox.' .. import .. '\n'
			end
			buf[#buf+1] = 'return function(' .. table.concat(paramNames, ', ') .. ')\n  return '
			if wrapper.ret then
				buf[#buf+1] = 'box_' .. wrapper.ret .. '('
			end
			buf[#buf+1] = funcDef[1] .. '('
			for i = 1, #paramNames do
				if (i > 1) then
					buf[#buf+1] = ', '
				end
				if wrapper[i] then
					buf[#buf+1] = 'unbox_' .. wrapper[i] .. '(' .. paramNames[i] .. ')'
				else
					buf[#buf+1] = paramNames[i]
				end
			end
			buf[#buf+1] = ')'
			if wrapper.ret then
				buf[#buf+1] = ')'
			end
			buf[#buf+1] = '\nend\n'
			print(table.concat(buf))
			func = loadstring(table.concat(buf))(func, self.returnWrappers, self.paramWrappers)
		end
		
		self.context[self:mangleFunctionName(funcDef[1])] = func
	end
	
	function loader_proto:importFunction(funcDef)
		local getProcAddress = self.getProcAddress
		if getProcAddress then
			local funcName = 'gl' .. funcDef[1]
			local func = getProcAddress(funcName)
			if (func == nil) then
				print('unable to load OpenGL function \'' .. funcName .. '\'')
        return nil
			end
			local sigBuf = {self:mangleTypeName(funcDef.ret or 'void') .. ' (*)('}
			for i = 2, #funcDef, 2 do
				if (i > 2) then
					sigBuf[#sigBuf+1] = ', '
				end
				sigBuf[#sigBuf+1] = self:mangleTypeName(funcDef[i]) .. ' ' .. funcDef[i+1]
			end
			sigBuf[#sigBuf+1] = ')'
			return ffi.cast(table.concat(sigBuf), func)
		else
			if ffi.os == 'Windows' then
				local opengl32 = require 'extern.microsoftwindows.opengl32'
				getProcAddress = opengl32.wglGetProcAddress
			end
			local library = getLibrary()
			local funcName = 'gl' .. funcDef[1]
			if getProcAddress then
				local func = getProcAddress(funcName)
				if func ~= nil then
					local sigBuf = {self:mangleTypeName(funcDef.ret or 'void') .. '(*)('}
					for i = 2, #funcDef, 2 do
						if (i > 2) then
							sigBuf[#sigBuf+1] = ', '
						end
						sigBuf[#sigBuf+1] = self:mangleTypeName(funcDef[i]) .. ' ' .. funcDef[i+1]
					end
					sigBuf[#sigBuf+1] = ')'
					return ffi.cast(table.concat(sigBuf), func)
				end
			end
			local cbuf = {self:mangleTypeName(funcDef.ret or 'void') .. ' ' .. funcName .. '('}
			for i = 2, #funcDef, 2 do
				if (i > 2) then
					cbuf[#cbuf+1] = ', '
				end
				cbuf[#cbuf+1] = self:mangleTypeName(funcDef[i]) .. ' ' .. funcDef[i+1]
			end
			cbuf[#cbuf+1] = ');'
			ffi.cdef(table.concat(cbuf))
			return library[funcName]
		end
	end
	
	function loader_proto:mangleTypeName(name)
		return name:gsub('[a-zA-Z_][a-zA-Z_0-9]*', self.typeAliases)
	end
	
	local paramTypes = {
		ACCUM_ALPHA_BITS = 'int';
		ACCUM_BLUE_BITS = 'int';
		ACCUM_CLEAR_VALUE = 'float4';
		ACCUM_GREEN_BITS = 'int';
		ACCUM_RED_BITS = 'int';
		ACTIVE_TEXTURE = 'int';
		ALIASED_POINT_SIZE_RANGE = 'float2';
		ALIASED_LINE_WIDTH_RANGE = 'float2';
		ALPHA_BIAS = 'float';
		ALPHA_BITS = 'int';
		ALPHA_SCALE = 'float';
		ALPHA_TEST = 'bool';
		ALPHA_TEST_FUNC = 'int';
		ALPHA_TEST_REF = 'float';
		ARRAY_BUFFER_BINDING = 'Buffer';
		ATTRIB_STACK_DEPTH = 'int';
		AUTO_NORMAL = 'bool';
		AUX_BUFFERS = 'int';
		BLEND = 'bool';
		BLEND_COLOR = 'float4';
		BLEND_DST_ALPHA = 'int';
		BLEND_DST_RGB = 'int';
		BLEND_EQUATION_RGB = 'int';
		BLEND_EQUATION_ALPHA = 'int';
		BLEND_SRC_ALPHA = 'int';
		BLEND_SRC_RGB = 'int';
		BLUE_BIAS = 'float';
		BLUE_BITS = 'int';
		BLUE_SCALE = 'float';
		CLIENT_ACTIVE_TEXTURE = 'int';
		CLIENT_ATTRIB_STACK_DEPTH = 'int';
		CLIP_PLANE0 = 'bool';
		CLIP_PLANE1 = 'bool';
		CLIP_PLANE2 = 'bool';
		CLIP_PLANE3 = 'bool';
		CLIP_PLANE4 = 'bool';
		CLIP_PLANE5 = 'bool';
		COLOR_ARRAY = 'bool';
		COLOR_ARRAY_BUFFER_BINDING = 'Buffer';
		COLOR_ARRAY_SIZE = 'int';
		COLOR_ARRAY_STRIDE = 'int';
		COLOR_ARRAY_TYPE = 'int';
		COLOR_CLEAR_VALUE = 'float4';
		COLOR_LOGIC_OP = 'int';
		COLOR_MATERIAL = 'bool';
		COLOR_MATERIAL_FACE = 'int';
		COLOR_MATERIAL_PARAMETER = 'int';
		COLOR_MATRIX = 'float16';
		COLOR_MATRIX_STACK_DEPTH = 'int';
		COLOR_SUM = 'bool';
		COLOR_TABLE = 'bool';
		COLOR_WRITEMASK = 'bool4';
		CONVOLUTION_1D = 'bool';
		CONVOLUTION_2D = 'bool';
		CULL_FACE = 'bool';
		CULL_FACE_MODE = 'int';
		CURRENT_COLOR = 'float4',
		CURRENT_FOG_COORD = 'float';
		CURRENT_INDEX = 'int';
		CURRENT_NORMAL = 'float3';
		CURRENT_PROGRAM = 'Program';
		CURRENT_RASTER_COLOR = 'float4';
		CURRENT_RASTER_DISTANCE = 'float';
		CURRENT_RASTER_INDEX = 'int';
		CURRENT_RASTER_POSITION = 'float4';
		CURRENT_RASTER_POSITION_VALID = 'bool';
		CURRENT_RASTER_SECONDARY_COLOR = 'float4';
		CURRENT_RASTER_TEXTURE_COORDS = 'float4';
		CURRENT_SECONDARY_COLOR = 'float4';
		CURRENT_TEXTURE_COORDS = 'float4';
		DEPTH_BIAS = 'float';
		DEPTH_BITS = 'int';
		DEPTH_CLEAR_VALUE = 'float';
		DEPTH_FUNC = 'int';
		DEPTH_RANGE = 'float2';
		DEPTH_SCALE = 'float';
		DEPTH_TEST = 'bool';
		DEPTH_WRITEMASK = 'bool';
		DITHER = 'bool';
		DOUBLEBUFFER = 'bool';
		DRAW_BUFFER0 = 'int',  DRAW_BUFFER1 = 'int',  DRAW_BUFFER2 = 'int',  DRAW_BUFFER3 = 'int';
		DRAW_BUFFER4 = 'int',  DRAW_BUFFER5 = 'int',  DRAW_BUFFER6 = 'int',  DRAW_BUFFER7 = 'int';
		DRAW_BUFFER8 = 'int',  DRAW_BUFFER9 = 'int',  DRAW_BUFFER10 = 'int', DRAW_BUFFER11 = 'int';
		DRAW_BUFFER12 = 'int', DRAW_BUFFER13 = 'int', DRAW_BUFFER14 = 'int', DRAW_BUFFER15 = 'int';
		EDGE_FLAG = 'bool';
		EDGE_FLAG_ARRAY = 'bool';
		EDGE_FLAG_ARRAY_BUFFER_BINDING = 'Buffer';
		EDGE_FLAG_ARRAY_STRIDE = 'int';
		ELEMENT_ARRAY_BUFFER_BINDING = 'Buffer';
		FEEDBACK_BUFFER_SIZE = 'int';
		FEEDBACK_BUFFER_TYPE = 'int';
		FOG = 'bool';
		FOG_COORD_ARRAY = 'bool';
		FOG_COORD_ARRAY_BUFFER_BINDING = 'Buffer';
		FOG_COORD_ARRAY_STRIDE = 'int';
		FOG_COORD_ARRAY_TYPE = 'int';
		FOG_COORD_SRC = 'int';
		FOG_COLOR = 'float4';
		FOG_DENSITY = 'float';
		FOG_END = 'float';
		FOG_HINT = 'int';
		FOG_INDEX = 'int';
		FOG_MODE = 'int';
		FOG_START = 'float';
		FRAGMENT_SHADER_DERIVATIVE_HINT = 'int';
		FRONT_FACE = 'int';
		GENERATE_MIPMAP_HINT = 'int';
		GREEN_BIAS = 'float';
		GREEN_BITS = 'int';
		GREEN_SCALE = 'float';
		HISTOGRAM = 'bool';
		INDEX_ARRAY = 'bool';
		INDEX_ARRAY_BUFFER_BINDING = 'Buffer';
		INDEX_ARRAY_STRIDE = 'int';
		INDEX_ARRAY_TYPE = 'int';
		INDEX_BITS = 'int';
		INDEX_CLEAR_VALUE = 'int';
		INDEX_LOGIC_OP = 'int';
		INDEX_MODE = 'bool';
		INDEX_OFFSET = 'int';
		INDEX_SHIFT = 'int';
		INDEX_WRITEMASK = 'int';
		LIGHT0 = 'bool', LIGHT1 = 'bool', LIGHT2 = 'bool', LIGHT3 = 'bool';
		LIGHT4 = 'bool', LIGHT5 = 'bool', LIGHT6 = 'bool', LIGHT7 = 'bool';
		LIGHTING = 'bool';
		LIGHT_MODEL_AMBIENT = 'float4';
		LIGHT_MODEL_COLOR_CONTROL = 'int';
		LIGHT_MODEL_LOCAL_VIEWER = 'bool';
		LIGHT_MODEL_TWO_SIDE = 'bool';
		LINE_SMOOTH = 'bool';
		LINE_SMOOTH_HINT = 'int';
		LINE_STIPPLE = 'bool';
		LINE_STIPPLE_PATTERN = 'int';
		LINE_STIPPLE_REPEAT = 'int';
		LINE_WIDTH = 'float';
		LINE_WIDTH_GRANULARITY = 'float';
		LINE_WIDTH_RANGE = 'float2';
		LIST_BASE = 'int';
		LIST_INDEX = 'int';
		LIST_MODE = 'int';
		LOGIC_OP_MODE = 'int';
		MAP1_COLOR_4 = 'bool';
		MAP1_GRID_DOMAIN = 'float2';
		MAP1_GRID_SEGMENTS = 'int';
		MAP1_INDEX = 'bool';
		MAP1_NORMAL = 'bool';
		MAP1_TEXTURE_COORD_1 = 'bool';
		MAP1_TEXTURE_COORD_2 = 'bool';
		MAP1_TEXTURE_COORD_3 = 'bool';
		MAP1_TEXTURE_COORD_4 = 'bool';
		MAP1_VERTEX_3 = 'bool';
		MAP1_VERTEX_4 = 'bool';
		MAP2_COLOR_4 = 'bool';
		MAP2_GRID_DOMAIN = 'float4';
		MAP2_GRID_SEGMENTS = 'float2';
		MAP2_INDEX = 'bool';
		MAP2_NORMAL = 'bool';
		MAP2_TEXTURE_COORD_1 = 'bool';
		MAP2_TEXTURE_COORD_2 = 'bool';
		MAP2_TEXTURE_COORD_3 = 'bool';
		MAP2_TEXTURE_COORD_4 = 'bool';
		MAP2_VERTEX_3 = 'bool';
		MAP2_VERTEX_4 = 'bool';
		MAP_COLOR = 'bool';
		MAP_STENCIL = 'bool';
		MATRIX_MODE = 'int';
		MAX_3D_TEXTURE_SIZE = 'int';
		MAX_CLIENT_ATTRIB_STACK_DEPTH = 'int';
		MAX_ATTRIB_STACK_DEPTH = 'int';
		MAX_CLIP_PLANES = 'int';
		MAX_COLOR_MATRIX_STACK_DEPTH = 'int';
		MAX_COMBINED_TEXTURE_IMAGE_UNITS = 'int';
		MAX_CUBE_MAP_TEXTURE_SIZE = 'int';
		MAX_DRAW_BUFFERS = 'int';
		MAX_ELEMENTS_INDICES = 'int';
		MAX_ELEMENTS_VERTICES = 'int';
		MAX_EVAL_ORDER = 'int';
		MAX_FRAGMENT_UNIFORM_COMPONENTS = 'int';
		MAX_LIGHTS = 'int';
		MAX_LIST_NESTING = 'int';
		MAX_MODELVIEW_STACK_DEPTH = 'int';
		MAX_NAME_STACK_DEPTH = 'int';
		MAX_PIXEL_MAP_TABLE = 'int';
		MAX_PROJECTION_STACK_DEPTH = 'int';
		MAX_TEXTURE_COORDS = 'int';
		MAX_TEXTURE_IMAGE_UNITS = 'int';
		MAX_TEXTURE_LOD_BIAS = 'int';
		MAX_TEXTURE_SIZE = 'int';
		MAX_TEXTURE_STACK_DEPTH = 'int';
		MAX_TEXTURE_UNITS = 'int';
		MAX_VARYING_FLOATS = 'int';
		MAX_VERTEX_ATTRIBS = 'int';
		MAX_VERTEX_TEXTURE_IMAGE_UNITS = 'int';
		MAX_VERTEX_UNIFORM_COMPONENTS = 'int';
		MAX_VIEWPORT_DIMS = 'int2';
		MINMAX = 'bool';
		MODELVIEW_MATRIX = 'float16';
		MODELVIEW_STACK_DEPTH = 'int';
		NAME_STACK_DEPTH = 'int';
		NORMAL_ARRAY = 'bool';
		NORMAL_ARRAY_BUFFER_BINDING = 'Buffer';
		NORMAL_ARRAY_STRIDE = 'int';
		NORMAL_ARRAY_TYPE = 'int';
		NORMALIZE = 'bool';
		NUM_COMPRESSED_TEXTURE_FORMATS = 'int';
		PACK_ALIGNMENT = 'int';
		PACK_IMAGE_HEIGHT = 'int';
		PACK_LSB_FIRST = 'bool';
		PACK_ROW_LENGTH = 'int';
		PACK_SKIP_IMAGES = 'int';
		PACK_SKIP_PIXELS = 'int';
		PACK_SKIP_ROWS = 'int';
		PACK_SWAP_BYTES = 'bool';
		PERSPECTIVE_CORRECTION_HINT = 'int';
		PIXEL_MAP_A_TO_A_SIZE = 'float';
		PIXEL_MAP_B_TO_B_SIZE = 'float';
		PIXEL_MAP_G_TO_G_SIZE = 'float';
		PIXEL_MAP_I_TO_A_SIZE = 'float';
		PIXEL_MAP_I_TO_B_SIZE = 'float';
		PIXEL_MAP_I_TO_G_SIZE = 'float';
		PIXEL_MAP_I_TO_I_SIZE = 'float';
		PIXEL_MAP_I_TO_R_SIZE = 'float';
		PIXEL_MAP_R_TO_R_SIZE = 'float';
		PIXEL_MAP_S_TO_S_SIZE = 'float';
		PIXEL_PACK_BUFFER_BINDING = 'Buffer';
		PIXEL_UNPACK_BUFFER_BINDING = 'Buffer';
		POINT_DISTANCE_ATTENUATION = 'float3';
		POINT_FADE_THRESHOLD_SIZE = 'float';
		POINT_SIZE = 'float';
		POINT_SIZE_GRANULARITY = 'float';
		POINT_SIZE_MAX = 'float';
		POINT_SIZE_MIN = 'float';
		POINT_SIZE_RANGE = 'float2';
		POINT_SMOOTH = 'bool';
		POINT_SMOOTH_HINT = 'int';
		POINT_SPRITE = 'bool';
		POLYGON_MODE = 'int2';
		POLYGON_OFFSET_FACTOR = 'float';
		POLYGON_OFFSET_UNITS = 'float';
		POLYGON_OFFSET_FILL = 'bool';
		POLYGON_OFFSET_LINE = 'bool';
		POLYGON_OFFSET_POINT = 'bool';
		POLYGON_SMOOTH = 'bool';
		POLYGON_SMOOTH_HINT = 'int';
		POLYGON_STIPPLE = 'bool';
		POST_COLOR_MATRIX_COLOR_TABLE = 'bool';
		POST_COLOR_MATRIX_RED_BIAS = 'float';
		POST_COLOR_MATRIX_GREEN_BIAS = 'float';
		POST_COLOR_MATRIX_BLUE_BIAS = 'float';
		POST_COLOR_MATRIX_ALPHA_BIAS = 'float';
		POST_COLOR_MATRIX_RED_SCALE = 'float';
		POST_COLOR_MATRIX_GREEN_SCALE = 'float';
		POST_COLOR_MATRIX_BLUE_SCALE = 'float';
		POST_COLOR_MATRIX_ALPHA_SCALE = 'float';
		POST_CONVOLUTION_COLOR_TABLE = 'bool';
		POST_CONVOLUTION_RED_BIAS = 'float';
		POST_CONVOLUTION_GREEN_BIAS = 'float';
		POST_CONVOLUTION_BLUE_BIAS = 'float';
		POST_CONVOLUTION_ALPHA_BIAS = 'float';
		POST_CONVOLUTION_RED_SCALE = 'float';
		POST_CONVOLUTION_GREEN_SCALE = 'float';
		POST_CONVOLUTION_BLUE_SCALE = 'float';
		POST_CONVOLUTION_ALPHA_SCALE = 'float';
		PROJECTION_MATRIX = 'float16';
		PROJECTION_STACK_DEPTH = 'int';
		READ_BUFFER = 'int';
		RED_BIAS = 'float';
		RED_BITS = 'int';
		RED_SCALE = 'float';
		RENDER_MODE = 'int';
		RESCALE_NORMAL = 'bool';
		RGBA_MODE = 'bool';
		SAMPLE_BUFFERS = 'int';
		SAMPLE_COVERAGE_VALUE = 'float';
		SAMPLE_COVERAGE_INVERT = 'bool';
		SAMPLES = 'int';
		SCISSOR_BOX = 'int4';
		SCISSOR_TEST = 'bool';
		SECONDARY_COLOR_ARRAY = 'bool';
		SECONDARY_COLOR_ARRAY_BUFFER_BINDING = 'Buffer';
		SECONDARY_COLOR_ARRAY_SIZE = 'int';
		SECONDARY_COLOR_ARRAY_STRIDE = 'int';
		SECONDARY_COLOR_ARRAY_TYPE = 'int';
		SELECTION_BUFFER_SIZE = 'int';
		SEPARABLE_2D = 'bool';
		SHADE_MODEL = 'int';
		SMOOTH_LINE_WIDTH_RANGE = 'float2';
		SMOOTH_LINE_WIDTH_GRANULARITY = 'float';
		SMOOTH_POINT_SIZE_RANGE = 'float2';
		SMOOTH_POINT_SIZE_GRANULARITY = 'float';
		STENCIL_BACK_FAIL = 'int';
		STENCIL_BACK_FUNC = 'int';
		STENCIL_BACK_PASS_DEPTH_FAIL = 'int';
		STENCIL_BACK_PASS_DEPTH_PASS = 'int';
		STENCIL_BACK_REF = 'int';
		STENCIL_BACK_VALUE_MASK = 'int';
		STENCIL_BACK_WRITEMASK = 'int';
		STENCIL_BITS = 'int';
		STENCIL_CLEAR_VALUE = 'int';
		STENCIL_FAIL = 'int';
		STENCIL_FUNC = 'int';
		STENCIL_PASS_DEPTH_FAIL = 'int';
		STENCIL_PASS_DEPTH_PASS = 'int';
		STENCIL_REF = 'int';
		STENCIL_TEST = 'bool';
		STENCIL_VALUE_MASK = 'int';
		STENCIL_WRITEMASK = 'int';
		STEREO = 'bool';
		SUBPIXEL_BITS = 'int';
		TEXTURE_1D = 'bool';
		TEXTURE_BINDING_1D = 'Texture';
		TEXTURE_2D = 'bool';
		TEXTURE_BINDING_2D = 'Texture';
		TEXTURE_3D = 'bool';
		TEXTURE_BINDING_3D = 'Texture';
		TEXTURE_BINDING_CUBE_MAP = 'Texture';
		TEXTURE_COMPRESSION_HINT = 'int';
		TEXTURE_COORD_ARRAY = 'bool';
		TEXTURE_COORD_ARRAY_BUFFER_BINDING = 'Buffer';
		TEXTURE_COORD_ARRAY_SIZE = 'int';
		TEXTURE_COORD_ARRAY_STRIDE = 'int';
		TEXTURE_COORD_ARRAY_TYPE = 'int';
		TEXTURE_CUBE_MAP = 'bool';
		TEXTURE_GEN_Q = 'bool';
		TEXTURE_GEN_R = 'bool';
		TEXTURE_GEN_S = 'bool';
		TEXTURE_GEN_T = 'bool';
		TEXTURE_MATRIX = 'float16';
		TEXTURE_STACK_DEPTH = 'int';
		TRANSPOSE_COLOR_MATRIX = 'float16';
		TRANSPOSE_MODELVIEW_MATRIX = 'float16';
		TRANSPOSE_PROJECTION_MATRIX = 'float16';
		TRANSPOSE_TEXTURE_MATRIX = 'float16';
		UNPACK_ALIGNMENT = 'int';
		UNPACK_IMAGE_HEIGHT = 'int';
		UNPACK_LSB_FIRST = 'bool';
		UNPACK_ROW_LENGTH = 'int';
		UNPACK_SKIP_IMAGES = 'int';
		UNPACK_SKIP_PIXELS = 'int';
		UNPACK_SKIP_ROWS = 'int';
		UNPACK_SWAP_BYTES = 'bool';
		VERTEX_ARRAY = 'bool';
		VERTEX_ARRAY_BUFFER_BINDING = 'Buffer';
		VERTEX_ARRAY_SIZE = 'int';
		VERTEX_ARRAY_STRIDE = 'int';
		VERTEX_ARRAY_TYPE = 'int';
		VERTEX_PROGRAM_POINT_SIZE = 'bool';
		VERTEX_PROGRAM_TWO_SIDE = 'bool';
		VIEWPORT = 'int4';
		ZOOM_X = 'float', ZOOM_Y = 'float';
		
		VENDOR = 'string';
		RENDERER = 'string';
		VERSION = 'string';
		SHADING_LANGUAGE_VERSION = 'string';
		EXTENSIONS = 'string';
	}
	_G.paramTypes = paramTypes
	
	function contextFactory.load(loader)
		loader = setmetatable(loader or {}, loader_meta)
		loader.typeAliases = loader.typeAliases or {}
		local context = {}
		loader.context = context
		context.loader = loader
		
		loader.returnWrappers = {
			Boolean = function(b)
				return (b ~= 0)
			end;
			String = function(str)
				if (str == nil) then
					return nil
				end
				return ffi.string(str)
			end;
		}
		loader.paramWrappers = {
		}
		loader.customImporters = {
		}
		
		if (loader.style == 'webgl') then
		
			local box = {}
			local unbox = {}
			
			local function addGenDelete(typeName, plural)
				plural = plural or typeName..'s'
				local delete
				local type_t = ffi.metatype('struct { unsigned int _id[1]; }', {
					__gc = function(self)
						if (self._id[0] ~= 0) then
							delete(1, self._id)
							self._id[0] = 0
						end
					end;
					__tostring = function(self)  return 'OpenGL ' .. typeName .. ': ' .. self._id[0];  end;
				})
				local byId = setmetatable({}, {__mode = 'v'})
				box[typeName] = function(id)
					id = tonumber(id)
					if (id == 0) then
						return nil
					end
					local boxed = byId[id]
					if not boxed then
						boxed = type_t(id)
						byId[id] = boxed
					end
					return boxed
				end
				unbox[typeName] = function(boxed)
					if (boxed == nil) then
						return 0
					end
					return boxed._id[0]
				end
				loader.customImporters["Gen"..plural] = function(self, funcDef)
					local gen = self:importFunction(funcDef)
					self.context["create" .. typeName] = function()
						local boxed = type_t()
						gen(1, boxed._id)
						byId[tonumber(boxed._id[0])] = boxed
						return boxed
					end
				end
				loader.customImporters["Delete" .. plural] = function(self, funcDef)
					delete = self:importFunction(funcDef)
					self.context["delete" .. typeName] = function(v)
						byId[v._id[0]] = nil
						delete(1, v._id)
						v._id[0] = 0
					end
				end
				loader.customImporters["Is" .. typeName] = function(self, funcDef)
					self.context["is" .. typeName] = function(v)
						return ffi.istype(v, type_t) and v._id[0] ~= 0
					end
				end
			end
		
			local function addCreateDelete(typeName)
				local delete
				local type_t = ffi.metatype('struct { unsigned int _id; }', {
					__gc = function(self)
						if (self._id ~= 0) then
							delete(self._id)
							self._id = 0
						end
					end;
					__tostring = function(self)  return 'OpenGL' .. typeName .. ' ' .. self._id;  end;
				})
				local byId = setmetatable({}, {__mode = 'v'})
				box[typeName] = function(id)
					id = tonumber(id)
					if (id == 0) then
						return nil
					end
					local boxed = byId[id]
					if not boxed then
						boxed = type_t(id)
						byId[id] = boxed
					end
					return boxed
				end
				unbox[typeName] = function(boxed)
					if (boxed == nil) then
						return 0
					end
					return boxed._id
				end
				loader.customImporters["Create"..typeName] = function(self, funcDef)
					local create = self:importFunction(funcDef)
					self.context["create" .. typeName] = function()
						local boxed = type_t(create())
						byId[tonumber(boxed._id)] = boxed
						return boxed
					end
				end
				loader.customImporters["Delete" .. typeName] = function(self, funcDef)
					delete = self:importFunction(funcDef)
					self.context["delete" .. typeName] = function(v)
						byId[v._id] = nil
						delete(v._id)
						v._id = 0
					end
				end
				loader.customImporters["Is" .. typeName] = function(self, funcDef)
					self.context["is" .. typeName] = function(v)
						return ffi.istype(v, type_t) and v._id ~= 0
					end
				end
			end
		
			-- texture objects
			do
				addGenDelete("Texture")
				
				function loader.customImporters:BindTexture(funcDef)
					local bindTexture = self:importFunction(funcDef)
					local pin = {}
					function self.context.bindTexture(target, texture)
						if (texture == nil) then
							pin[target] = nil
							bindTexture(target, 0)
						else
							assert(ffi.istype(texture, texture_t), 'invalid texture')
							pin[target] = texture
							bindTexture(target, texture._id[0])
						end
					end
				end
				
			end
			
			-- buffer objects
			do
				addGenDelete("Buffer")
			end
			
			-- framebuffer objects
			do
				addGenDelete("Framebuffer")
				
				function loader.customImporters:BindFramebuffer(funcDef)
					local bindFramebuffer = self:importFunction(funcDef)
					local unbox_Framebuffer = unbox.Framebuffer
					local bindFramebufferPin = {}
					function self.context.bindFramebuffer(target, fb)
						bindFramebufferPin[target] = fb
						return bindFramebuffer(target, unbox.Framebuffer(fb))
					end
				end
				loader.customImporters.BindFramebufferEXT = loader.customImporters.BindFramebuffer
				
				function loader.customImporters:FramebufferTexture(funcDef)
					local framebufferTexture = self:importFunction(funcDef)
					local unbox_Texture = unbox.Texture
					function self.context.framebufferTexture(target, attachment, texture, level)
						return framebufferTexture(target, attachment, unbox_Texture(texture), level)
					end
				end
				loader.customImporters.FramebufferTextureEXT = loader.customImporters.FramebufferTexture
				
				for i = 1, 3 do
					loader.customImporters['FramebufferTexture'..i..'D'] = function(self, funcDef)
						local framebufferTextureXD = self:importFunction(funcDef)
						local unbox_Texture = unbox.Texture
						if (i == 3) then
							self.context['framebufferTexture' .. i .. 'D'] = function(target, attachment, textarget, texture, level, layer)
								return framebufferTextureXD(target, attachment, textarget, unbox_Texture(texture), level, layer)
							end
						else
							self.context['framebufferTexture' .. i .. 'D'] = function(target, attachment, textarget, texture, level)
								return framebufferTextureXD(target, attachment, textarget, unbox_Texture(texture), level)
							end
						end
					end
					loader.customImporters['FramebufferTexture'..i..'DEXT'] = loader.customImporters['FramebufferTexture'..i..'D']
				end
				
			end
			
			-- renderbuffer objects
			do
				addGenDelete("Renderbuffer")
				
				function loader.customImporters:BindRenderbuffer(funcDef)
					local bindRenderbuffer = self:importFunction(funcDef)
					local unbox_Renderbuffer = unbox.Renderbuffer
					local bindRenderbufferPin = {}
					function self.context.bindRenderbuffer(target, rb)
						bindRenderbufferPin[target] = rb
						return bindRenderbuffer(target, unbox.Renderbuffer(rb))
					end
				end
				loader.customImporters.BindRenderbufferEXT = loader.customImporters.BindRenderbuffer
			end
			
			-- program objects
			do
				addCreateDelete("Program")
				
				function loader.customImporters:UseProgram(funcDef)
					local useProgram = self:importFunction(funcDef)
					local usedProgram = nil
					function self.context.useProgram(program)
						if (program == nil) then
							return useProgram(0)
						else
							return useProgram(program._id)
						end
					end
				end
			end
			
			-- shader objects
			
			-- uniform location objects
			
			-- queries
			do
				addGenDelete("Query", "Queries")
			end
			
			-- sampler objects
			do
				addGenDelete("Sampler")
			end
			
			-- parameters
			do
				local getBooleanv, getDoublev, getFloatv, getIntegerv, getString
				
				function loader.customImporters:GetBooleanv(funcDef)
					getBooleanv = self:importFunction(funcDef)
					return 'default'
				end
				
				function loader.customImporters:GetDoublev(funcDef)
					getDoublev = self:importFunction(funcDef)
					return 'default'
				end
				
				function loader.customImporters:GetFloatv(funcDef)
					getFloatv = self:importFunction(funcDef)
					return 'default'
				end
				
				function loader.customImporters:GetIntegerv(funcDef)
					getIntegerv = self:importFunction(funcDef)
					return 'default'
				end
				
				function loader.customImporters:GetString(funcDef)
					getString = self:importFunction(funcDef)
					return 'default'
				end
				
				local paramBuffer = ffi.new [[
					
					struct {
						union {
							int ints[4];
							float floats[16];
						};
					}
					
				]]
				
				local typeGetters = {
					string = function(name)
						local str = getString(name)
						if (str == nil) then
							return nil
						else
							return ffi.string(str)
						end
					end;
					int = function(name)
						getIntegerv(name, paramBuffer.ints)
						return paramBuffer.ints[0]
					end;
					int2 = function(name)
						getIntegerv(name, paramBuffer.ints)
						return paramBuffer.ints[0], paramBuffer.ints[1]
					end;
					int3 = function(name)
						getIntegerv(name, paramBuffer.ints)
						return paramBuffer.ints[0], paramBuffer.ints[1], paramBuffer.ints[2]
					end;
					int4 = function(name)
						getIntegerv(name, paramBuffer.ints)
						return paramBuffer.ints[0], paramBuffer.ints[1], paramBuffer.ints[2], paramBuffer.ints[3]
					end;
					bool = function(name)
						getIntegerv(name, paramBuffer.ints)
						return paramBuffer.ints[0] ~= 0
					end;
					bool2 = function(name)
						getIntegerv(name, paramBuffer.ints)
						return paramBuffer.ints[0] ~= 0, paramBuffer.ints[1] ~= 0
					end;
					bool3 = function(name)
						getIntegerv(name, paramBuffer.ints)
						return paramBuffer.ints[0] ~= 0, paramBuffer.ints[1] ~= 0, paramBuffer.ints[2] ~= 0
					end;
					bool4 = function(name)
						getIntegerv(name, paramBuffer.ints)
						return paramBuffer.ints[0] ~= 0, paramBuffer.ints[1] ~= 0, paramBuffer.ints[2] ~= 0, paramBuffer.ints[3] ~= 0
					end;
					float = function(name)
						getFloatv(name, paramBuffer.floats)
						return paramBuffer.floats[0]
					end;
					float2 = function(name)
						getFloatv(name, paramBuffer.floats)
						return paramBuffer.floats[0], paramBuffer.floats[1]
					end;
					float3 = function(name)
						getFloatv(name, paramBuffer.floats)
						return paramBuffer.floats[0], paramBuffer.floats[1], paramBuffer.floats[2]
					end;
					float4 = function(name)
						getFloatv(name, paramBuffer.floats)
						return paramBuffer.floats[0], paramBuffer.floats[1], paramBuffer.floats[2], paramBuffer.floats[3]
					end;
					float16 = function(name)
						getFloatv(name, paramBuffer.floats)
						return
							paramBuffer.floats[0],  paramBuffer.floats[1],  paramBuffer.floats[2],  paramBuffer.floats[3],
							paramBuffer.floats[4],  paramBuffer.floats[5],  paramBuffer.floats[6],  paramBuffer.floats[7],
							paramBuffer.floats[8],  paramBuffer.floats[9],  paramBuffer.floats[10], paramBuffer.floats[11],
							paramBuffer.floats[12], paramBuffer.floats[13], paramBuffer.floats[14], paramBuffer.floats[15]
					end
				}
				
				for k,boxer in pairs(box) do
					typeGetters[k] = function(name)
						getIntegerv(name, paramBuffer.ints)
						return boxer(paramBuffer.ints[0])
					end
				end
				
				local function getParameter_texture(name)
					getIntegerv(name, paramBuffer.ints)
					return box.Texture(paramBuffer.ints[0])
				end
				
				local NUM_COMPRESSED_TEXTURE_FORMATS = 0x86A2
				local COMPRESSED_TEXTURE_FORMATS = 0x86A3
				local paramGetters = {
					[COMPRESSED_TEXTURE_FORMATS] = function()
						getIntegerv(NUM_COMPRESSED_TEXTURE_FORMATS, paramBuffer.ints)
						local formats = ffi.new('int[?]', paramBuffer.ints[0])
						local intable = {}
						for i = 1, paramBuffer.ints[0] do
							intable[i] = tonumber(formats[i-1])
						end
						return intable
					end;
				}
				
				function loader.context.getParameter(name)
					name = assert(tonumber(name), 'bad argument #1: expecting symbolic constant')
					local getter = paramGetters[name]
					if not getter then
						for paramName, paramType in pairs(paramTypes) do
							local paramCode = context[loader:mangleConstantName(paramName)]
							if paramCode then
								local paramGetter = typeGetters[paramType]
								if not paramGetter then
									error('no getter for ' .. paramType)
								end
								paramGetters[paramCode] = paramGetter
								if (code == name) then
									getter = paramGetter
								end
							end
						end
					end
					if not getter then
						error('unknown OpenGL parameter: ' .. name, 2)
					end
					return getter(name)
				end
			end
		end
		
		loader:loadPackage(require 'extern.opengl.packages.VERSION_1_1')
		
		local getString = context[loader:mangleFunctionName("GetString")]
		local VERSION = context[loader:mangleConstantName("VERSION")]
    
		local v = getString(VERSION)
		
		local major, minor = v:match('^(%d+)%.(%d+)')
		loader:loadPackage(require('extern.opengl.packages.VERSION_' .. major .. '_' .. minor))
		
		return context
	end

end
return contextFactory
