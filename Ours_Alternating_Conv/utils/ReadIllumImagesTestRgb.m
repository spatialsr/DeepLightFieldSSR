function [fullLF, inputLF, upLF] = ReadIllumImagesTestRgb(scenePath, test_scale)

% -------------------------------------------------------------------------
%   Description:
%       Load Lytro Illum Images for Testing
%       Modified from the code produced by the authors in the citation below
%
%   Input:
%       - scenePath  : path to the light field image
%	- test_scale : scale for Spatial SR
%   Output:
%       - fullLF  : RGB LF as GroundTruth for evaluation
%       - inputLF : Y layer LF for model input
%       - upLF    : Bicubic Interpolated LF in YCbCr space
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

% the input image is resized into dimensions w and h that are divisible by
% test_scale for easy IO
h = floor(h /test_scale) * test_scale;
w = floor(w /test_scale) * test_scale;

inputLF = zeros(floor(h/test_scale), floor(w/test_scale), 1, numImgsY, numImgsX);
fullLF = zeros(floor(h), floor(w), 3, numImgsY, numImgsX);
upLF = zeros(floor(h), floor(w), 3, numImgsY, numImgsX);
for ax = 1 : numImgsX
    for ay = 1 : numImgsY
        img = inputImg(ay:numImgsY:end, ax:numImgsX:end, :);
        img = img(1:h , 1:w, :);
        fullLF(:, :, :, ay, ax) = img;
        img = mod_crop(img, test_scale);
        img = high2low(img, test_scale, 0);
        img = rgb2ycbcr(img);
        imgy = img(:,:,1);
        inputLF(:, :, :, ay, ax) = imgy;
        img = imresize(img, test_scale, 'bicubic');
        upLF(:, :, :, ay, ax) = img;
    end
end

fullLF = fullLF(:, :, :, 4:11, 4:11);
inputLF = inputLF(:, :, :, 4:11, 4:11); % we only take the 8 middle images
upLF = upLF(:, :, :, 4:11, 4:11);
[f_w, f_h, f_c, f_n1, f_n2] = size(inputLF);
inputLF = reshape(inputLF, [f_w, f_h, f_c, f_n1*f_n2]);
upLF = reshape(upLF, [h, w, 3, f_n1*f_n2]);
