function img_HR = Spatial_SR(img_LR, net, opts)
% -------------------------------------------------------------------------
%   Description:
%       function to apply Spatial SR
%       Modified from the code produced by the authors in the citation below
%
%   Input:
%       - img_LR: low-resolution image
%       - net   : LapSRN model
%       - opts  : options generated from init_opts()
%
%   Output:
%       - img_HR: high-resolution image
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

    %% setup
    net.mode = 'test' ;
    output_var = 'level1_output';
    output_index = net.getVarIndex(output_var);
    net.vars(output_index).precious = 1;
    img_LR = single(img_LR); 

    if( opts.gpu )
        y = gpuArray(img_LR);
    else
        y = img_LR;
    end
    

    % forward
    inputs = {'LR', y};
    net.eval(inputs);
    if( opts.gpu )
        y = gather(net.vars(output_index).value);
    else
        y = net.vars(output_index).value;
    end

    img_HR = double(y);   
    
end
