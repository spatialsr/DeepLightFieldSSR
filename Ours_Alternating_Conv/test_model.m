function test_model(model_scale, depth, gpu, saveImg, test_scale, epoch)
% -------------------------------------------------------------------------
%   Description:
%       Script to test Spatial SR model on benchmark datasets
%       Compute PSNR, SSIM and IFC
%       Modified from the code produced by the authors in the citation below
%
%   Input:
%       - model_scale   : model SR scale
%       - depth         : model depth
%       - gpu           : GPU ID
%       - saveImg       : Save the SR subviews
%       - test_scale    : testing SR scale
%       - epoch         : model epoch to test
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

   % Check correct Scale for testing
   if( test_scale ~= model_scale )
        error('Test scale must be greater than or equal to model scale (%d vs %d)', ...
            test_scale, model_scale);
    end

    %% generate opts
    opts = init_opts(model_scale, depth, gpu);
    
    %% setup paths
    addpath(genpath('utils'));
    addpath(fullfile(pwd, 'matconvnet/matlab'));
    vl_setupnn;
    
    %% Load model
    model_filename = fullfile(opts.train.expDir, sprintf('net-epoch-%d.mat', epoch));
    fprintf('Load %s\n', model_filename);
    
    net = load(model_filename);
    net = dagnn.DagNN.loadobj(net.net);
    
    if( opts.gpu )
        gpuDevice(opts.gpu);
        net.move('gpu');
    end
    
    %% load image list
    img_list = load_list('lists/Test.txt');
    num_img = length(img_list);
    

    %% testing
    PSNR = zeros(num_img, 1);
    SSIM = zeros(num_img, 1);
    PSNR_var = zeros(num_img, 1);
    SSIM_var = zeros(num_img, 1);
    IFC  = zeros(num_img, 1);
    
    for i = 1:num_img
        
        img_name = img_list{i};
        fprintf('Process Test Set %d/%d: %s\n', i, num_img, img_name);

        if( exist('saveImg'))
            mkdir(strcat(['Save_Img/', img_name]))
        end
    
        % Load HR image
        input_dir = '/media/data/Henry_Storage/LapSR_Test';
        input_filename = fullfile(input_dir, sprintf('%s.png', img_name));
        [originalLF, inputLF, upLF] = ReadIllumImagesTestRgb(input_filename, test_scale);
        
        % Split the testing image into 16 parts for SR separately
        img_HR = SR_Image(inputLF, net, opts, test_scale);

        %% evaluate
        [f_w, f_h, f_c, f_a] = size(img_HR);
        originalLF = reshape(originalLF, [f_w, f_h, 3, f_a]);
        psnr_score = [];
        ssim_score = [];
        
         for view = 1:64   
            tmp_RE = img_HR(:,:,:,view);
            tmp_UP = upLF(:,:,:,view);
            tmp_UP(:,:,1) = tmp_RE;
            tmp_HR = tmp_UP;
            tmp_LR = originalLF(:,:,:,view);  
 
            % Quantise pixels
            %tmp_LR = im2double(im2uint8(tmp_LR));
            
            % YCBCR2RGB
            tmp_HR = ycbcr2rgb(tmp_HR);
            tmp_HR = im2double(im2uint8(tmp_HR));

            if( exist('saveImg'))
                imwrite(tmp_HR, strcat(['Save_Img/general_', num2str(i), '_eslf/', img_name, int2str(view), '.png']))
            end

            % crop boundary
            tmp_HR = shave_bd(tmp_HR, 15);
            tmp_LR = shave_bd(tmp_LR, 15);           

            % evaluate
            pp = [];
            ss = [];

            for c = 1:3
            	pp(end+1) = psnr(tmp_HR(:,:,c), tmp_LR(:,:,c));
                ss(end+1) = ssim(tmp_HR(:,:,c), tmp_LR(:,:,c));
            end
            psnr_score(end+1) = mean(pp);
            ssim_score(end+1) = mean(ss);
        end
        
        % average
        PSNR(i) = mean(psnr_score);
        SSIM(i) = mean(ssim_score);
        PSNR_var(i) = var(psnr_score);
        SSIM_var(i) = var(ssim_score);
        
        disp(PSNR(i));
        disp(SSIM(i));       

    end
    
    disp('PSNR');
    disp(PSNR);
    disp('SSIM');
    disp(SSIM);
    disp('PSNR_VAR');
    disp(PSNR_var);
    disp('SSIM_VAR');
    disp(SSIM_var);
    
    PSNR_mean = mean(PSNR);
    SSIM_mean = mean(SSIM);
 
    % write result to csv file
    d = size(PSNR, 1);
    w = zeros([d,4]);
    w(:,1) = PSNR;
    w(:,2) = PSNR_var;
    w(:,3) = SSIM;
    w(:,4) = SSIM_var;
    csvwrite(strcat(['Result_CSV/', 'Model_scale_', num2str(model_scale), '_depth_', num2str(depth),'_testscale_', num2str(test_scale), '.csv']),w)
    
    fprintf('Average PSNR = %f\n', PSNR_mean);
    fprintf('Average SSIM = %f\n', SSIM_mean);

