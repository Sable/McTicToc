function drv_fib(args)

	scale = args(1);
	jit_warmup = args(2);
	warmup_scale = args(3);

	correct = [1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987 1597 2584 4181 6765 10946 17711 28657 46368 75025 121393 196418 317811 514229 832040 1346269 2178309 3524578 5702887 9227465 14930352 24157817 39088169 63245986 102334155];
	
	if(jit_warmup == 1)
		switch warmup_scale
			case 1
				w_scale = 10;
			case 10
				w_scale = 20;
			case 50
				w_scale = 30;
			otherwise
				w_scale = 40;
		end
		f = fib(w_scale);
	end

	switch (scale)
		case 1
			b_scale = 1;
		case 10
			b_scale = 20;
		case 50
			b_scale = 30;
		otherwise
			b_scale = 40;
	end
	
	tic
		f = fib(b_scale);
	time = toc * 1000;
	fprintf('<json>{');
	if(correct(b_scale) == f)
		correct_answer = 'true';
	else 
		correct_answer = 'false';
	end
	fprintf('\"time\": %.3f, ', time);
	fprintf('\"correct\": %s', correct_answer);

	fprintf('}</json>');
end
