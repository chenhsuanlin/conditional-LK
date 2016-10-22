% Get the warp parameter vector from the warp matrix
function warpMtrx = warpVec2Mtrx(params,warpVec)

switch(params.warpType)
    case 'T', % translation
        tx = warpVec(1);
        ty = warpVec(2);
        warpMtrx = [1,0,tx;...
                  0,1,ty;...
                  0,0, 1];
    case 'R', % rigid
        dr = warpVec(1);
        tx = warpVec(2);
        ty = warpVec(3);
        warpMtrx = [cos(dr),-sin(dr),tx;...
                  sin(dr), cos(dr),ty;...
                        0,       0, 1];
    case 'S', % similarity
        pc = warpVec(1);
        ps = warpVec(2);
        tx = warpVec(3);
        ty = warpVec(4);
        warpMtrx = [1+pc, -ps,tx;...
                    ps,1+pc,ty;...
                     0,   0, 1];
    case 'A', % affine
        p1 = warpVec(1);
        p2 = warpVec(2);
        p3 = warpVec(3);
        p4 = warpVec(4);
        p5 = warpVec(5);
        p6 = warpVec(6);
        warpMtrx = [1+p1,  p2,p5;...
                    p3,1+p4,p6;...
                     0,   0, 1];
    case 'H', % homography
        p1 = warpVec(1);
        p2 = warpVec(2);
        p3 = warpVec(3);
        p4 = warpVec(4);
        p5 = warpVec(5);
        p6 = warpVec(6);
        p7 = warpVec(7);
        p8 = warpVec(8);
        warpMtrx = [1+p1,  p2,p3;...
                    p4,1+p5,p6;...
                    p7,  p8, 1];
    otherwise
        warpMtrx = [];
end
