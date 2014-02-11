Optimizing the benchmark
===================================

The only difference in the optimized program is in inpoly function, where 
there is a for loop that loops through the points passed to it, and originally
they read by row, but in the optimized program, the matrix is transposed, and 
they are read by column, as in Matlab reading a matrix by column is faster.
