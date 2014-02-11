function [gridOUTPUT] = Benchmark(runtime)

coordVertices(:,:,1) = load('coords1.txt');
coordVertices(:,:,2) = load('coords2.txt');
coordVertices(:,:,3) = load('coords3.txt');

if(runtime == 1)
    [gridOUTPUT] = VOXELISE(50,  50,  50,  coordVertices, 'xyz');
elseif(runtime == 10)
    [gridOUTPUT] = VOXELISE(160, 160, 160, coordVertices, 'xyz');
elseif(runtime == 50)
    [gridOUTPUT] = VOXELISE(350, 350, 350, coordVertices, 'xyz');
elseif(runtime == 100)
    [gridOUTPUT] = VOXELISE(500, 500, 500, coordVertices, 'xyz');   
else
    disp('The valid inputs are 1, 10, 50, or 100.')
end

end