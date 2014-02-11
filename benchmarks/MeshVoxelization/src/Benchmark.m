function [time, correct] = Benchmark(runtime)

coordVertices(:,:,1) = load('coords1.txt');
coordVertices(:,:,2) = load('coords2.txt');
coordVertices(:,:,3) = load('coords3.txt');
tic
if(runtime == 1)
    [gridOUTPUT] = VOXELISE(50,  50,  50,  coordVertices, 'xyz');
elseif(runtime == 10)
    [gridOUTPUT] = VOXELISE(160, 160, 160, coordVertices, 'xyz');
elseif(runtime == 50)
    [gridOUTPUT] = VOXELISE(350, 350, 350, coordVertices, 'xyz');
else
    [gridOUTPUT] = VOXELISE(500, 500, 500, coordVertices, 'xyz');
end
time=toc*1000;
correct='true';
end
