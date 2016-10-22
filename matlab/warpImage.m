% Retrieve the current warped image
function imageWarp = warpImage(image,pVec,params)

image = double(rgb2gray(image));
pMtrx = warpVec2Mtrx(params,pVec);
% map to Im coordinate, perform warp, then map back to image coordinate
% forward warping the box --> inverse warping the image
transMtrx = params.Im2imageAffine...
           *(pMtrx...
           \params.image2ImAffine);
% apply warp to image
tform = projective2d(transMtrx');
imageWarp = imwarp(image,tform,'cubic','outputview',params.imref2d);

