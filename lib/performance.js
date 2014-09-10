var Q = require("q");
var errors = require("../lib/errors");
var type = require("../lib/grest").type;
var mongoose = require("../lib/mongoose");

var performanceSchema = {
	id: type.opt(type.integer),
	backend: {
		name: type.string,
		version: type.string,
	},
	benchmark: {
		name: type.string,
		version: type.string,
		iteration: type.integer,
		scale: type.integer,
	}
};

var performanceSchema1 = {
    iteration: type.integer,
    scale: type.integer,
    jit: type.boolean,
    warmupscale: type.integer,
    name: type.string,
    backend: type.integer,
    benchmarks: type.array(type.integer)
};

var PerformanceResults = {
	name: "PerformanceResults",
	db: null,
	connection: null
};

function createDBSchema(db) {
	PerformanceResults.connection = db.collection(PerformanceResults.name);
	PerformanceResults.db = db;
}

mongoose.CRUD(exports, PerformanceResults);

exports.schema = performanceSchema;
exports.runSchema = performanceSchema1;
exports.createDBSchema = createDBSchema;
