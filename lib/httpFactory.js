var errors = require('../lib/errors'),
	Q = require("q");

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
		//console.log(value);
	}
}

exports.httpResponseError = httpResponseError;
exports.toHttpResponse = toHttpResponse;
exports.toErrorLog = toErrorLog;
