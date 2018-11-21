%
% Mattia Rossi (mattia.rossi@epfl.ch)
% Signal Processing Laboratory 4 (LTS4)
% Ecole Polytechnique Federale de Lausanne (Switzerland)
%
function z = lf2col(Z)
% lf2col vectorizes the input light field 'Z'. The 2D cell array 'Z' is
% scanned in column major order, and the same for its views 'Z{t,s}'.
% If the views 'Z{t,s}' have more than one channel, then all the light fields
% (one for each channel) are vectorized separately, and then the vectorized
% light fields are stacked together.
%
% INPUT:
% Z - a 2D cell array storing the views as its entries.
%
% OUTPUT:
% z - the vectorized light field.

aux = cell2mat(Z(:)');
z = aux(:);

end

