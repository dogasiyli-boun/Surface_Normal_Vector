clear all
load('sample_data.mat')

signID = 222;
imID = 51;
blockCounts = [20 20];

depthIm = depth(:,:,imID);
depthIm(depthIm>1900) = 1900;   
cropArea = getCropArea(skeleton,imID,struct('colDepStr', 'depth'));

im_lh = cropBodyPart(depthIm, cropArea(1,1:2), cropArea(1,3:4));%LH_big
im_rh = cropBodyPart(depthIm, cropArea(2,1:2), cropArea(2,3:4));%RH_big
im_bh = cropBodyPart(depthIm, cropArea(3,1:2), cropArea(3,3:4));%BH_big
%imRGB_lh
%imRGB_rh
%imRGB_bh

OPS = struct('rejectPatchMethod','notIncludeHand', 'rgbImgAsFaceNorms_figID', 1);

im_lh = fill0s_gridFit(im_lh, true);
[~, OPS.pixelGroupIDs] = setRGBKmeans(im_lh);
[faceNormCells, quiverMatCells, blockAreaSizeCells, rgbImgAsFaceNormCells] = calcFaceNormsOfImage(im_lh, blockCounts, OPS);
subplot(3,2,6);
%imshow(imRGB_lh);title('source_{cropImFilled}');
imagesc(im_lh);colorbar;title('source_{cropImFilled}');
faceNormCells = faceNormCells(:);

visualizeNormals(im_lh, quiverMatCells, 'SNV_Visualized', []);