% Solve the regressor using SDM
function R = solve_SDM(params,trainData,layer,lambda)

dpAll = trainData.dpAll;
featDall = trainData.featDall;
R = (dpAll*featDall')/(featDall*featDall'+lambda*eye(params.featDim));
