Running the benchmark
===================================

To run this benchmark, execute engine function with scale parameter.
Scale parameter can be either of the following values:
	1 - Micro Run-time
	10 - Small Run-time
	50 - Medium Run-time
	100 - Large Run-time

It returns a set [p,v,stats] where p and v need to be compared to check
if the output matches, and stats is a structure that has various information
about the mesh that has been computed including the run time.