% Start of script
close all;                   	% close all figures
clearvars; clearvars -global;	% clear all variables
clc;                         	% clear the command terminal
format shortG;                 	% picks most compact numeric display
format compact;                	% suppress excess blank lines
addpath(genpath('utilities'));  % include local library
startup;                        % set defaults

rng default; % For reproducibility

X = [randn(100,2)*0.75+ones(100,2);
    randn(100,2)*0.5-ones(100,2)];

% figure;
% plot(X(:,1),X(:,2),'.');
% title 'Randomly Generated Data';

opts = statset('Display','iter');
% [idx,C] = kmeans(X,2,'Distance','cityblock',...
%     'Replicates',5,'Options',opts);

[idx,C] = kmeans(X,2,'Distance','sqeuclidean',...
    'Replicates',5,'Options',opts);

% [idx,C] = kmeans(X,2,'Distance','correlation',...
%     'Replicates',5,'Options',opts);

% [idx,C] = kmeans(X,2,'Distance','cosine',...
%     'Replicates',5,'Options',opts);

figure;
plot(X(idx==1,1),X(idx==1,2),'r.','MarkerSize',12)
hold on
plot(X(idx==2,1),X(idx==2,2),'b.','MarkerSize',12)
plot(C(:,1),C(:,2),'kx',...
     'MarkerSize',15,'LineWidth',3)
legend('Cluster 1','Cluster 2','Centroids',...
       'Location','NW')
title 'Cluster Assignments and Centroids'
hold off