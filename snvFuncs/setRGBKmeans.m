function [imColor, grpIDs, grpMedian, imVals, groupBegEnds] = setRGBKmeans(imGrey)
    imGrey = double(imGrey);
    [rc,cc] = size(imGrey);
    X1 = double([min(imGrey(:)) median(imGrey(:)) max(imGrey(:))]);
    
    groupBegEnds = zeros(3,2);
    
    %histBins = X(1):30:X(3);
    %histVals = hist(imGrey(:),histBins);

    %we can either define 3 mixture of gaussians or 2
    %if we can fit 3 MoG then min is hand, mean is body and max is
    %background
    
    [imVals, ~] = sort(imGrey(:));
    [peakVal01, peakInds01] = max(imVals(2:end)-imVals(1:end-1));
    if peakInds01==1
        peakInds01 = floor(length(imVals)/2);
    end
    %figure(1624);clf;
    %subplot(2,1,1);
    %plot(imVals);hold on;
    groupBegEnds(3,1) =  imVals(peakInds01+1);
    groupBegEnds(3,2) =  imVals(end);
    
    imVals(peakInds01:end) = [];
    groupBegEnds(1,1) = min(imVals);
    groupBegEnds(1,2) = median(imVals)-1;
    groupBegEnds(2,1) = median(imVals);    
    groupBegEnds(2,2) = max(imVals);
    
    X2 = double([groupBegEnds(1,1) groupBegEnds(2,2) groupBegEnds(3,1)]);
    grpIDs = 2*ones(size(imGrey(:)));
    grpIDs(imGrey(:)<groupBegEnds(1,2)) = 1;
    grpIDs(imGrey(:)>groupBegEnds(2,2)) = 3;

    %grpIDs = abs(bsxfun(@minus, imGrey(:), X));
    %[~, grpIDs] = min(grpIDs,[],2);
    
    %now the group with smallest mean will be set to red
    %middle will be set to green
    %furthest will be set to blue
    meanGrps = [mean(imGrey(grpIDs==1)) mean(imGrey(grpIDs==2)) mean(imGrey(grpIDs==3))];
    [~,idx] = sort(meanGrps);

    imColor = zeros(rc,cc,3);
    grpMedian = zeros(1,3);
    for i=1:3
       imColor(:,:,i) = double(reshape(grpIDs,rc,cc)==idx(i)); 
       grpMedian(idx(i)) = median(imGrey(grpIDs==idx(i)));
    end
    grpIDs = reSetLabels(grpIDs, 1:3, idx);
    grpMedian = grpMedian(idx);
    grpIDs = reshape(grpIDs,[rc,cc]);
end