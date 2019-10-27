% Problem to be solved:
% The file regression_data.m contains the measurements of a quantity y at 
% the time instants t = 1; 2;...;100sec. Write a Matlab script that will 
% compute a least-squares approximation for y = f(t), as 
%   (i) a linear function, 
%   (ii) a quadratic polynomial
%   (iii) a cubic polynomial. 
% For each of the three models, what is the norm of the error in the
% approximation? Which is smallest, which is largest? Explain the results 
% theoretically.
% 
% Solution:                                                             
% This MATLAB script loads the supplied data, and performs a fit as a 
% Linear, Quadratic, and Cubic function of the supplied data.


% Start of script
%-------------------------------------------------------------------------%
close all;                   	% close all figures
clearvars; clearvars -global;	% clear all variables
clc;                         	% clear the command terminal
format shortG;                 	% pick the most compact numeric display
format compact;                	% suppress excess blank lines


% Load the data
%-------------------------------------------------------------------------%
% load('LS_data.mat')
linear_regression_data;
[m,n] = size(y);


% Approximate f(x) as a linear function.
%-------------------------------------------------------------------------%
% initialize
c = ones(m,n);
f1 = zeros(m,n);

% create matricies and estimate the parameters, x.
A = [t; c]';
[Q,R] = qr(A,0);
x1 = R\Q'*y'; % use "matrix left-divide" instead of inv(R)*Q'*y';

% compute the line-fit using the estimates in x.
for i=1:n
    f1(i) = x1(1)*i + x1(2);
end

% compute the norm of the error
e1 = norm(y-f1);


% Approximate f(x) as a linear function.
%-------------------------------------------------------------------------%
% initialize
c = ones(m,n);
t2 = zeros(m,n);
f2 = zeros(m,n);

% create matricies and estimate the parameters, x.
for i=1:n
    t2(i) = t(i)^2;
end
A = [t2; t; c]';
[Q,R] = qr(A,0);
x2 = R\Q'*y'; % use "matrix left-divide" instead of inv(R)*Q'*y';

% compute the line-fit using the estimates in x.
for i=1:n
    f2(i) = x2(1)*i^2 + x2(2)*i + x2(3);
end

% compute the norm of the error
e2 = norm(y-f2);


% Approximate f(x) as a linear function.
%-------------------------------------------------------------------------%
% initialize
c = ones(m,n);
t2 = zeros(m,n);
t3 = zeros(m,n);
f3 = zeros(m,n);

% create matricies and estimate the parameters, x.
for i=1:n
    t2(i) = t(i)^2;
    t3(i) = t(i)^3;
end
A = [t3; t2; t; c]';
[Q,R] = qr(A,0);
x3 = R\Q'*y'; % use "matrix left-divide" instead of inv(R)*Q'*y';

% compute the line-fit using the estimates in x.
for i=1:n
    f3(i) = x3(1)*i^3 + x3(2)*i^2 + x3(3)*i + x3(4);
end

% compute the norm of the error
e3 = norm(y-f3);


% Plot & display the results.
%-------------------------------------------------------------------------%
% plot the data
figure(1);
plot(t, y,'o',...
     'LineWidth',1.5);
legend('data','Location','northwest');
title('Raw data');

% plot the results
figure(2);
plot(t, y,  'o',...
     t, f1, '--',...
     'LineWidth',1.5);
legend('data','1^{st}-order fit',...
    'Location','northwest');
title('Approximate data as Linear, Quadratic, and Cubic functions');

figure(3);
plot(t, y,  'o',...
     t, f1, '--',...
     t, f2, ':',...
     'LineWidth',1.5);
legend('data','1^{st}-order fit','2^{nd}-order fit',...
    'Location','northwest');
title('Approximate data as Linear, Quadratic, and Cubic functions');

figure(4);
plot(t, y,  'o',...
     t, f1, '--',...
     t, f2, ':',...
     t, f3, '-.',...
     'LineWidth',1.5);
legend('data','1^{st}-order fit','2^{nd}-order fit','3^{rd}-order fit',...
    'Location','northwest');
title('Approximate data as Linear, Quadratic, and Cubic functions');

dock_all_figures;

% display the results
fprintf(1,'First-order fit coefficients:\n');
fprintf(1,'x(1) = %8.4f\n',x1(1));
fprintf(1,'x(2) = %8.4f\n\n',x1(2));

fprintf(1,'Second-order fit coefficients:\n');
fprintf(1,'x(1) = %8.4f\n',x2(1));
fprintf(1,'x(2) = %8.4f\n',x2(2));
fprintf(1,'x(3) = %8.4f\n\n',x2(3));

fprintf(1,'Third-order fit coefficients:\n');
fprintf(1,'x(1) = %8.4f\n',x3(1));
fprintf(1,'x(2) = %8.4f\n',x3(2));
fprintf(1,'x(3) = %8.4f\n',x3(3));
fprintf(1,'x(4) = %8.4f\n\n',x3(4));

fprintf(1,'First-order norm(error)  = %8.4f\n',e1);
fprintf(1,'Second-order norm(error) = %8.4f\n',e2);
fprintf(1,'Third-order norm(error)  = %8.4f\n',e3);





























