function [ output_args ] = showRegistration( )
%showRegistration Show the registration calculated between images

im1 = imread('data/brain1.tif');
im2 = imread('data/brain2.tif');

% [fp, mp] = part1.getPoints()
fp = [ 
  351  821
   76  515
   49  438
  106  544
  403   71
  358   54
  744  327
  631  283
  219  363
  412  346
  ];

mp = [
  148  134
  559  141
  627  179
  514  148
  653  690
  689  670
  229  759
  338  708
  565  358
  445  509
  ];

[ R, t ] = part1.calcPointBasedReg( fp, mp )
theta = 0;
T = zeros(3,3);
T(1:2,1:2) = R;
T(3,1:2) = t;
T(3,3) = 1;
tform = affine2d(T);
im2Rot = imwarp(im2, tform);
figure()
imshowpair(im1, im2Rot);


%imshowpair(im1Rot, im2);

end

% fp = [ 
% 
%   351.0000  821.0000
%    76.0000  515.0000
%    49.0000  438.0000
%   106.0000  544.0000
%   403.0000   71.0000
%   358.0000   54.0000
%   744.0000  327.0000
%   631.0000  283.0000
%   219.0000  363.0000
%   412.0000  346.0000
%   ]
% % 
% % 
% mp = [
% 
%   148.0000  134.0000
%   559.0000  141.0000
%   627.0000  179.0000
%   514.0000  148.0000
%   653.0000  690.0000
%   689.0000  670.0000
%   229.0000  759.0000
%   338.0000  708.0000
%   565.0000  358.0000
%   445.0000  509.0000
%   
%   ]