function [hMain,hSub] = initiateFigure(figVec, clearFirst, subPlotAreaVec)
%initiateFigure start drawing a figure
%   figVec can be of length 1 or 4
%   if 1 -> main figure
%   if 3 -> subplot with subPlotVec
%   if 4 -> subplot
%   clearFirst can be eiter length 1 or 2
%   opt1 -> clearFirst = true --> clf;
%   opt2 -> clearFirst = [false, true] --> cla(h);
    if isempty(figVec)
        return
    end
    hMain = figure(figVec(1));
    hSub = [];
    if length(figVec)>=3
        if length(figVec)==3
            assert(1==exist('subPlotAreaVec','var'),'You must pass subPlotAreaVec as parameter');
        else
            subPlotAreaVec = figVec(4);
        end
        hSub = subplot(figVec(2),figVec(3),subPlotAreaVec);
        if length(clearFirst)==2
            if clearFirst(1)
                clf;
            elseif clearFirst(2)
                cla(hSub);
            end
        elseif clearFirst
            cla(hSub);
        end
    else
        if clearFirst
            clf;
        end        
    end
end

