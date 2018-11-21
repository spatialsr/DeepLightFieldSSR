function y = vl_nnreshape(x, dim, sp2an, h, w, dzdy)
% VL_NNRESHAPE Feature reshaping
%   Y = VL_NNRESHAPE(X, DIMS) reshapes the input data X to have
%   the dimensions specified by DIMS. X is a SINGLE array of 
%   dimension H x W x D x N where (H,W) are the height and width of 
%   the map stack, D is the image depth (number of feature channels) 
%   and N the number of of images in the stack. DIMS is a 1 x 3 array
%   of integers describing the dimensions that Y will take (batch 
%   size is preserved). In addition to positive integers, the 
%   following can also be specified in the style of caffe:
%
%   Interpretation of DIMS elements:
%   -1 := work it out from other dims
%    0 := copy dimension from X
%
%   NOTE: At most one dimension can be worked out from the others.
%
%   DZDX = VL_NNRESHAPE(X, DIMS, DZDY) computes the derivatives of the
%   block projected onto DZDY. DZDX and DZDY have the same dimensions
%   as X and Y respectively.

%assert(sum(dims == -1) <= 1, 'at most one dim can be computed from the others') ;
assert(length(dim) == 1, 'dims should have only one elements') ;
dim = dim(1);
%sz = size(x) ;

%copyDims = find(dims == 0) ;
%if copyDims
%    dims(copyDims) = sz(copyDims) ;
%end
%
%targetDim = find(dims == -1) ;
%if targetDim
%    idx = [1 2 3] ;
%    idx(targetDim) = [] ;
%    dims(targetDim) = prod(sz(1:3)) / prod(dims(idx)) ;
%end

%dims = horzcat(dims, size(x,4)) ;

if sp2an
    if nargin < 6 || isempty(dzdy)
        %disp(size(x));
        [h,w,c,n] = size(x);
        %y = gpuarray(zeros([dim,dim,c,h*w*n/64]));
        y = gpuArray([]);
        for k = 1:(n/64)
        x_tmp = x(:,:,:,1+(k-1)*64:k*64);
        x_tmp = permute(x_tmp, [4,3,1,2]);
        %y(:,:,:,1+(k-1)*h*w:k*h*w) = reshape(x_tmp, [dim, dim, c, h*w]);
        y = cat(4, y, reshape(x_tmp, [dim, dim, c, h*w]));
        end
    else
        c = size(dzdy, 3);
        n = size(dzdy, 4);
        %y = gpuarray(zeros([h,w,c,64*n/h/w]));
        y = gpuArray([]);
        for k = 1:(n/h/w)
        der_tmp = dzdy(:,:,:,1+(k-1)*h*w:k*h*w);
        der_tmp = reshape(der_tmp, [dim*dim, c, h, w]) ;
        %y(:,:,:,1+(k-1)*64:k*64) = permute(der_tmp, [3,4,2,1]);
        y = cat(4, y, permute(der_tmp, [3,4,2,1]));
        end
    end
else
    if nargin < 6 || isempty(dzdy)
        c = size(x, 3);
        n = size(x, 4);
        y = gpuArray([]);
        %y = zeros([h,w,c,64*n/h/w]);
        for k = 1:(n/h/w)
        x_tmp = x(:,:,:,1+(k-1)*h*w:k*h*w);
        x_tmp = reshape(x_tmp, [dim*dim, c, h, w]) ;
        %y(:,:,:,1+(k-1)*64:k*64) = permute(x_tmp, [3,4,2,1]);
        y = cat(4, y, permute(x_tmp, [3,4,2,1]));
        end
    else
        [h,w,c,n] = size(dzdy);
        %y = zeros([dim,dim,c,h*w*n/64]);
        y = gpuArray([]);
        for k = 1:(n/64)
        der_tmp = dzdy(:,:,:,1+(k-1)*64:k*64);
        der_tmp = permute(der_tmp, [4,3,1,2]);
        %y(:,:,:,1+(k-1)*h*w:k*h*w) = reshape(der_tmp, [dim, dim, c, h*w]);
        y = cat(4, y, reshape(der_tmp, [dim, dim, c, h*w]));
        end
    end
end
