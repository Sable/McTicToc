
function [strong_w] = strong_test(n)

	strong_w = 0;
	for a=2:n-2
		if (miller_rabin(n, a) == false)%returns not composite
		    strong_w = strong_w + 1;
		end
	end
end

%checks the number of a's that fail the miller-rabin test
%i.e. these a's say n is prime
