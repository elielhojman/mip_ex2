function [ fixedPoints, movingPoints ] = getPoints( )
%getPoints Selects points using cpselect from the brain images
brain1img = imread('data/brain1.tif');
brain2img = imread('data/brain2.tif');
% cpselect(moving, fixed)
[fixedPoints, movingPoints ] = cpselect(brain2img, brain1img, 'Wait', true);
end

