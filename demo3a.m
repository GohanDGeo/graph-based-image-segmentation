% Georgios Koutroumpis, AEM: 9668
% Digital Image Processing, ECE AUTH 2022
% Project 2
%
% Demo 3a: Demonstrate the usage of the function calculateNcut, and the 
% ncut method for one step.

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

k = 2;
% Perform one step of the ncut method and calculate the ncut value
clusterIdxIm1 = myGraphSpectralClustering(affinityMat1, k);
nCutValueIm1 = calculateNcut(affinityMat1 , clusterIdxIm1);

clusterIdxIm2 = myGraphSpectralClustering(affinityMat2, k);
nCutValueIm2 = calculateNcut(affinityMat2 , clusterIdxIm2);

% Display they results
figure;
clusterIdx1 = reshape(clusterIdxIm1, [size(im1,1), size(im1,2)]);
clustIm1 = label2rgb(clusterIdx1);
imshow(clustIm1,'InitialMagnification','fit')
title(sprintf("Clustering using k=%d clusters, nCutValue=%f ", ...
      k, nCutValueIm1));
  
figure;
clusterIdx2 = reshape(clusterIdxIm2, [size(im2,1), size(im2,2)]);
clustIm2 = label2rgb(clusterIdx2);
imshow(clustIm2,'InitialMagnification','fit')
title(sprintf("Clustering using k=%d clusters, nCutValue=%f ", ...
      k, nCutValueIm2));



