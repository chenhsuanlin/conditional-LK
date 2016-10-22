% Fit an affine warp
function affineWarpMtrx = affineFit(Xsrc,Xdst)

assert(size(Xsrc,2) =  = size(Xdst,2));
N = size(Xsrc,2);
X = Xsrc(1,:)';
Y = Xsrc(2,:)';
U = Xdst(1,:)';
V = Xdst(2,:)';
O = zeros(N,1);
I = ones(N,1);
A = [X,Y,O,O,I,O;...
   O,O,X,Y,O,I];
b = [U;V];
p = A\b;
affineWarpMtrx = [p(1),p(2),p(5);...
                  p(3),p(4),p(6);...
                     0,   0,   1];
