% get the inverse-compositional LK regressors
function Rall = getLKICregressors(params,layerMaxN)

featGT = reshape(params.featGTvec,[params.ImH,params.ImW,params.featChan]);
[featGTgradx,featGTgrady] = gradient(featGT);
g = [featGTgradx(:);featGTgrady(:)];
R = computeLKregressor(params,g);
R = [R,-R*params.featGTvec];
Rall = cell(layerMaxN,1);
for l = 1:length(Rall)
    Rall{l} = R;
end
