% Compute Lucas-Kanade regressor
function R = computeLKregressor(params,g)

D = params.ImDim;
K = params.featChan;
dxdp = compute_dxdp(params);
gi = repmat([1:D*K],[1,2]);
gj = [repmat([1:D],[1,K]),repmat([D+1:2*D],[1,K])];
G = sparse(gi,gj,g);
R = pinv(G*dxdp);
