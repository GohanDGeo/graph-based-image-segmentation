% Georgios Koutroumpis, AEM: 9668
% Digital Image Processing, ECE AUTH 2022
% Project 2
%
% Demo 3b: Demonstrate the usage of the function recursiveNcut, so
% clustering using the recursive version of the ncut algorithm

clc
clear
close all

rng(1);

% Load the 2 demo images
data = load("dip_hw_2.mat");
im1 = data.d2a;
im2 = data.d2b;

% Create the affinity matrices for the 2 images
affinityMat1 = Image2Graph(im1);
affinityMat2 = Image2Graph(im2);


% Thresholds for the first image
t11 = 5;
t12 = 0.6;

% Get the labels from the recursiveNcut function, which are returned as
% binary strings
idx1 = recursiveNcut(affinityMat1, t11, t12,'0');
% Turn the binary string to a decimal number (+1 is added to avoid 0 for
% better visual results in label2rgb)
idx1 = bin2dec(idx1) + 1;

% Reshape the cluster labels vector to the shape of the image
clusterIdx1 = reshape(idx1, [size(im1,1), size(im1,2)]);

% Display the clustering results
figure;
clustIm1 = label2rgb(clusterIdx1);
imshow(clustIm1,'InitialMagnification','fit')
k1 = length(unique(idx1));
title(sprintf("Clustering using recursive ncut. Made %d clusters", k1));

% Thresholds for the second image
t21 = 300;
t22 = 1;

% Get the labels from the recursiveNcut function, which are returned as
% binary strings
idx2 = recursiveNcut(affinityMat2, t21, t22,'0');
% Turn the binary string to a decimal number (+1 is added to avoid 0 for
% better visual results in label2rgb)
idx2 = bin2dec(idx2) + 1;

% Reshape the cluster labels vector to the shape of the image
clusterIdx2 = reshape(idx2, [size(im2,1), size(im2,2)]);

% Display the clustering results
figure;
clustIm2 = label2rgb(clusterIdx2);
imshow(clustIm2,'InitialMagnification','fit')
k2 = length(unique(idx2));
title(sprintf("Clustering using recursive ncut. Made %d clusters", k2));

