function img_HR = SR_Image(inputLF, net, opts, test_scale)

        [f_h, f_w, f_c, f_a] = size(inputLF);

	if test_scale == 4
	f_w_sub = floor(f_w/4/test_scale*2)*2;
	f_h_sub = floor(f_h/4/test_scale*2);
	else
	f_w_sub = floor(f_w/4);
	f_h_sub = floor(f_h/4);
	end
        
        % Split the testing image into 16 parts for SR separately (Currently hard coded)
	inputLF1 = inputLF(1:f_h_sub + 5,1:f_w_sub + 5, :, :);
	inputLF2 = inputLF(f_h_sub - 4:2*f_h_sub + 5,1:f_w_sub + 5, :, :);
	inputLF3 = inputLF(2*f_h_sub - 4:3*f_h_sub + 5,1:f_w_sub + 5, :, :);
	inputLF4 = inputLF(3*f_h_sub - 4:4*f_h_sub + 5,1:f_w_sub + 5, :, :);
	inputLF41 = inputLF(4*f_h_sub - 4:5*f_h_sub + 5,1:f_w_sub + 5, :, :);
	inputLF42 = inputLF(5*f_h_sub - 4:6*f_h_sub + 5,1:f_w_sub + 5, :, :);
	inputLF43 = inputLF(6*f_h_sub - 4:7*f_h_sub + 5,1:f_w_sub + 5, :, :);
	inputLF44 = inputLF(7*f_h_sub - 4:end,1:f_w_sub + 5, :, :);

	inputLF5 = inputLF(1:f_h_sub + 5,f_w_sub - 4:2*f_w_sub + 5, :, :);
	inputLF6 = inputLF(f_h_sub - 4:2*f_h_sub + 5,f_w_sub - 4:2*f_w_sub + 5, :, :);
	inputLF7 = inputLF(2*f_h_sub - 4:3*f_h_sub + 5,f_w_sub - 4:2*f_w_sub + 5, :, :);
	inputLF8 = inputLF(3*f_h_sub - 4:4*f_h_sub + 5,f_w_sub - 4:2*f_w_sub + 5, :, :);
	inputLF81 = inputLF(4*f_h_sub - 4:5*f_h_sub + 5,f_w_sub - 4:2*f_w_sub + 5, :, :);
	inputLF82 = inputLF(5*f_h_sub - 4:6*f_h_sub + 5,f_w_sub - 4:2*f_w_sub + 5, :, :);
	inputLF83 = inputLF(6*f_h_sub - 4:7*f_h_sub + 5,f_w_sub - 4:2*f_w_sub + 5, :, :);
	inputLF84 = inputLF(7*f_h_sub - 4:end,f_w_sub - 4:2*f_w_sub + 5, :, :);

	inputLF9 = inputLF(1:f_h_sub + 5,2*f_w_sub - 4:3*f_w_sub + 5, :, :);
	inputLF10 = inputLF(f_h_sub - 4:2*f_h_sub + 5,2*f_w_sub - 4:3*f_w_sub + 5, :, :);
	inputLF11 = inputLF(2*f_h_sub - 4:3*f_h_sub + 5,2*f_w_sub - 4:3*f_w_sub + 5, :, :);
	inputLF12 = inputLF(3*f_h_sub - 4:4*f_h_sub + 5,2*f_w_sub - 4:3*f_w_sub + 5, :, :);
	inputLF121 = inputLF(4*f_h_sub - 4:5*f_h_sub + 5,2*f_w_sub - 4:3*f_w_sub + 5, :, :);
	inputLF122 = inputLF(5*f_h_sub - 4:6*f_h_sub + 5,2*f_w_sub - 4:3*f_w_sub + 5, :, :);
	inputLF123 = inputLF(6*f_h_sub - 4:7*f_h_sub + 5,2*f_w_sub - 4:3*f_w_sub + 5, :, :);
	inputLF124 = inputLF(7*f_h_sub - 4:end,2*f_w_sub - 4:3*f_w_sub + 5, :, :);

	inputLF13 = inputLF(1:f_h_sub + 5,3*f_w_sub - 4:end-3, :, :);
	inputLF14 = inputLF(f_h_sub - 4:2*f_h_sub + 5,3*f_w_sub - 4:end-3, :, :);
	inputLF15 = inputLF(2*f_h_sub - 4:3*f_h_sub + 5,3*f_w_sub - 4:end-3, :, :);
	inputLF16 = inputLF(3*f_h_sub - 4:4*f_h_sub + 5,3*f_w_sub - 4:end-3, :, :);
	inputLF161 = inputLF(4*f_h_sub - 4:5*f_h_sub + 5,3*f_w_sub - 4:end-3, :, :);
	inputLF162 = inputLF(5*f_h_sub - 4:6*f_h_sub + 5,3*f_w_sub - 4:end-3, :, :);
	inputLF163 = inputLF(6*f_h_sub - 4:7*f_h_sub + 5,3*f_w_sub - 4:end-3, :, :);
	inputLF164 = inputLF(7*f_h_sub - 4:end,3*f_w_sub - 4:end-3, :, :);

	img_HR1 = SR_Spatial(inputLF1, net, opts);
	img_HR2 = SR_Spatial(inputLF2, net, opts);
	img_HR3 = SR_Spatial(inputLF3, net, opts);
	img_HR4 = SR_Spatial(inputLF4, net, opts);
	img_HR41 = SR_Spatial(inputLF41, net, opts);
	img_HR42 = SR_Spatial(inputLF42, net, opts);
	img_HR43 = SR_Spatial(inputLF43, net, opts);
	img_HR44 = SR_Spatial(inputLF44, net, opts);


	img_HR5 = SR_Spatial(inputLF5, net, opts);
	img_HR6 = SR_Spatial(inputLF6, net, opts);
	img_HR7 = SR_Spatial(inputLF7, net, opts);
	img_HR8 = SR_Spatial(inputLF8, net, opts);
	img_HR81 = SR_Spatial(inputLF81, net, opts);
	img_HR82 = SR_Spatial(inputLF82, net, opts);
	img_HR83 = SR_Spatial(inputLF83, net, opts);
	img_HR84 = SR_Spatial(inputLF84, net, opts);

	img_HR9 = SR_Spatial(inputLF9, net, opts);
	img_HR10 = SR_Spatial(inputLF10, net, opts);
	img_HR11 = SR_Spatial(inputLF11, net, opts);
	img_HR12 = SR_Spatial(inputLF12, net, opts);
	img_HR121 = SR_Spatial(inputLF121, net, opts);
	img_HR122 = SR_Spatial(inputLF122, net, opts);
	img_HR123 = SR_Spatial(inputLF123, net, opts);
	img_HR124 = SR_Spatial(inputLF124, net, opts);


	img_HR13 = SR_Spatial(inputLF13, net, opts);
	img_HR14 = SR_Spatial(inputLF14, net, opts);
	img_HR15 = SR_Spatial(inputLF15, net, opts);
	img_HR16 = SR_Spatial(inputLF16, net, opts);
	img_HR161 = SR_Spatial(inputLF161, net, opts);
	img_HR162 = SR_Spatial(inputLF162, net, opts);
	img_HR163 = SR_Spatial(inputLF163, net, opts);
	img_HR164 = SR_Spatial(inputLF164, net, opts);

	img_HR = zeros([f_h*test_scale, f_w*test_scale, f_c, f_a]);

	factor = test_scale /2;
	img_HR(1:2*factor*f_h_sub,1:2*factor*f_w_sub, :, :) = img_HR1(1:2*factor*f_h_sub, 1:2*factor*f_w_sub, :, :);
	img_HR(2*factor*f_h_sub + 1:4*factor*f_h_sub, 1:2*factor*f_w_sub,:,:) = img_HR2(factor*10+1:end-factor*10,1:2*factor*f_w_sub, :, :);
	img_HR(4*factor*f_h_sub + 1:6*factor*f_h_sub, 1:2*factor*f_w_sub,:,:) = img_HR3(factor*10+1:end-factor*10,1:2*factor*f_w_sub, :, :);
	img_HR(6*factor*f_h_sub + 1:8*factor*f_h_sub, 1:2*factor*f_w_sub,:,:) = img_HR4(factor*10+1:end-factor*10,1:2*factor*f_w_sub, :, :);
	img_HR(8*factor*f_h_sub + 1:10*factor*f_h_sub, 1:2*factor*f_w_sub,:,:) = img_HR41(factor*10+1:end-factor*10,1:2*factor*f_w_sub, :, :);
	img_HR(10*factor*f_h_sub + 1:12*factor*f_h_sub, 1:2*factor*f_w_sub,:,:) = img_HR42(factor*10+1:end-factor*10,1:2*factor*f_w_sub, :, :);
	img_HR(12*factor*f_h_sub + 1:14*factor*f_h_sub, 1:2*factor*f_w_sub,:,:) = img_HR43(factor*10+1:end-factor*10,1:2*factor*f_w_sub, :, :);
	img_HR(14*factor*f_h_sub + 1:end, 1:2*factor*f_w_sub,:,:) = img_HR44(factor*10+1:end,1:2*factor*f_w_sub, :, :);

	img_HR(1:2*factor*f_h_sub, 2*factor*f_w_sub + 1:4*factor*f_w_sub, :, :) = img_HR5(1:2*factor*f_h_sub, factor*10+1:end-factor*10, :, :);
	img_HR(2*factor*f_h_sub + 1:4*factor*f_h_sub, 2*factor*f_w_sub + 1:4*factor*f_w_sub,:,:) = img_HR6(factor*10+1:end-factor*10,factor*10+1:end-factor*10, :, :);
	img_HR(4*factor*f_h_sub + 1:6*factor*f_h_sub, 2*factor*f_w_sub + 1:4*factor*f_w_sub,:,:) = img_HR7(factor*10+1:end-factor*10,factor*10+1:end-factor*10, :, :);
	img_HR(6*factor*f_h_sub + 1:8*factor*f_h_sub, 2*factor*f_w_sub + 1:4*factor*f_w_sub,:,:) = img_HR8(factor*10+1:end-factor*10,factor*10+1:end-factor*10, :, :);
	img_HR(8*factor*f_h_sub + 1:10*factor*f_h_sub, 2*factor*f_w_sub + 1:4*factor*f_w_sub,:,:) = img_HR81(factor*10+1:end-factor*10,factor*10+1:end-factor*10, :, :);
	img_HR(10*factor*f_h_sub + 1:12*factor*f_h_sub, 2*factor*f_w_sub + 1:4*factor*f_w_sub,:,:) = img_HR82(factor*10+1:end-factor*10,factor*10+1:end-factor*10, :, :);
	img_HR(12*factor*f_h_sub + 1:14*factor*f_h_sub, 2*factor*f_w_sub + 1:4*factor*f_w_sub,:,:) = img_HR83(factor*10+1:end-factor*10,factor*10+1:end-factor*10, :, :);
	img_HR(14*factor*f_h_sub + 1:end, 2*factor*f_w_sub + 1:4*factor*f_w_sub,:,:) = img_HR84(factor*10+1:end,factor*10+1:end-factor*10, :, :);

	img_HR(1:2*factor*f_h_sub,4*factor*f_w_sub + 1:6*factor*f_w_sub, :, :) = img_HR9(1:2*factor*f_h_sub, factor*10+1:end-factor*10, :, :);
	img_HR(2*factor*f_h_sub + 1:4*factor*f_h_sub, 4*factor*f_w_sub + 1:6*factor*f_w_sub,:,:) = img_HR10(factor*10+1:end-factor*10,factor*10+1:end-factor*10, :, :);
	img_HR(4*factor*f_h_sub + 1:6*factor*f_h_sub, 4*factor*f_w_sub + 1:6*factor*f_w_sub,:,:) = img_HR11(factor*10+1:end-factor*10,factor*10+1:end-factor*10, :, :);
	img_HR(6*factor*f_h_sub + 1:8*factor*f_h_sub, 4*factor*f_w_sub + 1:6*factor*f_w_sub,:,:) = img_HR12(factor*10+1:end-factor*10,factor*10+1:end-factor*10, :, :);
	img_HR(8*factor*f_h_sub + 1:10*factor*f_h_sub, 4*factor*f_w_sub + 1:6*factor*f_w_sub,:,:) = img_HR121(factor*10+1:end-factor*10,factor*10+1:end-factor*10, :, :);
	img_HR(10*factor*f_h_sub + 1:12*factor*f_h_sub, 4*factor*f_w_sub + 1:6*factor*f_w_sub,:,:) = img_HR122(factor*10+1:end-factor*10,factor*10+1:end-factor*10, :, :);
	img_HR(12*factor*f_h_sub + 1:14*factor*f_h_sub, 4*factor*f_w_sub + 1:6*factor*f_w_sub,:,:) = img_HR123(factor*10+1:end-factor*10,factor*10+1:end-factor*10, :, :);
	img_HR(14*factor*f_h_sub + 1:end, 4*factor*f_w_sub + 1:6*factor*f_w_sub,:,:) = img_HR124(factor*10+1:end,factor*10+1:end-factor*10, :, :);

	img_HR(1:2*factor*f_h_sub,6*factor*f_w_sub + 1:end-12, :, :) = img_HR13(1:2*factor*f_h_sub, factor*10+1:end, :, :);
	img_HR(2*factor*f_h_sub + 1:4*factor*f_h_sub, 6*factor*f_w_sub + 1:end-12,:,:) = img_HR14(factor*10+1:end-factor*10,factor*10+1:end, :, :);
	img_HR(4*factor*f_h_sub + 1:6*factor*f_h_sub, 6*factor*f_w_sub + 1:end-12,:,:) = img_HR15(factor*10+1:end-factor*10,factor*10+1:end, :, :);
	img_HR(6*factor*f_h_sub + 1:8*factor*f_h_sub, 6*factor*f_w_sub + 1:end-12,:,:) = img_HR16(factor*10+1:end-factor*10,factor*10+1:end, :, :);
	img_HR(8*factor*f_h_sub + 1:10*factor*f_h_sub, 6*factor*f_w_sub + 1:end-12,:,:) = img_HR161(factor*10+1:end-factor*10,factor*10+1:end, :, :);
	img_HR(10*factor*f_h_sub + 1:12*factor*f_h_sub, 6*factor*f_w_sub + 1:end-12,:,:) = img_HR162(factor*10+1:end-factor*10,factor*10+1:end, :, :);
	img_HR(12*factor*f_h_sub + 1:14*factor*f_h_sub, 6*factor*f_w_sub + 1:end-12,:,:) = img_HR163(factor*10+1:end-factor*10,factor*10+1:end, :, :);
	img_HR(14*factor*f_h_sub + 1:end, 6*factor*f_w_sub + 1:end-12,:,:) = img_HR164(factor*10+1:end,factor*10+1:end, :, :);
