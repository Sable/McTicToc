
function [strong_w] = strong_test(n)

	strong_w = 0;
	for a=2:n-2
	    %returns not composite
		if (miller_rabin(n, a) == false)
		    strong_w = strong_w + 1;
		end
	end
end
%checks the number of a's that fail the miller-rabin test
%i.e. these a's say n is prime
