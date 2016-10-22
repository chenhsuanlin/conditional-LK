% Set the parameter settings
function params = setParams(imageAll,boxGT)

% type of warp function
% 'T' - translation
% 'S' - similarity
% 'A' - affine
% 'H' - homography
params.warpType = 'A';
% image size for alignment
params.ImW = 50;
params.ImH = 50;

% number of examples trained with per layer
params.exampleN = 200;
% number of examples used for validation
params.validationN = max(params.exampleN/10,1);
% scale of perturbations
params.warpScale.pert = 0.06;
params.warpScale.trans = 0.06;

% set the type of regressor to train/evaluate
% params.regressorType = 'SDM';
% params.regressorType = 'genLK';
params.regressorType = 'condLK';
% params.regressorType = 'LKIC';

% options for Conditional LK
% params.condLK_optimize = 'lsqnonlinLM';
% params.condLK_optimize = 'GaussNewtonGPU';
params.condLK_optimize = 'LevenbergMarquardtGPU';
% params.condLK_optimize = 'gradientDescent';
% params.condLK_optimize = 'LBFGS';
params.condLK_GNmaxIterN = 30;
params.condLK_LMmaxIterN = 10;
params.condLK_eta = 0.2;
params.condLK_etaDimRate = 0.8;
params.condLK_etaStep = 10;
params.condLK_GDmaxIterN = 100;
params.condLK_LBFGSmaxIterN = 50;
params.condLK_LBFGShistoryN = 20;

% GPU index if you have one (or more)
params.gpuIndex = 0;

% type of feature to learn in the LK framework
params.featType = 'pixel';
% params.featType = 'LBP';
params.LBP_compareDist = 1;
params.LBP_gaussianSize = 4;
params.LBP_gaussianSigma = 1;

% fix the SDM regularization factor (usually set to false)
params.fixLambda = false;
params.fixLambdaValue = 1e2;

% visualize during training/test
params.visualizeTrain = false;
params.visualizeTestPause = true;

% ------------------the below are automatically set ------------------
params.imageN = length(imageAll);
params.trainN = params.imageN*params.exampleN;

switch(params.warpType)
    case 'T', params.pDim = 2; % translation
    case 'R', params.pDim = 3; % rigid
    case 'S', params.pDim = 4; % similarity
    case 'A', params.pDim = 6; % affine
    case 'H', params.pDim = 8; % homography
    otherwise, params.pDim = 0;
end

params.ImDim = params.ImW*params.ImH;
switch(params.featType)
    case 'pixel',
        params.featChan = 1;
    case 'LBP',
        params.featChan = 8;
    otherwise,
end
params.featDim = params.ImDim*params.featChan;

W = params.ImW;
H = params.ImH;
params.boxGT = boxGT;
boxGTcorners = [boxGT(1),boxGT(1),boxGT(3),boxGT(3);...
                boxGT(2),boxGT(4),boxGT(4),boxGT(2)];
ImCorners = [-W/2,-W/2,W/2,W/2;
             -H/2,H/2,H/2,-H/2];
params.Im2imageAffine = affineFit(ImCorners,boxGTcorners);
params.image2ImAffine = affineFit(boxGTcorners,ImCorners);
params.imref2d = imref2d(size(imageAll{1}));

params.LBP_gaussianKernel = fspecial('gaussian',params.LBP_gaussianSize,params.LBP_gaussianSigma);
