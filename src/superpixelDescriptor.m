% Georgios Koutroumpis, AEM: 9668
% Digital Image Processing, ECE AUTH 2022
% Project 2
%
% Function that applies a descriptor in an image that has been split into
% superpixels. The descriptor applies the mean RGB value of the RGB values
% of the pixels in a superpixel, to all the pixels in that superpixel
% @args:
% imIn        -> the input image (MxNxn)
% labels      -> the superpixel labels for the image's pixels (MxNx1)
% @output:
% outputImage -> the output image, where each pixel has the mean RGB value
%                of its superpixel (MxNxn)

function outputImage = superpixelDescriptor(imIn , labels)
    
    [M,N,n] = size(imIn);
    
    % Initialize the outputImage, first as shape [M*N,n]
    outputImage = zeros([M*N, n], 'like', imIn);
    
    % Also reshape the input image to [M*N,n]
    imIn = reshape(imIn, [M*N, n]);
    
    % As well as the labels (but with one channel)
    labels = reshape(labels, [M*N, 1]);
    
    % Get a vector of the unique superpixel labels
    uniqueLabels = unique(labels');
    
    % Loop for each superpixel
    for l=uniqueLabels
        
        % Get the indices of each pixel that belongs to superpixel <l>
        pixels = labels == l;
        
        % Get the mean RGB value of the pixels in the superpixel
        rgbmean = mean(imIn(pixels,:));
        
        % For all pixels that belong in the superpixel, give them the RGB
        % value of the mean (repmat is needed as matlab does not broadcast,
        % so the mean RGB value has to be repeated once for each pixel in
        % the superpixel)
        outputImage(pixels,:) = repmat(rgbmean, sum(pixels),1);
    end
    
    % Finally, reshape the outputImage, to be the original size of the
    % input image
    outputImage = reshape(outputImage, [M,N,n]);
end