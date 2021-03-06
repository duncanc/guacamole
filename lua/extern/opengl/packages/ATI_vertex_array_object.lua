return {
  basicTypes = {
    GLuint = "unsigned int";
    GLsizei = "int";
    GLvoid = "void";
    GLenum = "unsigned int";
    GLboolean = "unsigned char";
    GLenum = "unsigned int";
    GLenum = "unsigned int";
    GLfloat = "float";
    GLint = "int";
    GLenum = "unsigned int";
    GLenum = "unsigned int";
  };
  typeAliases = {
    UInt32 = "GLuint";
    SizeI = "GLsizei";
    ConstVoid = "GLvoid";
    ArrayObjectUsageATI = "GLenum";
    Boolean = "GLboolean";
    PreserveModeATI = "GLenum";
    ArrayObjectPNameATI = "GLenum";
    Float32 = "GLfloat";
    Int32 = "GLint";
    EnableCap = "GLenum";
    ScalarType = "GLenum";
  };
  magicNumbers = {
    STATIC_ATI = 0x8760;
    DYNAMIC_ATI = 0x8761;
    PRESERVE_ATI = 0x8762;
    DISCARD_ATI = 0x8763;
    OBJECT_BUFFER_SIZE_ATI = 0x8764;
    OBJECT_BUFFER_USAGE_ATI = 0x8765;
    ARRAY_OBJECT_BUFFER_ATI = 0x8766;
    ARRAY_OBJECT_OFFSET_ATI = 0x8767;
  };
  funcs = {
    {'NewObjectBufferATI', ret='UInt32';
      'SizeI', 'size';
      'const ConstVoid*', 'pointer';
      'ArrayObjectUsageATI', 'usage'};
    {'IsObjectBufferATI', ret='Boolean';
      'UInt32', 'buffer'};
    {'UpdateObjectBufferATI';
      'UInt32', 'buffer';
      'UInt32', 'offset';
      'SizeI', 'size';
      'const ConstVoid*', 'pointer';
      'PreserveModeATI', 'preserve'};
    {'GetObjectBufferfvATI';
      'UInt32', 'buffer';
      'ArrayObjectPNameATI', 'pname';
      'Float32*', 'params'};
    {'GetObjectBufferivATI';
      'UInt32', 'buffer';
      'ArrayObjectPNameATI', 'pname';
      'Int32*', 'params'};
    {'FreeObjectBufferATI';
      'UInt32', 'buffer'};
    {'ArrayObjectATI';
      'EnableCap', 'array';
      'Int32', 'size';
      'ScalarType', 'type';
      'SizeI', 'stride';
      'UInt32', 'buffer';
      'UInt32', 'offset'};
    {'GetArrayObjectfvATI';
      'EnableCap', 'array';
      'ArrayObjectPNameATI', 'pname';
      'Float32*', 'params'};
    {'GetArrayObjectivATI';
      'EnableCap', 'array';
      'ArrayObjectPNameATI', 'pname';
      'Int32*', 'params'};
    {'VariantArrayObjectATI';
      'UInt32', 'id';
      'ScalarType', 'type';
      'SizeI', 'stride';
      'UInt32', 'buffer';
      'UInt32', 'offset'};
    {'GetVariantArrayObjectfvATI';
      'UInt32', 'id';
      'ArrayObjectPNameATI', 'pname';
      'Float32*', 'params'};
    {'GetVariantArrayObjectivATI';
      'UInt32', 'id';
      'ArrayObjectPNameATI', 'pname';
      'Int32*', 'params'};
  };
}
