var Q = require("q");
var errors = require("../lib/errors");
var type = require("grest").type;
var mongoose = require("../lib/mongoose");

var performanceSchema = {
    id: type.opt(type.integer),
    name: type.string,
    backend: type.integer,
    date: type.date,
    system: type.string
};

var PerformanceResults = {
    name: "ResultList",
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
