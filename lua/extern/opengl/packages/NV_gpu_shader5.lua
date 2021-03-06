return {
  basicTypes = {
    GLint = "int";
    GLint64EXT = "int64_t";
    GLsizei = "int";
    GLuint64EXT = "uint64_t";
    GLuint = "unsigned int";
  };
  typeAliases = {
    Int32 = "GLint";
    Int64EXT = "GLint64EXT";
    SizeI = "GLsizei";
    UInt64EXT = "GLuint64EXT";
    UInt32 = "GLuint";
  };
  magicNumbers = {
    INT64_NV = 0x140E;
    UNSIGNED_INT64_NV = 0x140F;
    INT8_NV = 0x8FE0;
    INT8_VEC2_NV = 0x8FE1;
    INT8_VEC3_NV = 0x8FE2;
    INT8_VEC4_NV = 0x8FE3;
    INT16_NV = 0x8FE4;
    INT16_VEC2_NV = 0x8FE5;
    INT16_VEC3_NV = 0x8FE6;
    INT16_VEC4_NV = 0x8FE7;
    INT64_VEC2_NV = 0x8FE9;
    INT64_VEC3_NV = 0x8FEA;
    INT64_VEC4_NV = 0x8FEB;
    UNSIGNED_INT8_NV = 0x8FEC;
    UNSIGNED_INT8_VEC2_NV = 0x8FED;
    UNSIGNED_INT8_VEC3_NV = 0x8FEE;
    UNSIGNED_INT8_VEC4_NV = 0x8FEF;
    UNSIGNED_INT16_NV = 0x8FF0;
    UNSIGNED_INT16_VEC2_NV = 0x8FF1;
    UNSIGNED_INT16_VEC3_NV = 0x8FF2;
    UNSIGNED_INT16_VEC4_NV = 0x8FF3;
    UNSIGNED_INT64_VEC2_NV = 0x8FF5;
    UNSIGNED_INT64_VEC3_NV = 0x8FF6;
    UNSIGNED_INT64_VEC4_NV = 0x8FF7;
    FLOAT16_NV = 0x8FF8;
    FLOAT16_VEC2_NV = 0x8FF9;
    FLOAT16_VEC3_NV = 0x8FFA;
    FLOAT16_VEC4_NV = 0x8FFB;
    PATCHES = 0x000E;
  };
  funcs = {
    {'Uniform1i64NV';
      'Int32', 'location';
      'Int64EXT', 'x'};
    {'Uniform2i64NV';
      'Int32', 'location';
      'Int64EXT', 'x';
      'Int64EXT', 'y'};
    {'Uniform3i64NV';
      'Int32', 'location';
      'Int64EXT', 'x';
      'Int64EXT', 'y';
      'Int64EXT', 'z'};
    {'Uniform4i64NV';
      'Int32', 'location';
      'Int64EXT', 'x';
      'Int64EXT', 'y';
      'Int64EXT', 'z';
      'Int64EXT', 'w'};
    {'Uniform1i64vNV';
      'Int32', 'location';
      'SizeI', 'count';
      'const Int64EXT*', 'value'};
    {'Uniform2i64vNV';
      'Int32', 'location';
      'SizeI', 'count';
      'const Int64EXT*', 'value'};
    {'Uniform3i64vNV';
      'Int32', 'location';
      'SizeI', 'count';
      'const Int64EXT*', 'value'};
    {'Uniform4i64vNV';
      'Int32', 'location';
      'SizeI', 'count';
      'const Int64EXT*', 'value'};
    {'Uniform1ui64NV';
      'Int32', 'location';
      'UInt64EXT', 'x'};
    {'Uniform2ui64NV';
      'Int32', 'location';
      'UInt64EXT', 'x';
      'UInt64EXT', 'y'};
    {'Uniform3ui64NV';
      'Int32', 'location';
      'UInt64EXT', 'x';
      'UInt64EXT', 'y';
      'UInt64EXT', 'z'};
    {'Uniform4ui64NV';
      'Int32', 'location';
      'UInt64EXT', 'x';
      'UInt64EXT', 'y';
      'UInt64EXT', 'z';
      'UInt64EXT', 'w'};
    {'Uniform1ui64vNV';
      'Int32', 'location';
      'SizeI', 'count';
      'const UInt64EXT*', 'value'};
    {'Uniform2ui64vNV';
      'Int32', 'location';
      'SizeI', 'count';
      'const UInt64EXT*', 'value'};
    {'Uniform3ui64vNV';
      'Int32', 'location';
      'SizeI', 'count';
      'const UInt64EXT*', 'value'};
    {'Uniform4ui64vNV';
      'Int32', 'location';
      'SizeI', 'count';
      'const UInt64EXT*', 'value'};
    {'GetUniformi64vNV';
      'UInt32', 'program';
      'Int32', 'location';
      'Int64EXT*', 'params'};
    {'ProgramUniform1i64NV';
      'UInt32', 'program';
      'Int32', 'location';
      'Int64EXT', 'x'};
    {'ProgramUniform2i64NV';
      'UInt32', 'program';
      'Int32', 'location';
      'Int64EXT', 'x';
      'Int64EXT', 'y'};
    {'ProgramUniform3i64NV';
      'UInt32', 'program';
      'Int32', 'location';
      'Int64EXT', 'x';
      'Int64EXT', 'y';
      'Int64EXT', 'z'};
    {'ProgramUniform4i64NV';
      'UInt32', 'program';
      'Int32', 'location';
      'Int64EXT', 'x';
      'Int64EXT', 'y';
      'Int64EXT', 'z';
      'Int64EXT', 'w'};
    {'ProgramUniform1i64vNV';
      'UInt32', 'program';
      'Int32', 'location';
      'SizeI', 'count';
      'const Int64EXT*', 'value'};
    {'ProgramUniform2i64vNV';
      'UInt32', 'program';
      'Int32', 'location';
      'SizeI', 'count';
      'const Int64EXT*', 'value'};
    {'ProgramUniform3i64vNV';
      'UInt32', 'program';
      'Int32', 'location';
      'SizeI', 'count';
      'const Int64EXT*', 'value'};
    {'ProgramUniform4i64vNV';
      'UInt32', 'program';
      'Int32', 'location';
      'SizeI', 'count';
      'const Int64EXT*', 'value'};
    {'ProgramUniform1ui64NV';
      'UInt32', 'program';
      'Int32', 'location';
      'UInt64EXT', 'x'};
    {'ProgramUniform2ui64NV';
      'UInt32', 'program';
      'Int32', 'location';
      'UInt64EXT', 'x';
      'UInt64EXT', 'y'};
    {'ProgramUniform3ui64NV';
      'UInt32', 'program';
      'Int32', 'location';
      'UInt64EXT', 'x';
      'UInt64EXT', 'y';
      'UInt64EXT', 'z'};
    {'ProgramUniform4ui64NV';
      'UInt32', 'program';
      'Int32', 'location';
      'UInt64EXT', 'x';
      'UInt64EXT', 'y';
      'UInt64EXT', 'z';
      'UInt64EXT', 'w'};
    {'ProgramUniform1ui64vNV';
      'UInt32', 'program';
      'Int32', 'location';
      'SizeI', 'count';
      'const UInt64EXT*', 'value'};
    {'ProgramUniform2ui64vNV';
      'UInt32', 'program';
      'Int32', 'location';
      'SizeI', 'count';
      'const UInt64EXT*', 'value'};
    {'ProgramUniform3ui64vNV';
      'UInt32', 'program';
      'Int32', 'location';
      'SizeI', 'count';
      'const UInt64EXT*', 'value'};
    {'ProgramUniform4ui64vNV';
      'UInt32', 'program';
      'Int32', 'location';
      'SizeI', 'count';
      'const UInt64EXT*', 'value'};
  };
}
