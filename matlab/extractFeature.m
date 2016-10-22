% Extract (feature) image
function feat = extractFeature(image,params)

switch(params.featType)
    case 'pixel',
        feat = image2Im(image,params);
    case 'LBP',
        feat = LBPimages(image,params);
    otherwise,
end

