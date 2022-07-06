% Georgios Koutroumpis, AEM: 9668
% Digital Image Processing, ECE AUTH 2022
% Project 2
%
% Function that performs Graph Spectral Clustering on an image, using it's
% affinity matrix, <anAffinityMat>, clustering it into <k> clusters.
% @args:
% anAffinityMat -> the affinity mat of the image (image represented as
%                  graph)
% k             -> the number of clusters to create
% @output:
% clusterIdx    -> a vector containing the label of the cluster of each
%                  pixel

function clusterIdx = myGraphSpectralClustering(anAffinityMat , k)

    % Calculate the Degree matrix
    D = diag(sum(anAffinityMat));

    % Calculate the non-normalized Laplacian Matrix
    L = D - anAffinityMat;

    % Solve the generic eigenvalue problem, by taking the k smallest
    % eigenvalues. The resulting matrix <U> contains the eigenvectors in 
    % the form of a matrix, with one vector being one column of the matrix.
    [U, ~] = eigs(L, D, k, 'smallestreal');
   
    % The eigenvectors matrix is then fed to the kmeans function, using <k>
    % clusters, and the result is the cluster labels for the image's
    % pixels.
    clusterIdx = kmeans(U, k);
end