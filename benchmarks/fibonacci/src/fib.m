function f = fib(n)
	if ( n ~= floor(n) )
		error('Argument must be an integer.');
		return;
	end

	if ~isreal(n)
		error('Argument must be an integer.');
		return;
	end

	if size(n,1) ~= 1 || size(n,2) ~= 1
		error('Argument must be an integer.');
		return;
	end

	if (n < 0)
		f = (-1)^(n+1) * fib(-n);
		return;
	end

	if (n < 2)
		f = n;
		return;
	end

	f = fib(n-1) + fib(n-2);
	
end
