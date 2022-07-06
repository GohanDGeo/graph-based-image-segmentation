% Georgios Koutroumpis, AEM: 9668
% Digital Image Processing, ECE AUTH 2022
% Project 2
%
% Function that implements the recursive version of the ncuts algorithm. So
% given an affinity matrix of an image, <anAffinityMat>, the image is
% clustered using the recursive ncuts algorithm.
% @args:
% anAffinityMat -> the affinity mat of the image (image represented as
%                  graph)
% t1            -> threshold 1 for ncuts, the minimum number of pixels in a
%                  cluster
% t2            -> threshold 2 for ncuts, the maximum ncut value
% id            -> the current label/id of the cluster. Used for recurssion
% @output:
% indices       -> a vector containing the label of the cluster of each
%                  pixel of the given affinity matrix, in the form of a
%                  binary string

function indices = recursiveNcut(anAffinityMat, t1, t2, id)
    
    % Perform spectracl clustering for k=2 in the given affinity mat
    clusterIdx = myGraphSpectralClustering(anAffinityMat, 2);
    
    % Calculate the ncut value of the cut/clustering
    nCutValue = calculateNcut(anAffinityMat , clusterIdx);
   
    % Get the 2 unique id's of the resulting clusters
    idx = unique(clusterIdx);
    % And get the indices of each pixel with label 1 and label 2
    clusterIdx1 = clusterIdx==idx(1);
    clusterIdx2 = clusterIdx==idx(2);

    % Create a string array that will hold the new ids/labels for the
    % pixels in the affinity matrix
    indices = strings(size(anAffinityMat,1),1);
    
    % Check if the clustering/cut made above is a good cut/clustering, by
    % checking if the ncut value is smaller than the threshold t2, or if
    % the resulting pixels in each cluster are more than the threshold t1
    if (sum(clusterIdx1) < t1) | (sum(clusterIdx2) < t1) ... 
            | (nCutValue > t2)
        
        % If the above conditions are not met, then it was a "bad"
        % cut/clustering, and the labels/ids of the pixels remain the same.
        % The function returns, as this branch is over, this is now a leaf
        % node.
        indices(:) = id;
        return;
    else
        
        % However, if the cut was a "good" one, then we split the affinity
        % matrix in two, one for each cluster
        afmatA = anAffinityMat(clusterIdx1,clusterIdx1);
        afmatB = anAffinityMat(clusterIdx2,clusterIdx2);
        
        % And recursively apply the ncut algorithm to the two clusters,
        % which now have a new id, adding 0 to the front of the one
        % cluster, and 1 to the front of the other
        idx1 = recursiveNcut(afmatA, t1, t2,['0' id]);
        idx2 = recursiveNcut(afmatB, t1, t2,['1' id]);

        % Now the new ids for the pixels in each cluster are the result of
        % the recursion, and so they new labels are updated.
        indices(clusterIdx1) = idx1;
        indices(clusterIdx2) = idx2;
       
    end
end