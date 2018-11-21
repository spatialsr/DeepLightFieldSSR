function [fullLF] = ReadIllumImages(scenePath)

% -------------------------------------------------------------------------
%   Description:
%       Load Lytro Illum Images for Training
%       Modified from the code produced by the authors in the citation below
%
%   Input:
%       - scenePath: path to the light field image
%
%   Citation
%       - Kalantari N K, Wang T C, Ramamoorthi R. Learning-based view synthesis 
%         for light field cameras[J]. ACM Transactions on Graphics (TOG), 
%	  2016, 35(6): 193.
% -------------------------------------------------------------------------
numImgsX = 14;
numImgsY = 14;

%%% converting the extracted light field to a different format
inputImg = im2double(imread(scenePath));

h = size(inputImg, 1) / numImgsY;
w = size(inputImg, 2) / numImgsX;
fullLF = zeros(h, w, numImgsY, numImgsX);
for ax = 1 : numImgsX
    for ay = 1 : numImgsY
        img = inputImg(ay:numImgsY:end, ax:numImgsX:end, :);
        img = rgb2ycbcr(img);
        fullLF(:, :, ay, ax) = im2single(img(:, :, 1));
    end
end

if (h == 375 && w == 540)
    fullLF = padarray(fullLF, [1, 1], 0, 'post');
end

if (h == 375 && w == 541)
    fullLF = padarray(fullLF, [1, 0], 0, 'post');
end

fullLF = fullLF(:, :, 4:11, 4:11); % we only take the 8 middle images
[f_w, f_h, f_n1, f_n2] = size(fullLF);
fullLF = reshape(fullLF, [f_w, f_h, f_n1*f_n2]);
