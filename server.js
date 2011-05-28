require.paths.unshift(".");

var express = require("express"),
		app = express.createServer(),
		jshint = require("jshint/jshint"),
		config = {
			"predef": [
				"jQuery"
			],

			"node" : true,
			"es5" : true,
			"browser" : true,

			"boss" : false,
			"curly": false,
			"debug": false,
			"devel": false,
			"eqeqeq": true,
			"evil": false,
			"forin": false,
			"immed": true,
			"laxbreak": false,
			"newcap": true,
			"noarg": true,
			"noempty": false,
			"nonew": false,
			"nomen": false,
			"onevar": true,
			"plusplus": false,
			"regexp": false,
			"undef": true,
			"sub": true,
			"strict": false,
			"white": false
		};

app.configure(function () {
    app.use(require('connect-form')({keepExtensions: true}));
    app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
    app.use(express.bodyParser());
});

app.get('/', function(req, res){
	res.send("<h1 style='text-align: center; font-size: 120px;'>ZOMG JSHINT</h1>");
});

app.post('/', function (req, res) {
    if (! req.form) {
        throw new TypeError("form data required");
    }
    return req.form.complete(function (err, fields, files) {
		var result = "";
		
		try {
			config = (fields.opts)?JSON.parse(fields.opts):config;
		} catch (e) {
			console.error("Error while parsing options string, it should be valid JSON:",e);
		}
		var passed = false;

		jshint.JSHINT(fields.source, config);
		jshint.JSHINT.errors.forEach(function(error){
			//console.log(error);
			result += "line " + error.line + ": " + error['reason'] + " \n";
		});

		res.send(result, {'Content-Type': 'text/plain'});
    });
});

app.listen(3000);