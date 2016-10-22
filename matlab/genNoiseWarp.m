% Generate a random warp
function dpVec = genNoiseWarp(params)

warpScale = params.warpScale;
% perturb the four corners of the box
W = params.ImW;
H = params.ImH;
dX = W*warpScale.pert*randn(4,1)+W*warpScale.trans*randn();
dY = H*warpScale.pert*randn(4,1)+H*warpScale.trans*randn();
X = [-W/2;W/2;W/2;-W/2];
Y = [-H/2;-H/2;H/2;H/2];
O = zeros(4,1);
I = ones(4,1);
switch(params.warpType)
    case 'T', % translation
        J = [I,O;...
           O,I];
        dpVec = J\[dX;dY];
    case 'R', % rigid, TODO
    case 'S', % similarity
        J = [X,-Y,I,O;...
           Y, X,O,I];
        dpVec = J\[dX;dY];
    case 'A', % affine
        J = [X,Y,O,O,I,O;...
           O,O,X,Y,O,I];
        dpVec = J\[dX;dY];
    case 'H', % homography
        Xp = X+dX;
        Yp = Y+dY;
        A = [X,Y,I,O,O,O,-X.*Xp,-Y.*Xp;...
           O,O,O,X,Y,I,-X.*Yp,-Y.*Yp];
        h = A\[Xp;Yp];
        dpVec = h-[1;0;0;0;1;0;0;0];
    otherwise, dpVec = [];
end
assert(length(dpVec) =  = params.pDim);

