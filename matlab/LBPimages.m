% Extract LBP feature
function LBP = LBPimages(image,params)

image = imfilter(image,params.LBP_gaussianKernel);
LBPimage = zeros(size(image,1),size(image,2),8);
c = params.LBP_compareDist;
LBPimage(1+c:end-c,1+c:end-c,1) = image(1+c:end-c,1+c:end-c)>image(1:end-c*2,1:end-c*2);
LBPimage(1+c:end-c,1+c:end-c,2) = image(1+c:end-c,1+c:end-c)>image(1:end-c*2,1+c:end-c);
LBPimage(1+c:end-c,1+c:end-c,3) = image(1+c:end-c,1+c:end-c)>image(1:end-c*2,1+c*2:end);
LBPimage(1+c:end-c,1+c:end-c,4) = image(1+c:end-c,1+c:end-c)>image(1+c:end-c,1+c*2:end);
LBPimage(1+c:end-c,1+c:end-c,5) = image(1+c:end-c,1+c:end-c)>image(1+c*2:end,1+c*2:end);
LBPimage(1+c:end-c,1+c:end-c,6) = image(1+c:end-c,1+c:end-c)>image(1+c*2:end,1+c:end-c);
LBPimage(1+c:end-c,1+c:end-c,7) = image(1+c:end-c,1+c:end-c)>image(1+c*2:end,1:end-c*2);
LBPimage(1+c:end-c,1+c:end-c,8) = image(1+c:end-c,1+c:end-c)>image(1+c:end-c,1:end-c*2);
LBP = image2Im(LBPimage,params);
