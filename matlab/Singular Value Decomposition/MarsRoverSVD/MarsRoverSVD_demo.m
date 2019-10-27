% Problem to be solved:
% Use the SVD to compute a compressed version of the image arizona_photo.jpg 
% provided. Experiment with using 10, 50, 100, and 200 singular vectors to 
% represent the image. Comment on the quality of the resulting image, and 
% compute how many numbers are needed to represent the image in each case.
% Note: in Matlab, you can use the command im = rgb2gray(im2double(imread('photo.jpg')));
% to load the image, convert it to grayscale, and store it into a matrix 
% of double precision floating point numbers. You can display the image 
% using the command imshow.
% 
% Solution:                                                             
% This MATLAB script loads the supplied data, and performs an SVD on the 
% image and then plots the results for various singular values.                 


% Start of script
%-------------------------------------------------------------------------%
close all;                   	% close all figures
clearvars; clearvars -global;	% clear all variables
clc;                         	% clear the command terminal
format shortG;                 	% pick the most compact numeric display
format compact;                	% suppress excess blank lines


% Load the data & plot
%-------------------------------------------------------------------------%

% open and plot the original image
im = im2double(imread('arizona_photo.jpg'));
figure(1);
imshow(im);
% compute total values needed to represent the image
[m,n] = size(im);
totalVals = m*n*2+n;
% add the title
title(sprintf('Original full-color image. Total values needed = %1.0f',totalVals));

% convert the image to a grey-scale image
im = rgb2gray(im2double(imread('arizona_photo.jpg')));
figure(2);
imshow(im);
% compute total values needed to represent the image
[m,n] = size(im);
totalVals = m*n*2+n;
% add the title
title(sprintf('Original grey-scale image. Total values needed = %1.0f',totalVals));

% Using n singular values:
vals = [200,100,50,10];

% try for 200, 100, 50, and 10 singular values:
for ii = 1:length(vals)
    % set the number of singular values
    n = vals(ii);

    % compute the SVD
    [U,S,V] = svd(im);
    
    % select only the number of singular values
    U_vals = U(:,1:n);
    V_vals = V(:,1:n);
    S_vals = S(1:n,1:n);
    
    % re-compute the "compressed" image
    A_vals = U_vals*S_vals*V_vals';
    
    % compute total values needed to represent the image
    totalVals = m*n*2+n;
    
    % plot the compressed image
    figure(ii+2);
    imshow(A_vals);
    title(sprintf('Grey-scale image using %1.0f singular values. Total values needed = %1.0f',n,totalVals));
end

dock_all_figures;