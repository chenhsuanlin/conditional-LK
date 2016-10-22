% Gets the appearance from the original image
function Im = image2Im(image,params)

boxGT = params.boxGT;
imageBbox = image(boxGT(2):boxGT(4),boxGT(1):boxGT(3),:);
Im = imresize(imageBbox,[params.ImW,params.ImH]);
