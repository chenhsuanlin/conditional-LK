% Compute warp Jacobian
function dxdp = compute_dxdp(params)

[u,v] = meshgrid(1:params.ImW,1:params.ImH);
u = u-params.ImW/2;
v = v-params.ImH/2;
U = u(:);
V = v(:);
O = zeros(params.ImDim,1);
I = ones(params.ImDim,1);
switch(params.warpType)
    case 'T', % translation
        dxdp = [I,O;...
              O,I];
    case 'R', % rigid, TODO
    case 'S', % similarity
        dxdp = [U,-V,I,O;...
              V, U,O,I];
    case 'A', % affine
        dxdp = [U,V,O,O,I,O;...
              O,O,U,V,O,I];
    case 'H', % homography
        dxdp = [U,V,I,O,O,O,-U.*U,-V.*U;...
              O,O,O,U,V,I,-U.*V,-V.*V];
    otherwise, dxdp = [];
end
