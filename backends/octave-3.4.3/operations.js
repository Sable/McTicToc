exports.getCompileString = function (options) {
	return options.backendPath + "/preprocessing.sh"
        + " -benchsrc " + options.sources + "/"
        + " -benchdst " + options.sources + "/../output/"
        + " -benchdrv " + options.runPath.substring(options.runPath.lastIndexOf("/")+1, options.runPath.lastIndexOf("."))
        + " -backsrc " + options.backendPath + "/";
};

exports.getRunString = function (options, args) {
	return "octave -q --path " + options.sources + "/../output/ " + options.sources + "/../output/run.m " + args.join(" ");
};
