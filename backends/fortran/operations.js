exports.getCompileString = function (options) {
    return options.backendPath + "/preprocessing.sh"
        + " -benchsrc " + options.sources + "/"
        + " -benchdst " + options.sources + "/../Fortranoutput/"
        + " -benchdrv " + options.runPath.substring(options.runPath.lastIndexOf("/")+1, options.runPath.lastIndexOf("."))
        + " -backsrc " + options.backendPath + "/";
};

exports.getRunString = function (options, args) {
    return options.sources + "/../Fortranoutput/run " + args.join(" ");
};
