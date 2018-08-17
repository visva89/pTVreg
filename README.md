**pTVreg** is the deformable image registration (alignment) toolbox. 
It provides the following functionality:
* 2D and 3D image registration
* pairwise and groupwise registration
* cubic and linear spline motion parametrization
* multichannel data 
* simple model for simultaneous registration and segmentation (via atlas deformation)
* approximate 2D registration run time: 5 sec (8 images), 40 sec (60 images) on a 6 core CPU
* approximate 3D registration run time: 90 sec pair of 226x226x106 volumes on a 6 core CPU
* Matlab implementation, compiled MEX files for Linux, Windows, and OSX (no multithreading)
* [Please see the complete set of **examples** here](Examples.md)
* [**Documentation** is available here](documentation.md)
* [**Troubleshooting** guide](troubleshooting.md)
* For more details please refer to ["Vishnevskiy V, Gass T, Szekely G, Tanner C, Goksel O. Isotropic total variation regularization of displacements in parametric image registration. IEEE TMI. 2017."](http://ieeexplore.ieee.org/abstract/document/7570266/)


Implemented image dissimilarity metrics:
* local correlation coefficient (LCC) <br/> $`D_{LCC}=1 - \frac{g_\sigma * (I\cdot J) - (g_\sigma*I)\cdot(g_\sigma*J)}{\sqrt{g_\sigma*I^2 - (g_\sigma*I)^2+\varepsilon }\,\sqrt{g_\sigma*J^2 - (g_\sigma*J)^2+\varepsilon }}`$
* nuclear (PCA) groupwise metric <br/> $`D_{nuclear} =\|\; [\, I_1\circ T(k_1),\quad ..., \quad I_N\circ T(k_N)\, ]\; \|_\ast`$
* sum of squared differences (SSD)
* sum of absolute differences (SAD)
* normalized gradient fields (NGF)

Implemented regularizations:
* temporal regularization
* transformation Jacobian regularization
* sparse and nonconvex spatial regularizations based on first- and second- order finite differences

The method works on CT, MRI, US and natural images. 
It is reported to be successful for registering breathing motion.

The method performs multiresolution (pyramidal) registration approach.
On each resolution level it solves unconstrained optimization problem of the following form:

$`\min_{k} D(J,\;  I\circ T(k) ) + \lambda \text{TV}(k)`$,

using [LBFGS](https://www.cs.ubc.ca/~schmidtm/Software/minFunc.html). 

### A Few Registration Examples

<img src = "imgs/perf_register.gif"  height = "200px"/>
<img src = "imgs/perf_track.gif"  height = "200px"/>

*Figure: input images; registered images; tracking animation;*

<img src = "imgs/heart_SA_register.gif" height = "200px"/>
<img src = "imgs/heart_SA_track.gif" height = "200px"/>

*Figure: input images; registered images; tracking animation;*

<img src = "imgs/faces_register.gif" height = "200px"/>
<img src = "imgs/faces_track.gif" height = "200px"/>

*Figure: input images; registered images; tracking animation;*

<img src="imgs/copd_pair.png" height="200px"/>

*Figure: overlayed initial images; overlayed registered images;*

<img src = "imgs/DIR_group_stab.gif" height = "200px"/>
<img src = "imgs/DIR_group_track.gif" height = "200px"/>

*Figure: registered images; tracking animation;*

### CT Lung Registration

We achieve state-of-the art registration result in [DIR and COPD challenges](https://www.dir-lab.com/ReferenceData.html).

| 4DCT 1  | 4DCT 2  | 4DCT 3  | 4DCT 4  | 4DCT 5  | 4DCT 6  | 4DCT 7  | 4DCT 8  | 4DCT 9  | 4DCT 10  |**Mean TRE**|Mean Time (sec.)|
|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|----------|---------|
|0.77|0.75|0.93|1.26|1.07|0.83|0.80|1.01|0.91|0.84|**0.92**|130|


| COPD 1  | COPD 2  | COPD 3  | COPD 4  | COPD 5  | COPD 6  | COPD 7  | COPD 8  | COPD 9  | COPD 10  |**Mean TRE**|Mean Time (sec.)|
|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|----------|---------|
|0.71|1.91|0.77|0.67|0.71|0.66|0.75|0.78|0.64|0.85|**0.8461**|442|

For details on lung registration please see [examples](Examples.md) and [DIR and COPDgene](DIRandCOPD.md) pages.




# pTV
If you decide to use our registration toolbox please consider referring to this repository or the following paper:
```
@article{vishnevskiy2017isotropic,
  title={Isotropic total variation regularization of displacements in parametric image registration},
  author={Vishnevskiy, Valery and Gass, Tobias and Szekely, Gabor and Tanner, Christine and Goksel, Orcun},
  journal={IEEE transactions on medical imaging},
  volume={36},
  number={2},
  pages={385--395},
  year={2017},
  publisher={IEEE}
}
```

The code is developed by Dr. Valery Vishnevskiy `valera.vishnevskiy@yandex.ru`, [Cardiac Magnetic Resonance group](http://www.cmr.ethz.ch/), Institute for Biomedical Engineering, ETH Zurich, University of Zurich,
[Computer-assisted Applications in Medicine](https://www.caim.ee.ethz.ch/), Computer Vision Laboratory, ETH Zurich.

![ETHZurich](imgs/ethzurich_logo.png)
![ETHZurich](imgs/uzh.png)

