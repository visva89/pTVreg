`voldef, Tmin_out, Kmin_out, [itinfos] = ptv_register(volmov, volfix, opts)`

### Input:

  `volmov`: image or array of movinv images that will be registered
  
  `volfix`: empty set or single reference image / target onto which moving
          images are registered. Can be [] only in groupwise registration
          with nuclear metric
          
  `opts`: configuration parameters of registration. Accepts following
          fields:
          
### Returns:
  `voldef`: warped moving images (volmov), i.e. voldef = imdeform(volmov, Tmin_out)
  
  `Tmin_out`: estimated DISPLACEMENTS for each image in physical units,
  specified by opts.pix_resolution.
  
  `Kmin_out`: parameters of displacement fields (Knots ofdisplacements). *INTERNAL*
  
  `itinfos`: estimates and optimization trace for each pyramid level

  We use the following array layot:
  
  `volmov:       sz1 - sz2 - sz3 - Nch - Nimgs`
  
  `Tmin_out:     sz1 - sz2 - sz3 - Nd  - Nimgs`
  
For 2D registration sz3=1, Nd=2, and Nd=3 for 3D
registration. Nimgs is the number of images, each image can have Nch
channels, which means that each displacement field will align all
channels of the corresponding image simultaneously.
      
ALL input (including parameters) are double real valued arrays.

Parameters that might behave differently in the following versions are
marked as *INTERNAL*.

*INTERNAL*:   vol_grads:  sz1 - sz2 - sz3 - Nch - Nimgs - Nd

### `opts` description:

`pix_resolution`: physical resolution of voxel array of size Nd,
  
*DEFAULT*:[1,1,1]

`nlvl`: number of pyramid levels >= 1
      
*DEFAULT*: determined using the size of the input

`k_down`: downscaling factor for pyramid. Usually value of 0.5 is used.

*DEFAULT*: 0.7

`grid_spacing`: gap in pixels between knots that are used to parametrize
displacements. Array of integers of size Nd

*DEFAULT*: [4,4,4]

`cp_refinements`: after finishing registration with grid_spacing we
subdivide knot spacing cp_refinements times. Used for fine tuning, try
to avoid.

*DEFAULT*: 0

`interp_type`: 0 - linear interpolation of image, 1 - cubic. Linear is more
optimized

*DEFAULT*: 0

`metric`: image dissimilarity metric. Possible values

* 'ssd': sum of squared differences ||x-y||_2^2

* 'sad': sum of absolute differences ||x-y||_1

* 'loc_cc_fftn': local correlation coefficient

* *INTERNAL* :'loc_cc_fftn_single', 'loc_cc_fftn_gpu', 'loc_cc_fftn_gpu_single'

* 'nuclear': nuclear (PCA) groupwise metric

* 'local_nuclear'

* 'ngf' : normalied gradients field

*DEFAULT*: 'ssd'

`local_nuclear_patch_size`: ...

*DEFAULT*: 10

`nuclear_centering type`: for 'nuclear' and 'local_nuclear' metric choose
patch centering type (options 0, 3 are the most reasonable):

* '0': no centering

* '1': average over dimensions 1,2,3 (spatial)

* '2': average over all dimensions 1,2,3,4,5

* '3': average over samples, dimensions 4,5 

* '4': 1 then 2

*DEFAULT*: 0

`metric_param`: used for 'loc_cc_fftn*' metrics, is the sigma of Gaussian
weighting kernel (in physical units). For local_nuclear is the spatial size of nonoverlapping. patch Array of size Nd

*DEFAULT*: 7, but you should in practice use smaller value 

`ngf_eta` : NGF safeguard

*DEFAULT*: 0.01

`scale_metric_param`: *INTERNAL* should we downscale sigma?

*DEFAULT*: true

`loc_cc_approximate`: flag if we should use fast (approximate) formula for
the gradient of 'loc_cc_fftn*' metric. Use only for huge images.

*DEFAULT*: false

`loc_cc_abs`: flag if we should use abs value of correlation coefficient in 'loc_cc_fftn*' metrics.
Works well for contrast inversions

*DEFAULT*: false

`singular_coefs`: list of coefficients (of size Nimgs) for singular values weighting when
using nuclear metric. Use custom values only if you know what you are
doing. Advise: set first coefficient to zero, when performing groupwise 
registation without target, otherwise algorithm will try to compress
high intensity regions, since they increase largest singular value.

*DEFAULT*: [0, 1, 1, ..., 1]

`spline_order`: controls type of displacement parametrization:
* 1 -- using linear interpolation (fastest and most reliable)
* 3 -- cubic interpolation
* 3.5 -- cubic with fractional knots *INTERNAL*
* -1 -- translation motion *INTERNAL*
* -2 -- rigid motion *INTERNAL*
* -3 -- rigid + scaling *INTERNAL*
* -4 -- affine *INTERNAL*

please avoid using values other than 1,3

*DEFAULT*: 1

`isoTV`: isotropic (vectorial) TV regularization of displacements

*DEFAULT*: 0

`max_iters`: max number of iterations at each pyramid level

*DEFAULT*: 100

`display`: 'iter' or 'off' ? display output of minFunc

*DEFAULT*: 'off'

`mean_penalty`: coefficient that forces displacement to be 'centered' 
across the images. Needed when the target is not fixed.

`fixed_mask`: specify pixels that should be used to evaluate image 
dissimilarity metric.

*DEFAULT*: []

`border_mask`: number of voxels around the borders that are not used in
image dissimilarity metric, combined with fixed mask. Needed to avoid
image extrapolation artefacts.

*DEFAULT*: 3

#### FOLLOWING ARE *INTERNAL* parameters

`fine_pyramid`: *INTERNAL* use different downscaling procedure to
construct pyramid.

*DEFAULT*: false

`nuclear_rescale_strategy`: *INTERNAL*, nuclear metric with pyramids is
hard...

`nuclear_coef`: *INTERNAL* image dissimilarity metric weight, can be only
used with nuclear metric, introduced because of scaling experiments

*DEFAULT*: 1

`moving_mask`: *INTERNAL* specify pixels that should be warped and used 
to evaluate image dissimilarity metric.

*DEFAULT*: []

`DiLj`: i-th order spatial drivative, x^j norm, includes D1L1, D2L1, D1L2, D2L2. 

*DEFAULT*: 0

`T_DiLj`: i-th order temporal drivative, x^j norm, includes T_D1L1, T_D2L1, T_D1L2, T_D2L2

*DEFAULT*: 0

`D1Lp`: nonconvex prior with value p = opts.spat_reg_p_val

`D2Lp`: nonconvex prior with value p = opts.spat_reg_p_val2

`check_gradients`: {false, true, #} numerically check # of derivatives

`regularize_directly`: bool

false: knots are regularized
true: T(knots) regularized
Probably should get rid of it.

*DEFAULT*: false

`folding_penalty`: coefficient of very crude approximation for folding penalty

*DEFAULT*: 0

`jac_reg`: regularization weight of Jacobian of transformation. Penalizes if Jacobian >= 4 or <= 0.2

*DEFAULT*: 0

`csqrt`: smoothing of TV norm `|x|\approx sqrt(x^2+csqrt)`

*DEFAULT*: 5e-3

`opt_method`: optimization method from minFunc 

*DEFAULT*: lbfgs

`img_edge_prior_strength`: puts a prior on displacement edges based on image edges. Doesn't seem to work. 

*DEFAULT*: 0

#### Segmentation parameters
`mov_segm`: segmentation mask of moving images

`segm_val1`: average image intensity at locations where mov_segm=1

`segm_val0`: average image intensity at locations where mov_segm=0

`segm_koef`: weigh of the segmentation cost

