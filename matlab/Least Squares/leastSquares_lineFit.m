% Start of script
%-------------------------------------------------------------------------%
close all;                   	% close all figures
clearvars;                      % clear all variables
clc;                         	% clear the command terminal
format shortG;                 	% picks most compact numeric display
format compact;                	% suppress excess blank lines

% Grab data
%-------------------------------------------------------------------------%
data = [1973 203;
        1974 124;
        1975 223;
        1976 177;
        1977 166;
        1978 104;
        1979 95;
        1980 94;
        1981 26;
        1982 135;
        1983 179;
        1984 210;
        1985 133;
        1986 153;
        1987 150;
        1988 189;
        1989 149;
        1990 184;
        1991 156;
        1992 133;
        1993 173;
        1994 211;
        1995 97;
        1996 92;
        1997 37;
        1998 200;
        1999 196;
        2000 195;
        2001 189;
        2002 155;
        2003 145;
        2004 149;
        2005 195;
        2006 168;
        2007 201;
        2008 173;
        2009 168;
        2010 192;
        2011 193;
        2012 216;
        2013 157];

    
% % Statistics
% %-------------------------------------------------------------------------%
% hist(data(:,2),20);
% 
% histfit(data(:,2),20,'normal')

    
% Simple linear regression
%-------------------------------------------------------------------------%
% y = beta_0 + beta_1 x + epsilon
%   beta_0 is the y-intercept
%   beta_1 is the slope (regression coefficient)
%   epsilon is the error term
% 
% Reformulate in matrix form
%   |y_1|   |1, x_1| |beta_0|
%   |...| = |  ... | |beta_1|
%   |y_n| = |1, x_n| 
% which is
%   y = X*b
% 
% Now solve using the mldivide
%   b = X^-1 * y

% reformat the data into vectors x and y
x = data(:,1);
y = data(:,2);

% reformat the data into matrix X
X = [ones(length(data(:,1)),1) data(:,1)];

% perform a 1st order linear fit using the mldivide
b = X\y;


%----------------------------------------%
% Note: We can also compute b using SVD
%----------------------------------------%
% Compute the SVD of X
% [U S V] = svd(X);
% 
% find number of nonzero singular value = rank(A)
% r = length(find(diag(S)));
% U_hat = U(:,1:r);
% S_hat = S(1:r,1:r);
% 
% Compute z and then b using the SVD
% z = S_hat\U_hat'*y; % this is: z = inv(S_hat)*U_hat'*y
% b = V*z;
%----------------------------------------%


% apply 1st order coefficients to equation of a line
y_hat = b(1) + b(2).*x;

% calculate the R-squared value: 
%
% R^2 = 1 - (\sum_{i=1}^n (y_i - y_hat_i)^2) / (\sum_{i=1}^n (y_i - y_bar_i)^2)
%
% This value tells us how well our estimate fits the data.  The higher the
% number, the better the fit.
R_sq = 1 - sum((y - y_hat).^2) / sum((y - mean(y)).^2)

% plot the results
figure(1);
plot(x,y,'.',x,y_hat,'r--')
xlim([min(x) max(x)])
ylim([0 360])
xlabel('Year')
ylabel('Wind Direction (deg.)')
legend('Measurements','Linear regression fit')
title('Simple Linear Regression')


% Perform a prediction
%-------------------------------------------------------------------------%
x_star = 2020;
y_star = b(1) + b(2).*x_star;

% plot prediction
hold on;
plot(x_star,y_star,'*')
hold off;
legend('Measurements','Linear regression fit','Prediction')
xlim([min(x) x_star+2])


% remove the outliers
%-------------------------------------------------------------------------%
y_bar = abs(y - y_hat);
x2 = [];
y2 = [];
k = 0;
for ii = 1:length(x)
    if y_bar(ii) < (2*mean(y_bar))
        k = k+1;
        y2(k,1) = y(ii);
        x2(k,1) = x(ii);
    end
end

% perform the same analysis as before
X2 = [ones(length(x2),1) x2];
b2 = X2\y2;
y2_hat = b2(1) + b2(2).*x2;
R2_sq = 1 - (sum((y2 - y2_hat).^2) / sum((y2 - mean(y2)).^2))

% plot the new estimates
figure(2)
plot(x2,y2,'.',x2,y2_hat,'r--')
xlim([min(x2) x_star+2])
ylim([0 360])
xlabel('Year')
ylabel('Wind Direction (deg.)')
legend('Measurements','Linear regression fit')
title('Simple Linear Regression: Outliers removed')


dock_all_figures;







