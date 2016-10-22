% Compute Jacobian of regressor R given g (for a single channel)
function dRdg1k = compute_dRdg1k(g,k,params)

addpath('../mtimesx_20110223/');
P = params.pDim;
D = params.ImDim;
K = params.featChan;
% precompute variables
dxdp = compute_dxdp(params);
dxdpX = dxdp(1:D,:);
dxdpY = dxdp(D+1:end,:);
gi = repmat([1:D*K],[1,2]);
gj = [repmat([1:D],[1,K]),repmat([D+1:2*D],[1,K])];
G = sparse(gi,gj,g);
G_dxdp = G*dxdp;
invH = inv(G_dxdp'*G_dxdp);
% compute Jacobian with respect to g
dGdg_dxdp = dxdp;
dHdg1term = mtimesx(permute([G_dxdp((k-1)*D+[1:D],:);...
                             G_dxdp((k-1)*D+[1:D],:)],[2,3,1]),...
                    permute(dGdg_dxdp,[3,2,1]));
dHdg = dHdg1term+permute(dHdg1term,[2,1,3]);
dinvHdg = -mtimesx(invH,mtimesx(dHdg,invH));
dRdg1k = mtimesx(dinvHdg,G_dxdp');
dRdg2diagX = dxdpX*invH;
dRdg2diagY = dxdpY*invH;
for p = 1:P
    idxX = [P*(k-1)*D+(P*D*K)*[0:D-1]+P*[0:D-1]+p];
    idxY = [P*(k-1)*D+P*D*D*K+(P*D*K)*[0:D-1]+P*[0:D-1]+p];
    dRdg1k(idxX) = dRdg1k(idxX)+dRdg2diagX(:,p)';
    dRdg1k(idxY) = dRdg1k(idxY)+dRdg2diagY(:,p)';
end
