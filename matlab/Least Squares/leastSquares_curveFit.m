% Start of script
%-------------------------------------------------------------------------%
close all;                   	% close all figures
clearvars;                      % clear all variables
clc;                         	% clear the command terminal
format shortG;                 	% picks most compact numeric display
format compact;                	% suppress excess blank lines

% Lets do a curve-fit
%-------------------------------------------------------------------------%
% p(x) = 1/10 x^2 -2x + 10


disp('Clean Data')

x = [10:0.2:11]';
y = [0:0.2:1]'.^2/10;
m = length(x);
hold on
plot(x, y, 'bo')
xlim([9.9 11.1])
ylim([0 0.1])


disp('Solving least squares problem with SVD')
A = [x.^2 x ones(m,1)];

% Compute the SVD of A
[U S V] = svd(A);

% find number of nonzero singular value = rank(A)
r = length(find(diag(S)));
Uhat = U(:,1:r);
Shat = S(1:r,1:r);
z = Shat\Uhat'*y;


c = V*z
xx = linspace(9.9,11.1,50);
yy = c(1)*xx.^2+c(2)*xx+c(3);

plot(xx, yy, 'r-')
title('Clean Data')
disp('Fitting with quadratic polynomial')
disp(sprintf('p(x) = %3.2fx^2 + %3.2fx + %3.2f',c))
hold off

disp('Coefficients obtained directly with pseudoinverse')
pinvA = pinv(A);
c = pinvA*y




% Fit "noisy" data using a quadratic polynomial
%-------------------------------------------------------------------------%
disp('Noisy Data')

% Add 10% noise to the data
y = y + 0.1*max(y)*rand(size(y));

figure
hold on
plot(x, y, 'bo')
xlim([9.9 11.1])
ylim([0 0.1])


disp('Solving noisy least squares problem with SVD')
% No need to re-compute the SVD of A since A is the same, only
% y has changed!
z = Shat\Uhat'*y;
c = V*z
xx = linspace(9.9,11.1,50);
yy = c(1)*xx.^2+c(2)*xx+c(3);

plot(xx, yy, 'r-')
title('Noisy Data')
disp('Fitting with quadratic polynomial')
disp(sprintf('p(x) = %3.2fx^2 + %3.2fx + %3.2f',c))
hold off

dock_all_figures;

disp('Coefficients obtained directly with pseudoinverse (computed earlier)')
c = pinvA*y