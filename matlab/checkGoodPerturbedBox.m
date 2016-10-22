% Make sure perturbed box doesn't fall out of image
function good = checkGoodPerturbedBox(params,pVec,image)

% warp the box
pMtrx = warpVec2Mtrx(params,pVec);
W = params.ImW;
H = params.ImH;
ImBox = [-W/2,-W/2,W/2,W/2,-W/2;
         -H/2,H/2,H/2,-H/2,-H/2];
warpImBox = pMtrx*[ImBox;[1,1,1,1,1]];
warpImBox(1,:) = warpImBox(1,:)./warpImBox(3,:);
warpImBox(2,:) = warpImBox(2,:)./warpImBox(3,:);
warpImBox(3,:) = 1;
warpImageBox = params.Im2imageAffine*warpImBox;
% check if warped box still lies inside image
[imageH,imageW,~] = size(image);
fail = (warpImageBox(1,:)<1|warpImageBox(1,:)>imageW)|...
	   (warpImageBox(2,:)<1|warpImageBox(2,:)>imageH);
good = (sum(fail)==0);
