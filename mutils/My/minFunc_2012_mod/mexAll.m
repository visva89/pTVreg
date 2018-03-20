% minFunc
fprintf('Compiling minFunc files...\n');
mex -outdir minFunc/compiled minFunc/mex/mcholC.c
mex -outdir minFunc/compiled minFunc/mex/lbfgsC.c
mex -outdir minFunc/compiled minFunc/mex/lbfgsAddC.c
% mex -outdir minFunc/compiled CXX='g++' CXXFLAGS='\$CXXFLAGS -O3 -funroll-loops -fopenmp' LDFLAGS="\$LDFLAGS -fopenmp" minFunc/mex/lbfgsProdC.cpp
if ismac()
    mex -v -outdir minFunc/compiled CXX='g++' CXXFLAGS='\$CXXFLAGS -O3' LDFLAGS="\$LDFLAGS" CXXOPTIMFLAGS='-O3' minFunc/mex/lbfgsProdC.cpp
elseif isunix()
    mex -v -outdir minFunc/compiled CXX='g++' CXXFLAGS='\$CXXFLAGS -O3 -fopenmp -funroll-loops' LDFLAGS="\$LDFLAGS -fopenmp" CXXOPTIMFLAGS='-O3' minFunc/mex/lbfgsProdC.cpp
%     mex -v -outdir minFunc/compiled CXX='g++' CXXFLAGS='\$CXXFLAGS -O0 ' LDFLAGS="\$LDFLAGS " CXXOPTIMFLAGS='-O0' minFunc/mex/lbfgsProdC.cpp
%     mex -outdir minFunc/compiled minFunc/mex/lbfgsProdC.cpp
elseif ispc()
    mex -v -outdir minFunc/compiled COMPFLAGS="-DUSE_WINDOWS /openmp /O3 $COMPFLAGS"  minFunc/mex/lbfgsProdC.cpp
end
% mex -v -outdir minFunc/compiled -fopenmp -O3 minFunc/mex/lbfgsProdC.cpp
% mex -v -outdir minFunc/compiled CXX='g++' CXXFLAGS='\$CXXFLAGS -O3 -msse4 -ftree-vectorize -ftree-vectorizer-verbose=5 -ftree-loop-distribution -funroll-all-loops -ftracer -funroll-loops -fopenmp' LDFLAGS="\$LDFLAGS -fopenmp" minFunc/mex/lbfgsProdC.cpp
% mex -outdir minFunc/compiled CXX='g++' CFLAGS='\$CFLAGS -O3 -msse4 -ftree-vectorize -ftree-vectorizer-verbose=5 -ftree-loop-distribution -funroll-all-loops -ftracer -funroll-loops -fopenmp' LDFLAGS="\$LDFLAGS -fopenmp" minFunc/mex/lbfgsProdC.c


%%
% mex -v -outdir minFunc/compiled COMPFLAGS="-DUSE_WINDOWS /openmp /O3 $COMPFLAGS"  minFunc/mex/lbfgsProdC.cpp
