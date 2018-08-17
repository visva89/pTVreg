We report the following accuracy of pTV on 4DCT and COPDgene datasets:

| 4DCT 1  | 4DCT 2  | 4DCT 3  | 4DCT 4  | 4DCT 5  | 4DCT 6  | 4DCT 7  | 4DCT 8  | 4DCT 9  | 4DCT 10  |**Mean TRE**|Mean Time (sec.)|
|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|----------|---------|
|0.77|0.75|0.93|1.26|1.07|0.83|0.80|1.01|0.91|0.84|**0.92**|130|
*Table: TRE is computed in the snap-to-voxel fashion. The code for this experiment is provided in* `examples_ptv/DIR_test_all.m`


| COPD 1  | COPD 2  | COPD 3  | COPD 4  | COPD 5  | COPD 6  | COPD 7  | COPD 8  | COPD 9  | COPD 10  |**Mean TRE**|Mean Time (sec.)|
|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|----------|---------|
|0.71|1.91|0.77|0.67|0.71|0.66|0.75|0.78|0.64|0.85|**0.8461**|442|
*Table: TRE is computed in the snap-to-voxel fashion. The code for this experiment is provided in* `examples_ptv/COPD_finetune.m`

For 4DCT dataset the method is configured as follows:
* images are resampled to 1x1x1 mm^3 resolution
* displacements control point grid spacing: 4x4x4 pixels
* LCC kernel sigma is 2.1 mm
* isotropic TV regularization weight is set to 0.11

For COPDgene dataset the method is configured as follows:
* images are resampled to 1x1x1 mm^3 resolution
* displacements control point grid spacing: 8x8x8 pixels and are refined to 4x4x4 pixels at the finest pyramid level
* LCC kernel sigma is 2.1 mm
* isotropic TV regularization weight is set to 0.11

Compared to ["Vishnevskiy V, Gass T, Szekely G, Tanner C, Goksel O. Isotropic total variation regularization of displacements in parametric image registration. IEEE TMI. 2017."](http://ieeexplore.ieee.org/abstract/document/7570266/)
the method is improved in the following ways:
* Image pyramids are constructed with downscaling factor of 0.7 (0.5 in the original paper)
* Image gradients are computed taking into account image interpolation scheme (we used approximation `grad(warp(image))` in the original paper)
* Bugs is displacement field upsampling were fixed

We also provide registration accuracy using different configurations of the method:
### DIR

| Method config        | 4DCT 1  | 4DCT 2  | 4DCT 3  | 4DCT 4  | 4DCT 5  | 4DCT 6  | 4DCT 7  | 4DCT 8  | 4DCT 9  | 4DCT 10  |**Mean TRE**|Mean Time (sec.)|
|----------------------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|----------|---------|
|`cp_refinements = 0`<br/>`loc_cc_approximate = false`<br/>Original resolution |0.82|0.83|0.98|1.28|1.13|0.88|0.83|1.05|0.95|0.87|**0.96**|72|
|`cp_refinements = 0`<br/>`loc_cc_approximate = true`<br/>Original resolution |0.78|0.79|0.96|1.27|1.09|0.89|0.86|1.07|0.94|0.93|**0.96**|57|
|`cp_refinements = 0`<br/>`loc_cc_approximate = true`<br/>Resampled to 1x1x1 mm^3 |0.77|0.75|0.93|1.26|1.07|0.83|0.80|1.01|0.91|0.84|**0.92**|130|
|`cp_refinements = 0`<br/>`loc_cc_approximate = false`<br/>Resampled to 1x1x1 mm^3 |0.80|0.77|0.92|1.28|1.11|0.81|0.80|1.12|0.90|0.79|**0.93**|188|
|`cp_refinements = 1`<br/>`loc_cc_approximate = true`<br/>Resampled to 1x1x1 mm^3 |0.78|0.74|0.92|1.27|1.09|0.84|0.81|0.99|0.92|0.85|**0.92**|178|
|`cp_refinements = 1`<br/>`loc_cc_approximate = false`<br/>Resampled to 1x1x1 mm^3 |0.80|0.77|0.92|1.30|1.13|0.78|0.79|1.00|0.91|0.82|**0.92**|300|

### COPD

| Method config        | COPD 1  | COPD 2  | COPD 3  | COPD 4  | COPD 5  | COPD 6  | COPD 7  | COPD 8  | COPD 9  | COPD 10  |**Mean TRE**|Mean Time (sec.)|
|----------------------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|----------|---------|
|`cp_refinements = 0`<br/>`loc_cc_approximate = false`<br/> Linear interpolation |0.78|3.38|0.79|0.72|0.77|1.00|0.81|1.19|0.67|0.86|**1.09**|224|
|`cp_refinements = 0`<br/>`loc_cc_approximate = true`<br/> Linear interpolation |0.79|3.81|0.83|0.78|0.98|0.90|0.82|1.02|0.72|1.07|**1.17**|186|
|`cp_refinements = 1`<br/>`loc_cc_approximate = false`<br/> Linear interpolation |0.72|2.22|0.79|0.68|0.81|0.70|0.81|0.83|0.64|0.86|**0.91**|359|
|`cp_refinements = 1`<br/>`loc_cc_approximate = true`<br/> Linear interpolation |0.74|3.22|0.79|0.74|0.80|1.13|0.81|0.85|0.66|0.92|**1.07**|275|
|`cp_refinements = 1`<br/>`loc_cc_approximate = false`<br/> Cubic interpolation |0.71|1.91|0.77|0.67|0.71|0.66|0.75|0.78|0.64|0.85|**0.8461**|442|


# Running The Code
The data used in this challenge is publicly available by request from [organizers](https://www.dir-lab.com/ReferenceData.html).
`bpath` variable sets the basepath for the dataset. 
Please double check that you directory formatting agrees with the one used by us: [tree output](DIRfiletree.md).

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

The code is developed by Valery Vishnevskiy, [Cardiac Magnetic Resonance group](http://www.cmr.ethz.ch/), Institute for Biomedical Engineering, ETH Zurich, University of Zurich,
[Computer-assisted Applications in Medicine](https://www.caim.ee.ethz.ch/), ETH Zurich.

![ETHZurich](imgs/ethzurich_logo.png)
![ETHZurich](imgs/uzh.png)


