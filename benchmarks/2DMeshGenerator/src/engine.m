function [time, correct] = engine(scale)

switch(scale)
	case 1
	  theta = 0:pi/50:(2*pi-pi/50);
      x = cos(theta)/2;
      y = sin(theta)/2;

      node = [ x',y'; -5,-5; 5,-5; 5,15; -5,15];

      n = size(node,1)-4;
      edge = [(1:n-1)', (2:n)'; n,1; n+1,n+2; n+2,n+3; n+3,n+4; n+4,n+1];

      hdata.hmax = 0.5;

	  options.output = false;
	tic;
      [p,t,stats] = mesh2d(node,edge,hdata,options);
	time = toc*1000;
	case 10
	  theta = 0:pi/50:(2*pi-pi/50);
      x = cos(theta)/2;
      y = sin(theta)/2;

      node = [ x',y'; -5,-5; 5,-5; 5,15; -5,15];

      n = size(node,1)-4;
      edge = [(1:n-1)', (2:n)'; n,1; n+1,n+2; n+2,n+3; n+3,n+4; n+4,n+1];

      hdata.hmax = 11.25;
	  node = 100*node;
	  options.output = false;
	tic;
      [p,t,stats] = mesh2d(node,edge,hdata,options);
	time = toc*1000;
	case 50
	  theta = 0:pi/50:(2*pi-pi/50);
      x = cos(theta)/2;
      y = sin(theta)/2;

      node = [ x',y'; -5,-5; 5,-5; 5,15; -5,15];

      n = size(node,1)-4;
      edge = [(1:n-1)', (2:n)'; n,1; n+1,n+2; n+2,n+3; n+3,n+4; n+4,n+1];

      hdata.hmax = 5.5264;
	  node = 100*node;
	  options.output = false;
	tic;
      [p,t,stats] = mesh2d(node,edge,hdata,options);
	time = toc*1000;
	case 100
	  node = [0,0; 4,0; 4,1; 2,1; 2,2; 4,2; 4,3; 0,3];
	  A = 45*pi/180;
	  T = [ cos(A), sin(A)
  	     -sin(A), cos(A)];
	  node = (T*node')';
      hdata.hmax = 1.0417;
	  node = 100*node;
	  options.output = false;
	tic;
      [p,t,stats] = mesh2d(node,[],hdata,options);
	time = toc*1000;

end
correct = 'true';

end

%Notes
%hmax = 5, time = 161.6
%hmax = 10, time = 33 ish
%hmax = 8, time = 33
%hmax = 7, time = 33
%hmax = 5.5, time = 65
%hmax = 5.75, time = 38
%hmax = 5.65, time = 42
%hmax = 5.58, time = 44
%hmax = 5.55, time = 47
%hmax = 5.20835, time = 59.54
%hmax = 5.2083, time  = 166
%
%7
%hmax 2 -> 47.8s
%hmax 4 -> 9.67s
%
%
