exports.getCompileString = function (options) {
	return options.backendPath + "/Mc2For.sh ../../benchmarks/" + options.runPath;
};

exports.getRunString = function (options, args) {
	return "octave -q --path " + options.sources + " --eval \"" + options.runPath.substring(options.runPath.lastIndexOf("/")+1, options.runPath.lastIndexOf(".")) + "([" + args.join(", ") + "])\"";
};
