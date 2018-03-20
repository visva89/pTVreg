function varargout = my_gradient(vol, varargin)
    % my_gradient(vol, [spacing, conj, grad_type])
    nd = ndims(vol);
    
    spacing = ones(1, nd);
    conj = 0;
    grad_type = 1;
    if nargin >= 2
        spacing = varargin{1};
    end
    if nargin >= 3
        conj = varargin{2};
    end
    if nargin >= 4
        grad_type = varargin{3};
    end
    
    nd = numel(spacing);
    if conj == 0
        if nd == 2
            if isa(vol, 'double')
                [varargout{1}, varargout{2}] = mex_my_gradient_2d_double(vol, double(spacing), double(conj), double(grad_type));
            elseif isa(vol, 'double')
                [varargout{1}, varargout{2}] = mex_my_gradient_2d_float(vol, single(spacing), single(conj), single(grad_type));
            end
%             nargout = 2; 
        elseif nd == 3
%             nargout = 3;
            if isa(vol, 'gpuArray')
                if strcmp(classUnderlying(vol), 'single')
                    [varargout{1}, varargout{2}, varargout{3}] = mex_my_gradient_3d_GPU_float(vol, single(spacing), single(conj), single(grad_type));
                elseif strcmp(classUnderlying(vol), 'double')
                    [varargout{1}, varargout{2}, varargout{3}] = mex_my_gradient_3d_GPU_double(vol, double(spacing), double(conj), double(grad_type));
                end
            elseif isa(vol, 'single')
                [varargout{1}, varargout{2}, varargout{3}] = mex_my_gradient_3d_float(vol, single(spacing), single(conj), single(grad_type));
            elseif isa(vol, 'double')
                [varargout{1}, varargout{2}, varargout{3}] = mex_my_gradient_3d_double(vol, double(spacing), double(conj), double(grad_type));
            end
        end
    else
%         nargout = 1;
        if nd == 2
            if isa(vol, 'single')
                varargout{1} = mex_my_gradient_2d_float(vol, single(spacing), single(conj), single(grad_type));
            elseif isa(vol, 'double')
                varargout{1} = mex_my_gradient_2d_double(vol, double(spacing), double(conj), double(grad_type));
            end
        elseif nd == 3
            if isa(vol, 'gpuArray')
                if strcmp(classUnderlying(vol), 'single')
                    varargout{1} = mex_my_gradient_3d_GPU_float(vol, single(spacing), single(conj), single(grad_type));
                elseif strcmp(classUnderlying(vol), 'double')
                    varargout{1} = mex_my_gradient_3d_GPU_float(vol, double(spacing), double(conj), double(grad_type));
                end
            elseif isa(vol, 'single')
                varargout{1} = mex_my_gradient_3d_float(vol, single(spacing), single(conj), single(grad_type));
            elseif isa(vol, 'double')
                varargout{1} = mex_my_gradient_3d_double(vol, double(spacing), double(conj), double(grad_type));
            end
        end
    end
end