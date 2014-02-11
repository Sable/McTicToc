function benches(scale)

disp('Original benches')
disp(['Scale: ', num2str(scale)]);

nbruns = 10;
times = zeros(1, nbruns);

for i = 1 : nbruns
	[time, correct] = drv_coloring(scale);
	times(i) = time;
end

disp('Times:');
disp(times);

tmin = min(times);
tmax = max(times);
tavg = mean(times);
tstd = std(times);

disp(['Min: ', num2str(tmin)]);
disp(['Max: ', num2str(tmax)]);
disp(['Avg: ', num2str(tavg)]);
disp(['Std: ', num2str(tstd)]);

end

