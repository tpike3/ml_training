function optimization_demo()   

% Problem to be Solved:
% This problem asks you to implement the two nonlinear minimization 
% methods we discussed in class.
% (i) Write a Matlab script that implements gradient descent with a 
%     constant preselected stepsize. Use the function below.
% (ii) Write a Matlab script the implements the pure Newton iteration. Use 
%      the same function as above to test your function. 
% How many iterations does each method take?
% 
% Function:
% f(x) = 3*exp(0.1*x_1)+(x_1-50)^2+2*x_1+2*exp(0.1*x_2)+(x_2-50)^2+2*x_2+1
% 
% Solution:                                                             
% This MATLAB script performs both Gradient Descent and Newton optimization
% of the function: 


% Start of script.
%-------------------------------------------------------------------------%
close all;                   	% close all figures
clearvars; clearvars -global;	% clear all variables
clc;                         	% clear the command terminal
format shortG;                 	% pick the most compact numeric display
format compact;                	% suppress excess blank lines


%-------------------------------------------------------------------------%
%                           User defines section
%-------------------------------------------------------------------------%

tol     = 1e-5; % tolerance for convergence
t_gd	= 0.3; % NOTE: 0.3 appears to be nearly optimal for this f(x)
t_n     = 1.0;

%-------------------------------------------------------------------------%
%                          END user defines section
%-------------------------------------------------------------------------%


% Gradient Descent Optimization.
%-------------------------------------------------------------------------%
% initialize
ii = 0;
x_ii = zeros(2,1);
x_gd_inc = zeros(10,2);
f_gd_inc = zeros(10,1);

% infinite loop
while 1
    % compute the Jacobian
    J = J_opt(x_ii);

    % check stopping criteria
    if ( ((J'*J)^0.5) < tol )
        % terminate while loop
        ii = ii+1;
        break;
    else
        % compute update
        dx = -J;
        x_ii = x_ii + t_gd*dx;
        ii = ii+1;
        x_gd_inc(ii,:) = x_ii';
        f_gd_inc(ii,1) = f_opt(x_ii);
    end
end

% compute final results
f_gd = f_opt(x_ii);
x_gd = x_ii;
ii_gd = ii;

% collapse inc
x_gd_inc = x_gd_inc(1:ii-1,:);
f_gd_inc = f_gd_inc(1:ii-1,:);


% Newton Optimization.
%-------------------------------------------------------------------------%
% initialize
ii = 0;
x_ii = zeros(2,1);
x_n_inc = zeros(10,2);
f_n_inc = zeros(10,1);

% infinite loop
while 1
    % compute the Jacobian
    J = J_opt(x_ii);
    
    % compute the Hessian
    H = H_opt(x_ii);
    
    % check stopping criteria
    if ( ((J'*J)^0.5) < tol )
        % terminate while loop
        ii = ii+1;
        break;
    else
        % compute update
        dx = -inv(H)*J;
        x_ii = x_ii + t_n*dx;
        ii = ii+1;
        x_n_inc(ii,:) = x_ii';
        f_n_inc(ii,1) = f_opt(x_ii);
    end
end

% compute final results
f_n = f_opt(x_ii);
x_n = x_ii;
ii_n = ii;

% collapse inc
x_n_inc = x_n_inc(1:ii-1,:);
f_n_inc = f_n_inc(1:ii-1,:);


% Plot the function as a "cost surface" with "level curves"
%-------------------------------------------------------------------------%
[X,Y] = meshgrid(0:1:65,0:1:65);
Z = 3.*exp(0.1.*X) + ((X-50).^2) + 2.*X + 2.*exp(0.1.*Y) + ((Y-50).^2) + 2.*Y+1;

figure(1);
contour(X,Y,Z);
hold on;
plot(x_gd(1),x_gd(2),'*');
plot(x_gd_inc(:,1),x_gd_inc(:,2),'-r',x_n_inc(:,1),x_n_inc(:,2),'-b','LineWidth',2);
plot(x_gd_inc(:,1),x_gd_inc(:,2),'or',x_n_inc(:,1),x_n_inc(:,2),'+b','LineWidth',2);
legend('Level Curves','Optimum','Gradient Descent','Gauss-Newton')
title('Level curves of the cost surface')
hold off;

figure(2);
surf(X,Y,Z);
hold on;
contour(X,Y,Z);
plot(x_gd(1),x_gd(2),'*');
plot(x_gd_inc(:,1),x_gd_inc(:,2),'-r',x_n_inc(:,1),x_n_inc(:,2),'-b','LineWidth',2);
plot(x_gd_inc(:,1),x_gd_inc(:,2),'or',x_n_inc(:,1),x_n_inc(:,2),'+b','LineWidth',2);
plot3(x_gd_inc(:,1),x_gd_inc(:,2),f_gd_inc,'-r','LineWidth',3);
plot3(x_gd_inc(:,1),x_gd_inc(:,2),f_gd_inc,'or','LineWidth',3);
plot3(x_n_inc(:,1),x_n_inc(:,2),f_n_inc,'-b','LineWidth',3);
plot3(x_n_inc(:,1),x_n_inc(:,2),f_n_inc,'+b','LineWidth',3);
legend('Cost Surface','Level Curves','Optimum','Gradient Descent','Gauss-Newton')
title('Level curves of the cost surface')
hold off;

figure(3);
plot([1:length(f_gd_inc)]',f_gd_inc,'r', [1:length(f_n_inc)]',f_n_inc,'b',...
    [1:length(f_gd_inc)]',f_gd_inc,'or', [1:length(f_n_inc)]',f_n_inc,'*b');
legend('cost: Gradient Descent','cost: Gauss-Newton');
title('Cost Function f(x) vs. Iteration');
xlabel('Iteration #');
ylabel('Cost: f(x)');



% Display the results.
%-------------------------------------------------------------------------%
fprintf(1,'Optimization Results:\n');
fprintf(1,'=====================\n\n');

fprintf(1,'Gradient Descent:\n');
fprintf(1,'f(x) = %8.3f\n',f_gd);
fprintf(1,'x(1) = %8.3f\n',x_gd(1));
fprintf(1,'x(2) = %8.3f\n',x_gd(2));
fprintf(1,'# iter = %2.0f.\n\n',ii_gd);

fprintf(1,'Newton:\n');
fprintf(1,'f(x) = %8.3f\n',f_n);
fprintf(1,'x(1) = %8.3f\n',x_n(1));
fprintf(1,'x(2) = %8.3f\n',x_n(2));
fprintf(1,'# iter = %2.0f.\n\n',ii_n);

dock_all_figures;

% Subfunctions.
%-------------------------------------------------------------------------%
% f(x)
function f_out = f_opt(x_in)
f_out = 3*exp(0.1*x_in(1)) + ((x_in(1)-50)^2) + 2*x_in(1) + ...
    2*exp(0.1*x_in(2)) + ((x_in(2)-50)^2) + 2*x_in(2)+1;

% Jacobian of f(x)
function J_out = J_opt(x_in)
J_out = zeros(2,1);
J_out(1,1) = 0.3*exp(0.1*x_in(1)) + 2*(x_in(1)-50) + 2;
J_out(2,1) = 0.2*exp(0.1*x_in(2)) + 2*(x_in(2)-50) + 2;

% Hessian of f(x)
function H_out = H_opt(x_in)
H_out = zeros(2,2);
H_out(1,1) = 0.03*exp(0.1*x_in(1)) + 2; 
H_out(2,2) = 0.02*exp(0.1*x_in(2)) + 2;












