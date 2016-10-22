%% read files
imageAll{1} = imread('simonbaker.png');
boxGTall{1} = [220,100,460,340];
% track one image
image = imageAll{1};
boxGT = boxGTall{1};

%% set parameters
params = setParams(imageAll,boxGT);

%% generate a random warp
while(true)
    pVec = genNoiseWarp(params);
    % make sure perturbed box doesn't fall out of image
    if(checkGoodPerturbedBox(params,pVec,image)) break; end
end

%% run the regressors
assert(params.pDim =  = size(Rall{1},1),'warp dimension mismatch.....');
[pVecAll,~] = performRegression(params,image,pVec,Rall,true);
