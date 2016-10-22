% Collect statistics of 1 frame for training
function [dp1frameVec,feat1frameVec] = getStats1frame(image,Rall,params)

dp1frame = zeros(params.pDim,params.exampleN+params.validationN);
feat1frame = zeros(params.featDim,params.exampleN+params.validationN);
warpHandle = [];
for e = 1:params.exampleN+params.validationN
    % sample a perturbation
    while(true)
    	dpVecNoise = genNoiseWarp(params);
        % make sure perturbed box doesn't fall out of image
        if(checkGoodPerturbedBox(params,dpVecNoise,image)) break; end
    end
    % regress with the given regressors
    [dpVecAll,featVec] = performRegression(params,image,dpVecNoise,Rall,false);
    dpVec = dpVecAll(end,:)';
    % visualization
    if(params.visualizeTrain)
        warpHandle = visualizeWarp(image,dpVec,params,warpHandle);
    	drawnow;
    end
    % add to statistics
    dp1frame(:,e) = dpVec;
    feat1frame(:,e) = featVec;
end
dp1frameVec = dp1frame(:);
feat1frameVec = feat1frame(:);
