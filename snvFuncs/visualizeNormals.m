function [hMain,hSub] = visualizeNormals(cropImFilled, quiverMat, titleParams, OPS)

    if ~exist('OPS', 'var') || ~isstruct(OPS)
        OPS = [];
    end
    %struct('vwp', [0 90],'figVec', 1);
    vwp         = getStructField(OPS, 'vwp', [0 90]);
    figVec      = getStructField(OPS, 'figVec', 2);
    p_LineWidth = getStructField(OPS, 'p_LineWidth', 1);
    p_MarkerSize= getStructField(OPS, 'p_MarkerSize', 1);
    showColorBar= getStructField(OPS, 'showColorBar', true);
    
    if exist('titleParams','var') && isstruct(titleParams)
        blockCnts = titleParams.blockCnts;
        blockAreaSize = titleParams.blockAreaSize;
        rejectPatchMethod = titleParams.rejectPatchMethod;
        rejectStr = titleParams.rejectStr;
    end

    if length(figVec)>=4
        [hMain,hSub] = initiateFigure(figVec(1:4), [false true]);
    else
        [hMain,hSub] = initiateFigure(figVec(1), [true true]);
    end
    imagesc(cropImFilled);hold on;
    if showColorBar
        colorbar;
    end
    quiver3(quiverMat(:,1),quiverMat(:,2),quiverMat(:,3),quiverMat(:,4),quiverMat(:,5),quiverMat(:,6),...
        'LineWidth',p_LineWidth,'MarkerSize',p_MarkerSize,'Color',[1 0 0]);
    quiver3(quiverMat(:,1),quiverMat(:,2),quiverMat(:,3),quiverMat(:,4),quiverMat(:,5),-quiverMat(:,6),...
        'LineWidth',p_LineWidth,'MarkerSize',p_MarkerSize,'Color',[1 1 0]);
    view(vwp(1),vwp(2));
    if isstring(titleParams)
        title(titleParams);
    elseif length(figVec)>=3 && figVec(3)>2
        title({['B(' mat2str(blockCnts) ')-bA(' mat2str(blockAreaSize) ')'], rejectPatchMethod});
        set(gca,'XTick',[]);
        set(gca,'YTick',[]);            
    elseif isstruct(titleParams)
        title({['HandNorms-Blck(' mat2str(blockCnts) ')-blockArea(' mat2str(blockAreaSize) ')'], rejectStr});
        xlabel('X-Left1-Right61');ylabel('Y-Top1Bottom61');zlabel('Z-minPlus-maxMinus');
    else
        set(gca,'XTick',[]);
        set(gca,'YTick',[]);
    end
end