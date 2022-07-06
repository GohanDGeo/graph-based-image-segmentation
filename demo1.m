% Georgios Koutroumpis, AEM: 9668
% Digital Image Processing, ECE AUTH 2022
% Project 2
%
% Demo 1: Demonstrate the usage of the myGraphSpectralClustering method on
% the affinity matrix d1a given.

clc
clear 
close all

% To have consistent results
rng(1);

% Load the test affinty matrix
data = load("dip_hw_2.mat");
affinityMat = data.d1a;

% Make three clustering experiments on the affinity mat, for k=2,3,4
figure;
for k=2:4
    % Cluster the input affinity matrix
    clusterIdx = myGraphSpectralClustering(affinityMat , k);
    
    
    subplot(1,3,k-1)
    clustIm = label2rgb(clusterIdx);
    imshow(clustIm,'InitialMagnification','fit')
    title(sprintf("k=%d clusters", k));
end
sgtitle("Clustering using");

