
local ffi    = require 'ffi'
local extern = require 'extern'

extern.defineversion(..., 'freetype', 'v2_4_4')

ffi.cdef [[

  typedef unsigned char FT_Bool;
  typedef signed short FT_FWord;
  typedef unsigned short FT_UFWord;
  typedef signed char FT_Char;
  typedef unsigned char FT_Byte;
  typedef const FT_Byte* FT_Bytes;
  typedef uint32_t FT_Tag;
  typedef char FT_String;
  typedef signed short FT_Short;
  typedef unsigned short FT_UShort;
  typedef signed int FT_Int;
  typedef unsigned int FT_UInt;
  typedef signed long FT_Long;
  typedef unsigned long FT_ULong;
  typedef signed short FT_F2Dot14;
  typedef signed long FT_F26Dot6;
  typedef signed long FT_Fixed;
  typedef int FT_Error;
  typedef void* FT_Pointer;
  typedef size_t FT_Offset;
  typedef signed long FT_Pos;
	
	typedef int FT_Enum;
	
	enum {
		FT_RENDER_POOL_SIZE = 16384,
		FT_MAX_MODULES = 32,
		T1_MAX_DICT_DEPTH = 5,
		T1_MAX_SUBRS_CALLS = 16,
		T1_MAX_CHARSTRINGS_OPERANDS = 256,
		FT_ALIGNMENT = 8,
		FT_Mod_Err_Base = 0x000,
		FT_Mod_Err_Autofit = 0x100,
		FT_Mod_Err_BDF = 0x200,
		FT_Mod_Err_Cache = 0x300,
		FT_Mod_Err_CFF = 0x400,
		FT_Mod_Err_CID = 0x500,
		FT_Mod_Err_Gzip = 0x600,
		FT_Mod_Err_LZW = 0x700,
		FT_Mod_Err_OTvalid = 0x800,
		FT_Mod_Err_PCF = 0x900,
		FT_Mod_Err_PFR = 0xA00,
		FT_Mod_Err_PSaux = 0xB00,
		FT_Mod_Err_PShinter = 0xC00,
		FT_Mod_Err_PSnames = 0xD00,
		FT_Mod_Err_Raster = 0xE00,
		FT_Mod_Err_SFNT = 0xF00,
		FT_Mod_Err_Smooth = 0x1000,
		FT_Mod_Err_TrueType = 0x1100,
		FT_Mod_Err_Type1 = 0x1200,
		FT_Mod_Err_Type42 = 0x1300,
		FT_Mod_Err_Winfonts = 0x1400,
		FT_Err_Ok = 0x00,
		FT_Err_Cannot_Open_Resource = 0x01,
		FT_Err_Unknown_File_Format = 0x02,
		FT_Err_Invalid_File_Format = 0x03,
		FT_Err_Invalid_Version = 0x04,
		FT_Err_Lower_Module_Version = 0x05,
		FT_Err_Invalid_Argument = 0x06,
		FT_Err_Unimplemented_Feature = 0x07,
		FT_Err_Invalid_Table = 0x08,
		FT_Err_Invalid_Offset = 0x09,
		FT_Err_Array_Too_Large = 0x0A,
		FT_Err_Invalid_Glyph_Index = 0x10,
		FT_Err_Invalid_Character_Code = 0x11,
		FT_Err_Invalid_Glyph_Format = 0x12,
		FT_Err_Cannot_Render_Glyph = 0x13,
		FT_Err_Invalid_Outline = 0x14,
		FT_Err_Invalid_Composite = 0x15,
		FT_Err_Too_Many_Hints = 0x16,
		FT_Err_Invalid_Pixel_Size = 0x17,
		FT_Err_Invalid_Handle = 0x20,
		FT_Err_Invalid_Library_Handle = 0x21,
		FT_Err_Invalid_Driver_Handle = 0x22,
		FT_Err_Invalid_Face_Handle = 0x23,
		FT_Err_Invalid_Size_Handle = 0x24,
		FT_Err_Invalid_Slot_Handle = 0x25,
		FT_Err_Invalid_CharMap_Handle = 0x26,
		FT_Err_Invalid_Cache_Handle = 0x27,
		FT_Err_Invalid_Stream_Handle = 0x28,
		FT_Err_Too_Many_Drivers = 0x30,
		FT_Err_Too_Many_Extensions = 0x31,
		FT_Err_Out_Of_Memory = 0x40,
		FT_Err_Unlisted_Object = 0x41,
		FT_Err_Cannot_Open_Stream = 0x51,
		FT_Err_Invalid_Stream_Seek = 0x52,
		FT_Err_Invalid_Stream_Skip = 0x53,
		FT_Err_Invalid_Stream_Read = 0x54,
		FT_Err_Invalid_Stream_Operation = 0x55,
		FT_Err_Invalid_Frame_Operation = 0x56,
		FT_Err_Nested_Frame_Access = 0x57,
		FT_Err_Invalid_Frame_Read = 0x58,
		FT_Err_Raster_Uninitialized = 0x60,
		FT_Err_Raster_Corrupted = 0x61,
		FT_Err_Raster_Overflow = 0x62,
		FT_Err_Raster_Negative_Height = 0x63,
		FT_Err_Too_Many_Caches = 0x70,
		FT_Err_Invalid_Opcode = 0x80,
		FT_Err_Too_Few_Arguments = 0x81,
		FT_Err_Stack_Overflow = 0x82,
		FT_Err_Code_Overflow = 0x83,
		FT_Err_Bad_Argument = 0x84,
		FT_Err_Divide_By_Zero = 0x85,
		FT_Err_Invalid_Reference = 0x86,
		FT_Err_Debug_OpCode = 0x87,
		FT_Err_ENDF_In_Exec_Stream = 0x88,
		FT_Err_Nested_DEFS = 0x89,
		FT_Err_Invalid_CodeRange = 0x8A,
		FT_Err_Execution_Too_Long = 0x8B,
		FT_Err_Too_Many_Function_Defs = 0x8C,
		FT_Err_Too_Many_Instruction_Defs = 0x8D,
		FT_Err_Table_Missing = 0x8E,
		FT_Err_Horiz_Header_Missing = 0x8F,
		FT_Err_Locations_Missing = 0x90,
		FT_Err_Name_Table_Missing = 0x91,
		FT_Err_CMap_Table_Missing = 0x92,
		FT_Err_Hmtx_Table_Missing = 0x93,
		FT_Err_Post_Table_Missing = 0x94,
		FT_Err_Invalid_Horiz_Metrics = 0x95,
		FT_Err_Invalid_CharMap_Format = 0x96,
		FT_Err_Invalid_PPem = 0x97,
		FT_Err_Invalid_Vert_Metrics = 0x98,
		FT_Err_Could_Not_Find_Context = 0x99,
		FT_Err_Invalid_Post_Table_Format = 0x9A,
		FT_Err_Invalid_Post_Table = 0x9B,
		FT_Err_Syntax_Error = 0xA0,
		FT_Err_Stack_Underflow = 0xA1,
		FT_Err_Ignore = 0xA2,
		FT_Err_No_Unicode_Glyph_Name = 0xA3,
		FT_Err_Missing_Startfont_Field = 0xB0,
		FT_Err_Missing_Font_Field = 0xB1,
		FT_Err_Missing_Size_Field = 0xB2,
		FT_Err_Missing_Fontboundingbox_Field = 0xB3,
		FT_Err_Missing_Chars_Field = 0xB4,
		FT_Err_Missing_Startchar_Field = 0xB5,
		FT_Err_Missing_Encoding_Field = 0xB6,
		FT_Err_Missing_Bbx_Field = 0xB7,
		FT_Err_Bbx_Too_Big = 0xB8,
		FT_Err_Corrupted_Font_Header = 0xB9,
		FT_Err_Corrupted_Font_Glyphs = 0xBA,
		FT_FACE_FLAG_SCALABLE = 1,
		FT_FACE_FLAG_FIXED_SIZES = 2,
		FT_FACE_FLAG_FIXED_WIDTH = 4,
		FT_FACE_FLAG_SFNT = 8,
		FT_FACE_FLAG_HORIZONTAL = 16,
		FT_FACE_FLAG_VERTICAL = 32,
		FT_FACE_FLAG_KERNING = 64,
		FT_FACE_FLAG_FAST_GLYPHS = 128,
		FT_FACE_FLAG_MULTIPLE_MASTERS = 256,
		FT_FACE_FLAG_GLYPH_NAMES = 512,
		FT_FACE_FLAG_EXTERNAL_STREAM = 1024,
		FT_FACE_FLAG_HINTER = 2048,
		FT_FACE_FLAG_CID_KEYED = 4096,
		FT_FACE_FLAG_TRICKY = 8192,
		FT_STYLE_FLAG_ITALIC = 1,
		FT_STYLE_FLAG_BOLD = 2,
		FT_OPEN_MEMORY = 0x1,
		FT_OPEN_STREAM = 0x2,
		FT_OPEN_PATHNAME = 0x4,
		FT_OPEN_DRIVER = 0x8,
		FT_OPEN_PARAMS = 0x10,
    FT_PIXEL_MODE_NONE = 0,
    FT_PIXEL_MODE_MONO = 1,
    FT_PIXEL_MODE_GRAY = 2,
    FT_PIXEL_MODE_GRAY2 = 3,
    FT_PIXEL_MODE_GRAY4 = 4,
    FT_PIXEL_MODE_LCD = 5,
    FT_PIXEL_MODE_LCD_V = 6,
    FT_PIXEL_MODE_MAX = 7,
		FT_OUTLINE_NONE = 0x0,
		FT_OUTLINE_OWNER = 0x1,
		FT_OUTLINE_EVEN_ODD_FILL = 0x2,
		FT_OUTLINE_REVERSE_FILL = 0x4,
		FT_OUTLINE_IGNORE_DROPOUTS = 0x8,
		FT_OUTLINE_SMART_DROPOUTS = 0x10,
		FT_OUTLINE_INCLUDE_STUBS = 0x20,
		FT_OUTLINE_HIGH_PRECISION = 0x100,
		FT_OUTLINE_SINGLE_PASS = 0x200,
		FT_CURVE_TAG_ON = 1,
		FT_CURVE_TAG_CONIC = 0,
		FT_CURVE_TAG_CUBIC = 2,
		FT_CURVE_TAG_HAS_SCANMODE = 4,
		FT_CURVE_TAG_TOUCH_X = 8,
		FT_CURVE_TAG_TOUCH_Y = 16,
		FT_CURVE_TAG_TOUCH_BOTH = 24,
		FT_Curve_Tag_On = FT_CURVE_TAG_ON,
		FT_Curve_Tag_Conic = FT_CURVE_TAG_CONIC,
		FT_Curve_Tag_Cubic = FT_CURVE_TAG_CUBIC,
		FT_Curve_Tag_Touch_X = FT_CURVE_TAG_TOUCH_X,
		FT_Curve_Tag_Touch_Y = FT_CURVE_TAG_TOUCH_Y,
		FT_RASTER_FLAG_DEFAULT = 0x0,
		FT_RASTER_FLAG_AA = 0x1,
		FT_RASTER_FLAG_DIRECT = 0x2,
		FT_RASTER_FLAG_CLIP = 0x4,
		FT_LOAD_DEFAULT = 0x0,
		FT_LOAD_NO_SCALE = 0x1,
		FT_LOAD_NO_HINTING = 0x2,
		FT_LOAD_RENDER = 0x4,
		FT_LOAD_NO_BITMAP = 0x8,
		FT_LOAD_VERTICAL_LAYOUT = 0x10,
		FT_LOAD_FORCE_AUTOHINT = 0x20,
		FT_LOAD_CROP_BITMAP = 0x40,
		FT_LOAD_PEDANTIC = 0x80,
		FT_LOAD_IGNORE_GLOBAL_ADVANCE_WIDTH = 0x200,
		FT_LOAD_NO_RECURSE = 0x400,
		FT_LOAD_IGNORE_TRANSFORM = 0x800,
		FT_LOAD_MONOCHROME = 0x1000,
		FT_LOAD_LINEAR_DESIGN = 0x2000,
		FT_LOAD_NO_AUTOHINT = 0x8000,
		FT_LOAD_ADVANCE_ONLY = 0x100,
		FT_LOAD_SBITS_ONLY = 0x4000,
		FT_LOAD_TARGET_NORMAL = 0,
		FT_LOAD_TARGET_LIGHT = 0x10000,
		FT_LOAD_TARGET_MONO = 0x20000,
		FT_LOAD_TARGET_LCD = 0x30000,
		FT_LOAD_TARGET_LCD_V = 0x40000,
    FT_KERNING_DEFAULT = 0,
    FT_KERNING_UNFITTED = 1,
    FT_KERNING_UNSCALED = 2,
		FT_SUBGLYPH_FLAG_ARGS_ARE_WORDS = 1,
		FT_SUBGLYPH_FLAG_ARGS_ARE_XY_VALUES = 2,
		FT_SUBGLYPH_FLAG_ROUND_XY_TO_GRID = 4,
		FT_SUBGLYPH_FLAG_SCALE = 8,
		FT_SUBGLYPH_FLAG_XY_SCALE = 0x40,
		FT_SUBGLYPH_FLAG_2X2 = 0x80,
		FT_SUBGLYPH_FLAG_USE_MY_METRICS = 0x200,
		FT_FSTYPE_INSTALLABLE_EMBEDDING = 0x0000,
		FT_FSTYPE_RESTRICTED_LICENSE_EMBEDDING = 0x0002,
		FT_FSTYPE_PREVIEW_AND_PRINT_EMBEDDING = 0x0004,
		FT_FSTYPE_EDITABLE_EMBEDDING = 0x0008,
		FT_FSTYPE_NO_SUBSETTING = 0x0100,
		FT_FSTYPE_BITMAP_EMBEDDING_ONLY = 0x0200,
		FREETYPE_MAJOR = 2,
		FREETYPE_MINOR = 4,
		FREETYPE_PATCH = 4
	};
	
	typedef enum {
    FT_GLYPH_FORMAT_NONE = 0,
		FT_GLYPH_FORMAT_COMPOSITE = 0x636f6d70,
		FT_GLYPH_FORMAT_BITMAP = 0x62697473,
		FT_GLYPH_FORMAT_OUTLINE = 0x6f75746c,
		FT_GLYPH_FORMAT_PLOTTER = 0x706c6f74
	} FT_Glyph_Format;
	
	typedef enum {
    FT_ENCODING_NONE = 0,
    FT_ENCODING_MS_SYMBOL = 0x73796d62,
    FT_ENCODING_UNICODE = 0x756e6963,
    FT_ENCODING_SJIS = 0x736a6973,
    FT_ENCODING_GB2312 = 0x67622020,
    FT_ENCODING_BIG5 = 0x62696735,
    FT_ENCODING_WANSUNG = 0x77616e73,
    FT_ENCODING_JOHAB = 0x6a6f6861,
    FT_ENCODING_MS_SJIS = FT_ENCODING_SJIS,
    FT_ENCODING_MS_GB2312 = FT_ENCODING_GB2312,
    FT_ENCODING_MS_BIG5 = FT_ENCODING_BIG5,
    FT_ENCODING_MS_WANSUNG = FT_ENCODING_WANSUNG,
    FT_ENCODING_MS_JOHAB = FT_ENCODING_JOHAB,
		FT_ENCODING_ADOBE_STANDARD = 0x41444f42,
		FT_ENCODING_ADOBE_EXPERT = 0x41444245,
		FT_ENCODING_ADOBE_CUSTOM = 0x41444243,
		FT_ENCODING_ADOBE_LATIN_1 = 0x6c617431,
		FT_ENCODING_OLD_LATIN_2 = 0x6c617432,
		FT_ENCODING_APPLE_ROMAN = 0x61726d6e
	} FT_Encoding;
	
	typedef enum {
    FT_SIZE_REQUEST_TYPE_NOMINAL = 0,
    FT_SIZE_REQUEST_TYPE_REAL_DIM = 1,
    FT_SIZE_REQUEST_TYPE_BBOX = 2,
    FT_SIZE_REQUEST_TYPE_CELL = 3,
    FT_SIZE_REQUEST_TYPE_SCALES = 4,
    FT_SIZE_REQUEST_TYPE_MAX = 5
	} FT_Size_Request_Type;
	
	typedef enum {
    FT_RENDER_MODE_NORMAL = 0,
    FT_RENDER_MODE_LIGHT = 1,
    FT_RENDER_MODE_MONO = 2,
    FT_RENDER_MODE_LCD = 3,
    FT_RENDER_MODE_LCD_V = 4,
    FT_RENDER_MODE_MAX = 5
	} FT_Render_Mode;
	
  typedef enum  FT_Glyph_BBox_Mode_
  {
    FT_GLYPH_BBOX_UNSCALED  = 0,
    FT_GLYPH_BBOX_SUBPIXELS = 0,
    FT_GLYPH_BBOX_GRIDFIT   = 1,
    FT_GLYPH_BBOX_TRUNCATE  = 2,
    FT_GLYPH_BBOX_PIXELS    = 3

  } FT_Glyph_BBox_Mode;

  typedef struct FT_MemoryRec_* FT_Memory;
  typedef void* (*FT_Alloc_Func)(FT_Memory memory, long size);
  typedef void (*FT_Free_Func)(FT_Memory memory, void* block);
  typedef void* (*FT_Realloc_Func)(FT_Memory memory, long cur_size, long new_size, void* block);
	
  struct FT_MemoryRec_ {
    void* user;
    FT_Alloc_Func alloc;
    FT_Free_Func free;
    FT_Realloc_Func realloc;
  };
	
  typedef struct FT_StreamRec_* FT_Stream;
	
  typedef union FT_StreamDesc_ {
    long value;
    void* pointer;
  } FT_StreamDesc;
	
  typedef unsigned long (*FT_Stream_IoFunc)(FT_Stream stream, unsigned long offset, unsigned char* buffer, unsigned long count);
	
  typedef void (*FT_Stream_CloseFunc)(FT_Stream stream);
	
  typedef struct FT_StreamRec_ {
    unsigned char* base;
    unsigned long size;
    unsigned long pos;
    FT_StreamDesc descriptor;
    FT_StreamDesc pathname;
    FT_Stream_IoFunc read;
    FT_Stream_CloseFunc close;
    FT_Memory memory;
    unsigned char* cursor;
    unsigned char* limit;
  } FT_StreamRec;
	
  typedef struct FT_Vector_ {
    FT_Pos x, y;
  } FT_Vector;
	
  typedef struct FT_BBox_ {
    FT_Pos xMin, yMin;
    FT_Pos xMax, yMax;
  } FT_BBox;
	
  typedef struct FT_Bitmap_ {
    int rows, width, pitch;
    unsigned char* buffer;
    short num_grays;
    char pixel_mode;
    char palette_mode;
    void* palette;
  } FT_Bitmap;
	
  typedef struct FT_Outline_ {
    short n_contours;
    short n_points;
    FT_Vector* points;
    char* tags;
    short* contours;
    int flags;
  } FT_Outline;

  typedef int (*FT_Outline_MoveToFunc)(const FT_Vector* to, void* user);
  typedef int (*FT_Outline_LineToFunc)(const FT_Vector* to, void* user);
  typedef int (*FT_Outline_ConicToFunc)(const FT_Vector* control, const FT_Vector* to, void* user);
  typedef int (*FT_Outline_CubicToFunc)(const FT_Vector* control1, const FT_Vector* control2, const FT_Vector* to, void* user);
	
  typedef struct FT_Outline_Funcs_ {
    FT_Outline_MoveToFunc move_to;
    FT_Outline_LineToFunc line_to;
    FT_Outline_ConicToFunc conic_to;
    FT_Outline_CubicToFunc cubic_to;
    int shift;
    FT_Pos delta;
  } FT_Outline_Funcs;
	
  typedef struct FT_RasterRec_* FT_Raster;
	
  typedef struct FT_Span_ {
    short x;
    unsigned short len;
    unsigned char coverage;
  } FT_Span;
	
  typedef void (*FT_SpanFunc)(int y, int count, const FT_Span* spans, void* user);
	
  typedef int (*FT_Raster_BitTest_Func)(int y, int x, void* user);
  typedef void (*FT_Raster_BitSet_Func)(int y, int x, void* user);
	
  typedef struct FT_Raster_Params_ {
    const FT_Bitmap* target;
    const void* source;
    int flags;
    FT_SpanFunc gray_spans;
    FT_SpanFunc black_spans;
    FT_Raster_BitTest_Func bit_test;
    FT_Raster_BitSet_Func bit_set;
    void* user;
    FT_BBox clip_box;
  } FT_Raster_Params;
	
  typedef int (*FT_Raster_NewFunc)(void* memory, FT_Raster* raster);
  typedef void (*FT_Raster_DoneFunc)(FT_Raster raster);
  typedef void (*FT_Raster_ResetFunc)(FT_Raster raster, unsigned char* pool_base, unsigned long pool_size);
  typedef int (*FT_Raster_SetModeFunc)(FT_Raster raster, unsigned long mode, void* args);
  typedef int (*FT_Raster_RenderFunc)(FT_Raster raster, const FT_Raster_Params* params);
	
  typedef struct FT_Raster_Funcs_ {
    FT_Glyph_Format glyph_format;
    FT_Raster_NewFunc raster_new;
    FT_Raster_ResetFunc raster_reset;
    FT_Raster_SetModeFunc raster_set_mode;
    FT_Raster_RenderFunc raster_render;
    FT_Raster_DoneFunc raster_done;
  } FT_Raster_Funcs;

  typedef struct FT_UnitVector_ {
    FT_F2Dot14 x, y;
  } FT_UnitVector;
	
  typedef struct FT_Matrix_ {
    FT_Fixed xx, xy;
    FT_Fixed yx, yy;
  } FT_Matrix;
	
  typedef struct FT_Data_ {
    const FT_Byte* pointer;
    FT_Int length;
  } FT_Data;
	
  typedef void (*FT_Generic_Finalizer)(void* object);
	
  typedef struct FT_Generic_ {
    void* data;
    FT_Generic_Finalizer finalizer;
  } FT_Generic;

  typedef struct FT_ListNodeRec_* FT_ListNode;
  typedef struct FT_ListRec_* FT_List;
	
  typedef struct FT_ListNodeRec_ {
    FT_ListNode prev;
    FT_ListNode next;
    void* data;
  } FT_ListNodeRec;
	
  typedef struct FT_ListRec_ {
    FT_ListNode head;
    FT_ListNode tail;
  } FT_ListRec;

  typedef struct FT_Glyph_Metrics_ {
    FT_Pos width, height;
    FT_Pos horiBearingX, horiBearingY, horiAdvance;
    FT_Pos vertBearingX, vertBearingY, vertAdvance;
  } FT_Glyph_Metrics;
	
  typedef struct FT_Bitmap_Size_ {
    FT_Short height, width;
    FT_Pos size;
    FT_Pos x_ppem, y_ppem;
  } FT_Bitmap_Size;
	
  typedef struct FT_LibraryRec_ *FT_Library;
  typedef struct FT_ModuleRec_* FT_Module;
  typedef struct FT_DriverRec_* FT_Driver;
  typedef struct FT_RendererRec_* FT_Renderer;
  typedef struct FT_FaceRec_* FT_Face;
  typedef struct FT_SizeRec_* FT_Size;
  typedef struct FT_GlyphSlotRec_* FT_GlyphSlot;
  typedef struct FT_CharMapRec_* FT_CharMap;
	
  typedef struct FT_CharMapRec_ {
    FT_Face face;
    FT_Encoding encoding;
    FT_UShort platform_id;
    FT_UShort encoding_id;
  } FT_CharMapRec;
	
  typedef struct FT_Face_InternalRec_* FT_Face_Internal;
	
  typedef struct FT_FaceRec_ {
    FT_Long num_faces;
    FT_Long face_index;
    FT_Long face_flags;
    FT_Long style_flags;
    FT_Long num_glyphs;
    FT_String* family_name;
    FT_String* style_name;
    FT_Int num_fixed_sizes;
    FT_Bitmap_Size* available_sizes;
    FT_Int num_charmaps;
    FT_CharMap* charmaps;
    FT_Generic generic;
    FT_BBox bbox;
    FT_UShort units_per_EM;
    FT_Short ascender;
    FT_Short descender;
    FT_Short height;
    FT_Short max_advance_width;
    FT_Short max_advance_height;
    FT_Short underline_position;
    FT_Short underline_thickness;
    FT_GlyphSlot glyph;
    FT_Size size;
    FT_CharMap charmap;
    FT_Driver driver;
    FT_Memory memory;
    FT_Stream stream;
    FT_ListRec sizes_list;
    FT_Generic autohint;
    void* extensions;
    FT_Face_Internal internal;
  } FT_FaceRec;
  typedef struct FT_Size_InternalRec_* FT_Size_Internal;
  typedef struct FT_Size_Metrics_ {
    FT_UShort x_ppem;
    FT_UShort y_ppem;
    FT_Fixed x_scale;
    FT_Fixed y_scale;
    FT_Pos ascender;
    FT_Pos descender;
    FT_Pos height;
    FT_Pos max_advance;
  } FT_Size_Metrics;
	
  typedef struct FT_SizeRec_ {
    FT_Face face;
    FT_Generic generic;
    FT_Size_Metrics metrics;
    FT_Size_Internal internal;
  } FT_SizeRec;
	
  typedef struct FT_SubGlyphRec_* FT_SubGlyph;
  typedef struct FT_Slot_InternalRec_* FT_Slot_Internal;
  typedef struct FT_GlyphSlotRec_ {
    FT_Library library;
    FT_Face face;
    FT_GlyphSlot next;
    FT_UInt reserved;
    FT_Generic generic;
    FT_Glyph_Metrics metrics;
    FT_Fixed linearHoriAdvance;
    FT_Fixed linearVertAdvance;
    FT_Vector advance;
    FT_Glyph_Format format;
    FT_Bitmap bitmap;
    FT_Int bitmap_left;
    FT_Int bitmap_top;
    FT_Outline outline;
    FT_UInt num_subglyphs;
    FT_SubGlyph subglyphs;
    void* control_data;
    long control_len;
    FT_Pos lsb_delta;
    FT_Pos rsb_delta;
    void* other;
    FT_Slot_Internal internal;
  } FT_GlyphSlotRec;
  typedef struct FT_Parameter_ {
    FT_ULong tag;
    FT_Pointer data;
  } FT_Parameter;
  typedef struct FT_Open_Args_ {
    FT_UInt flags;
    const FT_Byte* memory_base;
    FT_Long memory_size;
    FT_String* pathname;
    FT_Stream stream;
    FT_Module driver;
    FT_Int num_params;
    FT_Parameter* params;
  } FT_Open_Args;
  typedef struct FT_Size_RequestRec_ {
    FT_Size_Request_Type type;
    FT_Long width, height;
    FT_UInt horiResolution, vertResolution;
  } FT_Size_RequestRec;
  typedef struct FT_Size_RequestRec_ *FT_Size_Request;
	
  typedef struct FT_Glyph_Class_  FT_Glyph_Class;
  typedef struct FT_GlyphRec_*  FT_Glyph;
  typedef struct  FT_GlyphRec_
  {
    FT_Library             library;
    const FT_Glyph_Class*  clazz;
    FT_Glyph_Format        format;
    FT_Vector              advance;

  } FT_GlyphRec;
  typedef struct FT_BitmapGlyphRec_*  FT_BitmapGlyph;
  typedef struct  FT_BitmapGlyphRec_
  {
    FT_GlyphRec  root;
    FT_Int       left;
    FT_Int       top;
    FT_Bitmap    bitmap;

  } FT_BitmapGlyphRec;
  typedef struct FT_OutlineGlyphRec_*  FT_OutlineGlyph;
  typedef struct  FT_OutlineGlyphRec_
  {
    FT_GlyphRec  root;
    FT_Outline   outline;
  } FT_OutlineGlyphRec;
	
  FT_Error    FT_Init_FreeType      (FT_Library* out_library);
  FT_Error    FT_Done_FreeType      (FT_Library);
  FT_Error    FT_New_Face           (FT_Library, const char* filepathname, FT_Long face_index, FT_Face* out_face);
  FT_Error    FT_New_Memory_Face    (FT_Library, const FT_Byte* file_base, FT_Long file_size,  FT_Long face_index, FT_Face* out_face);
  FT_Error    FT_Open_Face          (FT_Library, const FT_Open_Args* args, FT_Long face_index, FT_Face *out_face);
  FT_Error    FT_Attach_File        (FT_Face, const char* filepathname);
  FT_Error    FT_Attach_Stream      (FT_Face, FT_Open_Args* parameters);
  FT_Error    FT_Reference_Face     (FT_Face);
  FT_Error    FT_Done_Face          (FT_Face);
  FT_Error    FT_Select_Size        (FT_Face, FT_Int strike_index);	
  FT_Error    FT_Request_Size       (FT_Face, FT_Size_Request req);
  FT_Error    FT_Set_Char_Size      (FT_Face, FT_F26Dot6 char_width, FT_F26Dot6 char_height, FT_UInt horz_resolution, FT_UInt vert_resolution);
  FT_Error    FT_Set_Pixel_Sizes    (FT_Face, FT_UInt pixel_width, FT_UInt pixel_height);
  FT_Error    FT_Load_Glyph         (FT_Face, FT_UInt glyph_index, int32_t load_flags);
  FT_Error    FT_Load_Char          (FT_Face, FT_ULong char_code, int32_t load_flags);
  void        FT_Set_Transform      (FT_Face, FT_Matrix*, FT_Vector* delta);
  FT_Error    FT_Render_Glyph       (FT_GlyphSlot, FT_Render_Mode);	
  FT_Error    FT_Get_Kerning        (FT_Face, FT_UInt left_glyph,  FT_UInt right_glyph, FT_UInt kern_mode,   FT_Vector* akerning);
  FT_Error    FT_Get_Track_Kerning  (FT_Face, FT_Fixed point_size, FT_Int degree,       FT_Fixed* akerning);
  FT_Error    FT_Get_Glyph_Name     (FT_Face, FT_UInt glyph_index, FT_Pointer buffer,   FT_UInt buffer_max);
  const char* FT_Get_Postscript_Name(FT_Face);
  FT_Error    FT_Select_Charmap     (FT_Face, FT_Encoding);
  FT_Error    FT_Set_Charmap        (FT_Face, FT_CharMap);
  FT_Int      FT_Get_Charmap_Index  (FT_CharMap);
  FT_UInt     FT_Get_Char_Index     (FT_Face, FT_ULong charcode);
  FT_ULong    FT_Get_First_Char     (FT_Face, FT_UInt* agindex);
  FT_ULong    FT_Get_Next_Char      (FT_Face, FT_ULong char_code, FT_UInt* agindex);
  FT_UInt     FT_Get_Name_Index     (FT_Face, FT_String* glyph_name);
  FT_Error    FT_Get_SubGlyph_Info  (FT_GlyphSlot glyph, FT_UInt sub_index, FT_Int *p_index, FT_UInt *p_flags, FT_Int *p_arg1, FT_Int *p_arg2, FT_Matrix *p_transform);
  FT_UShort   FT_Get_FSType_Flags   (FT_Face);
  FT_UInt     FT_Face_GetCharVariantIndex    (FT_Face, FT_ULong charcode, FT_ULong variantSelector);
  FT_Int      FT_Face_GetCharVariantIsDefault(FT_Face, FT_ULong charcode, FT_ULong variantSelector);
  uint32_t*   FT_Face_GetVariantSelectors    (FT_Face);
  uint32_t*   FT_Face_GetVariantsOfChar      (FT_Face, FT_ULong charcode);
  uint32_t*   FT_Face_GetCharsOfVariant      (FT_Face, FT_ULong variantSelector);
  FT_Long     FT_MulDiv(FT_Long a, FT_Long b, FT_Long c);
  FT_Long     FT_MulFix(FT_Long a, FT_Long b);
  FT_Long     FT_DivFix(FT_Long a, FT_Long b);
  FT_Fixed    FT_RoundFix(FT_Fixed a);
  FT_Fixed    FT_CeilFix (FT_Fixed a);
  FT_Fixed    FT_FloorFix(FT_Fixed a);
  void        FT_Vector_Transform         (FT_Vector* vec, const FT_Matrix* matrix);
  void        FT_Library_Version          (FT_Library library, FT_Int* amajor, FT_Int* aminor, FT_Int* apatch);
  FT_Bool     FT_Face_CheckTrueTypePatents(FT_Face);
  FT_Bool     FT_Face_SetUnpatentedHinting(FT_Face, FT_Bool value);
  FT_Error    FT_Get_Glyph                (FT_GlyphSlot, FT_Glyph* out_glyph);
  FT_Error    FT_Glyph_Copy               (FT_Glyph source, FT_Glyph* target);
  FT_Error    FT_Glyph_Transform          (FT_Glyph, FT_Matrix* matrix, FT_Vector* delta);
  void        FT_Glyph_Get_CBox           (FT_Glyph, FT_UInt bbox_mode, FT_BBox *acbox);
  FT_Error    FT_Glyph_To_Bitmap          (FT_Glyph* ref_glyph, FT_Render_Mode render_mode, FT_Vector* origin, FT_Bool destroy );
  void        FT_Done_Glyph               (FT_Glyph);
  void        FT_Matrix_Multiply          (const FT_Matrix* a, FT_Matrix* b);
  FT_Error    FT_Matrix_Invert            (FT_Matrix* matrix);
	
]]

-- TODO: work out the name to load for each platform?
return ffi.load 'libfreetype-6'
