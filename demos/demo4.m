% Georgios Koutroumpis, AEM: 9668
% Digital Image Processing, ECE AUTH 2022
% Project 2
%
% Demo 4: Demonstrates the usage of the recursive ncuts algorithm, and the
% non recursive ncuts algorithm, when paired with the usage of superpixels,
% for image segmentation

clear
close all
clc

rng(1)

% Load the the demo image
imIn = imread("bee.jpg");

% Get the image's dimensions
imSize = size(imIn);
imSize = imSize(1:end-1);

% The parameters used for superpixels
reqNumLabels = 400;
cFactor = 20;

% Split the image into superpixels
[labels , ~] = slicmex(imIn , reqNumLabels , cFactor);

% This is added to avoid having a label "0", which helps simplify the
% process 
labels = labels + 1;

% Display the superpixels created
visualizeSuperpixelImage = label2rgb(labels);
imshow(visualizeSuperpixelImage)
title("Visualization of resulting superpixels");

% Apply the superpixel descriptor
outputImage = superpixelDescriptor(imIn , labels);

% Show the result of the descriptor
figure;
imshow(outputImage)
title("Result of applying superpixel descriptor");

% Get the unique superpixel labels. In addition, get the indices of one
% pixel belonging for each superpixel (so we can have the RGB value of each
% superpixel)
[uniqueLabels,ia,ic] = unique(labels);

% Reshape the outputImage as an image vector ( so [MxN,n], n: number of
% channels), to simplify the process
outputImageVector = reshape(outputImage, ... 
           [size(outputImage,1)*size(outputImage,2), size(outputImage,3)]);

% Create a vector image, which holds each (unique) superpixel, and its RGB
% value
superpixelIm = outputImageVector(ia,:);

% Get the number of superpixels
labelCount = length(uniqueLabels);

% Create an affinity matrix for the superpixels
myAffinityMat = Image2Graph(superpixelIm);


% Apply Spectral Clustering using superpixels (non-recursive ncuts)
figure(3)
subplot(1,2,1)
k = 6;
superpixelGraphSpectral(k, myAffinityMat,labels, labelCount, imSize);

subplot(1,2,2)
k = 10;
superpixelGraphSpectral(k, myAffinityMat,labels, labelCount, imSize);


% Apply recursive ncuts using superpixels
figure(4)
% To get 6 clusters
subplot(1,2,1)
t1 = 5;
t2 = 0.98;

[clusters,~]= superpixelNcuts(myAffinityMat, t1, t2, ...
                             labels, labelCount, imSize);

% To get 10 clusters

subplot(1,2,2)
t1 = 12;
t2 = 0.9953;

[clusters,~]= superpixelNcuts(myAffinityMat, t1, t2,...
                              labels, labelCount, imSize);

 
                          
                          
% Helper function to apply spectral clustering (non-recursive ncuts) to an
% image with superpixels
% @args:
% k             -> the number of clusters
% myAffinityMat -> the affinity matrix for the superpixels
% labels        -> the superpixel labels
% labelCount    -> number of superpixels
% imSize        -> shape of image (excluding channels, so eg [M,N])
function [clusterLabels, clusterIm] = ...
    superpixelGraphSpectral(k, myAffinityMat, labels, labelCount, imSize)
    
    % Apply spectral clustering for k clusters
    clusterIdx = myGraphSpectralClustering(myAffinityMat , k);

    % Initialize a matrix which will hold the cluster label for each pixel
    clusterLabels = zeros(imSize);

    % For each superpixel, find all pixels in that superpixel, and give
    % them the cluster label of the superpixel
    for i=1:labelCount
        clusterLabels(labels==i) = repmat(clusterIdx(i), ...
            [size(clusterLabels(labels==i),1), 1]);
    end
    
    % Visualize the clustering
    clusterIm = label2rgb(clusterLabels);
    
    %figure;
    imshow(clusterIm)
    title(sprintf("Non-recursive Ncuts, clusters=%d",k));
end


% Helper function to apply recursive ncuts to image with superpixels
% @args:
% myAffinityMat -> the affinity matrix for the superpixels
% t1            -> threshold t1 for ncuts algorithm 
%                   (the minimum number of pixels in a cluster)
% t2            -> threshold t2 for ncuts algorithm, the maximum ncut value
% labels        -> the superpixel labels
% labelCount    -> number of superpixels
% imSize        -> shape of image (excluding channels, so eg [M,N])

function [clusterLabels, clusterIm] = ...
    superpixelNcuts(myAffinityMat, t1, t2, labels, labelCount, imSize)
    
    % Apply the recursive ncuts algorithm to the affinity matrix
    clusterIdx = recursiveNcut(myAffinityMat, t1, t2, '0');

    % Translate the binary string to decimal
    clusterIdx = bin2dec(clusterIdx) + 1;
    
    % Initialize a matrix which will hold the cluster label for each pixel
    clusterLabels = zeros(imSize);

    % For each superpixel, find all pixels in that superpixel, and give
    % them the cluster label of the superpixel
    for i=1:labelCount
        clusterLabels(labels==i) = repmat(clusterIdx(i), ...
            [size(clusterLabels(labels==i),1), 1]);
    end
    
    % Get the number of clusters created
    clusterCount = length(unique(clusterLabels));
    
    % Visualize the clustering
    clusterIm = label2rgb(clusterLabels);
    
    %figure;
    imshow(clusterIm)
    title(sprintf("Recursive Ncuts, clusters=%d",clusterCount));
end