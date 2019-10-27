
% Start of script
%-------------------------------------------------------------------------%
close all;                   	% close all figures
clearvars; clearvars -global;	% clear all variables
clc;                         	% clear the command terminal
format shortG;                 	% pick the most compact numeric display
format compact;                	% suppress excess blank lines

% load data
%-------------------------------------------------------------------------%
load carbig
X = [Acceleration Displacement Horsepower Weight];
miles = ordinal(MPG,{'1','2','3','4'},[],[9,19,29,39,48]);
[B,dev,stats] = mnrfit(X,miles,'model','ordinal');

fprintf(1,'Data order:\n Acceleration \n Displacement \n Horsepower \n Weight\n');

disp('Results')
disp(B)

disp('significance level p-value')
disp(stats.p)