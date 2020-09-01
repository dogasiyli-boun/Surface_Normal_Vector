function skeletonMat = processSkeletonMat(skeleton)
    cols2slct = [1 2 3 8 9 10 11];
    frameLen = size(skeleton.AnkleLeft,1);
    featLenPerJoint = length(cols2slct);
    skeletonMat = zeros(frameLen, featLenPerJoint*16);
    for f = 1:frameLen
        skeletonMat(f,:) = getSkeletonVec(skeleton, cols2slct, f);
    end
    skeletonMat = reshape(skeletonMat, [], featLenPerJoint);
    skeletonMat = reshape(skeletonMat, [], featLenPerJoint*16);
end

function skelVec = getSkeletonVec(skeleton, cols2slct, frameID)
    skelVec = [...
     skeleton.SpineBase(frameID,cols2slct);skeleton.SpineMid(frameID,cols2slct);...
     skeleton.Neck(frameID,cols2slct);skeleton.Head(frameID,cols2slct);...
     skeleton.ShoulderLeft(frameID,cols2slct);skeleton.ElbowLeft(frameID,cols2slct);skeleton.WristLeft(frameID,cols2slct);skeleton.HandLeft(frameID,cols2slct);skeleton.HandTipLeft(frameID,cols2slct);...
     skeleton.ShoulderRight(frameID,cols2slct);skeleton.ElbowRight(frameID,cols2slct);skeleton.WristRight(frameID,cols2slct);skeleton.HandRight(frameID,cols2slct);skeleton.HandTipRight(frameID,cols2slct); ...
     skeleton.HipLeft(frameID,cols2slct);skeleton.HipRight(frameID,cols2slct)...
    ];
    minBB = min(skelVec);
    maxBB = max(skelVec);
    lenBB = maxBB-minBB;
    skelVec = skelVec-minBB;
    skelVec = skelVec./lenBB;
    skelVec = 2*(0.5-skelVec);
    skelVec = skelVec(:)';
end