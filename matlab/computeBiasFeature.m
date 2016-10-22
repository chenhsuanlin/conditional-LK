% Precompute bias feature
function featGTvec = computeBiasFeature(imageAll,params)

fprintf('precomputing bias feature... \n');
featGTall = zeros(params.featDim,params.imageN);
for i = 1:params.imageN
    % read one image
    image = double(rgb2gray(imageAll{i}));
    featGT = extractFeature(image,params);
    featGTall(:,i) = featGT(:);
end
featGTvec = mean(featGTall,2);
