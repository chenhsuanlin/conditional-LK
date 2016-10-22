% update warp (compositional)
function pVec = composeWarp(pVec,dpVec,params,inverse)

pMtrx = warpVec2Mtrx(params,pVec);
dpMtrx = warpVec2Mtrx(params,dpVec);
if(inverse)
    pMtrx = dpMtrx\pMtrx;
else
    pMtrx = dpMtrx*pMtrx;
end
pVec = warpMtrx2Vec(params,pMtrx);
