function [time, correct] = driver_mozart(scale)
    tic
    switch scale 
        case 1 
            res = run_benchmark('mozart-512x512.ppm', 15);
        case 10
            res = run_benchmark('mozart-1024x1024.ppm', 20);
        case 50
            res = run_benchmark('mozart-2048x2048.ppm', 15);
        otherwise
            res = run_benchmark('mozart-4096x4096.ppm', 25);
    end
    time = toc*1000;
    correct='true';
end

function [res] = run_benchmark(img, kIter)
    times = zeros(1, 10);
    for i = 1:10
        tic;
        mozart(img, kIter, 0.5, [0 0 -1], 42, 0);
        times(1, i) = toc;
    end
    
    res = [min(times) max(times) mean(times) std(times)];
end

