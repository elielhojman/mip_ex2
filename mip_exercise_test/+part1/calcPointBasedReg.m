function [ rotMat, shift_pixel ] = calcPointBasedReg( fixedPoints, movingPoints )

rows = size(fixedPoints,1);
%calcPointBasedReg Returns rotation matrix and shift vector
pHat = mean(movingPoints);
qHat = mean(fixedPoints);

% centered vectors
X = movingPoints - repmat(pHat, rows, 1);
Y = fixedPoints - repmat(pHat, rows, 1);

% Covariance matrix
Cov = X' * Y;
[U, S, V] = svd(Cov);
R = V * diag([1 det(V*U')]) * U';

t = qHat' - R * pHat';

rotMat = R;
shift_pixel = t;
end

