function getHostInformation() {
    return Ember.RSVP.Promise(function(resolve, reject) {
        Host.reset();
        $.getJSON(Host.getURL() + "sysinfo").then(function(data) {
            Host = $.extend(Host, data.result, {connected: true});
            Ember.run(null, resolve, Host);
        }).fail(function(value) {
            Ember.run(null, resolve, Host);
        });
    });
}

function getBackends() {
    return Ember.RSVP.Promise(function(resolve, reject) {
        if(Host.connected === true && Backends.length !== 0) {
            Ember.run(null, resolve, Backends);
        } else {
            $.getJSON(Host.url + "backends").then(function(data) {
                var result = data.result,
                    keys = Object.keys(result);
                Backends = [];
                keys.forEach(function(i) {
                    Backends.push(result[i]);
                });
                Ember.run(null, resolve, Backends);
            }).fail(function(value) {
                Ember.run(null, resolve, []);
            });
        }
    });
}

function getBenchmarks() {
    return Ember.RSVP.Promise(function(resolve, reject) {
        if(Host.connected === true && Benchmarks.length !== 0) {
            Ember.run(null, resolve, Benchmarks);
        } else {
            $.getJSON(Host.url + "benchmarks").then(function(data) {
                var result = data.result,
                    keys = Object.keys(result);
                Benchmarks = [];
                keys.forEach(function(i) {
                    Benchmarks.push(result[i]);
                });
                Ember.run(null, resolve, Benchmarks);
            }).fail(function(value) {
                Ember.run(null, resolve, []);
            });
        }
    });
}

function getBenchmarkFiles(id) {
    return Ember.RSVP.Promise(function(resolve, reject) {
            var benchmark = Benchmarks.findBy('id', id);
            if(benchmark !== undefined && benchmark.files !== undefined) {
                Ember.run(null, resolve, benchmark);
            } else {
                $.ajax({
                    type: 'POST',
                    url: Host.url + "benchmarks/list",
                    data: JSON.stringify ({ "benchmark": { "name": benchmark.name } }),
                    contentType: "application/json",
                    dataType: 'json'
                }).then(function(data) {
                    var result = data.result;
                    var data = $.extend(benchmark, { files: result });
                    Ember.run(null, resolve, data);
                }).fail(function(value) {
                    Ember.run(null, resolve, benchmark);
                });
            }
    });
}

function getBenchmarkFileSrc(id, file) {
    return Ember.RSVP.Promise(function(resolve, reject) {
        var benchmark = Benchmarks.findBy('id', id);
        $.ajax({
            type: 'POST',
            url: Host.url + "benchmarks/src",
            data: JSON.stringify({ "benchmark": { "name": benchmark.name, "file": file } }),
            contentType: "application/json",
            dataType: 'json'
        }).then(function(data) {
            var result = data.result;
            var data = { name: file, file: result };
            Ember.run(null, resolve, data);
        }).fail(function(value) {
            Ember.run(null, resolve, { name: file, file: "Could not display this file" });
        });
    });
}

function getPerformanceRun(data) {
    return Ember.RSVP.Promise(function(resolve, reject) {
        $.ajax({
            type: 'POST',
            url: Host.url + "performance/run",
            data: JSON.stringify(data),
            contentType: "application/json",
            dataType: 'json'
        }).then(function(data) {
            Ember.run(null, resolve, data.result);
        }).fail(function(value) {
            Ember.run(null, resolve, null);
        });
    });
}
