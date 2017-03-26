% kernel based supervised hashing
function TRS = kernelbased(train_data, train_label, validation_data, num_bits)
	
	[num_cases case_dim] = size(train_data);
	
	% construct pairwise label S1
	%<1000 * 1000>
	
	sss = train_label * train_label';
	
	% uniformly choose m support samples
	m = 100;
	support_samples = zeros([m case_dim]);
	gap_m = num_cases / m;
	j = 1;
	for i = 1 : (2 * gap_m) : num_cases
		support_samples(j, :) = train_data(i, :);
		j++;
	end
	j = 1;
	for i = 1 : (2 * gap_m) : num_cases
		support_samples((m/2+j), :) = validation_data(i, :);
		j++;
	end
	
	%compute zero centered m dim kernel vectors k_bar
	k_bar = zeros([])
	
% kernel function
function KNL = kernel(xa, xb)
	%xa, xb <1 * 256>, KNL is scalar
	% gaussian
	y = 1;
	KNL = exp(-y*((norm(xa - xb))^2));