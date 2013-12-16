var Q = require("q");
var errors = require("../lib/errors");
var type = require("grest").type;
var mongoose = require("../lib/mongoose");
var task = require("../lib/task");
var MongoClient = require("mongodb").MongoClient;

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
exports.createDBSchema = createDBSchema;
