function img_HR = SR_Image(inputLF, net, opts, test_scale)

% -------------------------------------------------------------------------
%   Description:
%       Perform test on 16 sub light fields independently
%
%   Input:
%	- inputLF    : the input light field in Y layer
%       - net        : the Spatial SR model
%       - opts       : options
%       - test_scale : testing SR scale
%   Output:
%	- img_HR     : the super-resolved light field in Y layer
% -------------------------------------------------------------------------

        [f_h, f_w, f_c, f_a] = size(inputLF);

	if test_scale == 4
	f_w_sub = floor(f_w/4/test_scale*2)*2;
	f_h_sub = floor(f_h/4/test_scale*2)*2;
	else
	f_w_sub = floor(f_w/4);
	f_h_sub = floor(f_h/4);
	end
        
        % Split the testing image into 16 parts for SR separately (Currently hard coded)
	inputLF1 = inputLF(1:f_h_sub + 10,1:f_w_sub + 10, :, :);
	inputLF2 = inputLF(f_h_sub - 9:2*f_h_sub + 10,1:f_w_sub + 10, :, :);
	inputLF3 = inputLF(2*f_h_sub - 9:3*f_h_sub + 10,1:f_w_sub + 10, :, :);
	inputLF4 = inputLF(3*f_h_sub - 9:end,1:f_w_sub + 10, :, :);

	inputLF5 = inputLF(1:f_h_sub + 10,f_w_sub - 9:2*f_w_sub + 10, :, :);
	inputLF6 = inputLF(f_h_sub - 9:2*f_h_sub + 10,f_w_sub - 9:2*f_w_sub + 10, :, :);
	inputLF7 = inputLF(2*f_h_sub - 9:3*f_h_sub + 10,f_w_sub - 9:2*f_w_sub + 10, :, :);
	inputLF8 = inputLF(3*f_h_sub - 9:end,f_w_sub - 9:2*f_w_sub + 10, :, :);

	inputLF9 = inputLF(1:f_h_sub + 10,2*f_w_sub - 9:3*f_w_sub + 10, :, :);
	inputLF10 = inputLF(f_h_sub - 9:2*f_h_sub + 10,2*f_w_sub - 9:3*f_w_sub + 10, :, :);
	inputLF11 = inputLF(2*f_h_sub - 9:3*f_h_sub + 10,2*f_w_sub - 9:3*f_w_sub + 10, :, :);
	inputLF12 = inputLF(3*f_h_sub - 9:end,2*f_w_sub - 9:3*f_w_sub + 10, :, :);

	inputLF13 = inputLF(1:f_h_sub + 10,3*f_w_sub - 9:end, :, :);
	inputLF14 = inputLF(f_h_sub - 9:2*f_h_sub + 10,3*f_w_sub - 9:end, :, :);
	inputLF15 = inputLF(2*f_h_sub - 9:3*f_h_sub + 10,3*f_w_sub - 9:end, :, :);
	inputLF16 = inputLF(3*f_h_sub - 9:end,3*f_w_sub - 9:end, :, :);

	net = replace_layer(net, opts, f_h_sub + 10, f_w_sub + 10);
	img_HR1 = Spatial_SR(inputLF1, net, opts);
	net = replace_layer(net, opts, f_h_sub + 20, f_w_sub + 10);
	img_HR2 = Spatial_SR(inputLF2, net, opts);
	net = replace_layer(net, opts, f_h_sub + 20, f_w_sub + 10);
	img_HR3 = Spatial_SR(inputLF3, net, opts);
	net = replace_layer(net, opts, f_h - 3*f_h_sub + 10, f_w_sub + 10);
	img_HR4 = Spatial_SR(inputLF4, net, opts);

	net = replace_layer(net, opts, f_h_sub + 10, f_w_sub + 20);
	img_HR5 = Spatial_SR(inputLF5, net, opts);
	net = replace_layer(net, opts, f_h_sub + 20, f_w_sub + 20);
	img_HR6 = Spatial_SR(inputLF6, net, opts);
	net = replace_layer(net, opts, f_h_sub + 20, f_w_sub + 20);
	img_HR7 = Spatial_SR(inputLF7, net, opts);
	net = replace_layer(net, opts, f_h - 3*f_h_sub + 10, f_w_sub + 20);
	img_HR8 = Spatial_SR(inputLF8, net, opts);

	net = replace_layer(net, opts, f_h_sub + 10, f_w_sub + 20);
	img_HR9 = Spatial_SR(inputLF9, net, opts);
	net = replace_layer(net, opts, f_h_sub + 20, f_w_sub + 20);
	img_HR10 = Spatial_SR(inputLF10, net, opts);
	net = replace_layer(net, opts, f_h_sub + 20, f_w_sub + 20);
	img_HR11 = Spatial_SR(inputLF11, net, opts);
	net = replace_layer(net, opts, f_h - 3*f_h_sub + 10, f_w_sub + 20);
	img_HR12 = Spatial_SR(inputLF12, net, opts);

	net = replace_layer(net, opts, f_h_sub + 10, f_w - 3*f_w_sub + 10);
	img_HR13 = Spatial_SR(inputLF13, net, opts);
	net = replace_layer(net, opts, f_h_sub + 20, f_w - 3*f_w_sub + 10);
	img_HR14 = Spatial_SR(inputLF14, net, opts);
	net = replace_layer(net, opts, f_h_sub + 20, f_w - 3*f_w_sub + 10);
	img_HR15 = Spatial_SR(inputLF15, net, opts);
	net = replace_layer(net, opts, f_h - 3*f_h_sub + 10, f_w - 3*f_w_sub + 10);
	img_HR16 = Spatial_SR(inputLF16, net, opts);

	img_HR = zeros([f_h*test_scale, f_w*test_scale, f_c, f_a]);

	factor = test_scale /2;
	img_HR(1:2*factor*f_h_sub,1:2*factor*f_w_sub, :, :) = img_HR1(1:2*factor*f_h_sub, 1:2*factor*f_w_sub, :, :);
	img_HR(2*factor*f_h_sub + 1:4*factor*f_h_sub, 1:2*factor*f_w_sub,:,:) = img_HR2(factor*20+1:end-factor*20,1:2*factor*f_w_sub, :, :);
	img_HR(4*factor*f_h_sub + 1:6*factor*f_h_sub, 1:2*factor*f_w_sub,:,:) = img_HR3(factor*20+1:end-factor*20,1:2*factor*f_w_sub, :, :);
	img_HR(6*factor*f_h_sub + 1:end, 1:2*factor*f_w_sub,:,:) = img_HR4(factor*20+1:end,1:2*factor*f_w_sub, :, :);

	img_HR(1:2*factor*f_h_sub, 2*factor*f_w_sub + 1:4*factor*f_w_sub, :, :) = img_HR5(1:2*factor*f_h_sub, factor*20+1:end-factor*20, :, :);
	img_HR(2*factor*f_h_sub + 1:4*factor*f_h_sub, 2*factor*f_w_sub + 1:4*factor*f_w_sub,:,:) = img_HR6(factor*20+1:end-factor*20,factor*20+1:end-factor*20, :, :);
	img_HR(4*factor*f_h_sub + 1:6*factor*f_h_sub, 2*factor*f_w_sub + 1:4*factor*f_w_sub,:,:) = img_HR7(factor*20+1:end-factor*20,factor*20+1:end-factor*20, :, :);
	img_HR(6*factor*f_h_sub + 1:end, 2*factor*f_w_sub + 1:4*factor*f_w_sub,:,:) = img_HR8(factor*20+1:end,factor*20+1:end-factor*20, :, :);

	img_HR(1:2*factor*f_h_sub,4*factor*f_w_sub + 1:6*factor*f_w_sub, :, :) = img_HR9(1:2*factor*f_h_sub, factor*20+1:end-factor*20, :, :);
	img_HR(2*factor*f_h_sub + 1:4*factor*f_h_sub, 4*factor*f_w_sub + 1:6*factor*f_w_sub,:,:) = img_HR10(factor*20+1:end-factor*20,factor*20+1:end-factor*20, :, :);
	img_HR(4*factor*f_h_sub + 1:6*factor*f_h_sub, 4*factor*f_w_sub + 1:6*factor*f_w_sub,:,:) = img_HR11(factor*20+1:end-factor*20,factor*20+1:end-factor*20, :, :);
	img_HR(6*factor*f_h_sub + 1:end, 4*factor*f_w_sub + 1:6*factor*f_w_sub,:,:) = img_HR12(factor*20+1:end,factor*20+1:end-factor*20, :, :);

	img_HR(1:2*factor*f_h_sub,6*factor*f_w_sub + 1:end, :, :) = img_HR13(1:2*factor*f_h_sub, factor*20+1:end, :, :);
	img_HR(2*factor*f_h_sub + 1:4*factor*f_h_sub, 6*factor*f_w_sub + 1:end,:,:) = img_HR14(factor*20+1:end-factor*20,factor*20+1:end, :, :);
	img_HR(4*factor*f_h_sub + 1:6*factor*f_h_sub, 6*factor*f_w_sub + 1:end,:,:) = img_HR15(factor*20+1:end-factor*20,factor*20+1:end, :, :);
	img_HR(6*factor*f_h_sub + 1:end, 6*factor*f_w_sub + 1:end,:,:) = img_HR16(factor*20+1:end,factor*20+1:end, :, :);
