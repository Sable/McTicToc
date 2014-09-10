var express = require('express'),
	app = express(),
	http = require("http"),
	Q = require("q"),
    os = require("os"),
    path = require('path'),
    fs = require('fs'),
    sio = require('socket.io'), io,
    exec = require('child_process').exec,
	murmurhash = require('murmurhash'),
	MongoClient = require("mongodb").MongoClient,
	MongoServer = require("mongodb").Server,
	grest = require("./lib/grest"),
	mongoose = require("./lib/mongoose"),
	benchmarks = require('./lib/benchmark'),
	backends = require('./lib/backend'),
	task = require('./lib/task'),
	command = require("./lib/command"),
    resultlist = require("./lib/resultlist"),
	performance = require("./lib/performance"),
	errors = require('./lib/errors'),
	httpFactory = require('./lib/httpFactory'),
    iomsg = require('./lib/iomsg'),
	appConfig = require('./appConfig.json');

var type = grest.type,
	taskManager = new task.Manager(),
	options = {
		mongoHost: "0.0.0.0",
		mongoPort: "27017",
		mongoDBName: "McTicToc"
    },
    sysinfo = {
        name: "" + os.hostname(),
        hardware: "",
        software: os.platform() + " " + os.arch() + " " + os.release()
    };

var mongoClient = new MongoClient(new MongoServer(options.mongoHost, options.mongoPort));
var db = mongoClient.db(options.mongoDBName);

app.use(express.bodyParser());
app.set('port', process.env.PORT || 8080);
grest.rest(app, "", [
	/**
	 * REST application based on an array defined as follow.
	 * [REST_Type (GET/POST/DELETE), Request_Schema (in case of POST), Response_Schema, Description, Handle Function] 
	 */
    "GET", ["sysinfo"], type.string, "Returns all benchmarks",
    function (req, res) {
        httpFactory.toHttpResponse(sysinfo, res);
    },

    "GET", ["benchmarks"], type.array(benchmarks.schema), "Returns all benchmarks",
	function (req, res) {
		httpFactory.toHttpResponse(benchmarks.getAll(), res);
	},

    "POST", ["benchmarks", "list"], { "benchmark": { "name": type.string } }, type.array(type.string), "Returns the list of files in the benchmark directory",
    function (req, res) {
        httpFactory.toHttpResponse(benchmarks.listSrc(benchmarks.getId(req.body.benchmark)), res);
    },

    "POST", ["benchmarks", "src"], { "benchmark": { "name": type.string, "file": type.string } }, type.string, "Returns the source code of the benchmark",
    function (req, res) {
        var file = req.body.benchmark.file;
        if(file.indexOf("/") < 0 && file.indexOf("..") < 0) {
            httpFactory.toHttpResponse(benchmarks.getSrc(benchmarks.getId(req.body.benchmark), req.body.benchmark.file), res);
        } else {
            httpFactory.toHttpResponse(new errors.NotFound("Don't be naughty. Enter valid file name!!"), res);
        }
    },

	"GET", ["backends"], type.array(backends.schema), "Returns all benchmarks",
	function (req, res) {
		httpFactory.toHttpResponse(backends.getAll(), res);
	},
	
	"GET", ["performance"], type.array(performance.schema), "Returns all performance results",
	function (req, res) {
		httpFactory.toHttpResponse(performance.getAll(), res);
	},
	
	"POST", ["performance", "run"], performance.runSchema, type.array(task.schema), "Creates performance tasks with the provided options. Return created tasks",
	function (req, res) {
		var benchmarkIds = req.body.benchmarks,
		    backendId = req.body.backend,
            name = req.body.name,
            scale = req.body.scale,
            jit = req.body.jit,
            warmupscale = req.body.warmupscale,
            iteration = req.body.iteration,
            system = sysinfo.name,
            time = new Date(),
            id = parseInt(murmurhash.v2(time.toString() + " - " + time.getMilliseconds()), 10),
            ids = [];

        benchmarkIds.forEach(function(benchmarkId) {
            ids.push(prepareTask({
                benchmarkId: benchmarkId,
                backendId: backendId,
                scale: scale,
                iteration: iteration,
                jit: jit,
                warmupscale: warmupscale,
                systemID: system,
                taskID: id
            }));
        });
        resultlist.add({
            id: id,
            name: name,
            backend: backendId,
            date: time,
            system: system
        });
        httpFactory.toHttpResponse(ids, res);
	},

	"GET", ["tasks"], type.array(task.schema), "Returns all tasks",
	function (req, res) {
		httpFactory.toHttpResponse(task.TasksToJS(taskManager.getAll()), res);
	},

	"GET", ["tasks", "running"], type.array(task.schema), "Returns all running tasks",
	function (req, res) {
		httpFactory.toHttpResponse(task.TasksToJS(taskManager.getSome({ status: "running" })), res);
	},

	"GET", ["tasks", type.integer("id")], task.schema, "Returns the task with matching identifier",
	function (req, res) {
		var t = taskManager.get(req.params.id);
		if (t !== undefined) {
			httpFactory.toHttpResponse(task.TaskToJS(t), res);
		} else {
			httpFactory.toHttpResponse(new errors.NotFound("Task '" + req.params.id + "' could not be found"), res);
		}
	}
]);

app.enable('strict routing');
app.use('/client/', express.static(__dirname+'/client'));

mongoClient.open(function (err, client) {
	performance.createDBSchema(db);
    resultlist.createDBSchema(db);

	var server = http.createServer(app).listen(app.get('port'), function () {
		console.log('Express server listening on port ' + app.get('port'));
	});

    io = sio.listen(server, { log: false });

    io.sockets.on('connection', function (socket) {
        iomsg.connect(socket);
    });

    iomsg.setTaskManager(io, task, taskManager);
});

function prepareTask(options) {
	var benchmarkId = options.benchmarkId,
        backendId = options.backendId,
	    scale = options.scale,
        jit = options.jit,
        warmupscale = options.warmupscale,
	    iteration = options.iteration,
	    systemID = options.systemID,
	    taskID = options.taskID;

	return Q.allSettled([benchmarks.get(benchmarkId), backends.get(backendId)]).then(function (result) {
		var benchmark = result[0].value,
            backend = result[1].value,
            setup, t, t2,

		    sources = path.join(appConfig.benchmarks.path, benchmark.sources),
            runPath = path.join(appConfig.benchmarks.path, benchmark.runPath);

		t = taskManager.taskQueue(function () {
			return new command.Local(
				backends.operations[backendId].getCompileString({
					sources: sources,
					runPath: runPath,
					backendPath: __dirname + "/" + backend.path
				}),
				appConfig.command
			);
		}, systemID, 1, {benchmarkName: benchmark.name, backendName: backend.name});

		setup = {
			"_id": taskID,
			benchmarkName: benchmark.name,
			backendName: backend.name,
			backendVersion: backend.version,
			compile: true,
			run: true,
			scale: scale,
			iteration: iteration
		};


		t2 = taskManager.taskQueue(function () {
			return new command.Instrumented(new command.Local(
				backends.operations[backendId].getRunString({
					sources: sources,
					runPath: runPath
				}, [scale, jit, warmupscale]),
				appConfig.command
			));
		}, systemID, iteration, setup);

		httpFactory.toErrorLog(t2);
		taskManager.startProcessing();
		return task.TasksToJS([t, t2]);
	});
}

function parseCPU(cpus) {
    var temp = {}, temp2 = {}, arch;

    cpus.forEach(function(i) {
        if(temp[i.model] === undefined) {
            temp[i.model] = 1;
        } else {
            temp[i.model] = temp[i.model] + 1;
        }
    });

    Object.keys(temp).forEach(function(i) {
        var t = i + " x" + temp[i];
        temp2[t] = "";
    });

    arch = Object.keys(temp2).join(", ");
    return arch;
}
sysinfo.hardware = parseCPU(os.cpus()) + ", Memory: " + (Math.round(os.totalmem()/(1024*1024*1024)*100)/100) + " GiB";
