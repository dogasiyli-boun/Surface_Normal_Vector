function cropArea = getCropArea(skeleton, frameID, optParamStruct)
%getCropArea According to skeleton information get the area information to
%be cropped
%   Kinect gives us left hand as right and right hand as left,
%   we can scale our calculations depending on the distance of Neck and
%   Head positions given 1 single frame
%
%   optParamStruct_cropArea = struct('colDepStr', 'color','multipliers', struct('bigHandFaceRatio',[1,1],'smlHandFaceRatio',[2/3,2/3]));
   
    if ~exist('optParamStruct','var')
        optParamStruct = [];
    end
    colDepStr = getStructField(optParamStruct, 'colDepStr', 'color');
    multipliers = getStructField(optParamStruct, 'multipliers', struct('bigHandFaceRatio',[1,1],'smlHandFaceRatio',[2/3,2/3]));

    frCnt = size(skeleton.Head,1);
    if nargin>1 && ~isempty(frameID) && length(frameID) == 1
        cropArea = getCropArea_Single(skeleton, frameID, colDepStr, multipliers);
    else%if nargin==1
        cropArea = struct;% 1_from_row_y, 2_from_col_x, 3_height_row_y, 4_width_col_x
        cropArea.LH_big = zeros(frCnt,4);
        cropArea.LH_sml = zeros(frCnt,4);
        cropArea.RH_big = zeros(frCnt,4);
        cropArea.RH_sml = zeros(frCnt,4);
        cropArea.BH_big = zeros(frCnt,4);
        cropArea.BH_sml = zeros(frCnt,4);
        cropArea.FC_big = zeros(frCnt,4);
        cropArea.TS_big = zeros(frCnt,4);
        for i=1:frCnt
            cropArea_cur = getCropArea_Single(skeleton, i, colDepStr, multipliers);
            cropArea.LH_big(i,:) = cropArea_cur(1,:);
            cropArea.RH_big(i,:) = cropArea_cur(2,:);
            cropArea.BH_big(i,:) = cropArea_cur(3,:);
            cropArea.FC_big(i,:) = cropArea_cur(4,:);
            cropArea.LH_sml(i,:) = cropArea_cur(5,:);
            cropArea.RH_sml(i,:) = cropArea_cur(6,:);
            cropArea.BH_sml(i,:) = cropArea_cur(7,:);
            cropArea.TS_big(i,:) = cropArea_cur(8,:);
        end
    end    
end

function cropArea = getCropArea_Single(skeleton, frameID, colDepStr, multipliers)
    %'bigHandFaceRatio',[height_y_row_ratio,width_x_col_ratio]
    %multipliers = struct('bigHandFaceRatio',[1,1],'smlHandFaceRatio',[2/3,2/3])
    if strcmpi(colDepStr,'color')
        si = [8 9];%Skeleton Inds of color frame
    else
        si = [10 11];%Skeleton Inds of depth frame
    end

    curHeadSize = 2*max(abs(skeleton.Head(frameID,si(1))-skeleton.Neck(frameID,si(1))),abs(skeleton.Head(frameID,si(2))-skeleton.Neck(frameID,si(2))));
    
    szBig = curHeadSize.*multipliers.bigHandFaceRatio;%[height_y_row_length,width_x_col_length]
    szSml = curHeadSize.*multipliers.smlHandFaceRatio;%(2/3) - %kafanin 3'te 2 büyüklügü alabilmek için
    
    chs2 = curHeadSize/2;%merkezden yar?m geri gidip, tam kafa kadar almak için
    pushBig = szBig./2;%push from center for finding start [height_y_row_length,width_x_col_length]
    pushSmall = szSml./2;%el merkezinden 3'te bir geri gidip
    
    %Left Hand
    cropArea(1,:) = [skeleton.HandRight(frameID,si(1):si(2))-[pushBig(1) pushBig(2)], [szBig(1) szBig(2)]];%left hand big
    cropArea(2,:) = [skeleton.HandLeft( frameID,si(1):si(2))-[pushBig(1) pushBig(2)], [szBig(1) szBig(2)]];%right hand big
    cropArea(4,:) = [skeleton.Head(     frameID,si(1):si(2))-[chs2 chs2], [curHeadSize curHeadSize]];%face
    cropArea(5,:) = [skeleton.HandRight(frameID,si(1):si(2))-[pushSmall(1) pushSmall(2)], [szSml(1) szSml(2)]];%left hand small
    cropArea(6,:) = [skeleton.HandLeft( frameID,si(1):si(2))-[pushSmall(1) pushSmall(2)], [szSml(1) szSml(2)]];%right hand small
    
    %BOTH HANDS
    %big
    cropArea(3,:) = [min(cropArea(1:2,1)) min(cropArea(1:2,2)) max(cropArea(1:2,1)+cropArea(1:2,3))-min(cropArea(1:2,1)) max(cropArea(1:2,2)+cropArea(1:2,4))-min(cropArea(1:2,2))];%both hands - big
    %small
    cropArea(7,:) = [min(cropArea(5:6,1)) min(cropArea(5:6,2)) max(cropArea(5:6,1)+cropArea(5:6,3))-min(cropArea(5:6,1)) max(cropArea(5:6,2)+cropArea(5:6,4))-min(cropArea(5:6,2))];%both hands - small    
    
    %TORSO big
    %big
    cropArea(8,:) = [min(cropArea(1:4,1)) min(cropArea(1:4,2)) max(cropArea(1:4,1)+cropArea(1:4,3))-min(cropArea(1:4,1)) max(cropArea(1:4,2)+cropArea(1:4,4))-min(cropArea(1:4,2))];%torso - big
    
    %make integer
    cropArea(:,[1 2]) = ceil(cropArea(:,[1 2]));
    cropArea(:,[3 4]) = floor(cropArea(:,[3 4]));
end

% head_row_X = skeleton.Head(:,si(1));
% head_col_Y = skeleton.Head(:,si(2));
% neck_row_X = skeleton.Neck(:,si(1));
% neck_col_Y = skeleton.Neck(:,si(2));
% meanHeadSize = round(2*max(mean(abs(head_row_X-neck_row_X)),mean(abs(head_col_Y-neck_col_Y))));