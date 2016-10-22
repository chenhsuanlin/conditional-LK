% Solve the regressor using Generative Lucas-Kanade
function [R,gOpt] = solve_genLK(params,trainData,layer)

dpAll = trainData.dpAll;
featDall = trainData.featDall;
D = params.ImDim;
K = params.featChan;
% precompute vectors/matrices
dxdp = compute_dxdp(params);
dxAll = dxdp*dpAll;
gOpt = zeros(2*D*K,1);
for d = 1:D
    b = featDall(D*[0:K-1]+d,:);
    A = dxAll([d,d+D],:);
    % solve the small linear system
    gLs = b/A;
    gOpt(D*[0:2*K-1]+d) = gLs(:);
end
% form the final regressor
R = computeLKregressor(params,gOpt);
