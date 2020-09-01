function [normVector, normMagnitude] = calcFaceNormOfPatch(imagePatch, normCalcMethod, rejectPatchMethod, imageGroupIDPatch)
    if ~exist('normCalcMethod','var') || isempty(normCalcMethod)
        normCalcMethod = 'haar-like';
    end
    if ~isempty(imageGroupIDPatch)
        uniqGrpIDs = unique(imageGroupIDPatch(:));
    end
    normMagnitude = -1;
    switch rejectPatchMethod
        case 'notIncludeHand'
            if isempty(find(uniqGrpIDs==1, 1))
                normMagnitude = 0;
                normVector = [0 0 0];
            end
        case 'includeBackground'
            if ~isempty(find(uniqGrpIDs==3, 1))
                normMagnitude = 0;
                normVector = [0 0 0];
            end
        otherwise
    end
    if normMagnitude==-1
        switch normCalcMethod
            case 'eigenVec'
                [normVector,normMagnitude] = calcNormOfPatch_berk(img_curBlock);
            %case 'haar-like'
            otherwise
                [normVector,normMagnitude] = calcNormOfPatch_ah(imagePatch);
        end
    end
end

function [curVecNormed,curVecNorm] = calcNormOfPatch_ah(img_curBlock)
    [rr,cc] = size(img_curBlock);
    %imagine dividing the block into 4 and 9 parts
    meanLeft = mean(mean(img_curBlock(:,1:round(cc/2))));
    meanRight = mean(mean(img_curBlock(:,round(cc/2):end)));
    meanTop = mean(mean(img_curBlock(1:round(rr/2),:)));
    meanBottom = mean(mean(img_curBlock(round(rr/2):end,:)));
    meanCenter = mean(mean(img_curBlock(round(rr/4):round(3*rr/4),round(cc/4):round(3*cc/4))));
    meanAll = mean(img_curBlock(:));
    x = meanLeft-meanRight;
    y = meanTop-meanBottom;
    z = meanCenter-meanAll;
    curVec = [x y z];
    curVecNorm = norm(curVec);
    curVecNormed = curVec/(curVecNorm+0.01);
end

function [curVecNormed,curVecNorm] = calcNormOfPatch_berk(img_curBlock)
    %calculate every vector from boundaries to center?
    %[rr,cc] = size(img_curBlock);
    gridFitStruct = depthImTogridFitStruct(img_curBlock);
    [XColIndsMesh,YRowIndsMesh]=meshgrid(gridFitStruct.x,gridFitStruct.y);
    
    xVecs = mean(XColIndsMesh(:)) - XColIndsMesh(:);
    yVecs = mean(YRowIndsMesh(:)) - YRowIndsMesh(:);
    zVecs = mean(gridFitStruct.z(:)) - gridFitStruct.z(:);
    
    xVecs = map2_a_b(xVecs, -1, +1);
    yVecs = map2_a_b(yVecs, -1, +1);
    zVecs = map2_a_b(zVecs, -1, +1);
    
    np = [xVecs yVecs zVecs];
    
    %LINE01
    mvector  = mean(np,1); % find mean vector
    
    %LINE02
    %npdiff = np - repmat(mvector,size(np,1),1); % subtract mean vector
    npdiff = bsxfun(@minus, np, mvector); % subtract mean vector
    
    %LINE03
    S = npdiff' * npdiff; % compute eigenvectors and eigenvalues
    
    [EVECS,EVALS] = eig(S);
    V = fliplr(EVECS);
    curVecNormed = V(:,3)'; % pick surface normal
    assert(abs(1-curVecNormed*curVecNormed')<0.01,'not a normal vec?');
    
    littleOnes = gridFitStruct.z(:)<median(gridFitStruct.z(:));
    curVecNorm = mean(gridFitStruct.z(littleOnes==0))-mean(gridFitStruct.z(littleOnes==1));%sum(npdiff(:,3));
end

