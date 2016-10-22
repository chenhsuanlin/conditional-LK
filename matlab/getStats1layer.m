% Get statistics for 1 layer of regressor
function [trainData,validData] = getStats1layer(imageAll,boxGTall,Rall,params)

% collect statistics
fprintf('collecting data... ');
timeStats = tic;
pDim = params.pDim;
featDim = params.featDim;
exampleN = params.exampleN;
validationN = params.validationN;
imageN = params.imageN;
dpTrainAll = zeros(pDim*exampleN,imageN);
dpValidAll = zeros(pDim*validationN,imageN);
featTrainAll = zeros(featDim*exampleN,imageN);
featValidAll = zeros(featDim*validationN,imageN);
for i = 1:imageN
    image = imageAll{i};
    boxGT = boxGTall{i};
    [dp1frameVec,feat1frameVec] = getStats1frame(image,Rall,params);
    dp1frameTrainVec = dp1frameVec(1:pDim*exampleN);
    dp1frameValidVec = dp1frameVec(pDim*exampleN+1:end);
    feat1frameTrainVec = feat1frameVec(1:featDim*exampleN);
    feat1frameValidVec = feat1frameVec(featDim*exampleN+1:end);
    dpTrainAll(:,i) = dp1frameTrainVec;
    dpValidAll(:,i) = dp1frameValidVec;
    featTrainAll(:,i) = feat1frameTrainVec;
    featValidAll(:,i) = feat1frameValidVec;
end
trainData.dpAll = reshape(dpTrainAll,[pDim,exampleN]);
trainData.featDall = reshape(featTrainAll,[featDim,exampleN]);
validData.dpAll = reshape(dpValidAll,[pDim,validationN]);
validData.featDall = reshape(featValidAll,[featDim,validationN]);
% subtract the image samples by the bias
trainData.featDall = bsxfun(@minus,trainData.featDall,params.featGTvec);
validData.featDall = bsxfun(@minus,validData.featDall,params.featGTvec);
fprintf('done (time = %fsec)\n',toc(timeStats));

