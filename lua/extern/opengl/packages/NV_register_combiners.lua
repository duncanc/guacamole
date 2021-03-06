return {
  basicTypes = {
    GLenum = "unsigned int";
    GLfloat = "float";
    GLfloat = "float";
    GLint = "int";
    GLint = "int";
    GLenum = "unsigned int";
    GLenum = "unsigned int";
    GLenum = "unsigned int";
    GLenum = "unsigned int";
    GLenum = "unsigned int";
    GLenum = "unsigned int";
    GLenum = "unsigned int";
    GLenum = "unsigned int";
    GLboolean = "unsigned char";
  };
  typeAliases = {
    CombinerParameterNV = "GLenum";
    CheckedFloat32 = "GLfloat";
    Float32 = "GLfloat";
    CheckedInt32 = "GLint";
    Int32 = "GLint";
    CombinerStageNV = "GLenum";
    CombinerPortionNV = "GLenum";
    CombinerVariableNV = "GLenum";
    CombinerRegisterNV = "GLenum";
    CombinerMappingNV = "GLenum";
    CombinerComponentUsageNV = "GLenum";
    CombinerScaleNV = "GLenum";
    CombinerBiasNV = "GLenum";
    Boolean = "GLboolean";
  };
  magicNumbers = {
    REGISTER_COMBINERS_NV = 0x8522;
    VARIABLE_A_NV = 0x8523;
    VARIABLE_B_NV = 0x8524;
    VARIABLE_C_NV = 0x8525;
    VARIABLE_D_NV = 0x8526;
    VARIABLE_E_NV = 0x8527;
    VARIABLE_F_NV = 0x8528;
    VARIABLE_G_NV = 0x8529;
    CONSTANT_COLOR0_NV = 0x852A;
    CONSTANT_COLOR1_NV = 0x852B;
    PRIMARY_COLOR_NV = 0x852C;
    SECONDARY_COLOR_NV = 0x852D;
    SPARE0_NV = 0x852E;
    SPARE1_NV = 0x852F;
    DISCARD_NV = 0x8530;
    E_TIMES_F_NV = 0x8531;
    SPARE0_PLUS_SECONDARY_COLOR_NV = 0x8532;
    UNSIGNED_IDENTITY_NV = 0x8536;
    UNSIGNED_INVERT_NV = 0x8537;
    EXPAND_NORMAL_NV = 0x8538;
    EXPAND_NEGATE_NV = 0x8539;
    HALF_BIAS_NORMAL_NV = 0x853A;
    HALF_BIAS_NEGATE_NV = 0x853B;
    SIGNED_IDENTITY_NV = 0x853C;
    SIGNED_NEGATE_NV = 0x853D;
    SCALE_BY_TWO_NV = 0x853E;
    SCALE_BY_FOUR_NV = 0x853F;
    SCALE_BY_ONE_HALF_NV = 0x8540;
    BIAS_BY_NEGATIVE_ONE_HALF_NV = 0x8541;
    COMBINER_INPUT_NV = 0x8542;
    COMBINER_MAPPING_NV = 0x8543;
    COMBINER_COMPONENT_USAGE_NV = 0x8544;
    COMBINER_AB_DOT_PRODUCT_NV = 0x8545;
    COMBINER_CD_DOT_PRODUCT_NV = 0x8546;
    COMBINER_MUX_SUM_NV = 0x8547;
    COMBINER_SCALE_NV = 0x8548;
    COMBINER_BIAS_NV = 0x8549;
    COMBINER_AB_OUTPUT_NV = 0x854A;
    COMBINER_CD_OUTPUT_NV = 0x854B;
    COMBINER_SUM_OUTPUT_NV = 0x854C;
    MAX_GENERAL_COMBINERS_NV = 0x854D;
    NUM_GENERAL_COMBINERS_NV = 0x854E;
    COLOR_SUM_CLAMP_NV = 0x854F;
    COMBINER0_NV = 0x8550;
    COMBINER1_NV = 0x8551;
    COMBINER2_NV = 0x8552;
    COMBINER3_NV = 0x8553;
    COMBINER4_NV = 0x8554;
    COMBINER5_NV = 0x8555;
    COMBINER6_NV = 0x8556;
    COMBINER7_NV = 0x8557;
    TEXTURE0_ARB = 0x84C0;
    TEXTURE1_ARB = 0x84C1;
    ZERO = 0;
    NONE = 0;
    FOG = 0x0B60;
  };
  funcs = {
    {'CombinerParameterfvNV';
      'CombinerParameterNV', 'pname';
      'const CheckedFloat32*', 'params'};
    {'CombinerParameterfNV';
      'CombinerParameterNV', 'pname';
      'Float32', 'param'};
    {'CombinerParameterivNV';
      'CombinerParameterNV', 'pname';
      'const CheckedInt32*', 'params'};
    {'CombinerParameteriNV';
      'CombinerParameterNV', 'pname';
      'Int32', 'param'};
    {'CombinerInputNV';
      'CombinerStageNV', 'stage';
      'CombinerPortionNV', 'portion';
      'CombinerVariableNV', 'variable';
      'CombinerRegisterNV', 'input';
      'CombinerMappingNV', 'mapping';
      'CombinerComponentUsageNV', 'componentUsage'};
    {'CombinerOutputNV';
      'CombinerStageNV', 'stage';
      'CombinerPortionNV', 'portion';
      'CombinerRegisterNV', 'abOutput';
      'CombinerRegisterNV', 'cdOutput';
      'CombinerRegisterNV', 'sumOutput';
      'CombinerScaleNV', 'scale';
      'CombinerBiasNV', 'bias';
      'Boolean', 'abDotProduct';
      'Boolean', 'cdDotProduct';
      'Boolean', 'muxSum'};
    {'FinalCombinerInputNV';
      'CombinerVariableNV', 'variable';
      'CombinerRegisterNV', 'input';
      'CombinerMappingNV', 'mapping';
      'CombinerComponentUsageNV', 'componentUsage'};
    {'GetCombinerInputParameterfvNV';
      'CombinerStageNV', 'stage';
      'CombinerPortionNV', 'portion';
      'CombinerVariableNV', 'variable';
      'CombinerParameterNV', 'pname';
      'Float32*', 'params'};
    {'GetCombinerInputParameterivNV';
      'CombinerStageNV', 'stage';
      'CombinerPortionNV', 'portion';
      'CombinerVariableNV', 'variable';
      'CombinerParameterNV', 'pname';
      'Int32*', 'params'};
    {'GetCombinerOutputParameterfvNV';
      'CombinerStageNV', 'stage';
      'CombinerPortionNV', 'portion';
      'CombinerParameterNV', 'pname';
      'Float32*', 'params'};
    {'GetCombinerOutputParameterivNV';
      'CombinerStageNV', 'stage';
      'CombinerPortionNV', 'portion';
      'CombinerParameterNV', 'pname';
      'Int32*', 'params'};
    {'GetFinalCombinerInputParameterfvNV';
      'CombinerVariableNV', 'variable';
      'CombinerParameterNV', 'pname';
      'Float32*', 'params'};
    {'GetFinalCombinerInputParameterivNV';
      'CombinerVariableNV', 'variable';
      'CombinerParameterNV', 'pname';
      'Int32*', 'params'};
  };
}
