function x = convert_to_dtype(x, varargin)
    % x = convert_to_type(x, reference)
    % x = convert_to_type(x, 'CPU_single')
    % x = convert_to_type(x, 'CPU', 'single')
    
    if nargin == 3
        if strcmp(varargin{1}, 'CPU') && strcmp(varargin{2}, 'single')
            dtype = 'CPU_single';
        elseif strcmp(varargin{1}, 'CPU') && strcmp(varargin{2}, 'double')
            dtype = 'CPU_double';
        elseif strcmp(varargin{1}, 'GPU') && strcmp(varargin{2}, 'single')
            dtype = 'GPU_single';
        elseif strcmp(varargin{1}, 'GPU') && strcmp(varargin{2}, 'double')
            dtype = 'GPU_double';
        end
    elseif nargin == 2
        if ischar(varargin{1})
            dtype = varargin{1};
        else
            ref = varargin{1};
            if isa(ref, 'single') 
                dtype = 'CPU_single';
            elseif isa(ref, 'double') 
                dtype = 'CPU_double';
            elseif isa(ref, 'gpuArray')
                if strcmp(classUnderlying(ref), 'single') 
                    dtype = 'GPU_single';
                elseif strcmp(classUnderlying(ref), 'double') 
                    dtype = 'GPU_double';
                end
            end
        end
    end
    
    if strcmp(dtype, 'CPU_single')
        x = gather(single(x));
    elseif strcmp(dtype, 'CPU_double')
        x = gather(double(x));
    elseif strcmp(dtype, 'GPU_single')
        x = gpuArray(single(x));
    elseif strcmp(dtype, 'GPU_double')
        x = gpuArray(double(x));
    end
end