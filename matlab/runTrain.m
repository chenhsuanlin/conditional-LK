%% read files
imageAll{1} = imread('../images/simonbaker.png');
% set bounding box ([xmin,ymin,xmax,ymax])
boxGTall{1} = [220,100,460,340];
% train on a single image
image = imageAll{1};
boxGT = boxGTall{1};

%% set parameters
params = setParams(imageAll,boxGT);
% precompute the bias image/feature
featGTvec = computeBiasFeature(imageAll,params);
params.featGTvec = featGTvec;

%% train the regressors
rng('shuffle');
layerMaxN = 5;
fprintf('Training the regressors...\n');
if(strcmp(params.regressorType,'LKIC'))
    Rall = getLKICregressors(params,layerMaxN);
else
	timeTotal = tic;
    Rstack = {};
	for layer = 1:layerMaxN
	    time1layer = tic;
	    % collect statistics
        [trainData,validData] = getStats1layer(imageAll,boxGTall,Rstack,params);
        % solve the regressor
	    R = solveRegressor1layer(params,trainData,validData,layer);
	    % stack regressors
	    Rstack = [Rstack;{R}];
	    fprintf('----- layer %d done (time=%fsec), total time=%fsec -----\n',layer,toc(time1layer),toc(timeTotal));
	end
    Rall = Rstack;
end
