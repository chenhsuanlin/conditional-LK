% Load images for each frame
function [imlst,lmlst] = getFileLists(path,seq)

% read image filelist
fid = fopen([path,'/',seq,'_imlst.txt'],'r');
imlstCell = textscan(fid,'%s');
imlst = imlstCell{1};
fclose(fid);
% read landmark filelist
fid = fopen([path,'/',seq,'_lmlst.txt'],'r');
lmlstCell = textscan(fid,'%s');
lmlst = lmlstCell{1};
fclose(fid);

