function [ d_pixel ] = calcRMSE( fixedPoints, movingPoints, rotMat, ...
    shift_pixel )
%calcRMSE Calculates the Root Mean Square Error
rows = size(fixedPoints, 1);
adjustPoints = (rotMat * movingPoints')' + repmat(shift_pixel', rows, 1);

RSE = sqrt( (fixedPoints - adjustPoints).^2 );
d_pixel = mean(RSE(:));

end

