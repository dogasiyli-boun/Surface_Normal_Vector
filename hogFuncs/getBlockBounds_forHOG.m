function [blockBoundsMat, blockCnt, hogVecBounds] = getBlockBounds_forHOG(imColCnt, imRowCnt, blockCnt_ColsX, blockCnt_RowsY, binCnt)
    step_cxj=floor(imColCnt/(blockCnt_ColsX+1));
    step_ryi=floor(imRowCnt/(blockCnt_RowsY+1));
    cxSt = floor(linspace(1,(imColCnt-2*step_cxj),blockCnt_ColsX));%1:step_cxj:(imColCnt-2*step_cxj);
    rySt = floor(linspace(1,(imRowCnt-2*step_ryi),blockCnt_ColsX));%1:step_ryi:(imRowCnt-2*step_ryi);
    [rStInds, cStInds] = meshgrid(1:blockCnt_RowsY, 1:blockCnt_ColsX);
    rySt = rySt(rStInds(:));
    cxSt = cxSt(cStInds(:));
    blockBoundsMat = [rySt', rySt'+2*step_ryi-1, cxSt', cxSt'+2*step_cxj-1];
    blockCnt = blockCnt_ColsX*blockCnt_RowsY;
    
    if nargout>2
        hogVecBounds = [(0:blockCnt-1)*binCnt+1;(1:blockCnt)*binCnt]';
    end
    %hogVecBounds = (1:B:B*blockCnt)';
    %hogVecBounds = [hogVecBounds,hogVecBounds+B-1];
end