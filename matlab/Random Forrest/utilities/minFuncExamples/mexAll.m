% minFunc
fprintf('Compiling minFunc files...\n');
mex -compatibleArrayDims -outdir minFunc minFunc/lbfgsC.c

% UGM
fprintf('Compiling UGM files...\n');
mex -compatibleArrayDims -outdir UGM/compiled UGM/mex/UGM_makeEdgeVEC.c
mex -compatibleArrayDims -outdir UGM/compiled UGM/mex/UGM_CRF_makePotentialsC.c
mex -compatibleArrayDims -outdir UGM/compiled UGM/mex/UGM_CRF_PseudoNLLC.c
mex -compatibleArrayDims -outdir UGM/compiled UGM/mex/UGM_Decode_ICMC.c
mex -compatibleArrayDims -outdir UGM/compiled UGM/mex/UGM_Infer_LBPC.c
mex -compatibleArrayDims -outdir UGM/compiled UGM/mex/UGM_LogConfigurationPotentialC.c
mex -compatibleArrayDims -outdir UGM/compiled UGM/mex/UGM_CRF_NLLC.c