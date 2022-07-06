% Georgios Koutroumpis, AEM: 9668
% Digital Image Processing, ECE AUTH 2022
% Project 2
%
% Demo 2: Demonstrate the usage of the myGraphSpectralClustering method and
% the Image2Graph method, by using Image2Graph to create affinity matrices
% for given images, and then cluster them using myGraphSpectralClustering

clc
clear
close all

% To have consistent results
rng(1);

% Load the 2 demo images
data = load("dip_hw_2.mat");
im1 = data.d2a;
im2 = data.d2b;

figure(1)
subplot(1,4,1)
imshow(im1,'InitialMagnification','fit')
title("Original Image")

figure(2)
subplot(1,4,1)
imshow(im2,'InitialMagnification','fit')
title("Original Image")

% Create the affinity matrices for the 2 images
affinityMat1 = Image2Graph(im1);
affinityMat2 = Image2Graph(im2);

images1 = [];
images2 = [];

for k=2:4
    % Get the cluster labels for the images
    clusterIdx1 = myGraphSpectralClustering(affinityMat1 , k);
    clusterIdx2 = myGraphSpectralClustering(affinityMat2 , k);
    
    % Reshape the vector of labels back to the shape of the images, so they
    % can be displayed
    clusterIdx1 = reshape(clusterIdx1, [size(im1,1), size(im1,2)]);
    clusterIdx2 = reshape(clusterIdx2, [size(im2,1), size(im2,2)]);
    
    % Show the clusters on the images
    figure(1)
    subplot(1,4,k)
    showClusters(clusterIdx1, k);
    
    figure(2)
    subplot(1,4,k)
    showClusters(clusterIdx2, k);
end

figure(1)
sgtitle("Clustering using")

figure(2)
sgtitle("Clustering using")

% Helper function to show/display the clusters on the images.
% @args:
% clusterIdx -> an MxN (shape of image) matrix, holding the label of each
%               pixel
% k          -> the number of clusters
function clustIm = showClusters(clusterIdx, k)
    %figure;
    clustIm = label2rgb(clusterIdx);
    imshow(clustIm,'InitialMagnification','fit')
    title(sprintf("k=%d clusters", k));
end