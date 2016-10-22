% Read 1 image and landmark
function image = read1file(imFname)

image = imread(imFname);
image = double(rgb2gray(image));
