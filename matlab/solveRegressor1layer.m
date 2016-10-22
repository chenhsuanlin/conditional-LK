% Solve for 1 layer of regressor
function R = solveRegressor1layer(params,trainData,validData,layer)

% solve for the linear regressor
fprintf('solving for linear regressor...\n');
timeSolve = tic;
switch(params.regressorType)
    case 'SDM',
        R = validateModel(trainData,validData,layer,@solve_SDM,params);
    case 'genLK',
        [R,gOpt] = solve_genLK(params,trainData,layer);
    case 'condLK',
        [~,gIntm] = solve_genLK(params,trainData,layer);
        [R,gOpt] = solve_condLK(params,trainData,layer,gIntm);
    otherwise, R = [];
end
% append the bias
R = [R,-R*params.featGTvec];
fprintf('solve done (time=%fsec)\n',toc(timeSolve));

% ===================================================

% validation for R regularizer (golden ratio search)
function R_opt = validateModel(trainData,validData,layer,solver,params)

if(params.fixLambda)
    % skip validation, use manually determined lambda
    fprintf('validation skipped, using lambda=%f\n',params.fixLambdaValue);
    R_opt = solver(params,trainData,params.fixLambdaValue);
    return;
end
fprintf('validating model.... \n');
divN = 10;
lambdaMin = -10;
lambdaMax = 10;
ratio = (3-sqrt(5))/2;
% initial logarithm limits on the search
A = lambdaMin;
B = lambdaMax;
[RA,costA] = evaluateCost(10^A,trainData,validData,layer,solver,params);
fprintf('A = %f, costA = %f\n',A,costA);
[RB,costB] = evaluateCost(10^B,trainData,validData,layer,solver,params);
fprintf('B = %f, costB = %f\n',B,costB);
C = A+ratio*(B-A);
[RC,costC] = evaluateCost(10^C,trainData,validData,layer,solver,params);
fprintf('C = %f, costC = %f\n',C,costC);
for div = 1:divN
    D = C+ratio*(B-C);
    [RD,costD] = evaluateCost(10^D,trainData,validData,layer,solver,params);
    if(div>5&&(costD> = costA||costD> = costB))
        fprintf('(objective not U-shape)\n');
        break;
    end
    if(costC< = costD)
        B = A; costB = costA; RB = RA;
        A = D; costA = costD; RA = RD;
    else
        A = C; costA = costC; RA = RC;
        C = D; costC = costD; RC = RD;
    end
    R_opt = RC;
    fprintf('div=%d, lambdaOpt=%f, cost=%f (A=%f,B=%f,C=%f,D=%f)\n',div,C,costC,A,B,C,D);
end

% ===================================================

% Evaluate cost for validating lambda (R)
function [R,cost] = evaluateCost(lambda,trainData,validData,layer,solver,params)

R = solver(params,trainData,layer,lambda);
dpAllValid = validData.dpAll;
featDallValid = validData.featDall;
cost = norm(dpAllValid-R*featDallValid)^2;

