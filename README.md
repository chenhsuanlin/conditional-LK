## The Conditional Lucas & Kanade Algorithm

This is the code for the paper
#### The Conditional Lucas & Kanade Algorithm  
Chen-Hsuan Lin, Rui Zhu, and Simon Lucey  
European Conference on Computer Vision (ECCV), 2016

ECCV poster: http://www.eccv2016.org/files/posters/P-4B-22.pdf  
arXiv preprint: https://arxiv.org/pdf/1603.08597v1.pdf

We provide the MATLAB code for planar image alignment experiments.  
Please cite our paper if you find our code useful for your research!

--------------------------------------

### Prerequisites  
You would need to first compile **MTIMESX** (https://www.mathworks.com/matlabcentral/fileexchange/25977-mtimesx-fast-matrix-multiply-with-multi-dimensional-support). Please follow the instructions in the File Exchange to compile this library.

To run the code, run `runTrain` under the matlab directory.
There is also a number of different parameters that can be adjusted for the experiment in setParams.m.
The nonlinear optimization methods (Gauss-Newton/Levenberg-Marquardt) for Conditional LK are also GPU supported.

We have additionaly included support using the **minFunc** library (https://www.cs.ubc.ca/~schmidtm/Software/minFunc.html) if you wish to use LBFGS for optimization (nice if you have limited RAM). We did not use **minFunc** for our experiments, but if you wish to use it, please place the `minFunc_2012` directory in the repository root and follow the instructions to compile.

We also provide a script `visualizeGradients.m` to help visualize the learned gradients. You would need `imdisp` (https://www.mathworks.com/matlabcentral/fileexchange/22387-imdisp) to run this script.

--------------------------------------

Please contact me (chenhsul@andrew.cmu.edu) if you have any questions!


