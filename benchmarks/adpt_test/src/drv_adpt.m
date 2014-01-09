function drv_adpt(args)
%
% Driver for adaptive quadrature using Simpson's rule.
%

scale = args(1);
jit_warmup = 1;
warmup_scale = 10;

a=-1;
sz_guess=1;
tol=4e-13;

correctArr = [ -34.485 1.2263e-13;
			-34.526 5.8255e-14;
			-34.526 8.1013e-15;
			-34.526 7.7099e-17; ];

if(jit_warmup == 1)
	switch warmup_scale
		case 1
			b=6;
		case 10
			b=60;
		case 50
			b=600;
		otherwise
			b=6e4;
	end
	[SRmat, quad1, err] = adapt(a, b, sz_guess, tol);
end

switch (scale)
	case 1
		b=6;
		correct = correctArr(1, :);
	case 10
		b=60;
		correct = correctArr(2, :);
	case 50
		b=600;
		correct = correctArr(3, :);
	otherwise
		b=6e4;
		correct = correctArr(4, :);
end

tic
	[SRmat, quad1, err] = adapt(a, b, sz_guess, tol);
time = toc * 1000;
disp(correct);
disp([quad1 err]);
fprintf('<json>{');
if (isequal(correct, [quad1 err]))
	correct_answer = 'true';
else 
	correct_answer = 'false';
end
fprintf('\"time\": %.3f, ', time);
fprintf('\"correct\": %s', correct_answer);

fprintf('}</json>');

end
