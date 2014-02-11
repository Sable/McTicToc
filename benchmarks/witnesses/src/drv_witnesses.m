function [time, correctness] = drv_witnesses(scale)
%
% Driver for witness detection for primality testing
%
% The input for the benchmark is a composite number. The program will then return the number of witnesses that indicate that the number is prime. The two numbers returned are the strong witnesses (using the Miller-Rabin test) and the weak witnesses (using Fermat's Little Theorem). Therefore, witnesses(n) should be called, with n as a composite number. And the result should be checked against the true number of strong and weak witnesses.
%
% The inputs and answers below were derived from a C++ implemenation found in this directory. Higher input, as well as higher number of witnesses, will lead to a higher run-time.
%

candidate = 0;
correct = [0 0];
correctArr=[ 160 646;
			548 1598;
			96 194;
			20 62; ];

if (scale==1)
	candidate=6643;
	correct=correctArr(1, :);
elseif (scale==10)
	candidate=65641;
	correct=correctArr(2, :);
elseif (scale==50)
	candidate=196939;
	correct=correctArr(3, :);
else
	candidate=1181657;
	correct=correctArr(4, :);
end

tic
	[strong, weak ]= witnesses(candidate);
time = toc * 1000;
%strong
%weak
if(strong == correct(1) && weak == correct(2))
	correctness='true';
else
	correctness='false';
end
%correctness
end
