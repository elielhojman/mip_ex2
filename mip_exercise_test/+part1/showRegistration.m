function [ output_args ] = showRegistration( )
%showRegistration Show the registration calculated between images

im1 = imread('data/brain1.tif');
im2 = imread('data/brain2.tif');

%[fp, mp] = part1.getPoints()

fp = [

  817.2500  351.2500
  515.7500   71.2500
  434.7500   47.7500
   66.2500  400.7500
   52.7500  360.7500
  324.7500  743.7500
  345.7500  411.2500
  658.7500  200.7500
  607.7500  538.7500
  283.2500  631.7500
];

mp = [
  136.2500  148.7500
  136.7500  561.2500
  178.2500  630.2500
  689.2500  653.7500
  668.7500  689.2500
  755.7500  230.2500
  507.2500  445.2500
  136.7500  365.2500
  415.7500  168.7500
  709.2500  338.7500
 ]; 

[ R, t ] = part1.calcPointBasedReg( fp, mp );

% Create rotated image
T = zeros(3,3);
T(1:2,1:2) = R;
T(3,3) = 1;
tform = affine2d(T);
im2Rot = imwarp(im2, tform);

% Assigning referce coordinates
rim1 = imref2d(size(im1));
[yLength, xLength, ~] = size(im1);
vertices = [ 0 0; 0 xLength; yLength xLength; yLength 0];
verticesR = (R * vertices')';
maxV = max(verticesR);
minV = min(verticesR);
rim2Rot = imref2d(size(im2Rot),[minV(2) maxV(2)],[minV(1) maxV(1)]);

% Doing the translation
rim2Rot.XWorldLimits = rim2Rot.XWorldLimits + t(2);
rim2Rot.YWorldLimits = rim2Rot.YWorldLimits + t(1);

figure()
edges = edge(rgb2gray(im1),'canny');
imshowpair(edges, rim1, im2Rot, rim2Rot, 'blend');

figure()
imshowpair(im1, rim1, im2Rot, rim2Rot, 'blend');

end

