im1 = imread('data/brain1.tif');
im2 = imread('data/brain2.tif');

%im1 = rgb2gray(im1);
%im2 = rgb2gray(im2);
%[fp, mp] = part1.getPoints()

fp = [ 

  351.0000  821.0000
   76.0000  515.0000
   49.0000  438.0000
  106.0000  544.0000
  403.0000   71.0000
  358.0000   54.0000
  744.0000  327.0000
  631.0000  283.0000
  219.0000  363.0000
  412.0000  346.0000
  ];
% 
% 
mp = [

  148.0000  134.0000
  559.0000  141.0000
  627.0000  179.0000
  514.0000  148.0000
  653.0000  690.0000
  689.0000  670.0000
  229.0000  759.0000
  338.0000  708.0000
  565.0000  358.0000
  445.0000  509.0000
  
  ];

[ R, t ] = part1.calcPointBasedReg( fp, mp );
part1.calcRMSE(fp, mp, R, t)

T = zeros(3,3);
T(1:2,1:2) = R2;
T(3,3) = 1;
tform = affine2d(T);
im2Rot = imwarp(im2, tform);
rim1 = imref2d(size(im1));
rim2Rot = imref2d(size(im2Rot), [-1167 0], [-546 623]);
% figure()
% imshowpair(zeros(size(im1)), rim1, im2Rot, rim2Rot);
% 
% figure()
% imshowpair(im1, rim1, zeros(size(im2Rot)), rim2Rot);
rim2Rot.XWorldLimits = rim2Rot.XWorldLimits + t(2);
rim2Rot.YWorldLimits = rim2Rot.YWorldLimits + t(1);
figure()
edges = edge(rgb2gray(im1),'canny');
imshowpair(edges, rim1, im2Rot, rim2Rot, 'blend');
rim2 = imref2d(size(im2));
% imshow(im2, rim2);
