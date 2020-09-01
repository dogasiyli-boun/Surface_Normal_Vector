function [depthImFilled_gridFit, gridFitStruct] = fill0s_gridFit(imGrey, changeGivenValues)
% a = reshape(1:12,4,3);
% a(2,2) = 2000;
% a(3,3) = 0
% [a_gridFit, a_valsStruct] = fill0s_gridFit(a);


    %set all the values bigger than 1900 to 0
    imGrey(imGrey>1900) = 0;
    if ~exist('changeGivenValues','var') || isempty(changeGivenValues)
        %gridFit also changes the given values at points
        %if this is false thias algorithm will not change those values
        changeGivenValues = false;
    end
    
    %get the size of image
    [rowCount_y,colCount_x] = size(imGrey);
    [XColIndsMesh,YRowIndsMesh]=meshgrid(1:colCount_x,1:rowCount_y);
    zVals = imGrey(:);
    fullValuesInds = zVals>0;
    full_YR_Inds = double(YRowIndsMesh(fullValuesInds));
    full_XC_Inds = double(XColIndsMesh(fullValuesInds));
    full_ZD_Inds = double(zVals(fullValuesInds));
    
    all_YR_vectorized=1:rowCount_y;
    all_XC_vectorized=1:colCount_x;
    gz=gridfit(full_XC_Inds,full_YR_Inds,full_ZD_Inds,all_XC_vectorized,all_YR_vectorized);
    
    if changeGivenValues
        gz(fullValuesInds) = imGrey(fullValuesInds);
    end
    depthImFilled_gridFit = gz;%reshape(gz, size(imGrey));
    
    gridFitStruct = [];
    if nargout>1
        gridFitStruct = depthImTogridFitStruct(depthImFilled_gridFit);
    end
end