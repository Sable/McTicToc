angular.module('app', []).constant('partialUrl', './partials').run([
  '$rootScope',
  'partialUrl',
  function ($rootScope, partialUrl) {
    $rootScope.partialUrl = partialUrl;
  }
]);
angular.module('app').controller('BenchmarkViewCtrl', [
  '$routeParams',
  function ($routeParams) {
  }
]);
angular.module('app').controller('ExperimentRunnerCtrl', [
  '$scope',
  '$rootScope',
  '$http',
  'benchmarkData',
  function ($scope, $rootScope, $http, benchmarkData) {
    $scope.data = {
      'backend': {
        'name': 'Octave',
        'version': '3.4.3'
      },
      'benchmark': {
        'name': 'escoufier',
        'version': '1.0',
        'iteration': 3,
        'scale': 22
      }
    };
    $scope.isPolling = false;
    $scope.sendRunCommand = function () {
      $scope.isPolling = true;
      $scope.data.benchmark.iteration = parseInt($scope.data.benchmark.iteration, 10);
      $scope.data.benchmark.scale = parseInt($scope.data.benchmark.scale, 10);
      $http.post('http://184.107.193.50:8080/performance/run', $scope.data).success(function (response) {
        var taskId = response.result[1].id, intervalId = setInterval(pollTaskStatus, 2000);
        function pollTaskStatus() {
          jQuery.get('http://184.107.193.50:8080/tasks/' + taskId).success(function (response) {
            console.log(response.result.status, response.result.status === 'done');
            if (response.result.status === 'done') {
              clearInterval(intervalId);
              $scope.$apply(function () {
                benchmarkData.getAll();
                $scope.isPolling = false;
              });
            } else if (response.result.status === 'failed') {
              clearInterval(intervalId);
              $scope.$apply('isPollied = false');
            }
          }).error(function () {
            clearInterval(intervalId);
            $scope.$apply('isPollied = false');
          });
        }
      }).error(function () {
        alert('An error occurred!');
        console.log('error running the tasks', arguments);
        $scope.isPolling = false;
      });
    };
    $scope.open = function (evt, data) {
      if (!data) {
        data = {
          'benchmark': {
            'name': $scope.benchmark.instances[0].benchmarkName,
            'version': $scope.benchmark.instances[0].benchmarkVersion
          }
        };
      }
      jQuery.extend(true, $scope.data, data);
      $scope.shouldBeOpen = true;
    };
    $rootScope.$on('openExperimentRunner', $scope.open);
    $scope.close = function () {
      $scope.closeMsg = 'I was closed at: ' + new Date();
      $scope.shouldBeOpen = false;
    };
    $scope.items = [
      'item1',
      'item2'
    ];
    $scope.opts = {
      backdropFade: true,
      dialogFade: true
    };
  }
]);
angular.module('app').controller('MainCtrl', [
  '$scope',
  '$location',
  'benchmarkData',
  function ($scope, $location, benchmarkData) {
    $scope.benchmarks = benchmarkData.getAll();
    $scope.benchmark = null;
    $scope.useLogScaleForBubbleSize = false;
    $scope.toogleButtonScale = function () {
      $scope.useLogScaleForBubbleSize = !$scope.useLogScaleForBubbleSize;
    };
    $scope.selectBenchmark = function (benchmark) {
      $scope.benchmark = benchmark;
      if (benchmark) {
        $location.url('/benchmark/' + benchmarkUrl(benchmark));
      }
    };
    var stopBenchmarksWatch = $scope.$watch('benchmarks.length', function (length) {
        if (length) {
          if ($location.url().indexOf('/benchmark/') == 0) {
            var benchmarkName = $location.url().match(/^\/benchmark\/(.+)/);
            if (benchmarkName) {
              benchmarkName = benchmarkName[1];
              angular.forEach($scope.benchmarks, function (benchmark) {
                if (benchmarkName === benchmarkUrl(benchmark)) {
                  $scope.selectBenchmark(benchmark);
                }
              });
            } else {
              $scope.selectBenchmark($scope.benchmarks[0]);
            }
          } else {
            $scope.selectBenchmark($scope.benchmarks[0]);
          }
          stopBenchmarksWatch();
        }
      });
    function benchmarkUrl(benchmark) {
      return encodeURIComponent(benchmark.name.replace(/ /, '-'));
    }
  }
]);
angular.module('app').directive('bs3Modal', [
  '$parse',
  '$timeout',
  function ($parse, $timeout) {
    return function (scope, element, attr) {
      var setter = $parse(attr.bs3Modal).assign;
      scope.$watch(attr.bs3Modal, function (value) {
        if (value) {
          element.modal('show');
        } else {
          element.modal('hide');
        }
      });
      element.on('show.bs.modal', setScopeValue(true));
      element.on('hide.bs.modal', setScopeValue(false));
      function setScopeValue(value) {
        return setter ? function () {
          $timeout(function () {
            setter(scope, value);
          });
        } : angular.noop;
      }
    };
  }
]);
angular.module('app').directive('matlabSrcSyntaxHighlighting', [
  '$http',
  function ($http) {
    return {
      link: function (scope, element, attr) {
        var fibonacciSrc = '' + 'correct = [1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987 1597 2584 4181 6765 10946 17711 28657 46368 75025 121393 196418 317811 514229 832040 1346269 2178309 3524578 5702887 9227465 14930352 24157817 39088169 63245986 102334155];' + '' + 'arg_list = argv();\n' + 'scale = str2num(arg_list{1});\n' + 'iteration = str2num(arg_list{2});\n' + '' + '% Fibonacci.m by David Terr, Raytheon, 5-11-04\n' + '' + 'function fib = Fibonacci(n)\n' + '' + 'if ( n ~= floor(n) )\n' + '    error(\'Argument must be an integer.\');\n' + '    return;\n' + 'end\n' + '' + 'if ~isreal(n)\n' + '    error(\'Argument must be an integer.\');\n' + '    return;\n' + 'end\n' + '' + 'if size(n,1) ~= 1 || size(n,2) ~= 1\n' + '    error(\'Argument must be an integer.\');\n' + '    return;\n' + 'end\n' + '' + 'if ( n == 0 )\n' + '    fib = 0;\n' + '    return;\n' + 'end\n' + '' + 'if ( n == 1 )\n' + '    fib = 1;\n' + '    return;\n' + 'end\n' + '' + 'if ( n < 0 )\n' + '    fib = (-1)^(n+1) * Fibonacci(-n);\n' + '    return;\n' + 'end\n' + '' + 'fib = Fibonacci(n-1) + Fibonacci(n-2);\n' + '' + 'end\n' + '\n' + '\n' + 'for n = 1:iteration\n' + '    value = Fibonacci(scale);\n' + '    if ((correct(scale) != value)) \n' + '        exit(1);\n' + '    end\n' + 'end\n' + 'exit(0);';
        var sources = { 'fibonacci 1.0': fibonacciSrc };
        function addExecutionByNumber() {
          $http.get('http://184.107.193.50:8080/instrumentations/756271991/results').success(function (data) {
            var lis = element.find('li:not(:last-child)');
            angular.forEach(data.result.data[0].lines, function (info) {
              var li = lis.eq(info.line - 1);
              if (jQuery.trim(li.text())) {
                li.append('<span style="float: right">' + info.executed + '</span>');
              }
            });
          });
        }
        scope.$watch(attr.benchmarkName, function (name) {
          if (sources.hasOwnProperty(name)) {
            element.html(sources[name]);
            prettyPrint();
            addExecutionByNumber();
          } else {
            var info = name.split(' ');
            $http.post('http://184.107.193.50:8080/benchmarks/src', {
              'benchmark': {
                'name': info[0],
                'version': info[1]
              }
            }).success(function (data) {
              sources[name] = data.result;
              element.html(sources[name]);
              prettyPrint();
              addExecutionByNumber();
            });
          }
        });
      }
    };
  }
]);
angular.module('app').directive('scatterPlot', function () {
  return {
    link: function (scope, element, attr) {
      var compiler_runs_data = [];
      var useLogBubbleSize = true;
      showUserThePerformanceTestDetails = function (json) {
        var jsonForServer = {
            'backend': {
              'name': 'Octave',
              'version': '3.4.3'
            },
            'benchmark': {
              'name': 'escoufier',
              'version': '1.0',
              'iteration': 3,
              'scale': 22
            }
          };
        jsonForServer.backend.version = json.backendVersion;
        jsonForServer.backend.name = json.backendName;
        jsonForServer.benchmark.name = json.benchmarkName;
        jsonForServer.benchmark.version = json.benchmarkVersion;
        jsonForServer.benchmark.iteration = json.iteration;
        jsonForServer.benchmark.scale = json.scale;
        scope.$apply(function () {
          scope.$emit('openExperimentRunner', jsonForServer);
        });
      };
      var drawScatterPlot = function () {
        console.log(compiler_runs_data);
        var clearPreviousPlots = true;
        if (clearPreviousPlots) {
          element.html('');
        }
        var w = element.width(), h = 300, pad = 20, left_pad = 100;
        var svg = d3.select(element[0]).append('svg').attr('width', w).attr('height', h);
        var max_value_of_x = Math.max.apply(Math, compiler_runs_data.map(function (d) {
            return d.scale;
          }));
        var max_value_of_y = Math.max.apply(Math, compiler_runs_data.map(function (d) {
            return d.runtime;
          }));
        var x = d3.scale.linear().domain([
            0,
            max_value_of_x
          ]).range([
            left_pad,
            w - pad
          ]), y = d3.scale.linear().domain([
            max_value_of_y,
            0
          ]).range([
            pad,
            h - pad * 2
          ]);
        var xAxis = d3.svg.axis().scale(x).orient('bottom'), yAxis = d3.svg.axis().scale(y).orient('left');
        svg.append('g').attr('class', 'axis').attr('transform', 'translate(0, ' + (h - pad) + ')').call(xAxis);
        svg.append('g').attr('class', 'axis').attr('transform', 'translate(' + (left_pad - pad) + ', 0)').call(yAxis);
        svg.append('text').attr('class', 'loading').text('Loading ...').attr('x', function () {
          return w / 2;
        }).attr('y', function () {
          return h / 2 - 5;
        });
        var max_r = d3.max(compiler_runs_data.map(function (d) {
            return d[2];
          })), r = d3.scale.linear().domain([
            0,
            d3.max(compiler_runs_data, function (d) {
              return d[2];
            })
          ]).range([
            0,
            12
          ]);
        var getXFromJson = function (object) {
          return x(object.scale);
        };
        var getYFromJson = function (object) {
          return y(object.runtime);
        };
        var bubbleWeight = 1;
        var getBubbleSizeFromJson = function (object) {
          if (useLogBubbleSize) {
            bubbleWeight = 10;
          } else {
            bubbleWeight = 1;
          }
          var radius = object.runtime / object.iteration * bubbleWeight;
          console.log('Run time: ' + object.runtime);
          console.log('Dataset size: ' + object.iteration);
          console.log('\tRadius: ' + radius);
          if (useLogBubbleSize) {
            radius = Math.log(radius);
          }
          if (object.runtime < 0.2) {
            return 2;
          }
          if (radius < 2) {
            return 2;
          }
          return radius;
        };
        var tooltip = d3.select('body').append('div').style('position', 'absolute').style('z-index', '10').style('visibility', 'hidden').html('');
        var color = d3.scale.category20();
        svg.selectAll('.loading').remove();
        svg.selectAll('circle').data(compiler_runs_data).enter().append('circle').attr('class', 'circle').attr('cx', getXFromJson).attr('cy', getYFromJson).attr('r', getBubbleSizeFromJson).style('fill', function (object, i) {
          return color(i);
        }).style('opacity', function (object, i) {
          return '.9';
        }).on('mouseover', function (object) {
          return tooltip.style('visibility', 'visible').html('<div class=\'run_details_tooltip\'>Benchmark: ' + object.benchmarkName + '<br/> Time: ' + object.runtime + '<br/> Iterations: ' + object.iteration + '<br/> Dataset Size: ' + object.scale + '</div>');
        }).on('mousemove', function (object) {
          return tooltip.style('top', event.pageY - 10 + 'px').style('left', event.pageX + 10 + 'px');
        }).on('mouseout', function (object) {
          return tooltip.style('visibility', 'hidden');
        }).on('click', function (object) {
          showUserThePerformanceTestDetails(object);
        });
      };
      scope.$watch(attr.useLogBubbleSize, function (newValue, oldValue) {
        useLogBubbleSize = newValue;
        return drawScatterPlot();
      });
      scope.$watchCollection(attr.scatterPlot, function (newValue, oldValue) {
        compiler_runs_data = newValue;
        return drawScatterPlot();
      });
    }
  };
});
angular.module('app').factory('Benchmark', function () {
  function Benchmark(name, data) {
    this.name = name;
    this.instances = data;
    this.activeInstances = [].concat(data);
  }
  angular.extend(Benchmark.prototype, {
    isActive: function (instance) {
      return this.activeInstances.indexOf(instance) !== -1;
    },
    addActive: function (instance) {
      if (!this.isActive(instance)) {
        this.activeInstances.push(instance);
      }
    },
    removeActive: function (instance) {
      if (this.isActive(instance)) {
        this.activeInstances.splice(this.activeInstances.indexOf(instance), 1);
      }
    },
    toggleActive: function (instance) {
      if (this.isActive(instance)) {
        this.removeActive(instance);
      } else {
        this.addActive(instance);
      }
    },
    addEntry: function (data) {
      this.instances.push(data);
      this.activeInstances.push(data);
    },
    hasEntry: function (data) {
      var answer = false;
      angular.forEach(this.instances, function (instance) {
        if (instance.startDate === data.startDate && instance.endDate === data.endData) {
          answer = true;
        }
      });
      return answer;
    }
  });
  return Benchmark;
});
angular.module('app').service('benchmarkData', [
  '$http',
  '$q',
  'Benchmark',
  function ($http, $q, Benchmark) {
    var benchmarks = [];
    return {
      getAll: function () {
        $http.get('http://184.107.193.50:8080/performance').success(function (data) {
          var benchmarkByName = {};
          angular.forEach(data.result, function (benchmark) {
            var name = benchmark.benchmarkName + ' ' + benchmark.benchmarkVersion;
            if (!benchmarkByName[name]) {
              benchmarkByName[name] = [];
            }
            benchmarkByName[name].push(benchmark);
          });
          var existingBenchmarks = {};
          angular.forEach(benchmarks, function (benchmark) {
            existingBenchmarks[benchmark.name] = benchmark;
          });
          angular.forEach(benchmarkByName, function (allData, name) {
            if (!existingBenchmarks.hasOwnProperty(name)) {
              benchmarks.push(new Benchmark(name, allData));
            } else {
              var benchmark = existingBenchmarks[name];
              angular.forEach(allData, function (data) {
                if (!benchmark.hasEntry(data)) {
                  benchmark.addEntry(data);
                }
              });
            }
          });
        });
        return benchmarks;
      }
    };
  }
]);