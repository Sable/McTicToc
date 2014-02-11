import subprocess
import re
import numpy

def run_on_matlab(scale):
    output = subprocess.check_output(["matlab", "-nodisplay", "-r", "run_pagerank(" + str(scale) + ")"])
    time = re.search(r'\"time\": (\d*\.\d*),', output).group(1)
    result = re.search(r'\"correct\": true', output)
    if result == None:
        raise Exception("Error while executing benchmark, obtained output: " + output)
    return float(time)

def run_on_octave(scale):
    output = subprocess.check_output(["octave", "--eval", "run_pagerank(" + str(scale) + ")"])
    time = re.search(r'\"time\": (\d*\.\d*),', output).group(1)
    result = re.search(r'\"correct\": true', output)
    if result == None:
        raise Exception("Error while executing benchmark, obtained output: " + output)
    return float(time)

#scales = [1,10,50,100]
#repetitions = 10
scales = [100]
repetitions = 10

for scale in scales:
    print "Results for scale: " + str(scale)
    # MATLAB
    matlab_times = []
    for i in range(repetitions):
        matlab_times.append(run_on_matlab(scale))
    print "MATLAB"
    print "-----------"
    print "min: " + str(min(matlab_times))
    print "max: " + str(max(matlab_times))
    print "average: " + str(numpy.mean(matlab_times))
    print "std: " + str(numpy.std(matlab_times))

    # Octave
    octave_times = []
    for i in range(repetitions):
        octave_times.append(run_on_octave(scale))
    print "Octave"
    print "-----------"
    print "min: " + str(min(octave_times))
    print "max: " + str(max(octave_times))
    print "average: " + str(numpy.mean(octave_times))
    print "std: " + str(numpy.std(octave_times)) 
    print 
