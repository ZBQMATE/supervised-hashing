% semisupervised hashing S3PLH
function TRS = semisupervised(train_data, train_label, validation_data, num_bits)
	
	[num_cases case_dim] = size(train_data);
	
	% construct pairwise label S1
	% S1 is <1000 * 1000>; 
	% sij = 1 if <xi xj> is same, 0 if contradict
	%<1000 * 1000> = <1000 * 10> * <10 * 1000>
	sss = train_label * train_label';
	
	%regulize parameter scalar
	reg_para = 0.1;
	%constant
	a = 0.1;
	www = zeros([case_dim num_bits]);
	xxx = train_data;
	xxx_un = validation_data;
	
	for k = 1 : num_bits
	
		% compute the regulized covariance matrix
		%mmm <256 * 256>
		mmm = (xxx' * sss * xxx) + reg_para * (xxx_un' * xxx_un);
		
		% extract the first eigenvector e from mk
		% vct <256 * 1>
		[vct, dia] = eigs(mmm, 1);
		www(:, k) = vct;
		
		% update the labels from vector wk
		
		% compute sss_yipiao
		% <1000 * 1000> = <1000 * 256> * <256 * 1> * <1 * 256> * <256 * 1000>
		sss_yipiao = xxx * www(:, k) * transpose(www(:, k)) * xxx';
		ttt = (sss_yipiao .* sss < 0) .* sss_yipiao;
		sss = sss - a * ttt;
		
		%compute the residual
		xxx_un = transpose(xxx_un' - www(:, k) * transpose(www(:, k)) * xxx_un');
		
	end
	%!!!!!!
	TRS = (validation_data - mean(mean(validation_data))) * www;