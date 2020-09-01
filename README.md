# Surface_Normal_Vector
Surface Normal Vector (SNV) feature extraction and display functions.

Before running "run_SNV.m" you should add the other folders to path.

When running "run_SNV.m" the necessary source files are loaded from sample_data.mat:
- blockCounts: The bigger block counts as in HOG calculation
- depth: A sample depth frame to work on, acquired from Microsoft Kinect V2
- depthIm: selected frame (frameID=51) from signed sentence 222, usrID=2, repetitionID=2 of HospiSign Dataset
- im_bh: cropped image of both hands for the related frame
- im_lh: cropped image of left hand for the related frame
- im_rh: cropped image of right hand for the related frame
- skeleton: skeleton struct provided by Microsoft Kinect V2 

Then it calculates the SNV for left cropped hand and visualizes it in 2 seperate figures.

# Skeleton Feature Calculation
To calculate the 112 dimensional skeleton feature used in HospiSign Dataset run;
skeletonMat = processSkeletonMat(skeleton);

which takes input "skeleton" that Microsoft Kinect V2 provides
and outputs N frames by 112 dimensional features
