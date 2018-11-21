function img_list = batch_imread(batch)
% -------------------------------------------------------------------------
%   Description:
%       read a batch of images
%
%   Input:
%       - batch : array of ID to fetch
%
%   Output:
%       - img_list: batch of images
%
%   Citation: 
%       Deep Laplacian Pyramid Networks for Fast and Accurate Super-Resolution
%       Wei-Sheng Lai, Jia-Bin Huang, Narendra Ahuja, and Ming-Hsuan Yang
%       IEEE Conference on Computer Vision and Pattern Recognition (CVPR), 2017
%
%   Contact:
%       Wei-Sheng Lai
%       wlai24@ucmerced.edu
%       University of California, Merced
% -------------------------------------------------------------------------
    
    % To prevent loading too much data, set list_length to a smaller number
    list_length = size(batch, 1);
    img_list = cell(list_length, 1);
    
    for i = 1:list_length
         
         [fullLF] = ReadIllumImages(batch{i});
         img_list{i} = fullLF;
         disp(['Loaded Image ' num2str(i) '/' num2str(list_length)]);
    end

end
