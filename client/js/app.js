var Host = {
    url: (localStorage.host == undefined) ? ((location.protocol == "chrome-extension:") ? "http://localhost:8080/": (location.protocol + "//" + location.host + "/")):localStorage.host,
    reset: function() {
        this.name = "Host"; this.hardware = "unknown hardware";
        this.software = "unknown software"; this.connected = false;
    },
    setURL: function(url) {
        localStorage.host = url;
    },
    getURL: function() {
        return this.url;
    }
}, Backends = [], Benchmarks = [], tasks = [], notifications = [];

var App = Ember.Application.create({
    Socket: ES.Module.extend({
        host: Host.url,
        controllers: ['application']
    })
});

App.Router.map(function() {
    this.resource('home');
    this.resource('backends');
    this.resource('benchmarks', function() {
        this.resource('benchmark', { path: ':benchmark_id' }, function() {
            this.resource('showfile', { path: ':file' });
        });
    });
    this.resource('runner');
    this.resource('charts');
    this.resource('tables');
    this.resource('about');
});

App.ApplicationRoute = Ember.Route.extend({
    model: function() {
        return {
            tasks: tasks,
            notifications: notifications
        };
    }
});

App.ApplicationController = Ember.ObjectController.extend({
    actions: {
        showError: function(obj) {
            $('#alertTitle').html('Error Detail');
            $('#alertBody').html('<div>Message: <pre>' + obj.error.message + '</pre></div><div>Output: <pre>' + obj.error.output + '</pre></div>');
            $('#alertBox').modal('show');
        }
    },
    sockets: {
        tasks: function(data) {
            tasks = data.data;
            this.set('tasks', tasks);
        },
        updateProgress: function(data) {
            tasks.replace(tasks.indexOf(tasks.findBy('id', data.id)), 1, [data]);
        },
        updateStatus: function(data) {
            if(data.status == "created") {
                tasks.pushObject(data);
            } else {
                tasks.removeAt(tasks.indexOf(tasks.findBy('id', data.id)));
                if(data.status == "failed") {
                    notifications.pushObject(data);
                    $("#notiLink").popover({html: true, content: "<i class='glyphicon glyphicon-envelope'></i>&nbsp;&nbsp;New Notification received!"});
                    $("#notiLink").popover('show');
                    $("#notiLink").on('click', function() { $(this).popover('destroy'); $(this).off('click'); });
                }
            }
        }
    }
});

App.IndexRoute = Ember.Route.extend({
    beforeModel: function() {
        this.transitionTo('home');
    }
});

App.HomeRoute = Ember.Route.extend({
    model: getHostInformation
});

App.HomeController = Ember.ObjectController.extend({
    isEditingURL: false,
    actions: {
        editURL: function() {
            this.set('isEditingURL', true);
        },
        doneEditingURL: function() {
            this.set('isEditingURL', false);
            Host.setURL(Host.url);
            location.reload(true);
        }
    }
});

App.BackendsRoute = Ember.Route.extend({
    model: getBackends
});

App.BenchmarksRoute = Ember.Route.extend({
    model: getBenchmarks
});

App.BenchmarksController = Ember.ArrayController.extend({
    searchBenchmarkTerm: "",
    searchResult: function() {
        var searchTerm = this.get('searchBenchmarkTerm'),
            regExp = new RegExp(searchTerm,'i'), content = [];

        Benchmarks.forEach(function(i) {
            if(regExp.test(i.name)) {
                content.push(i);
            }
        });

        this.set('content', content);
    }.observes('searchBenchmarkTerm')
});

App.BenchmarkRoute = Ember.Route.extend({
    beforeModel: function(params) {
        if(params.providedModels.benchmark !== undefined) {
            return getBenchmarkFiles(params.providedModels.benchmark.id);
        }
    },
    model: function(params) {
        return getBenchmarkFiles(parseInt(params.benchmark_id));
    }
});

App.ShowfileRoute = Ember.Route.extend({
    model: function(params) {
        return getBenchmarkFileSrc(parseInt(location.hash.split("/")[2]), params.file);
    }
});

App.RunnerRoute = Ember.Route.extend({
    model: function(params) {
        return getBenchmarks().then(getBackends).then(function() {
            return {
                benchmarksModel: Benchmarks,
                backendsModel: Backends,
                scaleModel: [{value: 1, name: "Micro Run"}, {value: 10, name: "Small Run"}, {value: 50, name: "Medium Run"}, {value: 100, name: "Long Run"}]
            };
        });
    }
});

App.RunnerController = Ember.ObjectController.extend({
    runName: null,
    runScale: null,
    runJIT: false,
    runIte: 10,
    warmScale: null,
    selectedBackEnd: null,
    selectedBenchmark: [],
    actions: {
        selectBenchmarks: function() {
            var t = [];
            var ba = this.get("selectedBackEnd");
            Benchmarks.forEach(function(b) {
                var bTags = b.tags,
                    baTags = ba.tags,
                    add = true,
                    l = bTags.length;

                for(var i = 0; i<l; i++) {
                    var tag = bTags[i].toUpperCase();
                    if(baTags.map(function(item) { return item.toUpperCase(); }).indexOf(tag) < 0) {
                        add = false;
                        break;
                    }
                }

                if(add) {
                    t.push(b);
                }
            });

            this.set('selectedBenchmark', t);
        },
        allBenchmarks: function() {
            this.set('selectedBenchmark', Benchmarks);
        },
        clearBenchmarks: function() {
            this.set('selectedBenchmark', []);
        },
        submitRun: function() {
            var data = {
                name: this.get('runName'),
                scale: parseInt(this.get('runScale').value),
                jit: this.get('runJIT'),
                iteration: parseInt(this.get('runIte')),
                warmupscale: parseInt(this.get('warmScale').value),
                backend: this.get('selectedBackEnd').id,
                benchmarks: this.get('selectedBenchmark').getEach('id')
            };
            console.log(data);
            getPerformanceRun(data).then(function(res) {
                if(res !== null) {
                    $('#alertTitle').html('Success!');
                    $('#alertBody').html('Benchmarking tasks are created successfully!');
                    $('#alertBox').modal('show');
                } else {
                    $('#alertTitle').html('Failed!');
                    $('#alertBody').html('Could not create Benchmarking tasks! Please try again later.');
                    $('#alertBox').modal('show');
                }
            });
        }
    }
});

$(document).bind("ajaxSend", function() {
    //NProgress.start();
    NProgress.set(0.4);
}).bind("ajaxComplete", function() {
    NProgress.done();
});

/*
$(function() {
    var socket = io.connect(Host.url);
    socket.on('tasks', function(data) {
        tasks = data.data;
        Ember.set(modTasks, 'tasks', tasks);
    });
    socket.on('updateProgress', function(data) {
        console.log(tasks.findBy('id', data.id));
        tasks.findBy('id', data.id).progress = data.progress;
        Ember.set(modTasks, 'tasks', tasks);
    });
    socket.on('updateStatus', function(data) {
        if(data.status == "created") {
            tasks.push(data);
            Ember.set(modTasks, 'tasks', tasks);
        }
    });
});
*/
