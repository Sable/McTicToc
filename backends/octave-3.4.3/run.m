arg_list = argv();
scale = str2num(arg_list{1});
jit_warmup = str2num(arg_list{2});
warmup_scale = str2num(arg_list{3});

if(jit_warmup == 1)
	[time, correct] = {{##benchmark##}}(warmup_scale);
end

	[time, correct] = {{##benchmark##}}(scale);

fprintf('<json>{');
fprintf('\"time\": %.3f, ', time);
fprintf('\"correct\": %s', correct);
fprintf('}</json>');

