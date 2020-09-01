% maxFaceNormTresh = 50;
% [faceNorms, fnd] = calcFaceNormsOfImage( cropImFilled, blockCnts, normCalcMethod, rejectPatchMethod, maxFaceNormTresh )
function [faceNorms, quiverMat, blockAreaSize, rgbImgAsFaceNorms] = calcFaceNormsOfImage( depthImg, blockCnts, optionalParamsStruct)
    
    normCalcMethod = getOptionalParamsFromStruct(optionalParamsStruct, 'normCalcMethod', 'haar-like', true);
    pixelGroupIDs = getOptionalParamsFromStruct(optionalParamsStruct, 'pixelGroupIDs', [], false);
    maxFaceNormTresh = getOptionalParamsFromStruct(optionalParamsStruct, 'maxFaceNormTresh', inf, true);
    rejectPatchMethod = getOptionalParamsFromStruct(optionalParamsStruct, 'rejectPatchMethod', 'none', true);
    removeFromDisplayTresh = getOptionalParamsFromStruct(optionalParamsStruct, 'removeFromDisplayTresh', []);
    rgbImgAsFaceNorms_figID = getOptionalParamsFromStruct(optionalParamsStruct, 'rgbImgAsFaceNorms_figID', []);
     
    %ignore the blocks with grpIDs==3
    %otherwise look at the block and do sth if the block has both grp 1 and 2
    [imRowCnt, imColCnt] = size(depthImg);
    
    %get the blocks given blockR, blockC and
    blockCnt_RowsY = blockCnts(1);
    blockCnt_ColsX = blockCnts(2);
    [blockBoundsMat, blockCnt] = getBlockBounds_forHOG(imColCnt, imRowCnt, blockCnt_ColsX, blockCnt_RowsY);
    
    faceNorms = zeros(blockCnt, 4);
    plotPoints = zeros(blockCnt, 3);
    for i = 1:blockCnt
        cbi = blockBoundsMat(i,:);
        img_curBlock = depthImg(cbi(1):cbi(2),cbi(3):cbi(4)); 
        if ~isempty(pixelGroupIDs)
            imageGroupIDPatch = pixelGroupIDs(cbi(1):cbi(2),cbi(3):cbi(4));
        else
            imageGroupIDPatch = [];
        end
        [normVector, normMagnitude] = calcFaceNormOfPatch(img_curBlock, normCalcMethod, rejectPatchMethod, imageGroupIDPatch);
        %calc x y and z direction for the plane normal
        faceNorms(i,:) = [normVector normMagnitude];
        plotPoints(i,1:2) = round([mean(cbi(1:2)) mean(cbi(3:4))]);
    end
    
    %NORMALIZE magnitudes of normals
    magVec = getMagnitudeVec(faceNorms, true, maxFaceNormTresh);
    
    fnd = bsxfun(@times, faceNorms(:,1:3), magVec);
    faceNorms(:,4) = magVec;
    blockAreaSize = size(img_curBlock);
    
    if ~isempty(removeFromDisplayTresh)
        mean3val = mean(abs(fnd(:,3)));
        dontDisplayRows = abs(fnd(:,3))<mean3val/removeFromDisplayTresh;
        fnd(dontDisplayRows,:) = 0;
    end    
    
    quiverMat = [plotPoints(:,[2 1 3]) fnd(:,[1 2 3])];
    rgbImgAsFaceNorms = getNormalsAsRGB(faceNorms, blockCnts, rgbImgAsFaceNorms_figID);
end

function magVec = getMagnitudeVec(faceNorms, normalizeVec, maxFaceNormTresh)
    magVec = faceNorms(:,4);
    if normalizeVec
        maxFaceNorm = max(magVec);
        if maxFaceNorm>maxFaceNormTresh
            maxFaceNorm = maxFaceNormTresh;
        end
        magVec = magVec./maxFaceNorm;
        magVec(magVec>1) = 1;
    end
end
