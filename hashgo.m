%supervised hashing methods
function hashgo(model)
	
	%parameters : run hash model, output bit length;
	
	warning('error', 'Octave:broadcast');
	
	if exist('page_output_immediately')
		page_output_immediately(1);
	end
	
	more off;
	
	from_data_file = load('data.mat');
	usps_data = from_data_file.data;
	
	% 256 * 9000 testing data, 256 * 1000 training data, 256 * 1000 validation data
	
	train_batch.inputs = usps_data.training.inputs;
	train_batch.targets = usps_data.training.targets;
	
	validation_batch.inputs = usps_data.validation.inputs;
	validation_batch.targets = usps_data.validation.targets;
	
	%train_data <1000 * 256>
	train_data = transpose(train_batch.inputs);
	validation_data = transpose(validation_batch.inputs);
	
	%train_label <1000 * 10>
	train_label = transpose(train_batch.targets);
	
	[num_cases case_dim] = size(train_data);
	[num_cases_vali case_dim_vali] = size(validation_data);
	
	for bits = [8, 16, 32]
		
		%************* choose model **************
		
		% TRS_MTX <num_cases * num_bits> based on validation data
		
		%model 1, semi supervised hashing
		if model == 1
			TRS_MTX = semisupervised(train_data, train_label, validation_data, bits);
		end
		
		%model 2, 
		
		%binary hash code, <num_cases * num_bits>
		BIN_HASH = TRS_MTX > 0;
		
		% ********* check the result *********
		
		%check total hamming distance in a same label
		temp = zeros([num_cases/10 bits]);
		idx = 1;
		hamming_distance = 0;
		
		for tgt = 1 : 10
			
			for i = 1 : num_cases
				if validation_batch.targets(tgt, i) == 1
					temp(idx, :) = BIN_HASH(i, :);
					idx++;
				end
			end
			
			for i = 1 : (num_cases/10)
				for j = 1 : (num_cases/10)
					hamming_distance = hamming_distance + sum(temp(i, :) - temp(j, :) != 0);
				end
			end
			
			idx = 1;
			temp = zeros([num_cases/10 bits]);
			
		end
		
		fprintf('\n total hamming diatance %d', hamming_distance);
		
	end