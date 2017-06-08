# dibco_2017
Submission for DIBCO 2017

This repo is my submission to the 2017 Document Image Binarization COmpetition (DIBCO) organized as part of ICDAR 2017.
This method performs binarization using an ensemble of 5 deep Fully Convolutional Networks (FCNs) that operate over multiple image scales, including full resolution.
The underlying deep learning library is Caffe, and more specifically, my own particular fork of Caffe (https://github.com/waldol1/caffe), which should be installed with the python bindings.

The networks take in 3 input image features: 1) raw grayscale input image, 2) The Howe binarization of the image [1], and 3) Relative Darkness (RD) features [2] densely computed over the image.
Howe binarization is a state-of-the-art binarization algorithm with more information and code located at http://www.cs.smith.edu/~nhowe/research/code/.
RD features are simply a count how of many pixels in a neighborhood are darker, lighter, or similar than the central pixel, where darker, lighter, and similar are determined by a threshold.
The RD features these networks were trained on use a 5x5 window with a threshold of 10 (i.e. darker pixels are those wtih intensity at least 10 below that of the central pixel).
As a side note, FCNs do quite well when trained on just the raw grayscale images, so these additional features should not be viewed as critical to success of this method, but do empirically improve quality of results ~1%.

Raw predicted probabilities are averaged per-pixel across the 5 FCNs in the ensemble.
The resulting average probabilities are post-processed using a Densely Connected Conditional Random Field (CRF) with Gaussian edge potentials [3].
Inference is done using the mean-field approximation for 5 iterations.
For implementation, I use a python wrapper [4] for the C++ code provided by the authors of [3].
See [4] for installation instructions for the densecrf wrapper.

As this method relies on [1], I have provided a helper script (`get_howe_code.sh`) to download and compile the MATLAB code from [1].
If something goes wrong with the script, just download his code manually, and compile the needed .mex files (requires a working install of MATLAB).
Then put that and the \*.m and \*.mexa64 files into the root directory of this repo.
As I don't own the code from [1], all licencing restrictions of that code apply when using that code as part of this repo, so read them carefully.
Calling this MATLAB code from `dibco_submission.py` requires installing the matlab.engine module (https://www.mathworks.com/help/matlab/matlab_external/install-the-matlab-engine-for-python.html).

The usage statement for the code is:
```USAGE: python hdibco_submission.py in_image out_image [gpu#]
        in_image is the input image to be binarized
		out_image is where the binarized image will be written to
		gpu is an integer device ID to run networks on the specified GPU.  If ommitted, CPU mode is used```
Using GPU mode requires ~1.2GB of device memory on my combination of hardware/software (GTX 660, CuDNN v5), though your mileage may vary.

References:
[1] Document Binarization with Automatic Parameter Tuning, N. Howe.  To appear in International Journal of Document Analysis and Recognition. DOI: 10.1007/s10032-012-0192-x.

[2] Wu, Yue, et al. "Learning document image binarization from data." Image Processing (ICIP), 2016 IEEE International Conference on. IEEE, 2016.

[3] Koltun, Vladlen. "Efficient inference in fully connected crfs with gaussian edge potentials." Adv. Neural Inf. Process. Syst 2.3 (2011): 4.

[4] https://github.com/lucasb-eyer/pydensecrf
