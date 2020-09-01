function rgbImgAsFaceNorms = getNormalsAsRGB(faceNorms, blockCnts, figID)
    magDisp = reshape(faceNorms(:,4), blockCnts)';
    rgbImgAsFaceNorms = zeros(blockCnts(1),blockCnts(2),3);
    rgbImgAsFaceNorms(:,:,1) = reshape(faceNorms(:,1), blockCnts)';
    rgbImgAsFaceNorms(:,:,2) = reshape(faceNorms(:,2), blockCnts)';
    rgbImgAsFaceNorms(:,:,3) = magDisp;
    rgbImgAsFaceNorms = (rgbImgAsFaceNorms + 1)/2;
    if isempty(figID)
        return
    end
    try %#ok<TRYNC> - 
        initiateFigure(figID, true);
        subplot(3,2,1);
        imagesc(reshape(faceNorms(:,1), blockCnts)');colorbar;title('x(Red Channel)');
        subplot(3,2,2);
        imagesc(reshape(faceNorms(:,2), blockCnts)');colorbar;title('y(Green Channel)');
        subplot(3,2,3);
        imagesc(reshape(faceNorms(:,3), blockCnts)');colorbar;title('z');
        subplot(3,2,4);
        imagesc(magDisp);colorbar;title('magnitude(Blue Channel)');
        subplot(3,2,5);
        image(rgbImgAsFaceNorms);title('rgbImgAsFaceNorms');
        subplot(3,2,6);
        imagesc(cropImFilled);colorbar;title('source_{cropImFilled}');
    end
end