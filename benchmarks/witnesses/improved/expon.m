function [z] = expon(b, ex, m)
    x = bitget(ex, 32:-1:1);
    l = find(x, 1, 'first');
    z = 1;
	%do the square and multiply algorithm
	for i = l:32,
		z = mod(z*z, m);
		if (x(i) == 1)
			z = mod(z * b,  m);
	    end
	end

end
