function [nId, nDist] = kNearestNeighbors(data, query, k)
% Program to find the k - nearest neighbors (kNN) within a set of points. 
% Distance metric used: Euclidean distance.
%
% Syntax: 
%  [nId, nDist] = kNearestNeighbors(data, query, k)
%
% Parameters:
%   data:       N x D - N vectors with dimensionality D (within which we 
%               search for the nearest neighbors)
%   query:      M x D - M query vectors with dimensionality D
%   k:          1 x 1 - Number of nearest neighbors desired
%
% Return values:
%   nId:        neighbor IDs
%   nDist:      neighbor distances
% 
% Example:
%   a = [1 1; 2 2; 3 2; 4 4; 5 6];
%   b = [1 1; 2 1; 6 2];
%   [neighbors distances] = kNearestNeighbors(a,b,2);
% 
%   Output:
%   neighbors =
%      1     2
%      1     2
%      4     3
% 
%   distances =
%          0    1.4142
%     1.0000    1.0000
%     2.8284    3.0000
% 
% Reference:
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%



% calculations
%-------------------------------------------------------------------------%
nId = zeros(size(query,1),k);
nDist = nId;

numDataVectors = size(data,1);
numQueryVectors = size(query,1);
for i=1:numQueryVectors,
    dist = sum((repmat(query(i,:),numDataVectors,1)-data).^2,2);
    [sortval sortpos] = sort(dist,'ascend');
    
    % neighbor IDs
    nId(i,:) = sortpos(1:k);
    
    % neighbor Distances
    nDist(i,:) = sqrt(sortval(1:k));
end