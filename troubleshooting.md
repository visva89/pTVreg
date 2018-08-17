## Invalid Mex-file, static TLS on Linux
Some Matlab and Linux combinations might result in Matlab error like:

`Invalid Mex-file ‘path/… .mexa64’ : dlopen: cannot load any more object with static TLS`

This error happens due to system and Matlab openmp mismatch. The issue can be fixed by preloading 
correct openmp library when starting Matlab:

`>>LD_PRELOAD=/usr/lib/gcc/x86_64-linux-gnu/4.9/libgomp.so  /path/to/matlab`

you have to change library and matlab paths accordingly. You can find the location of libgomp via
`ldconfig -p | grep libgomp`.

## Failure while loading Mex files in Windows
Do not remember the exact issue. Occurred due long path name that was caused by 
git repo archive name generation. Just rename the main working directory.