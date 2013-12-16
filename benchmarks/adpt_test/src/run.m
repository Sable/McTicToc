arg_list = argv();

scale = str2num(arg_list{1});
warmup = str2num(arg_list{2});
wscale = str2num(arg_list{2});

tic;

drv_adpt(scale);

time = toc * 1000

