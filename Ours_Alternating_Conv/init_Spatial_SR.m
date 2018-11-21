function net = init_Spatial_SR(opts)
% -------------------------------------------------------------------------
%   Description:
%       create initial Spatial SR model
%       Modified from the code produced by the authors in the citation below
%
%   Input:
%       - opts  : options generated from init_opts()
%
%   Output:
%       - net   : dagnn model
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

    %% parameters
    rng('default');
    rng(0) ;
    
    % filter width
    f       = opts.conv_f;
    % number of filters set to 64
    n       = opts.conv_n;
    % angular resolution should be 64 
    a       = opts.conv_a;
    pad     = floor(f/2);
    depth   = opts.depth;
    scale   = opts.scale;
    if( scale == 2 || scale == 3)
        level = 1;
    else
        level = 2;
    end
    h = opts.patch_size/scale;
    w = h;
    if( scale == 2 || scale == 4)
        crop = 1; crop1 = [0,1,0,1]; scale = 2;
    elseif( scale == 3 )
        crop = [0, 1, 0, 1]; crop1 = 0;
    else
        error('Please use scale 2, 3 or 4');
    end
   
    net = dagnn.DagNN;
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Feature extraction branch
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    sigma   = opts.init_sigma;
    filters = sigma * randn(f, f, 1, n, 'single');
    biases  = zeros(1, n, 'single');
    
    % conv
    inputs  = { 'LR' };
    outputs = { 'input_conv' };
    params  = { 'input_conv_f', 'input_conv_b' };
    
    net.addLayer(outputs{1}, ...
                 dagnn.Conv('size', size(filters), ...
                            'pad', pad, ...
                            'stride', 1), ...
                 inputs, outputs, params);

    idx = net.getParamIndex(params{1});
    net.params(idx).value         = filters;
    net.params(idx).learningRate  = 1;
    net.params(idx).weightDecay   = 1;

    idx = net.getParamIndex(params{2});
    net.params(idx).value         = biases;
    net.params(idx).learningRate  = 0.1;
    net.params(idx).weightDecay   = 1;
    
    % ReLU
    inputs  = { 'input_conv' };
    outputs = { 'input_relu' };
    
    net.addLayer(outputs{1}, ...
                 dagnn.ReLU('leak', 0.2), ...
                 inputs, outputs);
    
    next_input = outputs{1};
    
    %% deep conv layers (f x f x 1 x n)    
    sigma   = sqrt( 2 / (f * f * n) );
    
    for s = level : -1 : 1
        
        % conv layers (f x f x 1 x n) (both spatial and angular)
        for d = 1:depth
            
            filters = sigma * randn(f, f, n, n, 'single');
            biases  = zeros(1, n, 'single');

            % conv: Spatial Filter
            inputs  = { next_input };
            outputs = { sprintf('level%d_conv%d', s, d) };
            params  = { sprintf('level%d_conv%d_f', s, d), ...
                        sprintf('level%d_conv%d_b', s, d)};

            net.addLayer(outputs{1}, ...
                         dagnn.Conv('size', size(filters), ...
                                    'pad', pad, ...
                                    'stride', 1), ...
                         inputs, outputs, params);

            idx = net.getParamIndex(params{1});
            net.params(idx).value         = filters;
            net.params(idx).learningRate  = 1;
            net.params(idx).weightDecay   = 1;

            idx = net.getParamIndex(params{2});
            net.params(idx).value         = biases;
            net.params(idx).learningRate  = 0.1;
            net.params(idx).weightDecay   = 1;
            
            % ReLU
            inputs  = { sprintf('level%d_conv%d', s, d) };
            outputs = { sprintf('level%d_relu%d', s, d) };

            net.addLayer(outputs{1}, ...
                         dagnn.ReLU('leak', 0.2), ...
                     inputs, outputs);
            
            %Reshape Layer
            inputs  = { sprintf('level%d_relu%d', s, d) };
            outputs = { sprintf('level%d_reshape%d', s, d) };

            net.addLayer(outputs{1}, ...
                         dagnn.Reshape('dims', sqrt(a), ...
                                       'w', w/s, ...
                                       'h', h/s, ...
                                       'sp2an', true), ...
                     inputs, outputs);
                 
            % conv: Angular Filter
            
            inputs  = { sprintf('level%d_reshape%d', s, d) };
            outputs = { sprintf('level%d_conv_an%d', s, d) };
            params  = { sprintf('level%d_conv_an%d_f', s, d), ...
                        sprintf('level%d_conv_an%d_b', s, d)};

            net.addLayer(outputs{1}, ...
                         dagnn.Conv('size', size(filters), ...
                                    'pad', pad, ...
                                    'stride', 1), ...
                         inputs, outputs, params);

            idx = net.getParamIndex(params{1});
            net.params(idx).value         = filters;
            net.params(idx).learningRate  = 1;
            net.params(idx).weightDecay   = 1;

            idx = net.getParamIndex(params{2});
            net.params(idx).value         = biases;
            net.params(idx).learningRate  = 0.1;
            net.params(idx).weightDecay   = 1;

            % ReLU
            inputs  = { sprintf('level%d_conv_an%d', s, d) };
            outputs = { sprintf('level%d_relu_an%d', s, d) };

            net.addLayer(outputs{1}, ...
                         dagnn.ReLU('leak', 0.2), ...
                     inputs, outputs);
            
            %Reshape Layer
            inputs  = { sprintf('level%d_relu_an%d', s, d) };
            outputs = { sprintf('level%d_reshape_an%d', s, d) };

            net.addLayer(outputs{1}, ...
                         dagnn.Reshape('dims', sqrt(a), ...
                                       'w', w/s, ...
                                       'h', h/s, ...
                                       'sp2an', false), ...
                     inputs, outputs);

            next_input = outputs{1};
            
        end
        
        %% features upsample layers
        filters = sigma * randn(f, f, n, n, 'single');
        biases  = zeros(1, n, 'single');
        
        inputs  = { next_input };
        outputs = { sprintf('level%d_upconv', s) };
        params  = { sprintf('level%d_upconv_f', s), ...
                    sprintf('level%d_upconv_b', s) };
                    
        net.addLayer(outputs{1}, ...
                     dagnn.ConvTranspose(...
                         'size', size(filters), ...
                         'upsample', scale, ...
                         'crop', crop1, ...
                         'numGroups', 1, ...
                         'hasBias', true), ...
                     inputs, outputs, params) ;
        
        idx = net.getParamIndex(params{1});
        net.params(idx).value         = filters;
        net.params(idx).learningRate  = 1;
        net.params(idx).weightDecay   = 1;
        
        idx = net.getParamIndex(params{2});
        net.params(idx).value         = biases;
        net.params(idx).learningRate  = 0.1;
        net.params(idx).weightDecay   = 1;
        
        %% ReLU
        inputs  = { sprintf('level%d_upconv', s) };
        outputs = { sprintf('level%d_uprelu', s) };

        net.addLayer(outputs{1}, ...
                     dagnn.ReLU('leak', 0.2), ...
                     inputs, outputs);
                 
        next_input = outputs{1};
        
        %% residual prediction layer (f x f x n x 1)
        sigma   = sqrt(2 / (f * f * n));
        filters = sigma * randn(f, f, n, 1, 'single');
        biases  = zeros(1, 1, 'single');
        
        inputs  = { next_input };
        outputs = { sprintf('level%d_residual', s) };
        params  = { sprintf('level%d_residual_conv_f', s), ...
                    sprintf('level%d_residual_conv_b', s) };
        
        net.addLayer(outputs{1}, ...
            dagnn.Conv('size', size(filters), ...
                       'pad', pad, ...
                       'stride', 1), ...
            inputs, outputs, params);
        
        idx = net.getParamIndex(params{1});
        net.params(idx).value         = filters;
        net.params(idx).learningRate  = 1;
        net.params(idx).weightDecay   = 1;
        
        idx = net.getParamIndex(params{2});
        net.params(idx).value         = biases;
        net.params(idx).learningRate  = 0.1;
        net.params(idx).weightDecay   = 1;
        
        
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Image reconstruction branch
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    next_input = 'LR';
 
    for s = level : -1 : 1
        
        %% image upsample layer
        filters = single(bilinear_kernel(4, 1, 1));

        inputs  = { next_input };
        outputs = { sprintf('level%d_img_up', s) };
        params  = { sprintf('level%d_img_up_f', s) };

        net.addLayer(outputs{1}, ...
            dagnn.ConvTranspose(...
                'size', size(filters), ...
                'upsample', scale, ...
                'crop', crop, ...
                'numGroups', 1, ...
                'hasBias', false), ...
            inputs, outputs, params) ;

        idx = net.getParamIndex(params{1});
        net.params(idx).value         = filters;
        net.params(idx).learningRate  = 1;
        net.params(idx).weightDecay   = 1;

        
        %% residual addition layer
        inputs  = { sprintf('level%d_img_up', s), ...
                    sprintf('level%d_residual', s) };
        outputs = { sprintf('level%d_output', s) };
        net.addLayer(outputs{1}, ...
            dagnn.Sum(), ...
            inputs, outputs);
        
        next_input = outputs{1};
        
        %% Loss layer
        inputs  = { next_input, ...
                    sprintf('level%d_HR', s) };
        outputs = { sprintf('level%d_%s_loss', s, opts.loss) };
        
        net.addLayer(outputs{1}, ...
                 dagnn.vllab_dag_loss(...
                    'loss_type', opts.loss), ...
                 inputs, outputs);
             
    end   
             

end
