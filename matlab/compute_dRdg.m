% Compute Jacobian of regressor R given g
function dRdg = compute_dRdg(g,params)

addpath('../mtimesx_20110223/');
P = params.pDim;
D = params.ImDim;
K = params.featChan;
% precompute variables
dxdp = compute_dxdp(params);
dxdpX = dxdp(1:D,:);
dxdpY = dxdp(D+1:end,:);
dxdpXrepmatK = repmat(dxdpX,[K,1]);
dxdpYrepmatK = repmat(dxdpY,[K,1]);
gi = repmat([1:D*K],[1,2]);
gj = [repmat([1:D],[1,K]),repmat([D+1:2*D],[1,K])];
G = sparse(gi,gj,g);
G_dxdp = G*dxdp;
invH = inv(G_dxdp'*G_dxdp);
% compute Jacobian with respect to g
dGdg_dxdp = [dxdpXrepmatK;dxdpYrepmatK];
dHdg1term = mtimesx(permute([G_dxdp;G_dxdp],[2,3,1]),...
                    permute(dGdg_dxdp,[3,2,1]));
dHdg = dHdg1term+permute(dHdg1term,[2,1,3]);
dinvHdg = -mtimesx(invH,mtimesx(dHdg,invH));
dRdg = mtimesx(dinvHdg,G_dxdp');
dRdg2diagX = dxdpXrepmatK*invH;
dRdg2diagY = dxdpYrepmatK*invH;
for p = 1:P
    idxX = [(P*D*K)*[0:D*K-1]+P*[0:D*K-1]+p];
    idxY = [P*D*K*D*K+(P*D*K)*[0:D*K-1]+P*[0:D*K-1]+p];
    dRdg(idxX) = dRdg(idxX)+dRdg2diagX(:,p)';
    dRdg(idxY) = dRdg(idxY)+dRdg2diagY(:,p)';
end
