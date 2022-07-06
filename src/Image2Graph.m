% Georgios Koutroumpis, AEM: 9668
% Digital Image Processing, ECE AUTH 2022
% Project 2
%
% Function that calculates the affinity matrix of an image <imIn>.
% Can also accept an image represented as a vector of superpixels. 
% The superpixel image will then have dimenions of M x c x 1, where M is
% the number of superpixels, c the number of channels.
% @args:
% imIn          -> the image to calculate the matrix for (MxNxn)
% @output:
% myAffinityMat -> the affinity matrix of the input image

function myAffinityMat = Image2Graph(imIn)

    % Get size of image
    [M,N,n] = size(imIn);
    
    % Cast image to double, so norm can be used
    imIn = im2double(imIn);

    % If n=1, then the input image is a Superpixel vector, as described
    % above. If so, the affinity matrix will have dimensions MxM 
    if n == 1
        K = M;
    else
    % If a 2D image is given as input, it's a normal image, and so the
    % resulting affinity matrix will have (M*N)x(M*N) dimensions.
        K = M*N;
    % The image is then reshaped into a vector with the RGB values, to make
    % calculations easier. 
        imIn = reshape(imIn, [K, n]);
    end
    
    % Initialize the affinity matrix with zeros.
    myAffinityMat = zeros(K,K);
    
    % Calculate only the lower part of the symmetric matrix. Then, for an
    % entry (i,j), the entry (j,i) is equal to it. Only go until j=i-1, as
    % we want the diagonal to have 0s.
    for i=1:K
        for j=1:(i-1)
            % Calculate the eucledian distance between the RGB vector of
            % the two elements
            d = norm(imIn(i,:) - imIn(j,:));
            
            % And update the affinity matrix
            myAffinityMat(i,j) = 1/exp(d);
            myAffinityMat(j,i) = 1/exp(d);
        end
    end
end