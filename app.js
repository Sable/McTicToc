var express = require('express'),
	app = express(),
	grest = require("grest"),
	http = require("http"),
	Q = require("q"),
	MongoClient = require("mongodb").MongoClient;
	MongoServer = require("mongodb").Server;
	mongoose = require("./lib/mongoose");
	benchmarks = require('./lib/benchmark'),
	backends = require('./lib/backend'),
	task = require('./lib/task.js'),
	command = require("./lib/command.js"),
	performance = require("./lib/performance"),
	errors = require('./lib/errors'),
	appConfig = require('./appConfig.json'),
	path = require('path'),
	instrumentations = require("./lib/instrumentation.js"),
	fs = require('fs');

var type = grest.type,
	taskManager = new task.Manager(),
	options = {
		mongoHost: "0.0.0.0",
		mongoPort: "27017",
		mongoDBName: "McTicToc"
	};

var mongoClient = new MongoClient(new MongoServer(options.mongoHost, options.mongoPort));
var db = mongoClient.db(options.mongoDBName);

function httpResponseError(e, res) {
	if (e.httpStatus === undefined) {
		throw new Error("Unsupported eor " + e);
	}

	var jsonError = {
		statusCode: e.httpStatus,
		error: e
	};

	if (e.stack !== undefined) {
		jsonError.stack = e.stack;
	}

	res.json(e.httpStatus, jsonError);
}

function toHttpResponse(value, res) {
	if (res === undefined) {
		throw new errors.McBench("expected a valid http response object");
	}

	if (Q.isPromise(value)) {
		value.then(function (result) {
			res.json(200, {
				statusCode: 200,
				result: result
			});
		}).fail(function(e) { httpResponseError(e, res); }).done();
	} else if (value instanceof(errors.McBench)) {
		httpResponseError(value, res);
	} else {
		res.json(200, {
			statusCode: 200,
			result: value
		});
	}
}

function toErrorLog(value) {
	if (Q.isPromise(value)) {
		value.then(function () {}) // do nothing on success
		.fail(function (err) {
			console.log(new Date() + ": " + err);
		}).done();
	} else {
		console.log(value);
	}
}

app.use(express.bodyParser());
app.set('port', process.env.PORT || 8080);
grest.rest(app, "", [
	/**
	 * REST application based on an array defined as follow.
	 * [REST_Type (GET/POST/DELETE), Request_Schema (in case of POST), Response_Schema, Description, Handle Function] 
	 */
	"GET", ["benchmarks"], type.array(benchmarks.schema), "Returns all benchmarks",
	function (req, res) {
		toHttpResponse(benchmarks.getAll(), res);
	},
	"GET", ["backends"], type.array(backends.schema), "Returns all benchmarks",
	function (req, res) {
		toHttpResponse(backends.getAll(), res);
	},
	"GET", ["performance"], type.array(performance.schema), "Returns all performance results",
	function (req, res) {
		toHttpResponse(performance.getAll(), res);
	},
	"POST", ["performance", "run"], performance.schema, type.array(task.schema), "Creates performance tasks with the provided options. Return created tasks.",
	function (req, res) {
		var benchmarkId = benchmarks.getId(req.body.benchmark);
		var backendId = backends.getId(req.body.backend);
		var scale = req.body.benchmark.scale;
		var iteration = req.body.benchmark.iteration;

		toHttpResponse(
			benchmarks.get(benchmarkId).then(function (benchmark) {
				return backends.get(backendId).then(function (backend) {
						var sources = path.join(appConfig.benchmarks.path, benchmark.sources);
						var runPath = path.join(appConfig.benchmarks.path, benchmark.runPath);

						var t = taskManager.taskQueue(function () {
							return new command.Local(
								backends.operations[backendId].getCompileString({
									sources: sources,
									runPath: runPath
								}),
								appConfig.command
							);
						}, "wow", 1);

						var t2 = taskManager.taskQueue(function () {
							return new command.Instrumented(new command.Local(
								backends.operations[backendId].getRunString({
									sources: sources,
									runPath: runPath
								}, [scale, 0, 10]),
								appConfig.command
							));
						}, "cheetah", iteration);

						toErrorLog(
							t.start()
							.then(t2)
							.then(function (t2) {
								console.log(t2.results);
								/*performance.add({
									benchmarkName: benchmark.name,
									benchmarkVersion: benchmark.version,
									backendName: backend.name,
									backendVersion: backend.version,
									compile: true,
									run: true,
									scale: scale,
									iteration: iteration,
									result: t2.results,
									startDate: t2.startTime,
									endDate: t2.endTime
								}).then(function (argument) {
									console.log(argument);
								});*/
							})
						);
						return task.TasksToJS([t, t2]);
					});
			}),
			res
		);
	},

	"POST", ["benchmarks", "src"], { "benchmark": { "name": type.string, "version": type.string } }, type.string, "Returns the source code of the benchmark",
	function (req, res) {
		toHttpResponse(benchmarks.getSrc(benchmarks.getId(req.body.benchmark)), res);
	},

	"GET", ["tasks"], type.array(task.schema), "Returns all tasks.",
	function (req, res) {
		toHttpResponse(task.TasksToJS(taskManager.getAll()), res);
	},

	"GET", ["tasks", "running"], type.array(task.schema), "Returns all running tasks.",
	function (req, res) {
		toHttpResponse(task.TasksToJS(taskManager.getSome({ status: "running" })), res);
	},

	"GET", ["tasks", type.integer("id")], task.schema, "Returns the task with matching identifier.",
	function (req, res) {
		var t = taskManager.get(req.params.id);
		if (t !== undefined) {
			toHttpResponse(task.TaskToJS(t), res);
		} else {
			toHttpResponse(new errors.NotFound("Task '" + req.params.id + "' could not be found"), res);
		}
	},
]);

mongoClient.open(function (err, client) {
	performance.createDBSchema(db);

	http.createServer(app).listen(app.get('port'), function () {
		console.log('Express server listening on port ' + app.get('port'));
	});
});
