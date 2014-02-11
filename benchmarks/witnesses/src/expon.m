function [z] = expon(b, ex, m)
    l = 0;
    shifted = 1;
    for l = 31:-1:0
        shifted = 2 .^ l;
		if (bitand(ex, shifted))
		    break;
		end
    end
    z = 1;
	%do the square and multiply algorithm
	
	j = 1;
	for i = l:-1:0,
		z = mod(z*z, m);
		j = 2 ^ i;
		if (bitand(j, ex))
			z = mod(z * b,  m);
	    end
	end
end
