function [time, correctness] = drv_coloring(scale)
%
% Driver for class hierarchy coloring based on the Ducourneau's algorithm.
%
% Ref: R. Ducournau, "Coloring, a versatile technique for implementing object-oriented languages,"
% Software: Practice and Experience, vol. 41, pp. 627–659, May 2011.
%
% This script use some external data files:
%
%	scale.classes: class ids as an array of integers
%	1 2 3 4
%
%   scale.datas: inheritance matrix with the following format:
%	1 0 0 0
%	2 1 0 0
%	2 0 1 0
%	3 2 2 1
%
%		Rows and columns represent classes
%		Indexes match class ids
%		Each row represents a class and each line represents possible super-classes
%		Possible values are:
%		  0 - no inheritance
%		  1 - class itself
%		  2 - direct parent
%		  3 - ancestor
%
%	scale.results: the result colors array to check with
%	1 4 2 3
%
%	Datas directory can be changed with the `datasdir` var
datasdir = '../datas/';

% Classes are represented by an array of integer ids
global classes;

% Classes inheritance is represented by an adjacency matrix
global matrix;

% class sorting algorithm
global sortc;
sortc = @bubble_sort;

% Run-time scale are
%   1: micro run-time (around 1 sec)
%   10: small run-time (around 10 sec)
%   50: medium run-time (aroud 30 secs)
%   100: larger run-time (around 5 min or longer)
if (scale == 1)
	% micro run-time scale inputs
	classes = load(strcat(datasdir, 'micro.classes'));
	matrix = load(strcat(datasdir, 'micro.datas'));
	correct = load(strcat(datasdir, 'micro.results'));
elseif (scale==10)
	% small run-time scale
	classes = load(strcat(datasdir, 'small.classes'));
	matrix = load(strcat(datasdir, 'small.datas'));
	correct = load(strcat(datasdir, 'small.results'));
elseif (scale==50)
	% medium run-time scale
	classes = load(strcat(datasdir, 'medium.classes'));
	matrix = load(strcat(datasdir, 'medium.datas'));
	correct = load(strcat(datasdir, 'medium.results'));
elseif (scale==100)
	% larger run-time scale
	classes = load(strcat(datasdir, 'larger.classes'));
	matrix = load(strcat(datasdir, 'larger.datas'));
	correct = load(strcat(datasdir, 'larger.results'));
else
	% larger run-time scale
	classes = load(strcat(datasdir, 'test.classes'));
	matrix = load(strcat(datasdir, 'test.datas'));
	correct = load(strcat(datasdir, 'test.results'));
end

% run the benchmarks
tic
	colors = coloring();
time = toc;

% check results correctness
if(colors == correct)
	correctness='true';
else
	correctness='false';
end

%disp('classes:');
%disp(classes);
%disp('colors:');
%disp(colors);
disp(['correctness: ', correctness]);

end
