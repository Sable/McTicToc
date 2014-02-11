
function [test] = miller_rabin(n, a)
    temp = n-1;
    k=0;
    
    while (mod(temp, 2) == 0)
        temp = temp/2;
        k = k + 1;
    end
    
    m = temp;
    b = expon(a, m, n);
    
    if (b == 1)
        %no composite
        test = false;
        return
    end
	
    for i=1:k
        if (b == n-1)
            test = false;
            return
        else
            b = expon(b, 2, n);
        end
    end
	
	test = true;
end
%does a primality test on n using the witness a
