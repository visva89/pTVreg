% mex -v CXX='g++' CXXFLAGS='\$CXXFLAGS -O3 -funroll-loops -march=native -mtune=native -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_2d_linear_disp.cpp ../linear_grid_general.cpp
% 
% mex -v CXX='g++' CXXFLAGS='\$CXXFLAGS -O3 -funroll-loops -march=native -mtune=native -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_2d_linear_disp_and_warp.cpp ../linear_grid_general.cpp
% 
% mex -v CXX='g++' CXXFLAGS='\$CXXFLAGS -O3 -funroll-loops -march=native -mtune=native -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_2d_linear_disp_warp_diff_conv.cpp ../linear_grid_general.cpp
% 
% mex -v CXX='g++' CXXFLAGS='\$CXXFLAGS -O3 -funroll-loops -march=native -mtune=native -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_2d_linear_partial_conv.cpp ../linear_grid_general.cpp
% 
% 
% mex -v CXX='g++' CXXFLAGS='\$CXXFLAGS -O3 -funroll-loops -march=native -mtune=native -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_3d_linear_disp.cpp ../linear_grid_general.cpp
% mex -v CXX='g++' CXXFLAGS='\$CXXFLAGS -O3 -funroll-loops -march=native -mtune=native -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_3d_linear_disp_and_warp.cpp ../linear_grid_general.cpp
% mex -v CXX='g++' CXXFLAGS='\$CXXFLAGS -O3 -funroll-loops -march=native -mtune=native -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_3d_disp_warp_diff_conv.cpp ../linear_grid_general.cpp
% 
% %%
% mex -v -output mex_3d_volume_warp_double CXX='g++' CXXFLAGS='\$CXXFLAGS -O3 -funroll-loops -march=native -mtune=native -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_3d_volume_warp.cpp ../image_warping.cpp
% mex -v -output mex_3d_volume_warp_float CXX='g++' CXXFLAGS='\$CXXFLAGS -DUSE_FLOAT -O3 -funroll-loops -march=native -mtune=native -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_3d_volume_warp.cpp ../image_warping.cpp
% 
% mex -v -output mex_3d_linear_disp_and_warp_double CXX='g++' CXXFLAGS='\$CXXFLAGS -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_3d_linear_disp_and_warp.cpp ../linear_grid_general.cpp
% mex -v -output mex_3d_linear_disp_and_warp_float CXX='g++' CXXFLAGS='\$CXXFLAGS -DUSE_FLOAT -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_3d_linear_disp_and_warp.cpp ../linear_grid_general.cpp
% 
% mex -v -output mex_3d_linear_partial_conv_double CXX='g++' CXXFLAGS='\$CXXFLAGS -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_3d_linear_partial_conv.cpp ../linear_grid_general.cpp
% mex -v -output mex_3d_linear_partial_conv_float CXX='g++' CXXFLAGS='\$CXXFLAGS -DUSE_FLOAT -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_3d_linear_partial_conv.cpp ../linear_grid_general.cpp
% 
% %%
% mex -v -output mex_3d_volume_warp_double -DUSE_WINDOWS COMPFLAGS="/openmp $COMPFLAGS" -I"../../mex_helpers" -I"../../deformation_tools_cpp"  mex_3d_volume_warp.cpp ../image_warping.cpp
%%
% if isunix() || ismac()
%     %3d
%     mex  -output bin/mex_3d_volume_warp_double CXX='g++' CXXFLAGS='\$CXXFLAGS -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_3d_volume_warp.cpp ../image_warping.cpp
%     mex  -output bin/mex_3d_volume_warp_float CXX='g++' CXXFLAGS='\$CXXFLAGS -DUSE_FLOAT -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_3d_volume_warp.cpp ../image_warping.cpp
% 
%     mex  -output bin/mex_3d_linear_disp_and_warp_double CXX='g++' CXXFLAGS='\$CXXFLAGS -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_3d_linear_disp_and_warp.cpp ../linear_grid_general.cpp
%     mex  -output bin/mex_3d_linear_disp_and_warp_float CXX='g++' CXXFLAGS='\$CXXFLAGS -DUSE_FLOAT -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_3d_linear_disp_and_warp.cpp ../linear_grid_general.cpp
% 
%     mex  -output bin/mex_3d_linear_partial_conv_double CXX='g++' CXXFLAGS='\$CXXFLAGS -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_3d_linear_partial_conv.cpp ../linear_grid_general.cpp
%     mex  -output bin/mex_3d_linear_partial_conv_float CXX='g++' CXXFLAGS='\$CXXFLAGS -DUSE_FLOAT -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_3d_linear_partial_conv.cpp ../linear_grid_general.cpp
%     
%     mex  -output bin/mex_3d_linear_disp_double CXX='g++' CXXFLAGS='\$CXXFLAGS -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_3d_linear_disp.cpp ../linear_grid_general.cpp
%     mex  -output bin/mex_3d_linear_disp_float CXX='g++' CXXFLAGS='\$CXXFLAGS -DUSE_FLOAT -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_3d_linear_disp.cpp ../linear_grid_general.cpp
%     
%     mex  -output bin/mex_3d_cubic_disp_double CXX='g++' CXXFLAGS='\$CXXFLAGS -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_3d_cubic_disp.cpp ../cubic_grid.cpp
%     mex  -output bin/mex_3d_cubic_disp_float CXX='g++' CXXFLAGS='\$CXXFLAGS -DUSE_FLOAT -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_3d_cubic_disp.cpp ../cubic_grid.cpp
%     
%     mex  -output bin/mex_3d_cubic_partial_conv_double CXX='g++' CXXFLAGS='\$CXXFLAGS -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_3d_cubic_partial_conv.cpp ../cubic_grid.cpp
%     mex  -output bin/mex_3d_cubic_partial_conv_float CXX='g++' CXXFLAGS='\$CXXFLAGS -DUSE_FLOAT -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_3d_cubic_partial_conv.cpp ../cubic_grid.cpp
%     %2d
%     mex  -output bin/mex_2d_image_warp_double CXX='g++' CXXFLAGS='\$CXXFLAGS -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_2d_image_warp.cpp ../image_warping.cpp
%     mex  -output bin/mex_2d_image_warp_float CXX='g++' CXXFLAGS='\$CXXFLAGS -DUSE_FLOAT -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_2d_image_warp.cpp ../image_warping.cpp
% 
%     mex  -output bin/mex_2d_linear_disp_and_warp_double CXX='g++' CXXFLAGS='\$CXXFLAGS -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_2d_linear_disp_and_warp.cpp ../linear_grid_general.cpp
%     mex  -output bin/mex_2d_linear_disp_and_warp_float CXX='g++' CXXFLAGS='\$CXXFLAGS -DUSE_FLOAT -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_2d_linear_disp_and_warp.cpp ../linear_grid_general.cpp
% 
%     mex  -output bin/mex_2d_linear_partial_conv_double CXX='g++' CXXFLAGS='\$CXXFLAGS -O3 -march=native -mtune=native -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_2d_linear_partial_conv.cpp ../linear_grid_general.cpp
%     mex  -output bin/mex_2d_linear_partial_conv_float CXX='g++' CXXFLAGS='\$CXXFLAGS -DUSE_FLOAT -O3 -march=native -mtune=native -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_2d_linear_partial_conv.cpp ../linear_grid_general.cpp
%     
%     mex  -output bin/mex_2d_linear_disp_double CXX='g++' CXXFLAGS='\$CXXFLAGS -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_2d_linear_disp.cpp ../linear_grid_general.cpp
%     mex  -output bin/mex_2d_linear_disp_float CXX='g++' CXXFLAGS='\$CXXFLAGS -DUSE_FLOAT -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_2d_linear_disp.cpp ../linear_grid_general.cpp
%     
%     mex  -output bin/mex_2d_spherical_warp_uint8  -DUSE_UINT8  CXX='g++ -fopenmp' CXXFLAGS='\$CXXFLAGS -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' mex_2d_spherical_warp.cpp ../image_warping.cpp
%     mex  -output bin/mex_2d_spherical_trans_warp_uint8  -DUSE_UINT8  CXX='g++ -fopenmp' CXXFLAGS='\$CXXFLAGS -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' mex_2d_spherical_trans_warp.cpp ../image_warping.cpp
%     
%     mex  -output bin/mex_3d_linear_disp_and_warp_and_grad_double CXX='g++' CXXFLAGS='\$CXXFLAGS -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_3d_linear_disp_and_warp_and_grad.cpp ../linear_grid_general.cpp
%     mex  -output bin/mex_3d_linear_disp_and_warp_and_grad_float CXX='g++' CXXFLAGS='\$CXXFLAGS -DUSE_FLOAT -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_3d_linear_disp_and_warp_and_grad.cpp ../linear_grid_general.cpp
%     
%     mex  -output bin/mex_2d_linear_disp_and_warp_and_grad_double CXX='g++' CXXFLAGS='\$CXXFLAGS -march=native -mtune=native -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_2d_linear_disp_and_warp_and_grad.cpp ../linear_grid_general.cpp
%     mex  -output bin/mex_2d_linear_disp_and_warp_and_grad_float CXX='g++' CXXFLAGS='\$CXXFLAGS -march=native -mtune=native -DUSE_FLOAT -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_2d_linear_disp_and_warp_and_grad.cpp ../linear_grid_general.cpp
%     
%     mex  -output bin/mex_2d_image_warp_and_grad_double CXX='g++' CXXFLAGS='\$CXXFLAGS -march=native -mtune=native -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_2d_image_warp_and_grad.cpp
%     mex  -output bin/mex_2d_image_warp_and_grad_float CXX='g++' CXXFLAGS='\$CXXFLAGS -DUSE_FLOAT -march=native -mtune=native -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_2d_image_warp_and_grad.cpp
%     mex  -output bin/mex_3d_volume_warp_and_grad_double CXX='g++' CXXFLAGS='\$CXXFLAGS -march=native -mtune=native -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_3d_volume_warp_and_grad.cpp
%     mex  -output bin/mex_3d_volume_warp_and_grad_float CXX='g++' CXXFLAGS='\$CXXFLAGS -DUSE_FLOAT -march=native -mtune=native -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_3d_volume_warp_and_grad.cpp
% elseif ispc()
%     mex -v -output bin/mex_3d_volume_warp_double -DUSE_WINDOWS COMPFLAGS="/openmp $COMPFLAGS" -I"../../mex_helpers" -I"../../deformation_tools_cpp"  mex_3d_volume_warp.cpp ../image_warping.cpp
%     mex -v -output bin/mex_3d_volume_warp_float -DUSE_WINDOWS -DUSE_FLOAT COMPFLAGS="/openmp $COMPFLAGS" -I"../../mex_helpers" -I"../../deformation_tools_cpp"  mex_3d_volume_warp.cpp ../image_warping.cpp
%     
%     mex -v -output bin/mex_3d_linear_disp_and_warp_double -DUSE_WINDOWS COMPFLAGS="/openmp $COMPFLAGS" -I"../../mex_helpers" -I"../../deformation_tools_cpp" mex_3d_linear_disp_and_warp.cpp ../linear_grid_general.cpp
%     mex -v -output bin/mex_3d_linear_disp_and_warp_float -DUSE_WINDOWS -DUSE_FLOAT COMPFLAGS="/openmp $COMPFLAGS" -I"../../mex_helpers" -I"../../deformation_tools_cpp" mex_3d_linear_disp_and_warp.cpp ../linear_grid_general.cpp
% 
%     mex -v -output bin/mex_3d_linear_partial_conv_double -DUSE_WINDOWS COMPFLAGS="/openmp $COMPFLAGS" -I"../../mex_helpers" -I"../../deformation_tools_cpp" mex_3d_linear_partial_conv.cpp ../linear_grid_general.cpp
%     mex -v -output bin/mex_3d_linear_partial_conv_float -DUSE_WINDOWS -DUSE_FLOAT COMPFLAGS="/openmp $COMPFLAGS" -I"../../mex_helpers" -I"../../deformation_tools_cpp" mex_3d_linear_partial_conv.cpp ../linear_grid_general.cpp
%     
%     mex -v -output bin/mex_3d_linear_disp_double -DUSE_WINDOWS COMPFLAGS="/openmp $COMPFLAGS" -I"../../mex_helpers" -I"../../deformation_tools_cpp" mex_3d_linear_disp.cpp ../linear_grid_general.cpp
%     mex -v -output bin/mex_3d_linear_disp_float -DUSE_WINDOWS -DUSE_FLOAT COMPFLAGS="/openmp $COMPFLAGS" -I"../../mex_helpers" -I"../../deformation_tools_cpp" mex_3d_linear_disp.cpp ../linear_grid_general.cpp
%     %2d
%     mex -v -output bin/mex_2d_image_warp_double -DUSE_WINDOWS COMPFLAGS="/openmp $COMPFLAGS" -I"../../mex_helpers" -I"../../deformation_tools_cpp" mex_2d_image_warp.cpp ../image_warping.cpp
%     mex -v -output bin/mex_2d_image_warp_float -DUSE_WINDOWS -DUSE_FLOAT COMPFLAGS="/openmp $COMPFLAGS" -I"../../mex_helpers" -I"../../deformation_tools_cpp" mex_2d_image_warp.cpp ../image_warping.cpp
% 
%     mex -v -output bin/mex_2d_linear_disp_and_warp_double -DUSE_WINDOWS COMPFLAGS="/openmp $COMPFLAGS" -I"../../mex_helpers" -I"../../deformation_tools_cpp" mex_2d_linear_disp_and_warp.cpp ../linear_grid_general.cpp
%     mex -v -output bin/mex_2d_linear_disp_and_warp_float -DUSE_WINDOWS -DUSE_FLOAT COMPFLAGS="/openmp $COMPFLAGS" -I"../../mex_helpers" -I"../../deformation_tools_cpp" mex_2d_linear_disp_and_warp.cpp ../linear_grid_general.cpp
% 
%     mex -v -output bin/mex_2d_linear_partial_conv_double -DUSE_WINDOWS COMPFLAGS="/openmp $COMPFLAGS" -I"../../mex_helpers" -I"../../deformation_tools_cpp" mex_2d_linear_partial_conv.cpp ../linear_grid_general.cpp
%     mex -v -output bin/mex_2d_linear_partial_conv_float -DUSE_WINDOWS -DUSE_FLOAT COMPFLAGS="/openmp $COMPFLAGS" -I"../../mex_helpers" -I"../../deformation_tools_cpp" mex_2d_linear_partial_conv.cpp ../linear_grid_general.cpp
%     
%     mex -v -output bin/mex_2d_linear_disp_double -DUSE_WINDOWS COMPFLAGS="/openmp $COMPFLAGS" -I"../../mex_helpers" -I"../../deformation_tools_cpp" mex_2d_linear_disp.cpp ../linear_grid_general.cpp
%     mex -v -output bin/mex_2d_linear_disp_float -DUSE_WINDOWS -DUSE_FLOAT COMPFLAGS="/openmp $COMPFLAGS" -I"../../mex_helpers" -I"../../deformation_tools_cpp" mex_2d_linear_disp.cpp ../linear_grid_general.cpp
%     
%     mex -v -output bin/mex_2d_spherical_warp_uint8 -DUSE_WINDOWS -DUSE_UINT8 COMPFLAGS="/openmp $COMPFLAGS" -I"../../mex_helpers" -I"../../deformation_tools_cpp" mex_2d_spherical_warp.cpp ../image_warping.cpp
%     mex -v -output bin/mex_2d_spherical_trans_warp_uint8 -DUSE_WINDOWS -DUSE_UINT8 COMPFLAGS="/openmp $COMPFLAGS" -I"../../mex_helpers" -I"../../deformation_tools_cpp" mex_2d_spherical_trans_warp.cpp ../image_warping.cpp
%     
%     mex -v -output bin/mex_3d_linear_disp_and_warp_and_grad_double -DUSE_WINDOWS COMPFLAGS="/openmp $COMPFLAGS" -I"../../mex_helpers" -I"../../deformation_tools_cpp" mex_3d_linear_disp_and_warp_and_grad.cpp ../linear_grid_general.cpp
%     mex -v -output bin/mex_3d_linear_disp_and_warp_and_grad_float -DUSE_WINDOWS -DUSE_FLOAT COMPFLAGS="/openmp $COMPFLAGS" -I"../../mex_helpers" -I"../../deformation_tools_cpp" mex_3d_linear_disp_and_warp_and_grad.cpp ../linear_grid_general.cpp
% end
%%
nms = { {'mex_3d_volume_warp', '../image_warping.cpp'}, ...
        {'mex_3d_linear_disp_and_warp', '../linear_grid_general.cpp'}, ...
        {'mex_3d_linear_partial_conv', '../linear_grid_general.cpp'}, ...
        {'mex_Nd_linear_partial_conv', '../linear_grid_general.cpp'}, ...
        {'mex_3d_linear_disp', '../linear_grid_general.cpp'}, ... 
        {'mex_3d_cubic_disp', '../cubic_grid.cpp'}, ...
        {'mex_3d_cubic_partial_conv', '../cubic_grid.cpp'}, ...
        {'mex_2d_image_warp', '../image_warping.cpp'}, ... 
        {'mex_2d_linear_disp_and_warp', '../linear_grid_general.cpp'}, ...
        {'mex_2d_linear_partial_conv', '../linear_grid_general.cpp'}, ...
        {'mex_2d_linear_disp', '../linear_grid_general.cpp'}, ...
        {'mex_2d_spherical_warp', '../image_warping.cpp'}, ...
        {'mex_3d_linear_disp_and_warp_and_grad', '../linear_grid_general.cpp'}, ...
        {'mex_2d_linear_disp_and_warp_and_grad', '../linear_grid_general.cpp'}, ...
        {'mex_2d_image_warp_and_grad', '../image_warping.cpp'}, ...
        {'mex_3d_volume_warp_and_grad', ''}, ...
        {'mex_2d_cubic_disp', '../cubic_grid.cpp'}, ...
        {'mex_3d_cubic_partial_conv', '../cubic_grid.cpp'}, ...
        {'mex_2d_cubic_partial_conv', '../cubic_grid.cpp'}, ...
        {'mex_inverse_3d_displacements', ''}, ...
        {'mex_Nd_linear_disp_and_warp_and_grad', '../linear_grid_general.cpp'},...
        };

% nms = { ...
%     {'mex_2d_image_warp_and_grad', '../image_warping.cpp'},...
%         };
targets = struct();
for i = 1 : numel(nms)
    if isunix() && ~ismac()
        cm = "mex -v -output bin/%s_%s CXX='g++' CXXFLAGS='\\$CXXFLAGS %s' LDFLAGS='\\$LDFLAGS %s'  %s.cpp %s";
%         cxx_flags = '-fopenmp -O3 -funroll-loops -march=native -mtune=native -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp';
        cxx_flags = '-fopenmp -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp';
%         cxx_flags = '-fopenmp -O3 -march=native -mtune=native -Ofast -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp';
        ld_flags = '-fopenmp';
        com = sprintf(cm, nms{i}{1}, 'float', ['-DUSE_FLOAT ', cxx_flags], ld_flags, nms{i}{1}, nms{i}{2});
        eval(com)
        com = sprintf(cm, nms{i}{1}, 'double', cxx_flags, ld_flags, nms{i}{1}, nms{i}{2});
        eval(com)
    elseif ispc()
        cm = "mex -v -output bin/%s_%s -DUSE_WINDOWS %s COMPFLAGS='%s $COMPFLAGS' %s  %s.cpp %s";
        cxx_flags = '/openmp /Ox';
        incs = '-I../../mex_helpers -I../../deformation_tools_cpp';
        com = sprintf(cm, nms{i}{1}, 'float', '-DUSE_FLOAT' , cxx_flags, incs, nms{i}{1}, nms{i}{2});
        eval(com)
        com = sprintf(cm, nms{i}{1}, 'double', ' ' , cxx_flags, incs, nms{i}{1}, nms{i}{2});
        eval(com)
    elseif ismac()
        cm = "mex -v -output bin/%s_%s CXX='g++' CXXFLAGS='\\$CXXFLAGS %s' LDFLAGS='\\$LDFLAGS %s'  %s.cpp %s";
        cxx_flags = '-O3 -funroll-loops -march=native -mtune=native -I../../mex_helpers -I../../deformation_tools_cpp';
        ld_flags = '';
        com = sprintf(cm, nms{i}{1}, 'float', ['-DUSE_FLOAT ', cxx_flags], ld_flags, nms{i}{1}, nms{i}{2});
        eval(com)
        com = sprintf(cm, nms{i}{1}, 'double', cxx_flags, ld_flags, nms{i}{1}, nms{i}{2});
        eval(com)
    end
%     pause(0.2);
end

% sname float/double  CXXFLAGS LDFLAGS

%%
if isunix() || ismac()
mex -v -output bin/mex_2d_image_warp_uint8 -DUSE_WINDOWS -DUSE_UINT8 COMPFLAGS="/openmp $COMPFLAGS" -I"../../mex_helpers" -I"../../deformation_tools_cpp" mex_2d_image_warp.cpp ../image_warping.cpp

%textures
mexcuda -v -output bin/mex_3d_volume_warp_GPU_float CXXFLAGS='\$CXXFLAGS -D_FORCE_INLINES -DUSE_FLOAT -O3 -I../../mex_helpers' mex_3d_volume_warp_GPU.cu
mexcuda -v -output bin/mex_3d_linear_disp_GPU_float CXXFLAGS='\$CXXFLAGS -D_FORCE_INLINES -DUSE_FLOAT -O3 -I../../mex_helpers' mex_3d_linear_disp_GPU.cu
mexcuda -v -output bin/mex_3d_linear_disp_and_warp_GPU_float CXXFLAGS='\$CXXFLAGS -D_FORCE_INLINES -DUSE_FLOAT -O3 -I../../mex_helpers' mex_3d_linear_disp_and_warp_GPU.cu

mexcuda -v -output bin/mex_3d_volume_warp_GPU_double СXX='g++-4.7' CXXFLAGS='\$CXXFLAGS -D_FORCE_INLINES -O3 -I../../mex_helpers' mex_3d_volume_warp_GPU.cu
mexcuda -v -output bin/mex_3d_linear_disp_GPU_double CXXFLAGS='\$CXXFLAGS -D_FORCE_INLINES -O3 -I../../mex_helpers' mex_3d_linear_disp_GPU.cu
mexcuda -v -output bin/mex_3d_linear_disp_and_warp_GPU_double CXXFLAGS='\$CXXFLAGS -D_FORCE_INLINES -O3 -I../../mex_helpers' mex_3d_linear_disp_and_warp_GPU.cu

%no textures
mexcuda -v -output bin/mex_3d_linear_disp_and_warp_notex_GPU_float CXXFLAGS='\$CXXFLAGS -D_FORCE_INLINES -DUSE_FLOAT -O3 -I../../mex_helpers' mex_3d_linear_disp_and_warp_notex_GPU.cu
mexcuda -v -output bin/mex_3d_linear_disp_and_warp_notex_GPU_double CXXFLAGS='\$CXXFLAGS -D_FORCE_INLINES -O3 -I../../mex_helpers' mex_3d_linear_disp_and_warp_notex_GPU.cu
mexcuda -v -output bin/mex_3d_linear_partial_conv_GPU_double CXXFLAGS='\$CXXFLAGS -D_FORCE_INLINES -O3 -I../../mex_helpers' mex_3d_linear_partial_conv_GPU.cu
mexcuda -v -output bin/mex_3d_linear_partial_conv_GPU_float CXXFLAGS='\$CXXFLAGS -D_FORCE_INLINES -DUSE_FLOAT -O3 -I../../mex_helpers' mex_3d_linear_partial_conv_GPU.cu

mexcuda -v -output bin/mex_3d_linear_disp_and_warp_and_grad_GPU_double CXXFLAGS='\$CXXFLAGS -D_FORCE_INLINES -O3 -I../../mex_helpers' mex_3d_linear_disp_and_warp_and_grad_GPU.cu
mexcuda -v -output bin/mex_3d_linear_disp_and_warp_and_grad_GPU_float CXXFLAGS='\$CXXFLAGS -DUSE_FLOAT -D_FORCE_INLINES -O3 -I../../mex_helpers' mex_3d_linear_disp_and_warp_and_grad_GPU.cu
end