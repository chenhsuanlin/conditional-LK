% Run through the regressors
function [pVecAll,featVec] = performRegression(params,image,pVec,Rall,visualize)

% visualization
warpHandle = [];
if(visualize)
    warpHandle = visualizeWarp(image,pVec,params,warpHandle);
    drawnow;
    pause;
end
% cascade regression
layerN = length(Rall);
pVecAll = zeros(layerN+1,params.pDim);
pVecAll(1,:) = pVec';
for l = 1:layerN
    % crop out the warped frame
    imageWarp = warpImage(image,pVec,params);
    feat = extractFeature(imageWarp,params);
    featVec = feat(:);
	% apply regression and try to warp back image
	dpVec = Rall{l}*[featVec;1];
    % update warp
	pVec = composeWarp(pVec,dpVec,params,true);
	% visualization
    if(visualize)
        warpHandle = visualizeWarp(image,pVec,params,warpHandle);
    	drawnow;
        if(params.visualizeTestPause) pause; end
    end
    pVecAll(l+1,:) = pVec';
end
imageWarp = warpImage(image,pVec,params);
feat = extractFeature(imageWarp,params);
featVec = feat(:);
