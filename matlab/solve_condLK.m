% Solve the regressor using Conditional Lucas-Kanade
function [R,gOpt] = solve_condLK(params,trainData,layer,gIntm)

dpAll = trainData.dpAll;
featDall = trainData.featDall;
P = params.pDim;
D = params.ImDim;
K = params.featChan;
if(strcmp(params.condLK_optimize,'lsqnonlinLM'))
    objFuncLMH = @(g) objFuncLM(g,params,dpAll,featDall);
    opts = optimoptions(@lsqnonlin,'algorithm','levenberg-marquardt',...
                                   'display','iter-detailed',...
                                   'maxiter',params.condLK_LMmaxIterN,...
                                   'jacobian','on');
    gOpt = lsqnonlin(objFuncLMH,gIntm,[],[],opts);
elseif(strcmp(params.condLK_optimize,'GaussNewtonGPU'))
    gpuDevice(params.gpuIndex);
    g = gIntm;
    f = compute_f(params,g,dpAll,featDall);
    fprintf('layer %d init, obj = %f\n',layer,f);
    for it = 1:params.condLK_GNmaxIterN
        [f,dfdg] = objFuncLM(g,params,dpAll,featDall);
        bGPU = gpuArray(f);
        AGPU = -gpuArray(dfdg);
        dgtempGPU = AGPU\bGPU;
        dgOpt = gather(dgtempGPU);
        cost = compute_f(params,g+dgOpt,dpAll,featDall);
        fprintf('it = %d/%d, obj = %f\n',it,params.condLK_GNmaxIterN,cost);
        g = g+dgOpt;
    end
    gOpt = g;
elseif(strcmp(params.condLK_optimize,'LevenbergMarquardtGPU'))
    gpuDevice(params.gpuIndex);
    diagIdx = [0:2*D*K-1]*2*D*K+[0:2*D*K-1]+1;
    divN = 10;
    lambdaMin = -5;
    lambdaMax = 5;
    ratio = (3-sqrt(5))/2;
    g = gIntm;
    f = compute_f(params,g,dpAll,featDall);
    fprintf('layer %d init, obj = %f\n',layer,f);
    for it = 1:params.condLK_LMmaxIterN
        [f,dfdg] = objFuncLM(g,params,dpAll,featDall);
        % preload matrices in GPU
        bGPU = gpuArray(f);
        AGPU = -gpuArray(dfdg);
        AtAGPU = AGPU'*AGPU;
        AtbGPU = AGPU'*bGPU;
        diagAtAGPU = AtAGPU(diagIdx);
        % find best damping factor (golden ratio search)
        A = lambdaMin;
        B = lambdaMax;
        AtAGPU(diagIdx) = (1+10^A)*diagAtAGPU;
        dgtempGPU = AtAGPU\AtbGPU; dgA = gather(dgtempGPU);
        costA = compute_f(params,g+dgA,dpAll,featDall);
        AtAGPU(diagIdx) = (1+10^B)*diagAtAGPU;
        dgtempGPU = AtAGPU\AtbGPU; dgB = gather(dgtempGPU);
        costB = compute_f(params,g+dgB,dpAll,featDall);
        C = A+ratio*(B-A);
        AtAGPU(diagIdx) = (1+10^C)*diagAtAGPU;
        dgtempGPU = AtAGPU\AtbGPU; dgC = gather(dgtempGPU);
        costC = compute_f(params,g+dgC,dpAll,featDall);
        for div = 1:divN
            D = C+ratio*(B-C);
            AtAGPU(diagIdx) = (1+10^D)*diagAtAGPU;
            dgtempGPU = AtAGPU\AtbGPU; dgD = gather(dgtempGPU);
            costD = compute_f(params,g+dgD,dpAll,featDall);
            if(div>5&&(costD> = costA||costD> = costB))
                break;
            end
            if(costC< = costD)
                B = A; costB = costA; dgB = dgA;
                A = D; costA = costD; dgA = dgD;
            else
                A = C; costA = costC; dgA = dgC;
                C = D; costC = costD; dgC = dgD;
            end
            dgOpt = dgC;
        end
        fprintf('it = %d/%d, lambda = %f, obj = %f\n',it,params.condLK_LMmaxIterN,C,costC);
        g = g+dgOpt;
    end
    gOpt = g;
elseif(strcmp(params.condLK_optimize,'gradientDescent'))
    eta = params.condLK_eta;
    etaDimRate = params.condLK_etaDimRate;
    etaStep = params.condLK_etaStep;
    g = gIntm;
    f = compute_f(params,g,dpAll,featDall);
    fprintf('init, eta = %f, obj = %f\n',eta,f);
    for it = 1:params.condLK_GDmaxIterN
        dfdg = compute_dfdg(params,g,dpAll,featDall);
        g = g-eta*dfdg;
        f = compute_f(params,g,dpAll,featDall);
        fprintf('it = %d/%d, eta = %f, obj = %f\n',it,params.condLK_GDmaxIterN,eta,f);
        if(mod(it,etaStep) =  = 0) eta = eta*etaDimRate; end
    end
    gOpt = g;
elseif(strcmp(params.condLK_optimize,'LBFGS'))
    addpath(genpath('../minFunc_2012'));
    options.Method = 'lbfgs';
    options.maxFunEvals = params.condLK_LBFGSmaxIterN;
    options.Corr = params.condLK_LBFGShistoryN;
    options.LS_interp = 1;
    options.Damped = 1;
    objFuncMinFuncH = @(g) objFuncMinFunc(params,g,dpAll,featDall);
    f = compute_f(params,gIntm,dpAll,featDall);
    fprintf('init, obj = %f\n',f);
    gOpt = minFunc(objFuncMinFuncH,gIntm,options);
end
% form the final regressor
R = computeLKregressor(params,gOpt);

% ===================================================

% Compute objective function
function [f,dfdg] = objFuncLM(g,params,dpAll,featDall)

addpath('../mtimesx_20110223/');
P = params.pDim;
D = params.ImDim;
K = params.featChan;
N = size(dpAll,2);
R = computeLKregressor(params,g);
F = dpAll-R*featDall;
f = F(:);
dFdgReshape = zeros(P,N,2*D,K);
parfor k = 1:K
    dRdg1k = compute_dRdg1k(g,k,params);
    dFdgReshape(:,:,:,k) = -mtimesx(dRdg1k,featDall);
end
dfdg = reshape(dFdgReshape,[P*N,2*D*K]);

% ===================================================

% Compute objective function
function [f,dfdg] = objFuncMinFunc(params,g,dpAll,featDall)
f = compute_f(params,g,dpAll,featDall);
dfdg = compute_dfdg(params,g,dpAll,featDall);

% ===================================================

% Compute objective function
function f = compute_f(params,g,dpAll,featDall)
N = params.trainN;
R = computeLKregressor(params,g);
f = norm(dpAll-R*featDall,'fro')^2/N;
% Compute gradient of objective
function dfdg = compute_dfdg(params,g,dpAll,featDall)
P = params.pDim;
D = params.ImDim;
K = params.featChan;
N = params.trainN;
R = computeLKregressor(params,g);
dfdR = -2*(dpAll-R*featDall)*featDall';
% dRdg = compute_dRdg(g,params);
% dvecRdg = reshape(dRdg,[P*D*K,2*D*K]);
% dfdg = dvecRdg'*dfdR(:)/N;
dfdvecR = dfdR(:);
dfdgReshape = zeros(2*D,K);
parfor k = 1:K
    dRdg1k = compute_dRdg1k(g,k,params);
    dvecRdg1k = reshape(dRdg1k,[P*D*K,2*D]);
    dfdg1k = dvecRdg1k'*dfdvecR/N;
    dfdgReshape(:,k) = dfdg1k;
end
dfdgReshapeX = dfdgReshape(1:D,:);
dfdgReshapeY = dfdgReshape(D+1:2*D,:);
dfdg = [dfdgReshapeX(:);dfdgReshapeY(:)];

