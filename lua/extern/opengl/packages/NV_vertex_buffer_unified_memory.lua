return {
  basicTypes = {
    GLenum = "unsigned int";
    GLuint = "unsigned int";
    GLuint64EXT = "uint64_t";
    GLsizeiptr = "ptrdiff_t";
    GLint = "int";
    GLsizei = "int";
    GLboolean = "unsigned char";
  };
  magicNumbers = {
    VERTEX_ATTRIB_ARRAY_UNIFIED_NV = 0x8F1E;
    ELEMENT_ARRAY_UNIFIED_NV = 0x8F1F;
    VERTEX_ATTRIB_ARRAY_ADDRESS_NV = 0x8F20;
    VERTEX_ARRAY_ADDRESS_NV = 0x8F21;
    NORMAL_ARRAY_ADDRESS_NV = 0x8F22;
    COLOR_ARRAY_ADDRESS_NV = 0x8F23;
    INDEX_ARRAY_ADDRESS_NV = 0x8F24;
    TEXTURE_COORD_ARRAY_ADDRESS_NV = 0x8F25;
    EDGE_FLAG_ARRAY_ADDRESS_NV = 0x8F26;
    SECONDARY_COLOR_ARRAY_ADDRESS_NV = 0x8F27;
    FOG_COORD_ARRAY_ADDRESS_NV = 0x8F28;
    ELEMENT_ARRAY_ADDRESS_NV = 0x8F29;
    VERTEX_ATTRIB_ARRAY_LENGTH_NV = 0x8F2A;
    VERTEX_ARRAY_LENGTH_NV = 0x8F2B;
    NORMAL_ARRAY_LENGTH_NV = 0x8F2C;
    COLOR_ARRAY_LENGTH_NV = 0x8F2D;
    INDEX_ARRAY_LENGTH_NV = 0x8F2E;
    TEXTURE_COORD_ARRAY_LENGTH_NV = 0x8F2F;
    EDGE_FLAG_ARRAY_LENGTH_NV = 0x8F30;
    SECONDARY_COLOR_ARRAY_LENGTH_NV = 0x8F31;
    FOG_COORD_ARRAY_LENGTH_NV = 0x8F32;
    ELEMENT_ARRAY_LENGTH_NV = 0x8F33;
    DRAW_INDIRECT_UNIFIED_NV = 0x8F40;
    DRAW_INDIRECT_ADDRESS_NV = 0x8F41;
    DRAW_INDIRECT_LENGTH_NV = 0x8F42;
  };
  funcs = {
    {'BufferAddressRangeNV';
      'GLenum', 'pname';
      'UInt32', 'index';
      'UInt64EXT', 'address';
      'BufferSize', 'length'};
    {'VertexFormatNV';
      'Int32', 'size';
      'GLenum', 'type';
      'SizeI', 'stride'};
    {'NormalFormatNV';
      'GLenum', 'type';
      'SizeI', 'stride'};
    {'ColorFormatNV';
      'Int32', 'size';
      'GLenum', 'type';
      'SizeI', 'stride'};
    {'IndexFormatNV';
      'GLenum', 'type';
      'SizeI', 'stride'};
    {'TexCoordFormatNV';
      'Int32', 'size';
      'GLenum', 'type';
      'SizeI', 'stride'};
    {'EdgeFlagFormatNV';
      'SizeI', 'stride'};
    {'SecondaryColorFormatNV';
      'Int32', 'size';
      'GLenum', 'type';
      'SizeI', 'stride'};
    {'FogCoordFormatNV';
      'GLenum', 'type';
      'SizeI', 'stride'};
    {'VertexAttribFormatNV';
      'UInt32', 'index';
      'Int32', 'size';
      'GLenum', 'type';
      'Boolean', 'normalized';
      'SizeI', 'stride'};
    {'VertexAttribIFormatNV';
      'UInt32', 'index';
      'Int32', 'size';
      'GLenum', 'type';
      'SizeI', 'stride'};
    {'GetIntegerui64i_vNV';
      'GLenum', 'value';
      'UInt32', 'index';
      'UInt64EXT*', 'result'};
  };
}
