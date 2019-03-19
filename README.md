## The Conditional Lucas & Kanade Algorithm
[Chen-Hsuan Lin](https://chenhsuanlin.bitbucket.io/),
[Rui Zhu](https://jerrypiglet.github.io/),
and [Simon Lucey](http://www.simonlucey.com/)  
European Conference on Computer Vision (ECCV), 2016  

Project page: https://chenhsuanlin.bitbucket.io/conditional-LK  
Paper: https://chenhsuanlin.bitbucket.io/conditional-LK/paper.pdf  
Poster: https://chenhsuanlin.bitbucket.io/conditional-LK/poster.pdf

We provide the MATLAB code for planar image alignment experiments.  

--------------------------------------

### Prerequisites  
You would need to first compile [MTIMESX](https://www.mathworks.com/matlabcentral/fileexchange/25977-mtimesx-fast-matrix-multiply-with-multi-dimensional-support). This is required for fast computation for optimizing Conditional LK. Please follow the instructions in the MATLAB File Exchange to compile this library.

### Running the code  

To train the linear regressors, run `runTrain` under the matlab directory.  
Run `runTest` to evaluate the trained regressors.
There is also a number of different parameters that can be adjusted for the experiment in setParams.m.  

The nonlinear optimization methods we provide include:
* Levenberg-Marquardt using the MATLAB built-in `lsqnonlin` function
* Gauss-Newton with GPU support
* Levenberg-Marquardt with GPU support
* Vanilla gradient descent
* Limited-memory BFGS (LBFGS)  

**(new)** We have additionaly included support using the [minFunc](https://www.cs.ubc.ca/~schmidtm/Software/minFunc.html) library if you wish to use LBFGS for optimization (nice if you have limited RAM). Other optimization methods in *minFunc* are also compatible.  
We did not use *minFunc* for our experiments, but if you wish to use it, please place the `minFunc_2012` directory in the repository root and follow the instructions to compile.

We also provide a script `visualizeGradients.m` to help visualize the learned gradients. You would need [imdisp](https://www.mathworks.com/matlabcentral/fileexchange/22387-imdisp) to run this script.

--------------------------------------

If you find our code useful for your research, please cite
```
@inproceedings{lin2016conditional,
  title={The Conditional Lucas \& Kanade Algorithm},
  author={Lin, Chen-Hsuan and Zhu, Rui and Lucey, Simon},
  booktitle={European Conference on Computer Vision (ECCV)},
  pages={793--808},
  year={2016},
  organization={Springer International Publishing}
}
```
Please contact me (chlin@cmu.edu) if you have any questions!


