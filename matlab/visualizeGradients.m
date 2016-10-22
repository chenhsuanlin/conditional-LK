% Transform R back to gradients and visualize
function visualizeGradients(R,range)

H = 50;
W = 50;
Gdxdp = pinv(R(:,1:end-1));
p = size(R,1);
switch(p)
    case 2, % translation
        gx = Gdxdp(:,1);
        gy = Gdxdp(:,2);
    case 6, % affine
        gx = Gdxdp(:,5);
        gy = Gdxdp(:,6);
    case 8, % homography
        gx = Gdxdp(:,3);
        gy = Gdxdp(:,6);
end
gImgX = reshape(gx,H,W,[]);
gImgY = reshape(gy,H,W,[]);
gImgXstack = permute(gImgX,[1,2,4,3]);
gImgYstack = permute(gImgY,[1,2,4,3]);
addpath('..');
warning('off');
figure(5),imdisp(gImgXstack,[-range,range],'border',0.03);
figure(6),imdisp(gImgYstack,[-range,range],'border',0.03);
warning('on');


