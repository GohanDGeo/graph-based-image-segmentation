% Georgios Koutroumpis, AEM: 9668
% Digital Image Processing, ECE AUTH 2022
% Project 2
%
% Function that calculates the nCut value of an affinity matrix of an
% image, that has been clustered into 2 clusters.
% @args:
% anAffinityMat -> the affinity matrix of the image
% clusterIdx    -> vector of the label of the cluster of each pixel
% @output:
% nCutValue     -> the ncut value for the specific clustering/cut

function nCutValue = calculateNcut(anAffinityMat , clusterIdx)

    % Get the label names of the two clusters (they will more likely be 1
    % and 2, but this covers all cases)
    idx = unique(clusterIdx);       % Gets all unique values of the labels
    
    % Get the indices of all the pixels with the first label
    idx1 = clusterIdx==idx(1);  
    % Get the indices of all the pixels with the second label
    idx2 = clusterIdx==idx(2);
    
    % Get the affinity matrix of the pixels with label 1
    afmatA = anAffinityMat(idx1,idx1);
    % Get the affinity matrix of the pixels with label 2
    afmatB = anAffinityMat(idx2,idx2);
    
    % Sum the weights of the affinity matrix of pixels with label 1 between
    % the other pixels with label 1
    assoc_A_A = sum(sum(afmatA,2));
    
    % Sum the weights of the affinity matrix of pixels with label 2 between
    % the other pixels with label 2
    assoc_B_B = sum(sum(afmatB,2));
    
    % Get the affinity matrix of the pixels with label 1 to all pixels 
    afmatAV = anAffinityMat(idx1,:);
    % Get the affinity matrix of the pixels with label 2 to all pixels 
    afmatBV = anAffinityMat(idx2,:);
    
    % Sum the weights of the affinity matrix of pixels with label 1 between
    % all other pixels
    assoc_A_V = sum(sum(afmatAV,2));
    
    % Sum the weights of the affinity matrix of pixels with label 2 between
    % all other pixels
    assoc_B_V = sum(sum(afmatBV,2));
    
    % Calculate the Nassoc value as described in the paper
    Nassoc = (assoc_A_A / assoc_A_V) + (assoc_B_B / assoc_B_V);
    
    % Calculate the ncut value as described in the paper
    nCutValue = 2 - Nassoc;

end