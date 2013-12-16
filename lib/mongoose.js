var type = require("grest").type;
var errors = require("../lib/errors");
var Q = require("q");

exports.SequelizeToPromise = function (deferred, schema) {
	return function (err, data) {
		if (!err) {
			deferred.resolve(data);
		} else {
			deferred.reject(new errors.DataBase(err));
		}
	};
};

exports.CRUD = function (exports, table) {

	function ensureTableInitialized() {
		if (table.connection === null ) throw new Error("Uninitialized '" + table.name + "' collection");
	}

	function SequelizeToPromise(deferred) {
		return function (err, data) {
			if (!err) {
				deferred.resolve(data);
			} else {
				deferred.reject(err);
			}
		};
	}

	function add(data) {
		ensureTableInitialized();
		var deferred = Q.defer();
		table.connection.insert(data, SequelizeToPromise(deferred));
		return deferred.promise;
	}

	function getSome(data) {
		ensureTableInitialized();
		var deferred = Q.defer();
		table.connection.find(data).toArray(SequelizeToPromise(deferred));
		return deferred.promise;
	}

	function get(id) {
		ensureTableInitialized();
		var deferred = Q.defer();
		table.connection.findOne({ "_id": id }, SequelizeToPromise(deferred));
		return deferred.promise;
	}

	function getAll() {
		return getSome({});
	}

	function update(id, data) {
		ensureTableInitialized();
		var deferred = Q.defer();
		table.connection.update({ "_id": id }, data, SequelizeToPromise(deferred));
		return deferred.promise;
	}

	function remove(id) {
		ensureTableInitialized();
		var deferred = Q.defer();
		table.connection.remove({ "_id": id }, data, SequelizeToPromise(deferred));
		return deferred.promise;
	}

	exports.add = add;
	exports.get = get;
	exports.getAll = getAll;
	exports.getSome = getSome;
	exports.update = update;
	exports.remove = remove;
};
