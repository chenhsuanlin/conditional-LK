% Get the warp matrix from the warp parameter vector
function warpVec = warpMtrx2Vec(params,warpMtrx)

switch(params.warpType)
    case 'T', % translation
        tx = warpMtrx(1,3);
        ty = warpMtrx(2,3);
        warpVec = [tx,ty]';
    case 'R', % rigid
        dr = asin(warpMtrx(2,1)); % assuming dr is within +-pi/2
        tx = warpMtrx(1,3);
        ty = warpMtrx(2,3);
        warpVec = [dr,tx,ty]';
    case 'S', % similarity
        pc = warpMtrx(1,1)-1;
        ps = warpMtrx(2,1);
        tx = warpMtrx(1,3);
        ty = warpMtrx(2,3);
        warpVec = [pc,ps,tx,ty]';
    case 'A', % affine
        p1 = warpMtrx(1,1)-1;
        p2 = warpMtrx(1,2);
        p3 = warpMtrx(2,1);
        p4 = warpMtrx(2,2)-1;
        p5 = warpMtrx(1,3);
        p6 = warpMtrx(2,3);
        warpVec = [p1,p2,p3,p4,p5,p6]';
    case 'H', % homography
        p1 = warpMtrx(1,1)-1;
        p2 = warpMtrx(1,2);
        p3 = warpMtrx(1,3);
        p4 = warpMtrx(2,1);
        p5 = warpMtrx(2,2)-1;
        p6 = warpMtrx(2,3);
        p7 = warpMtrx(3,1);
        p8 = warpMtrx(3,2);
        warpVec = [p1,p2,p3,p4,p5,p6,p7,p8]';
    otherwise
        warpVec = [];
end
