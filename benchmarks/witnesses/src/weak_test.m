
function [num] = weak_test(n)
    num = 0;
    for a = 2:n-2
    
		if (expon(a, n-1, n) == 1)
			num = num + 1;
		end
	end
end
	
%use Fermat's Little Thm. to do a weak test for witnesses
%this counts the number of a's that say n is prime
