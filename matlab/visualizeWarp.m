% Visualize the image with the warped box and ground truth
function warpHandle = visualizeWarp(image,pVec,params,warpHandle)

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
warpImageBox(3,:) = [];
imageBox = params.Im2imageAffine*[ImBox;[1,1,1,1,1]];
imageBox(3,:) = [];
% plot the box
if(isempty(warpHandle))
    % create new plot
    figure(1),imshow(uint8(image)); hold on;
    plot(imageBox(1,:),imageBox(2,:),'color',[1,0.3,0.3],'linewidth',2);
    warpHandle = plot(warpImageBox(1,:),warpImageBox(2,:),'color',[0.3,1,0.3],'linewidth',2);
else
    % just update the warped box
    set(warpHandle,'XData',warpImageBox(1,:));
    set(warpHandle,'YData',warpImageBox(2,:));
end
