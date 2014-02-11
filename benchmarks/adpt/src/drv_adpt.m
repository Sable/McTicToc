function [time, correctness] = drv_adpt(scale)
%
% Driver for adaptive quadrature using Simpson's rule.
%

a=-1;
sz_guess=1;
tol=4e-13;

correctArr=[ -34.485 1.2263e-13;
			-34.526 5.8255e-14;
			-34.526 8.1013e-15;
			-34.526 7.7099e-17; ];

if (scale==1)
	b=6;
	correct=correctArr(1, :);
elseif (scale==10)
	b=60;
	correct=correctArr(2, :);
elseif (scale==50)
	b=600;
	correct=correctArr(3, :);
else
	b=6e4;
	correct=correctArr(4, :);
end

tic
	[SRmat, quad1, err]=adpt(a, b, sz_guess, tol);
time = toc * 1000;

if(abs(quad1-correct(1))<1)
	correctness='true';
else
	correctness='false';
end

end
