exports.getCompileString = function (options) {
	return "";
};

exports.getRunString = function (options, args) {
	return "octave -q --path " + options.sources + " --eval \"" + options.runPath.substring(options.runPath.lastIndexOf("/")+1, options.runPath.lastIndexOf(".")) + "([" + args.join(", ") + "])\"";
};
